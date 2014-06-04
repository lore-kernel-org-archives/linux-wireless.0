Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52915 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFDSBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 14:01:52 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
Date: Wed,  4 Jun 2014 11:01:39 -0700
Message-Id: <1401904902-5842-1-git-send-email-greearb@candelatech.com> (sfid-20140604_200155_954901_67BE450B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Store the firmware crash registers and last 128 or so
firmware debug-log ids and present them to user-space
via debugfs.

Should help with figuring out why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Changes from RFC:  Fixed spacing and naming and some other
requests.  Did not change everything Michal asked for.

Also, added a bunch of info to the file header to have better
chance of understanding what hardware/firmware/kernel and such
is being reported.  Version field will let us update the file
format as needed...whatever decodes it can take different action
based on the version, etc.

 drivers/net/wireless/ath/ath10k/core.h  |  73 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.c | 144 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |  25 ++++++
 drivers/net/wireless/ath/ath10k/pci.c   |  82 +++++++++++++++++-
 4 files changed, 321 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 68ceef6..a8866d3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -41,6 +41,11 @@
 #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
 #define ATH10K_NUM_CHANS 38
 
+/* Duplicates define in pci.h, if there is ever mis-match we should
+ * get a compile error.  Cannot just include pci.h here.
+ */
+#define REG_DUMP_COUNT_QCA988X 60
+
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
 
@@ -338,6 +343,68 @@ enum ath10k_dev_flags {
 	ATH10K_FLAG_CORE_REGISTERED,
 };
 
+/**
+ * enum ath10k_fw_error_dump_type - types of data in the dump file
+ * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
+ * @ATH10K_FW_ERROR_DUMP_CRASH:   Crash dump in binary format
+ */
+enum ath10k_fw_error_dump_type {
+	ATH10K_FW_ERROR_DUMP_DBGLOG = 0,
+	ATH10K_FW_ERROR_DUMP_REGDUMP = 1,
+
+	ATH10K_FW_ERROR_DUMP_MAX,
+};
+
+
+struct ath10k_tlv_dump_data {
+	u32 type; /* see ath10k_fw_error_dump_type above */
+	u32 tlv_len; /* in bytes */
+	u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
+} __packed;
+
+struct ath10k_dump_file_data {
+	/* Dump file information */
+	u32 len;
+	u32 magic; /* 0x01020304, tells us byte-order of host if we care */
+	u32 version; /* File dump version, 1 for now. */
+
+	/* Some info we can get from ath10k struct that might help. */
+	u32 chip_id;
+	u32 target_version;
+	u8 fw_version_major;
+	u8 unused8; /* pad fw_version_major */
+	u16 unused16; /* pad fw_version_major */
+	u32 fw_version_minor;
+	u16 fw_version_release;
+	u16 fw_version_build;
+	u32 phy_capability;
+	u32 hw_min_tx_power;
+	u32 hw_max_tx_power;
+	u32 ht_cap_info;
+	u32 vht_cap_info;
+	u32 num_rf_chains;
+	char fw_ver[64]; /* Firmware version string */
+
+	/* Kernel related information */
+	u32 kernel_ver_code; /* LINUX_VERSION_CODE */
+	char kernel_ver[64]; /* VERMAGIC_STRING */
+
+	u8 unused[64]; /* Room for growth w/out changing binary format */
+
+	struct ath10k_tlv_dump_data data; /* more may follow */
+} __packed;
+
+/* This will store at least the last 128 entries.  Each dbglog message
+ * is a max of 7 32-bit integers in length, but the length can be less
+ * than that as well.
+ */
+#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)
+struct ath10k_dbglog_entry_storage {
+	u32 next_idx; /* Where to write next chunk of data */
+	u8 data[ATH10K_DBGLOG_DATA_LEN];
+};
+
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -488,6 +555,12 @@ struct ath10k {
 
 	struct dfs_pattern_detector *dfs_detector;
 
+	/* Used for crash-dump storage */
+	/* Don't over-write dump info until someone reads the data. */
+	bool crashed_since_read;
+	struct ath10k_dbglog_entry_storage dbglog_entry_data;
+	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1b7ff4b..a7d7877 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -17,6 +17,8 @@
 
 #include <linux/module.h>
 #include <linux/debugfs.h>
+#include <linux/version.h>
+#include <linux/vermagic.h>
 
 #include "core.h"
 #include "debug.h"
@@ -577,6 +579,145 @@ static const struct file_operations fops_chip_id = {
 	.llseek = default_llseek,
 };
 
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u8 *buffer, int len)
+{
+	int i;
+	int z = ar->dbglog_entry_data.next_idx;
+
+	/* Don't save any new logs until user-space reads this. */
+	if (ar->crashed_since_read)
+		return;
+
+	for (i = 0; i < len; i++) {
+		ar->dbglog_entry_data.data[z] = buffer[i];
+		z++;
+		if (z >= ATH10K_DBGLOG_DATA_LEN)
+			z = 0;
+	}
+	ar->dbglog_entry_data.next_idx = z;
+}
+EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
+
+static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
+{
+	unsigned int len = (sizeof(ar->dbglog_entry_data)
+			    + sizeof(ar->reg_dump_values));
+	unsigned int sofar = 0;
+	char *buf;
+	struct ath10k_tlv_dump_data *dump_tlv;
+	struct ath10k_dump_file_data *dump_data;
+	int hdr_len = sizeof(*dump_data) - sizeof(dump_data->data);
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	len += hdr_len;
+	sofar += hdr_len;
+
+	/* So we can add headers to the data dump */
+	len += 2 * sizeof(*dump_tlv);
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
+	dump_data->len = len;
+	dump_data->magic = 0x01020304;
+	dump_data->version = 1;
+	dump_data->chip_id = ar->chip_id;
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
+	strncpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
+		sizeof(dump_data->fw_ver) - 1);
+
+	dump_data->kernel_ver_code = LINUX_VERSION_CODE;
+	strncpy(dump_data->kernel_ver, VERMAGIC_STRING,
+		sizeof(dump_data->kernel_ver) - 1);
+
+	/* Gather dbg-log */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_DBGLOG;
+	dump_tlv->tlv_len = sizeof(ar->dbglog_entry_data);
+	memcpy(dump_tlv->tlv_data, &ar->dbglog_entry_data, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
+
+	/* Gather crash-dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = ATH10K_FW_ERROR_DUMP_REGDUMP;
+	dump_tlv->tlv_len = sizeof(ar->reg_dump_values);
+	memcpy(dump_tlv->tlv_data, &ar->reg_dump_values, dump_tlv->tlv_len);
+	sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
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
+	if (!ar)
+		return -EINVAL;
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
+	ar->crashed_since_read = false;
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
@@ -861,6 +1002,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_simulate_fw_crash);
 
+	debugfs_create_file("fw_error_dump", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_fw_error_dump);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index a582499..72ed34c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -19,6 +19,7 @@
 #define _DEBUG_H_
 
 #include <linux/types.h>
+#include "pci.h"
 #include "trace.h"
 
 enum ath10k_debug_mask {
@@ -110,4 +111,28 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 {
 }
 #endif /* CONFIG_ATH10K_DEBUG */
+
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
+void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, u8 *buffer, int len);
+
 #endif /* _DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d0004d5..f2cfe69 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/bitops.h>
+#include <linux/ctype.h>
 
 #include "core.h"
 #include "debug.h"
@@ -840,6 +840,8 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	u32 host_addr;
 	int ret;
 	u32 i;
+	struct ath10k_fw_dbglog_hdr dbg_hdr;
+	u32 dbufp; /* pointer in target memory space */
 
 	ath10k_err("firmware crashed!\n");
 	ath10k_err("hardware name %s version 0x%x\n",
@@ -851,7 +853,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 				       &reg_dump_area, sizeof(u32));
 	if (ret) {
 		ath10k_err("failed to read FW dump area address: %d\n", ret);
-		return;
+		goto do_restart;
 	}
 
 	ath10k_err("target register Dump Location: 0x%08X\n", reg_dump_area);
@@ -861,7 +863,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 				       REG_DUMP_COUNT_QCA988X * sizeof(u32));
 	if (ret != 0) {
 		ath10k_err("failed to read FW dump area: %d\n", ret);
-		return;
+		goto do_restart;
 	}
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
@@ -875,6 +877,80 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+	/* Dump the debug logs on the target */
+	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
+	if (ath10k_pci_diag_read_mem(ar, host_addr,
+				     &reg_dump_area, sizeof(u32)) != 0) {
+		ath10k_warn("failed to read hi_dbglog_hdr\n");
+		goto save_regs_and_restart;
+	}
+
+	ath10k_err("target register Debug Log Location: 0x%08X\n",
+		   reg_dump_area);
+
+	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area,
+				       &dbg_hdr, sizeof(dbg_hdr));
+	if (ret != 0) {
+		ath10k_err("failed to dump Debug Log Area\n");
+		goto save_regs_and_restart;
+	}
+
+	ath10k_err("Debug Log Header, dbuf: 0x%x  dropped: %i\n",
+		   dbg_hdr.dbuf, dbg_hdr.dropped);
+	dbufp = dbg_hdr.dbuf;
+	i = 0;
+	while (dbufp) {
+		struct ath10k_fw_dbglog_buf dbuf;
+
+		ret = ath10k_pci_diag_read_mem(ar, dbufp,
+					       &dbuf, sizeof(dbuf));
+		if (ret != 0) {
+			ath10k_err("failed to read Debug Log Area: 0x%x\n",
+				   dbufp);
+			goto save_regs_and_restart;
+		}
+
+		/* We have a buffer of data */
+		ath10k_err("[%i] next: 0x%x buf: 0x%x sz: %i len: %i count: %i free: %i\n",
+			   i, dbuf.next, dbuf.buffer, dbuf.bufsize, dbuf.length,
+			   dbuf.count, dbuf.free);
+		if (dbuf.buffer && dbuf.length) {
+			u8 *buffer = kmalloc(dbuf.length, GFP_ATOMIC);
+
+			if (buffer) {
+				ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer,
+							       buffer,
+							       dbuf.length);
+				if (ret != 0) {
+					ath10k_err("failed to read Debug Log buffer: 0x%x\n",
+						   dbuf.buffer);
+					kfree(buffer);
+					goto save_regs_and_restart;
+				}
+
+				ath10k_dbg_save_fw_dbg_buffer(ar, buffer,
+							      dbuf.length);
+				kfree(buffer);
+			}
+		}
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
+save_regs_and_restart:
+	if (!ar->crashed_since_read) {
+		ar->crashed_since_read = true;
+		memcpy(ar->reg_dump_values, reg_dump_values,
+		       sizeof(ar->reg_dump_values));
+	}
+
+do_restart:
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
-- 
1.7.11.7

