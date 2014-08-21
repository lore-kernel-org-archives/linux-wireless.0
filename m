Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:58115 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaHUMtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 08:49:13 -0400
Subject: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Aug 2014 15:49:07 +0300
Message-ID: <20140821124907.27159.64620.stgit@potku.adurom.net> (sfid-20140821_144916_865910_8B25D7B4)
In-Reply-To: <20140821124705.27159.67898.stgit@potku.adurom.net>
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Store the firmware registers and other relevant data to a firmware crash dump
file and provide it to user-space via debugfs. Should help with figuring out
why the firmware crashed.

kvalo: remove dbglog support, rework and refactor the code to avoid ifdefs and
otherwise simplify it as well

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   13 ++
 drivers/net/wireless/ath/ath10k/debug.c |  249 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   15 ++
 drivers/net/wireless/ath/ath10k/hw.h    |    2 
 drivers/net/wireless/ath/ath10k/pci.c   |   43 ++++-
 drivers/net/wireless/ath/ath10k/pci.h   |    3 
 6 files changed, 312 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cca6060dbf30..8da77c706708 100644
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
@@ -278,6 +280,15 @@ struct ath10k_vif_iter {
 	struct ath10k_vif *arvif;
 };
 
+/* used for crash-dump storage, protected by data-lock */
+struct ath10k_fw_crash_data {
+	bool crashed_since_read;
+
+	uuid_le uuid;
+	struct timespec timestamp;
+	__le32 registers[REG_DUMP_COUNT_QCA988X];
+};
+
 struct ath10k_debug {
 	struct dentry *debugfs_phy;
 
@@ -295,6 +306,8 @@ struct ath10k_debug {
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
+
+	struct ath10k_fw_crash_data *fw_crash_data;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index df1abe7f1fef..b30dba661c07 100644
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
@@ -24,6 +27,85 @@
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
 
+#define ATH10K_FW_CRASH_DUMP_VERSION 1
+
+/**
+ * enum ath10k_fw_crash_dump_type - types of data in the dump file
+ * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
+ */
+enum ath10k_fw_crash_dump_type {
+	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
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
@@ -588,6 +670,148 @@ static const struct file_operations fops_chip_id = {
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
+	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
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
+	/* Gather crash-dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGISTERS);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->registers));
+	memcpy(dump_tlv->tlv_data, &crash_data->registers,
+	       sizeof(crash_data->registers));
+	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
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
@@ -921,11 +1145,20 @@ static const struct file_operations fops_dfs_stats = {
 
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
@@ -941,6 +1174,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_simulate_fw_crash);
 
+	debugfs_create_file("fw_crash_dump", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_fw_crash_dump);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
@@ -969,10 +1205,17 @@ int ath10k_debug_create(struct ath10k *ar)
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
index a5824990bd2a..416c62bbbb26 100644
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
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index ffd04890407e..13568b01de9f 100644
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
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b4ae4bb3fc09..36c4f4130027 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -832,16 +832,13 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
-static void ath10k_pci_hif_dump_area(struct ath10k *ar)
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
@@ -862,6 +859,38 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+	/* crash_data is in little endian */
+	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i++)
+		crash_data->registers[i] = cpu_to_le32(reg_dump_values[i]);
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

