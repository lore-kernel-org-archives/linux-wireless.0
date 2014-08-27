Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50016 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaH0Eoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 00:44:32 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  save firmware debug log messages.
Date: Tue, 26 Aug 2014 21:44:20 -0700
Message-Id: <1409114660-19211-1-git-send-email-greearb@candelatech.com> (sfid-20140827_064436_421404_2AA9B4C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They may be dumped through the firmware dump debugfs
file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is re-work of original patch.  It has been tested
with my (necessarily private) decode tool and appears to
work as I had hoped.
It is against linux.ath, but I am a few patches behind.

 drivers/net/wireless/ath/ath10k/core.h  |  18 ++++++
 drivers/net/wireless/ath/ath10k/debug.c |  87 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h |   5 ++
 drivers/net/wireless/ath/ath10k/hw.h    |  21 +++++++
 drivers/net/wireless/ath/ath10k/pci.c   | 102 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c   |   9 +++
 6 files changed, 239 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4ef4760..9cf9bff 100644
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
+	u32 next_idx; /* Where to write next chunk of data */
+	u32 first_idx; /* Index of first msg */
+	u32 data[ATH10K_DBGLOG_DATA_LEN];
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
index 442fe93..f65c5d0 100644
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
 
@@ -695,7 +696,6 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->data_lock);
 
-	crash_data->crashed_since_read = true;
 	uuid_le_gen(&crash_data->uuid);
 	getnstimeofday(&crash_data->timestamp);
 
@@ -703,6 +703,69 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_debug_get_new_fw_crash_data);
 
+static void ath10k_dbg_drop_dbg_buffer(struct ath10k *ar)
+{
+	/* Find next message boundary */
+	u32 lg_hdr;
+	int acnt;
+	int first_idx = ar->debug.dbglog_entry_data.first_idx;
+	int h_idx = (first_idx + 1) % ATH10K_DBGLOG_DATA_LEN;
+
+	/* Log header is second 32-bit word */
+	lg_hdr = ar->debug.dbglog_entry_data.data[h_idx];
+
+	acnt = (lg_hdr & DBGLOG_NUM_ARGS_MASK) >> DBGLOG_NUM_ARGS_OFFSET;
+
+	if (acnt > DBGLOG_NUM_ARGS_MAX) {
+		/* Some sort of corruption it seems, recover as best we can. */
+		ath10k_err("Invalid dbglog arg-count: %i %i %i\n",
+			   acnt, ar->debug.dbglog_entry_data.first_idx,
+			   ar->debug.dbglog_entry_data.next_idx);
+		ar->debug.dbglog_entry_data.first_idx =
+			ar->debug.dbglog_entry_data.next_idx;
+		return;
+	}
+
+	/* Move forward over the args and the two header entries */
+	ar->debug.dbglog_entry_data.first_idx =
+		(first_idx + acnt + 2) % ATH10K_DBGLOG_DATA_LEN;
+}
+
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u32 *buffer, int len)
+{
+	int i;
+	int z;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	z = ar->debug.dbglog_entry_data.next_idx;
+
+	/* Don't save any new logs until user-space reads this. */
+	if (ar->debug.fw_crash_data &&
+	    ar->debug.fw_crash_data->crashed_since_read) {
+		ath10k_warn("Dropping dbg buffer due to crash since read.\n");
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
+		 * first_idx to the next message.  If idx's are same, we
+		 * are empty.
+		 */
+		if (z == ar->debug.dbglog_entry_data.first_idx)
+			ath10k_dbg_drop_dbg_buffer(ar);
+
+		ar->debug.dbglog_entry_data.next_idx = z;
+	}
+}
+EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
+
+
 static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
@@ -711,9 +774,14 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	int hdr_len = sizeof(*dump_data);
 	unsigned int len, sofar = 0;
 	unsigned char *buf;
+	int i;
+	u32 *u32_buf;
+	__le32 *le32_buf;
+	int tmp, tmp2;
 
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+	len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
 
 	sofar += hdr_len;
 
@@ -772,8 +840,23 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	       sizeof(crash_data->registers));
 	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 
+	/* Gather dbg-log */
+	tmp = sizeof(ar->debug.dbglog_entry_data);
+	tmp2 = tmp/sizeof(u32);
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
+	dump_tlv->tlv_len = cpu_to_le32(tmp);
+	le32_buf = (__le32 *)(dump_tlv->tlv_data);
+	u32_buf = (u32 *)(&ar->debug.dbglog_entry_data);
+	/* Convert entire struct to le32 */
+	for (i = 0; i < tmp2; i++)
+		le32_buf[i] = cpu_to_le32(u32_buf[i]);
+
+	sofar += sizeof(*dump_tlv) + tmp;
+
 	ar->debug.fw_crash_data->crashed_since_read = false;
 
+	WARN_ON(sofar != len);
 	spin_unlock_bh(&ar->data_lock);
 
 	return dump_data;
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 47ee4a6..5d70c395 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -112,6 +112,7 @@ __printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
 void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, __le32 *buffer, int len);
 #else /* CONFIG_ATH10K_DEBUG */
 
 static inline int ath10k_dbg(enum ath10k_debug_mask dbg_mask,
@@ -125,5 +126,9 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 				   const void *buf, size_t len)
 {
 }
