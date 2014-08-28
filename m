Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34416 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaH1MI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 08:08:57 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4] ath10k:  save firmware debug log messages.
Date: Thu, 28 Aug 2014 05:08:50 -0700
Message-Id: <1409227730-10474-1-git-send-email-greearb@candelatech.com> (sfid-20140828_140903_632967_7747F867)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They may be dumped through the firmware dump debugfs
file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v4: Per Michal's suggestions, except that I did not
   add struct for the debug-log message header.
   I want approval from QCA before documenting that.

v3:  Re-worked byte-order related stuff again,
   thanks to Michael's comments on IRC.
   Fix problem reported by smatch, possible NPE.

v2:  Remove some #ifdefs
     rebase:  Fix logging, deal with byte-order differences
       when reading firmware memory.

Tested on x86-64.  smatch & sparse is clean, assuming I
ran sparse correctly.

 drivers/net/wireless/ath/ath10k/core.h  | 18 ++++++
 drivers/net/wireless/ath/ath10k/debug.c | 97 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h |  5 ++
 drivers/net/wireless/ath/ath10k/hw.h    | 21 +++++++
 drivers/net/wireless/ath/ath10k/pci.c   | 99 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   | 13 ++++-
 drivers/net/wireless/ath/ath10k/wmi.h   |  5 ++
 7 files changed, 255 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4ef4760..09ef3e2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -280,6 +280,22 @@ struct ath10k_vif_iter {
 	struct ath10k_vif *arvif;
 };
 
+/* This will store at least the last 128 entries.  Each dbglog message
+ * is a max of 7 32-bit integers in length, but the length can be less
+ * than that as well.
+ */
+#define ATH10K_DBGLOG_DATA_LEN (128 * 7)
+struct ath10k_dbglog_entry_storage {
+	u32 head_idx; /* Where to write next chunk of data */
+	u32 tail_idx; /* Index of first msg */
+	__le32 data[ATH10K_DBGLOG_DATA_LEN];
+};
+
+/* Just enough info to decode firmware debug-log argument length */
+#define DBGLOG_NUM_ARGS_OFFSET           26
+#define DBGLOG_NUM_ARGS_MASK             0xFC000000 /* Bit 26-31 */
+#define DBGLOG_NUM_ARGS_MAX              5 /* firmware tool chain limit */
+
 /* used for crash-dump storage, protected by data-lock */
 struct ath10k_fw_crash_data {
 	bool crashed_since_read;
@@ -307,6 +323,8 @@ struct ath10k_debug {
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
 
+	struct ath10k_dbglog_entry_storage dbglog_entry_data;
+
 	struct ath10k_fw_crash_data *fw_crash_data;
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f3f0a80..8da3d57 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -32,10 +32,11 @@
 /**
  * enum ath10k_fw_crash_dump_type - types of data in the dump file
  * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
+ * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
-
+	ATH10K_FW_CRASH_DUMP_DBGLOG = 1,
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
 
@@ -106,6 +107,12 @@ struct ath10k_dump_file_data {
 	u8 data[0];
 } __packed;
 
+struct ath10k_dbglog_entry_storage_user {
+	__le32 head_idx; /* Where to write next chunk of data */
+	__le32 tail_idx; /* Index of first msg */
+	__le32 data[ATH10K_DBGLOG_DATA_LEN];
+} __packed;
+
 int ath10k_info(struct ath10k *ar, const char *fmt, ...)
 {
 	struct va_format vaf = {
@@ -673,7 +680,6 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->data_lock);
 
-	crash_data->crashed_since_read = true;
 	uuid_le_gen(&crash_data->uuid);
 	getnstimeofday(&crash_data->timestamp);
 
@@ -681,17 +687,87 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_debug_get_new_fw_crash_data);
 
+static void ath10k_dbg_drop_dbg_buffer(struct ath10k *ar)
+{
+	/* Find next message boundary */
+	u32 lg_hdr;
+	int acnt;
+	int tail_idx = ar->debug.dbglog_entry_data.tail_idx;
+	int h_idx = (tail_idx + 1) % ATH10K_DBGLOG_DATA_LEN;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	/* Log header is second 32-bit word */
+	lg_hdr = le32_to_cpu(ar->debug.dbglog_entry_data.data[h_idx]);
+
+	acnt = (lg_hdr & DBGLOG_NUM_ARGS_MASK) >> DBGLOG_NUM_ARGS_OFFSET;
+
+	if (acnt > DBGLOG_NUM_ARGS_MAX) {
+		/* Some sort of corruption it seems, recover as best we can. */
+		ath10k_err(ar, "invalid dbglog arg-count: %i %i %i\n",
+			   acnt, ar->debug.dbglog_entry_data.tail_idx,
+			   ar->debug.dbglog_entry_data.head_idx);
+		ar->debug.dbglog_entry_data.tail_idx =
+			ar->debug.dbglog_entry_data.head_idx;
+		return;
+	}
+
+	/* Move forward over the args and the two header fields */
+	ar->debug.dbglog_entry_data.tail_idx =
+		(tail_idx + acnt + 2) % ATH10K_DBGLOG_DATA_LEN;
+}
+
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, __le32 *buffer, int len)
+{
+	int i;
+	int z;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	z = ar->debug.dbglog_entry_data.head_idx;
+
+	/* Don't save any new logs until user-space reads this. */
+	if (ar->debug.fw_crash_data &&
+	    ar->debug.fw_crash_data->crashed_since_read) {
+		ath10k_warn(ar, "dropping dbg buffer due to crash since read\n");
+		return;
+	}
+
+	for (i = 0; i < len; i++) {
+		ar->debug.dbglog_entry_data.data[z] = buffer[i];
+		z++;
+		if (z >= ATH10K_DBGLOG_DATA_LEN)
+			z = 0;
+
+		/* If we are about to over-write an old message, move the
+		 * tail_idx to the next message.  If idx's are same, we
+		 * are empty.
+		 */
+		if (z == ar->debug.dbglog_entry_data.tail_idx)
+			ath10k_dbg_drop_dbg_buffer(ar);
+
+		ar->debug.dbglog_entry_data.head_idx = z;
+	}
+}
+EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
+
 static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
 	struct ath10k_dump_file_data *dump_data;
 	struct ath10k_tlv_dump_data *dump_tlv;
