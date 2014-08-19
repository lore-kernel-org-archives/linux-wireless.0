Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:37020 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHSIW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 04:22:57 -0400
Subject: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Aug 2014 11:22:53 +0300
Message-ID: <20140819082253.16842.32433.stgit@potku.adurom.net> (sfid-20140819_102302_595485_51591FCF)
In-Reply-To: <20140819082038.16842.46876.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Store the firmware crash registers and last 128 or so
firmware debug-log ids and present them to user-space
via debugfs.

Should help with figuring out why the firmware crashed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   27 +++
 drivers/net/wireless/ath/ath10k/debug.c |  280 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   22 ++
 drivers/net/wireless/ath/ath10k/hw.h    |   29 +++
 drivers/net/wireless/ath/ath10k/pci.c   |  133 ++++++++++++++-
 drivers/net/wireless/ath/ath10k/pci.h   |    3 
 6 files changed, 481 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cca6060dbf30..09c0a109368a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -22,6 +22,8 @@
 #include <linux/if_ether.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/uuid.h>
+#include <linux/time.h>
 
 #include "htt.h"
 #include "htc.h"
@@ -278,6 +280,29 @@ struct ath10k_vif_iter {
 	struct ath10k_vif *arvif;
 };
 
+/* This will store at least the last 128 entries.  Each dbglog message
+ * is a max of 7 32-bit integers in length, but the length can be less
+ * than that as well.
+ */
+#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * sizeof(u32))
+
+struct ath10k_dbglog_entry_storage {
+	/* where to write next chunk of data */
+	u32 next_idx;
+
+	u8 data[ATH10K_DBGLOG_DATA_LEN];
+};
+
+/* used for crash-dump storage, protected by data-lock */
+struct ath10k_fw_crash_data {
+	bool crashed_since_read;
+
+	uuid_le uuid;
+	struct timespec timestamp;
+	struct ath10k_dbglog_entry_storage dbglog_entry_data;
+	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X];
+};
+
 struct ath10k_debug {
 	struct dentry *debugfs_phy;
 
@@ -295,6 +320,8 @@ struct ath10k_debug {
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
+
+	struct ath10k_fw_crash_data *fw_crash_data;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index df1abe7f1fef..8c3f9acd6492 100644
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
@@ -24,6 +27,87 @@
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
 
+#define ATH10K_FW_CRASH_DUMP_VERSION 1
+
+/**
+ * enum ath10k_fw_crash_dump_type - types of data in the dump file
+ * @ATH10K_FW_CRASH_DUMP_DBGLOG:  Recent firmware debug log entries
+ * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
+ */
+enum ath10k_fw_crash_dump_type {
+	ATH10K_FW_CRASH_DUMP_DBGLOG = 0,
+	ATH10K_FW_CRASH_DUMP_REGDUMP = 1,
+
+	ATH10K_FW_CRASH_DUMP_MAX,
+};
+
+struct ath10k_tlv_dump_data {
+	/* see ath10k_fw_crash_dump_type above */
+	__le32 type;
+
+	/* in bytes */
+	__le32 tlv_len;
+
+	/* pad to 32-bit boundaries as needed */
+	u8 tlv_data[];
+} __packed;
+
+struct ath10k_dump_file_data {
+	/* dump file information */
+
+	/* "ATH10K-FW-DUMP" */
+	char df_magic[16];
+
+	__le32 len;
+
+	/* file dump version */
+	__le32 version;
+
+	/* some info we can get from ath10k struct that might help */
+
+	u8 uuid[16];
+
+	__le32 chip_id;
+
+	/* 0 for now, in place for later hardware */
+	__le32 bus_type;
+
+	__le32 target_version;
+	__le32 fw_version_major;
+	__le32 fw_version_minor;
+	__le32 fw_version_release;
+	__le32 fw_version_build;
+	__le32 phy_capability;
+	__le32 hw_min_tx_power;
+	__le32 hw_max_tx_power;
+	__le32 ht_cap_info;
+	__le32 vht_cap_info;
+	__le32 num_rf_chains;
+
+	/* firmware version string */
+	char fw_ver[ETHTOOL_FWVERS_LEN];
+
+	/* Kernel related information */
+
+	/* time-of-day stamp */
+	__le64 tv_sec;
+
+	/* time-of-day stamp, nano-seconds */
+	__le64 tv_nsec;
+
+	/* LINUX_VERSION_CODE */
+	__le32 kernel_ver_code;
+
+	/* VERMAGIC_STRING */
+	char kernel_ver[64];
+
+	/* room for growth w/out changing binary format */
+	u8 unused[128];
+
+	/* struct ath10k_tlv_dump_data + more */
+	u8 data[0];
+} __packed;
+
 static int ath10k_printk(const char *level, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -588,6 +672,177 @@ static const struct file_operations fops_chip_id = {
 	.llseek = default_llseek,
 };
 
+struct ath10k_fw_crash_data *
+ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
+{
+	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	crash_data->crashed_since_read = true;
+	uuid_le_gen(&crash_data->uuid);
+	getnstimeofday(&crash_data->timestamp);
+
+	return crash_data;
+}
+EXPORT_SYMBOL(ath10k_debug_get_new_fw_crash_data);
+
+void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len)
+{
+	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
+	int i, z;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	z = crash_data->dbglog_entry_data.next_idx;
+
+	for (i = 0; i < len; i++) {
+		crash_data->dbglog_entry_data.data[z] = buffer[i];
+		z++;
+		if (z >= ATH10K_DBGLOG_DATA_LEN)
+			z = 0;
+	}
+
+	crash_data->dbglog_entry_data.next_idx = z;
+}
+EXPORT_SYMBOL(ath10k_debug_dbglog_add);
+
+static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
+{
+	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
+	struct ath10k_dump_file_data *dump_data;
+	struct ath10k_tlv_dump_data *dump_tlv;
+	int hdr_len = sizeof(*dump_data);
+	unsigned int len, sofar = 0;
+	unsigned char *buf;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	len = hdr_len;
+	len += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
+	len += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
+
+	sofar += hdr_len;
+
+	/* This is going to get big when we start dumping FW RAM and such,
+	 * so go ahead and use vmalloc.
+	 */
+	buf = vzalloc(len);
+	if (!buf)
+		return NULL;
+
+	spin_lock_bh(&ar->data_lock);
+
+	if (!crash_data->crashed_since_read) {
+		spin_unlock_bh(&ar->data_lock);
+		vfree(buf);
+		return NULL;
+	}
+
+	dump_data = (struct ath10k_dump_file_data *)(buf);
+	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
+		sizeof(dump_data->df_magic));
+	dump_data->len = cpu_to_le32(len);
+
+	dump_data->version = cpu_to_le32(ATH10K_FW_CRASH_DUMP_VERSION);
+
+	memcpy(dump_data->uuid, &crash_data->uuid, sizeof(dump_data->uuid));
+	dump_data->chip_id = cpu_to_le32(ar->chip_id);
+	dump_data->bus_type = cpu_to_le32(0);
+	dump_data->target_version = cpu_to_le32(ar->target_version);
+	dump_data->fw_version_major = cpu_to_le32(ar->fw_version_major);
+	dump_data->fw_version_minor = cpu_to_le32(ar->fw_version_minor);
+	dump_data->fw_version_release = cpu_to_le32(ar->fw_version_release);
+	dump_data->fw_version_build = cpu_to_le32(ar->fw_version_build);
+	dump_data->phy_capability = cpu_to_le32(ar->phy_capability);
+	dump_data->hw_min_tx_power = cpu_to_le32(ar->hw_min_tx_power);
+	dump_data->hw_max_tx_power = cpu_to_le32(ar->hw_max_tx_power);
+	dump_data->ht_cap_info = cpu_to_le32(ar->ht_cap_info);
+	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
+	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
+
+	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
+		sizeof(dump_data->fw_ver));
+
+	dump_data->kernel_ver_code = cpu_to_le32(LINUX_VERSION_CODE);
+	strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
+		sizeof(dump_data->kernel_ver));
+
+	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
+	dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
+
+	/* Gather dbg-log */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->dbglog_entry_data));
+	memcpy(dump_tlv->tlv_data, &crash_data->dbglog_entry_data,
+	       sizeof(crash_data->dbglog_entry_data));
+	sofar += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
+
+	/* Gather crash-dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGDUMP);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->reg_dump_values));
+	memcpy(dump_tlv->tlv_data, &crash_data->reg_dump_values,
+	       sizeof(crash_data->reg_dump_values));
+	sofar += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
+
+	ar->debug.fw_crash_data->crashed_since_read = false;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	return dump_data;
+}
+
+static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
+{
+	struct ath10k *ar = inode->i_private;
+	struct ath10k_dump_file_data *dump;
+	int ret;
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
+	ret = 0;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static ssize_t ath10k_fw_crash_dump_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath10k_dump_file_data *dump_file = file->private_data;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       dump_file,
+				       le32_to_cpu(dump_file->len));
+}
+
+static int ath10k_fw_crash_dump_release(struct inode *inode,
+					struct file *file)
+{
+	vfree(file->private_data);
+
+	return 0;
+}
+
+static const struct file_operations fops_fw_crash_dump = {
+	.open = ath10k_fw_crash_dump_open,
+	.read = ath10k_fw_crash_dump_read,
+	.release = ath10k_fw_crash_dump_release,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static int ath10k_debug_htt_stats_req(struct ath10k *ar)
 {
 	u64 cookie;
@@ -921,11 +1176,20 @@ static const struct file_operations fops_dfs_stats = {
 
 int ath10k_debug_create(struct ath10k *ar)
 {
+	int ret;
+
+	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
+	if (!ar->debug.fw_crash_data) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
 						   ar->hw->wiphy->debugfsdir);
-
-	if (!ar->debug.debugfs_phy)
-		return -ENOMEM;
+	if (!ar->debug.debugfs_phy) {
+		ret = -ENOMEM;
+		goto err_free_fw_crash_data;
+	}
 
 	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
 			  ath10k_debug_htt_stats_dwork);
@@ -941,6 +1205,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_simulate_fw_crash);
 
+	debugfs_create_file("fw_crash_dump", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_fw_crash_dump);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
@@ -969,10 +1236,17 @@ int ath10k_debug_create(struct ath10k *ar)
 	}
 
 	return 0;
+
+err_free_fw_crash_data:
+	vfree(ar->debug.fw_crash_data);
+
+err:
+	return ret;
 }
 
 void ath10k_debug_destroy(struct ath10k *ar)
 {
+	vfree(ar->debug.fw_crash_data);
 	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index a5824990bd2a..80ff14e4db9b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -53,6 +53,10 @@ void ath10k_debug_read_service_map(struct ath10k *ar,
 				   size_t map_size);
 void ath10k_debug_read_target_stats(struct ath10k *ar,
 				    struct wmi_stats_event *ev);
+struct ath10k_fw_crash_data *
+ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
+
+void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
 
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
@@ -86,6 +90,17 @@ static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
 {
 }
 
+static inline void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer,
+					   int len)
+{
+}
+
+static inline struct ath10k_fw_crash_data *
+ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
+{
+	return NULL;
+}
+
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #endif /* CONFIG_ATH10K_DEBUGFS */
@@ -96,6 +111,7 @@ __printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
 void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
