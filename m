Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39357 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaGWQiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 12:38:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4 1/5] ath10k:  provide firmware crash info via debugfs.
Date: Wed, 23 Jul 2014 09:38:03 -0700
Message-Id: <1406133487-7541-1-git-send-email-greearb@candelatech.com> (sfid-20140723_183820_282397_431BE870)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Store the firmware crash registers and last 128 or so
firmware debug-log ids and present them to user-space
via debugfs.

Should help with figuring out why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v4:  Use _bh spinlock variants everywhere.

For patch 0005:  Fix kmalloc/vfree problem. 

drivers/net/wireless/ath/ath10k/core.h  |  71 ++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.c | 164 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   8 ++
 drivers/net/wireless/ath/ath10k/hw.h    |  24 +++++
 drivers/net/wireless/ath/ath10k/pci.c   | 106 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/pci.h   |   3 -
 6 files changed, 371 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 83a5fa9..5c0c5bf 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -276,6 +276,70 @@ struct ath10k_vif_iter {
 	struct ath10k_vif *arvif;
 };
 
+/**
+ * enum ath10k_fw_error_dump_type - types of data in the dump file
+ * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
+ * @ATH10K_FW_ERROR_DUMP_REGDUMP: Register crash dump in binary format
+ */
+enum ath10k_fw_error_dump_type {
+	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
+	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
+
+	ATH10K_FW_ERROR_DUMP_MAX,
+};
+
+struct ath10k_tlv_dump_data {
+	u32 type; /* see ath10k_fw_error_dump_type above */
+	u32 tlv_len; /* in bytes */
+	u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
+} __packed;
+
+struct ath10k_dump_file_data {
+	/* Dump file information */
+	char df_magic[16]; /* ATH10K-FW-DUMP */
+	u32 len;
+	u32 big_endian; /* 0x1 if host is big-endian */
+	u32 version; /* File dump version, 1 for now. */
+
+	/* Some info we can get from ath10k struct that might help. */
+	u32 chip_id;
+	u32 bus_type; /* 0 for now, in place for later hardware */
+	u32 target_version;
+	u32 fw_version_major;
+	u32 fw_version_minor;
+	u32 fw_version_release;
+	u32 fw_version_build;
+	u32 phy_capability;
+	u32 hw_min_tx_power;
+	u32 hw_max_tx_power;
+	u32 ht_cap_info;
+	u32 vht_cap_info;
+	u32 num_rf_chains;
+	char fw_ver[ETHTOOL_FWVERS_LEN]; /* Firmware version string */
+
+	/* Kernel related information */
+	u32 tv_sec_hi; /* time-of-day stamp, high 32-bits for seconds */
+	u32 tv_sec_lo; /* time-of-day stamp, low 32-bits for seconds */
+	u32 tv_nsec_hi; /* time-of-day stamp, nano-seconds, high bits */
+	u32 tv_nsec_lo; /* time-of-day stamp, nano-seconds, low bits */
+	u32 kernel_ver_code; /* LINUX_VERSION_CODE */
+	char kernel_ver[64]; /* VERMAGIC_STRING */
+
+	u8 unused[128]; /* Room for growth w/out changing binary format */
+
+	u8 data[0]; /* struct ath10k_tlv_dump_data + more */
+} __packed;
+
+/* This will store at least the last 128 entries.  Each dbglog message
+ * is a max of 7 32-bit integers in length, but the length can be less
+ * than that as well.
+ */
+#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * sizeof(u32))
+struct ath10k_dbglog_entry_storage {
+	u32 next_idx; /* Where to write next chunk of data */
+	u8 data[ATH10K_DBGLOG_DATA_LEN];
+};
+
 struct ath10k_debug {
 	struct dentry *debugfs_phy;
 
@@ -293,6 +357,13 @@ struct ath10k_debug {
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
+
+	/* Used for crash-dump storage */
+	/* Don't over-write dump info until someone reads the data. */
+	/* Protected by data-lock */
+	bool crashed_since_read;
+	struct ath10k_dbglog_entry_storage dbglog_entry_data;
+	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c9e35c87e..cc81a99 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -17,6 +17,9 @@
 
 #include <linux/module.h>
 #include <linux/debugfs.h>
+#include <linux/version.h>
+#include <linux/vermagic.h>
+#include <linux/vmalloc.h>
 
 #include "core.h"
 #include "debug.h"
@@ -580,6 +583,164 @@ static const struct file_operations fops_chip_id = {
 	.llseek = default_llseek,
 };
 
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u8 *buffer, int len)
+{
+	int i;
+	int z = ar->debug.dbglog_entry_data.next_idx;
+
+	spin_lock_bh(&ar->data_lock);
+
+	/* Don't save any new logs until user-space reads this. */
+	if (ar->debug.crashed_since_read)
+		goto exit;
+
+	for (i = 0; i < len; i++) {
+		ar->debug.dbglog_entry_data.data[z] = buffer[i];
+		z++;
+		if (z >= ATH10K_DBGLOG_DATA_LEN)
+			z = 0;
+	}
+
+	ar->debug.dbglog_entry_data.next_idx = z;
+exit:
+	spin_unlock_bh(&ar->data_lock);
+}
+EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
+
+static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
+{
+	unsigned int len;
+	unsigned int sofar = 0;
+	unsigned char *buf;
+	struct ath10k_tlv_dump_data *dump_tlv;
+	struct ath10k_dump_file_data *dump_data;
+	int hdr_len = sizeof(*dump_data);
+	struct timespec timestamp;
+
+	len = hdr_len;
+	len += sizeof(*dump_tlv) + sizeof(ar->debug.reg_dump_values);
+	len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	sofar += hdr_len;
+
+	/* This is going to get big when we start dumping FW RAM and such,
+	 * so go ahead and use vmalloc.
+	 */
+	buf = vmalloc(len);
+	if (!buf)
+		return NULL;
+
+	memset(buf, 0, len);
+	dump_data = (struct ath10k_dump_file_data *)(buf);
+	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
+		sizeof(dump_data->df_magic));
+	dump_data->len = len;
+#ifdef __BIG_ENDIAN
+	dump_data->big_endian = 1;
+#else
+	dump_data->big_endian = 0;
+#endif
+	dump_data->version = 1;
+	dump_data->chip_id = ar->chip_id;
+	dump_data->bus_type = 0;
+	dump_data->target_version = ar->target_version;
+	dump_data->fw_version_major = ar->fw_version_major;
+	dump_data->fw_version_minor = ar->fw_version_minor;
+	dump_data->fw_version_release = ar->fw_version_release;
+	dump_data->fw_version_build = ar->fw_version_build;
+	dump_data->phy_capability = ar->phy_capability;
+	dump_data->hw_min_tx_power = ar->hw_min_tx_power;
+	dump_data->hw_max_tx_power = ar->hw_max_tx_power;
+	dump_data->ht_cap_info = ar->ht_cap_info;
+	dump_data->vht_cap_info = ar->vht_cap_info;
+	dump_data->num_rf_chains = ar->num_rf_chains;
+
+	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
+		sizeof(dump_data->fw_ver));
+
+	dump_data->kernel_ver_code = LINUX_VERSION_CODE;
+	strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
+		sizeof(dump_data->kernel_ver));
+
+	getnstimeofday(&timestamp);
+	dump_data->tv_sec_hi = timestamp.tv_sec >> 32;
+	dump_data->tv_sec_lo = timestamp.tv_sec;
+	dump_data->tv_nsec_hi = timestamp.tv_nsec >> 32;
+	dump_data->tv_nsec_lo = timestamp.tv_nsec;
+
+	spin_lock_bh(&ar->data_lock);
+
+	/* Gather dbg-log */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_DBGLOG;
+	dump_tlv->tlv_len = sizeof(ar->debug.dbglog_entry_data);
+	memcpy(dump_tlv->tlv_data, &ar->debug.dbglog_entry_data, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
+	/* Gather crash-dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_REGDUMP;
+	dump_tlv->tlv_len = sizeof(ar->debug.reg_dump_values);
+	memcpy(dump_tlv->tlv_data, &ar->debug.reg_dump_values, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	return dump_data;
+}
+
+static int ath10k_fw_error_dump_open(struct inode *inode, struct file *file)
+{
+	struct ath10k *ar = inode->i_private;
+	int ret;
+	struct ath10k_dump_file_data *dump;
+
+	mutex_lock(&ar->conf_mutex);
+
+	dump = ath10k_build_dump_file(ar);
+	if (!dump) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	file->private_data = dump;
+	ar->debug.crashed_since_read = false;
+	ret = 0;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static ssize_t ath10k_fw_error_dump_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath10k_dump_file_data *dump_file = file->private_data;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       dump_file,
+				       dump_file->len);
+}
+
+static int ath10k_fw_error_dump_release(struct inode *inode,
+					struct file *file)
+{
+	vfree(file->private_data);
+
+	return 0;
+}
+
+static const struct file_operations fops_fw_error_dump = {
+	.open = ath10k_fw_error_dump_open,
+	.read = ath10k_fw_error_dump_read,
+	.release = ath10k_fw_error_dump_release,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static int ath10k_debug_htt_stats_req(struct ath10k *ar)
 {
 	u64 cookie;
@@ -933,6 +1094,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_simulate_fw_crash);
 
+	debugfs_create_file("fw_error_dump", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_fw_error_dump);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index a582499..6e8f5f6 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -96,6 +96,8 @@ __printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
 void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u8 *buffer, int len);
+
 #else /* CONFIG_ATH10K_DEBUG */
 
 static inline int ath10k_dbg(enum ath10k_debug_mask dbg_mask,
@@ -109,5 +111,11 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 				   const void *buf, size_t len)
 {
 }
+
+static inline void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar,
+						 u8 *buffer, int len)
+{
+}
 #endif /* CONFIG_ATH10K_DEBUG */