+	struct ath10k_dbglog_entry_storage_user *dbglog_storage;
 	int hdr_len = sizeof(*dump_data);
 	unsigned int len, sofar = 0;
 	unsigned char *buf;
+	int tmp;
+
+	BUILD_BUG_ON(sizeof(struct ath10k_dbglog_entry_storage) !=
+		     sizeof(struct ath10k_dbglog_entry_storage_user));
 
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+	len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
 
 	sofar += hdr_len;
 
@@ -750,8 +826,25 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	       sizeof(crash_data->registers));
 	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 
+	/* Gather dbg-log */
+	tmp = sizeof(ar->debug.dbglog_entry_data);
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
+	dump_tlv->tlv_len = cpu_to_le32(tmp);
+	dbglog_storage =
+		(struct ath10k_dbglog_entry_storage_user *)(dump_tlv->tlv_data);
+	memcpy(dbglog_storage->data, ar->debug.dbglog_entry_data.data,
+	       sizeof(dbglog_storage->data));
+	dbglog_storage->head_idx =
+		cpu_to_le32(ar->debug.dbglog_entry_data.head_idx);
+	dbglog_storage->tail_idx =
+		cpu_to_le32(ar->debug.dbglog_entry_data.tail_idx);
+
+	sofar += sizeof(*dump_tlv) + tmp;
+
 	ar->debug.fw_crash_data->crashed_since_read = false;
 
+	WARN_ON(sofar != len);
 	spin_unlock_bh(&ar->data_lock);
 
 	return dump_data;
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 5674653..c168cdb 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -114,6 +114,7 @@ void ath10k_dbg_dump(struct ath10k *ar,
 		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, __le32 *buffer, int len);
 #else /* CONFIG_ATH10K_DEBUG */
 
 static inline int ath10k_dbg(struct ath10k *ar,
@@ -129,5 +130,9 @@ static inline void ath10k_dbg_dump(struct ath10k *ar,
 				   const void *buf, size_t len)
 {
 }
+static inline void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar,
+						 __le32 *buffer, int len)
+{
+}
 #endif /* CONFIG_ATH10K_DEBUG */
 #endif /* _DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 13568b0..28fedba 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -364,4 +364,25 @@ enum ath10k_mcast2ucast_mode {
 
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
+/* Target debug log related defines and structs */
+
+/* Target is 32-bit CPU, so we just use u32 for
+ * the pointers.  The memory space is relative to the
+ * target, not the host.  Values are converted to host
+ * byte order when reading from firmware.
+ */
+struct ath10k_fw_dbglog_buf {
+	__le32 next; /* pointer to ath10k_fw_dbglog_buf. */
+	__le32 buffer; /* pointer to u8 buffer */
+	__le32 bufsize;
+	__le32 length;
+	__le32 count;
+	__le32 free;
+} __packed;
+
+struct ath10k_fw_dbglog_hdr {
+	__le32 dbuf; /* pointer to ath10k_fw_dbglog_buf */
+	__le32 dropped;
+} __packed;
+
 #endif /* _HW_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1ff2f34..1f1878a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1024,6 +1024,102 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 		crash_data->registers[i] = reg_dump_values[i];
 }
 
