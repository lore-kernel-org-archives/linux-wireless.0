Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZJPVZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/10] iwlwifi: show current power save status reported by uCode
Date: Fri, 16 Oct 2009 14:25:50 -0700
Message-Id: <1255728358-29976-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Power save request is sent from driver to uCode, but there is no
indication from uCode about the current device power save state.

Reading GP_CNTRL register bit 25:24 to show the current power save
status

00: no power save
01: MAC power down
10: PHY power down
11: Error

The uCode could switch in and out of power save mode in the order of
once per 100-300 ms in many cases. The reading here should just be used for
reference on the current uCode power save status. Do not confuse this
reading with the PowerSave set by driver and mac80211.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 8f183e0..401e1e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -235,6 +235,11 @@
 #define CSR_OTP_GP_REG_OTP_ACCESS_MODE	(0x00020000) /* 0 - absolute, 1 - relative */
 #define CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK          (0x00100000) /* bit 20 */
 #define CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK        (0x00200000) /* bit 21 */
+#define CSR_GP_REG_POWER_SAVE_STATUS_MSK            (0x03000000) /* bit 24/25 */
+#define CSR_GP_REG_NO_POWER_SAVE            (0x00000000)
+#define CSR_GP_REG_MAC_POWER_SAVE           (0x01000000)
+#define CSR_GP_REG_PHY_POWER_SAVE           (0x02000000)
+#define CSR_GP_REG_POWER_SAVE_ERROR         (0x03000000)
 
 /* EEPROM signature */
 #define CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP	(0x00000000)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index b9ca475..96c92ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -106,6 +106,7 @@ struct iwl_debugfs {
 		struct dentry *file_sensitivity;
 		struct dentry *file_chain_noise;
 		struct dentry *file_tx_power;
+		struct dentry *file_power_save_status;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 2cd11ba..e78cd26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1802,6 +1802,29 @@ static ssize_t iwl_dbgfs_tx_power_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
+						    char __user *user_buf,
+						    size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[60];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+	u32 pwrsave_status;
+
+	pwrsave_status = iwl_read32(priv, CSR_GP_CNTRL) &
+			CSR_GP_REG_POWER_SAVE_STATUS_MSK;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
+	pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
+		(pwrsave_status == CSR_GP_REG_NO_POWER_SAVE) ? "none" :
+		(pwrsave_status == CSR_GP_REG_MAC_POWER_SAVE) ? "MAC" :
+		(pwrsave_status == CSR_GP_REG_PHY_POWER_SAVE) ? "PHY" :
+		"error");
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1813,6 +1836,7 @@ DEBUGFS_READ_FILE_OPS(ucode_general_stats);
 DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(tx_power);
+DEBUGFS_READ_FILE_OPS(power_save_status);
 
 /*
  * Create the debugfs files and directories
@@ -1860,6 +1884,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rx_queue, debug);
 	DEBUGFS_ADD_FILE(tx_queue, debug);
 	DEBUGFS_ADD_FILE(tx_power, debug);
+	DEBUGFS_ADD_FILE(power_save_status, debug);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
@@ -1912,6 +1937,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_power);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_power_save_status);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
-- 
1.5.6.3