+static inline void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar,
+						 u32 *buffer, int len)
+{
+}
 #endif /* CONFIG_ATH10K_DEBUG */
 #endif /* _DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 13568b0..828b4cd 100644
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
+	u32 next; /* pointer to dblog_buf_s. */
+	u32 buffer; /* pointer to u8 buffer */
+	u32 bufsize;
+	u32 length;
+	u32 count;
+	u32 free;
+} __packed;
+
+struct ath10k_fw_dbglog_hdr {
+	u32 dbuf; /* pointer to dbglog_buf_s */
+	u32 dropped;
+} __packed;
+
 #endif /* _HW_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3af462a..c63f156 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -921,6 +921,103 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 		crash_data->registers[i] = cpu_to_le32(reg_dump_values[i]);
 }
 
+#ifdef CONFIG_ATH10K_DEBUGFS
+static void ath10k_pci_dump_dbglog(struct ath10k *ar,
+				   struct ath10k_fw_crash_data *crash_data)
+{
+	struct ath10k_fw_dbglog_hdr dbg_hdr;
+	u32 dbufp; /* pointer in target memory space */
+	struct ath10k_fw_dbglog_buf dbuf;
+	u8 *buffer;
+	u32 host_addr, addr;
+	int ret;
+	int i;
+
+	/* Dump the debug logs on the target */
+	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
+	ret = ath10k_pci_diag_read_mem(ar, host_addr, &addr, sizeof(u32));
+	if (ret != 0) {
+		ath10k_warn("failed to read hi_dbglog_hdr: %d\n", ret);
+		return;
+	}
+
+	ret = ath10k_pci_diag_read_mem(ar, addr, &dbg_hdr, sizeof(dbg_hdr));
+	if (ret != 0) {
+		ath10k_err("failed to dump debug log area: %d (addr 0x%x)\n",
+			   ret, addr);
+		return;
+	}
+
+	ath10k_dbg(ATH10K_DBG_PCI,
+		   "Debug Log Header, dbuf: 0x%x  dropped: %i\n",
+		   dbg_hdr.dbuf, dbg_hdr.dropped);
+	dbufp = dbg_hdr.dbuf;
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
+			ath10k_err("failed to read debug log area: %d (addr 0x%x)\n",
+				   ret, dbufp);
+			return;
+		}
+
+		/* We have a buffer of data */
+		ath10k_dbg(ATH10K_DBG_PCI,
+			   "[%i] next: 0x%x buf: 0x%x sz: %i len: %i count: %i free: %i\n",
+			   i, dbuf.next, dbuf.buffer, dbuf.bufsize, dbuf.length,
+			   dbuf.count, dbuf.free);
+		if (dbuf.buffer == 0 || dbuf.length == 0)
+			goto next;
+
+		/* Pick arbitrary upper bound in case firmware is corrupted for
+		 * whatever reason.
+		 */
+		if (dbuf.length > 4096) {
+			ath10k_err("debuglog buf length is out of bounds: %d\n",
+				   dbuf.length);
+			/* Do not trust the next pointer either... */
+			return;
+		}
+
+		buffer = kmalloc(dbuf.length, GFP_ATOMIC);
+
+		if (!buffer)
+			goto next;
+
+		ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer, buffer,
+					       dbuf.length);
+		if (ret != 0) {
+			ath10k_err("failed to read debug log buffer: %d (addr 0x%x)\n",
+				   ret, dbuf.buffer);
+			kfree(buffer);
+			return;
+		}
+
+		WARN_ON(dbuf.length & 0x3);
+		ath10k_dbg_save_fw_dbg_buffer(ar, (u32 *)(buffer),
+					      dbuf.length >> 2);
+		kfree(buffer);
+
+next:
+		dbufp = dbuf.next;
+		if (dbufp == dbg_hdr.dbuf) {
+			/* It is a circular buffer it seems, bail if next
+			 * is head
+			 */
+			break;
+		}
+		i++;
+	} /* While we have a debug buffer to read */
+}
+#endif
+
 static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data;
@@ -942,7 +1039,10 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 		goto exit;
 
 	ath10k_pci_dump_registers(ar, crash_data);
-
+#ifdef CONFIG_ATH10K_DEBUGFS
+	ath10k_pci_dump_dbglog(ar, crash_data);
+#endif
+	crash_data->crashed_since_read = true;
 exit:
 	spin_unlock_bh(&ar->data_lock);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ec3bf4e..95b60fa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1290,6 +1290,15 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_dbglog(skb->data, skb->len);
 
+	spin_lock_bh(&ar->data_lock);
+	/* First 4 bytes are a messages-dropped-due-to-overflow counter,
+	 * and should not be recorded in the dbglog buffer, so we skip
+	 * them.
+	 */
+	ath10k_dbg_save_fw_dbg_buffer(ar, (u32 *)(skb->data + 4),
+				      (skb->len - 4)/sizeof(u32));
+	spin_unlock_bh(&ar->data_lock);
+
 	return 0;
 }
 
-- 
1.7.11.7