+
 #else /* CONFIG_ATH10K_DEBUG */
 
 static inline int ath10k_dbg(enum ath10k_debug_mask dbg_mask,
@@ -109,5 +125,11 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
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
index ffd04890407e..c931cce17063 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -39,6 +39,8 @@
 /* includes also the null byte */
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
 
+#define REG_DUMP_COUNT_QCA988X 60
+
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
@@ -362,4 +364,31 @@ enum ath10k_mcast2ucast_mode {
 
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
+
+/* Target debug log related defines and structs */
+
+/* Target is 32-bit CPU, so we just use u32 for
+ * the pointers.  The memory space is relative to the
+ * target, not the host.
+ */
+struct ath10k_fw_dbglog_buf {
+	/* pointer to dblog_buf_s */
+	u32 next;
+
+	/* pointer to u8 buffer */
+	u32 buffer;
+
+	u32 bufsize;
+	u32 length;
+	u32 count;
+	u32 free;
+} __packed;
+
+struct ath10k_fw_dbglog_hdr {
+	/* pointer to dbglog_buf_s */
+	u32 dbuf;
+
+	u32 dropped;
+} __packed;
+
 #endif /* _HW_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b4ae4bb3fc09..41ff620e1af2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -832,16 +832,103 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
-static void ath10k_pci_hif_dump_area(struct ath10k *ar)
+static void ath10k_pci_dump_dbglog(struct ath10k *ar,
+				   struct ath10k_fw_crash_data *crash_data)
+{
+	struct ath10k_fw_dbglog_hdr dbg_hdr;
+	struct ath10k_fw_dbglog_buf dbuf;
+	u8 *buffer;
+	int ret, i;
+	u32 dbufp;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	/* dump the debug logs on the target */
+	ret = ath10k_pci_diag_read_hi(ar, &dbg_hdr,
+				      hi_dbglog_hdr, sizeof(dbg_hdr));
+	if (ret != 0) {
+		ath10k_warn("failed to dump debug log area from hi_dbglog_hdr: %d\n",
+			    ret);
+		return;
+	}
+
+	ath10k_dbg(ATH10K_DBG_PCI,
+		   "pci dbglog header dbuf 0x%x dropped %i\n",
+		   dbg_hdr.dbuf, dbg_hdr.dropped);
+
+	/* pointer in target memory space */
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
+			ath10k_warn("failed to read debug log area from address 0x%x: %d\n",
+				    dbufp, ret);
+			return;
+		}
+
+		/* we have a buffer of data */
+		ath10k_dbg(ATH10K_DBG_PCI,
+			   "pci dbglog [%i] next 0x%x buf 0x%x size %i len %i count %i free %i\n",
+			   i, dbuf.next, dbuf.buffer, dbuf.bufsize, dbuf.length,
+			   dbuf.count, dbuf.free);
+		if (dbuf.buffer == 0 || dbuf.length == 0)
+			goto next;
+
+		/* Pick arbitrary upper bound in case firmware is corrupted for
+		 * whatever reason.
+		 */
+		if (dbuf.length > 16000) {
+			ath10k_warn("firmware debug log buffer length is out of bounds: %d\n",
+				    dbuf.length);
+			/* do not trust the next pointer either... */
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
+			ath10k_warn("failed to read debug log buffer from address 0x%x: %d\n",
+				    dbuf.buffer, ret);
+			kfree(buffer);
+			return;
+		}
+
+		ath10k_debug_dbglog_add(ar, buffer, dbuf.length);
+		kfree(buffer);
+
+next:
+		dbufp = dbuf.next;
+		if (dbufp == dbg_hdr.dbuf) {
+			/* It is a circular buffer it seems, bail if next
+			 * is head.
+			 */
+			break;
+		}
+		i++;
+	} /* while we have a debug buffer to read */
+}
+
+static void ath10k_pci_dump_registers(struct ath10k *ar,
+				      struct ath10k_fw_crash_data *crash_data)
 {
-	u32 reg_dump_values[REG_DUMP_COUNT_QCA988X] = {};
+	u32 i, reg_dump_values[REG_DUMP_COUNT_QCA988X] = {};
 	int ret;
-	u32 i;
 
-	ath10k_err("firmware crashed!\n");
-	ath10k_err("hardware name %s version 0x%x\n",
-		   ar->hw_params.name, ar->target_version);
-	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
+	lockdep_assert_held(&ar->data_lock);
 
 	ret = ath10k_pci_diag_read_hi(ar, &reg_dump_values[0],
 				      hi_failure_state,
@@ -862,6 +949,38 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+	memcpy(crash_data->reg_dump_values, reg_dump_values,
+	       sizeof(crash_data->reg_dump_values));
+}
+
+static void ath10k_pci_hif_dump_area(struct ath10k *ar)
+{
+	struct ath10k_fw_crash_data *crash_data;
+	char uuid[50];
+
+	spin_lock_bh(&ar->data_lock);
+
+	crash_data = ath10k_debug_get_new_fw_crash_data(ar);
+
+	if (crash_data)
+		scnprintf(uuid, sizeof(uuid), "%pUl", &crash_data->uuid);
+	else
+		scnprintf(uuid, sizeof(uuid), "n/a");
+
+	ath10k_err("firmware crashed! (uuid %s)\n", uuid);
+	ath10k_err("hardware name %s version 0x%x\n",
+		   ar->hw_params.name, ar->target_version);
+	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
+
+	if (!crash_data)
+		goto exit;
+
+	ath10k_pci_dump_registers(ar, crash_data);
+	ath10k_pci_dump_dbglog(ar, crash_data);
+
+exit:
+	spin_unlock_bh(&ar->data_lock);
+
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 662bca3922ef..294a72e01909 100644
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