+
 #endif /* _DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 007e855..d4df3f0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -38,6 +38,8 @@
 /* includes also the null byte */
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
 
+#define REG_DUMP_COUNT_QCA988X 60
+
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
@@ -361,4 +363,26 @@ enum ath10k_mcast2ucast_mode {
 
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
+
+/* Target debug log related defines and structs */
+
+/* Target is 32-bit CPU, so we just use u32 for
+ * the pointers.  The memory space is relative to the
+ * target, not the host.
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
+
 #endif /* _HW_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 06840d1..24ddc22 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -840,6 +840,12 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	u32 host_addr;
 	int ret;
 	u32 i;
+#ifdef CONFIG_ATH10K_DEBUGFS
+	struct ath10k_fw_dbglog_hdr dbg_hdr;
+	u32 dbufp; /* pointer in target memory space */
+	struct ath10k_fw_dbglog_buf dbuf;
+	u8 *buffer;
+#endif
 
 	ath10k_err("firmware crashed!\n");
 	ath10k_err("hardware name %s version 0x%x\n",
@@ -851,7 +857,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 				       &reg_dump_area, sizeof(u32));
 	if (ret) {
 		ath10k_err("failed to read FW dump area address: %d\n", ret);
-		return;
+		goto exit;
 	}
 
 	ath10k_err("target register Dump Location: 0x%08X\n", reg_dump_area);
@@ -861,7 +867,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 				       REG_DUMP_COUNT_QCA988X * sizeof(u32));
 	if (ret != 0) {
 		ath10k_err("failed to read FW dump area: %d\n", ret);
-		return;
+		goto exit;
 	}
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
@@ -875,6 +881,102 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+#ifdef CONFIG_ATH10K_DEBUGFS
+	/* Dump the debug logs on the target */
+	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
+	ret = ath10k_pci_diag_read_mem(ar, host_addr,
+				       &reg_dump_area, sizeof(u32));
+	if (ret != 0) {
+		ath10k_warn("failed to read hi_dbglog_hdr: %d\n", ret);
+		goto exit_save_regs;
+	}
+
+	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area,
+				       &dbg_hdr, sizeof(dbg_hdr));
+	if (ret != 0) {
+		ath10k_err("failed to dump debug log area: %d (addr 0x%x)\n",
+			   ret, reg_dump_area);
+		goto exit_save_regs;
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
+		ret = ath10k_pci_diag_read_mem(ar, dbufp,
+					       &dbuf, sizeof(dbuf));
+		if (ret != 0) {
+			ath10k_err("failed to read debug log area: %d (addr 0x%x)\n",
+				   ret, dbufp);
+			goto exit_save_regs;
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
+		if (dbuf.length > 16000) {
+			ath10k_err("debuglog buf length is out of bounds: %d\n",
+				   dbuf.length);
+			/* Do not trust the next pointer either... */
+			goto exit_save_regs;
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
+			goto exit_save_regs;
+		}
+
+		ath10k_dbg_save_fw_dbg_buffer(ar, buffer, dbuf.length);
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
+
+exit_save_regs:
+	spin_lock_bh(&ar->data_lock);
+	if (!ar->debug.crashed_since_read) {
+		ar->debug.crashed_since_read = true;
+		memcpy(ar->debug.reg_dump_values, reg_dump_values,
+		       sizeof(ar->debug.reg_dump_values));
+	}
+	spin_unlock_bh(&ar->data_lock);
+#endif /* debugfs */
+
+exit:
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 9401292..f72a7cd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -23,9 +23,6 @@
 #include "hw.h"
 #include "ce.h"
 
-/* FW dump area */
-#define REG_DUMP_COUNT_QCA988X 60
-
 /*
  * maximum number of bytes that can be handled atomically by DiagRead/DiagWrite
  */
-- 
1.7.11.7