+/**
+ * Read any not-yet-delivered debug-log buffers on the target
+ * and save them to storage in the host driver.  Typically
+ * only done on crash, as firmware will normally deliver
+ * logs periodically on its own if it is functioning
+ * properly.
+ */
+static void ath10k_pci_dump_dbglog(struct ath10k *ar)
+{
+	struct ath10k_fw_dbglog_hdr dbg_hdr;
+	u32 dbufp; /* pointer in target memory space */
+	struct ath10k_fw_dbglog_buf dbuf;
+	u8 *buffer;
+	int ret;
+	int i;
+	int len;
+
+	ret = ath10k_pci_diag_read_hi(ar, &dbg_hdr, hi_dbglog_hdr,
+				      sizeof(dbg_hdr));
+	if (ret != 0) {
+		ath10k_err(ar, "failed to dump debug log area: %d\n", ret);
+		return;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_PCI,
+		   "debug log header, dbuf: 0x%x  dropped: %i\n",
+		   le32_to_cpu(dbg_hdr.dbuf), le32_to_cpu(dbg_hdr.dropped));
+	dbufp = le32_to_cpu(dbg_hdr.dbuf);
+
+	/* i is for logging purposes and sanity check in case firmware buffers
+	 * are corrupted and will not properly terminate the list.
+	 * In standard firmware, it appears there are no more than 2
+	 * buffers, so 10 should be safe upper limit even if firmware
+	 * changes quite a bit.
+	 */
+	i = 0;
+	while (dbufp && i < 10) {
+		ret = ath10k_pci_diag_read_mem(ar, dbufp, &dbuf, sizeof(dbuf));
+		if (ret != 0) {
+			ath10k_err(ar, "failed to read debug log area: %d (addr 0x%x)\n",
+				   ret, dbufp);
+			return;
+		}
+
+		len = le32_to_cpu(dbuf.length);
+
+		ath10k_dbg(ar, ATH10K_DBG_PCI,
+			   "[%i] next: 0x%x buf: 0x%x sz: %i len: %i count: %i free: %i\n",
+			   i, le32_to_cpu(dbuf.next), le32_to_cpu(dbuf.buffer),
+			   le32_to_cpu(dbuf.bufsize), len,
+			   le32_to_cpu(dbuf.count), le32_to_cpu(dbuf.free));
+		if (dbuf.buffer == 0 || len == 0)
+			goto next;
+
+		/* Pick arbitrary upper bound in case firmware is corrupted for
+		 * whatever reason.
+		 */
+		if (len > 4096) {
+			ath10k_err(ar,
+				   "debuglog buf length is out of bounds: %d\n",
+				   len);
+			/* Do not trust the next pointer either... */
+			return;
+		}
+
+		buffer = kmalloc(len, GFP_ATOMIC);
+
+		if (!buffer)
+			goto next;
+
+		ret = ath10k_pci_diag_read_mem(ar, le32_to_cpu(dbuf.buffer),
+					       buffer, len);
+		if (ret != 0) {
+			ath10k_err(ar, "failed to read debug log buffer: %d (addr 0x%x)\n",
+				   ret, le32_to_cpu(dbuf.buffer));
+			kfree(buffer);
+			return;
+		}
+
+		WARN_ON(len & 0x3);
+
+		ath10k_dbg_save_fw_dbg_buffer(ar, (__le32 *)(buffer), len >> 2);
+		kfree(buffer);
+
+next:
+		dbufp = le32_to_cpu(dbuf.next);
+		if (dbufp == le32_to_cpu(dbg_hdr.dbuf)) {
+			/* It is a circular buffer it seems, bail if next
+			 * is head
+			 */
+			break;
+		}
+		i++;
+	} /* While we have a debug buffer to read */
+}
+
 static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data;
@@ -1041,6 +1137,9 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_err(ar, "firmware crashed! (uuid %s)\n", uuid);
 	ath10k_print_driver_info(ar);
 	ath10k_pci_dump_registers(ar, crash_data);
+	ath10k_pci_dump_dbglog(ar);
+	if (crash_data)
+		crash_data->crashed_since_read = true;
 
 	spin_unlock_bh(&ar->data_lock);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e500a3c..5d96926 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1285,10 +1285,21 @@ static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
 
 static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 {
+	struct ath10k_fw_dbglog_report *ev;
+
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
 		   skb->len);
-
 	trace_ath10k_wmi_dbglog(skb->data, skb->len);
+	ev = (struct ath10k_fw_dbglog_report *)skb->data;
+
+	spin_lock_bh(&ar->data_lock);
+	/* First 4 bytes are a messages-dropped-due-to-overflow counter,
+	 * and should not be recorded in the dbglog buffer, so we skip
+	 * them.
+	 */
+	ath10k_dbg_save_fw_dbg_buffer(ar, ev->messages,
+				      (skb->len - 4)/sizeof(__le32));
+	spin_unlock_bh(&ar->data_lock);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e708365..eae0105 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4730,6 +4730,11 @@ struct wmi_dbglog_cfg_cmd {
 /* By default disable power save for IBSS */
 #define ATH10K_DEFAULT_ATIM 0
 
+struct ath10k_fw_dbglog_report {
+	__le32 dropped_count;
+	__le32 messages[];
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 
-- 
1.7.11.7

