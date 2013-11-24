Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41855 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3KXUHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:06 -0500
Received: by mail-wg0-f54.google.com with SMTP id n12so1948513wgh.21
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:05 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/29] iwlwifi: mvm: small debugfs cleanups
Date: Sun, 24 Nov 2013 22:06:29 +0200
Message-Id: <1385323606-3603-12-git-send-email-egrumbach@gmail.com> (sfid-20131124_210807_521830_ABFB51D9)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just clean up the code a bit, in particular
 * make all the debugfs writes follow the same pattern
   with respect to buf/buf_size variables
 * get rid of useless comments
 * check return values of all file creations
 * drop unnecessary parentheses
 * remove an unused struct definition
 * fix some whitespace

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   77 ++++++++++------------------
 1 file changed, 27 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 4b31d06..9cb340a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -65,26 +65,19 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 
-struct iwl_dbgfs_mvm_ctx {
-	struct iwl_mvm *mvm;
-	struct ieee80211_vif *vif;
-};
-
 static ssize_t iwl_dbgfs_tx_flush_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-
-	char buf[16];
-	int buf_size, ret;
+	char buf[16] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
+	int ret;
 	u32 scd_q_msk;
 
 	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
@@ -106,15 +99,13 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct file *file,
 {
 	struct iwl_mvm *mvm = file->private_data;
 	struct ieee80211_sta *sta;
-
-	char buf[8];
-	int buf_size, sta_id, drain, ret;
+	char buf[8] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
+	int sta_id, drain, ret;
 
 	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
 		return -EIO;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
@@ -196,12 +187,10 @@ static ssize_t iwl_dbgfs_sram_write(struct file *file,
 				    loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	char buf[64];
-	int buf_size;
+	char buf[64] = {};
+	size_t buf_size = min(count, sizeof(buf) -  1);
 	u32 offset, len;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
@@ -270,14 +259,14 @@ static ssize_t iwl_dbgfs_disable_power_off_write(struct file *file,
 {
 	struct iwl_mvm *mvm = file->private_data;
 	char buf[64] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
 	int ret;
 	int val;
 
 	if (!mvm->ucode_loaded)
 		return -EIO;
 
-	count = min_t(size_t, count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, count))
+	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
 	if (!strncmp("disable_power_off_d0=", buf, 21)) {
@@ -315,11 +304,10 @@ static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
 		int dtimper_msec = dtimper * vif->bss_conf.beacon_int;
 
 		IWL_DEBUG_POWER(mvm, "debugfs: set keep_alive= %d sec\n", val);
-		if (val * MSEC_PER_SEC < 3 * dtimper_msec) {
+		if (val * MSEC_PER_SEC < 3 * dtimper_msec)
 			IWL_WARN(mvm,
 				 "debugfs: keep alive period (%ld msec) is less than minimum required (%d msec)\n",
 				 val * MSEC_PER_SEC, 3 * dtimper_msec);
-		}
 		dbgfs_pm->keep_alive_seconds = val;
 		break;
 	}
@@ -368,11 +356,11 @@ static ssize_t iwl_dbgfs_pm_params_write(struct file *file,
 	struct iwl_mvm *mvm = mvmvif->dbgfs_data;
 	enum iwl_dbgfs_pm_mask param;
 	char buf[32] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
 	int val;
 	int ret;
 
-	count = min_t(size_t, count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, count))
+	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
 	if (!strncmp("keep_alive=", buf, 11)) {
@@ -467,7 +455,7 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	pos += scnprintf(buf+pos, bufsz-pos, "bssid: %pM\n",
 			 vif->bss_conf.bssid);
 	pos += scnprintf(buf+pos, bufsz-pos, "QoS:\n");
-	for (i = 0; i < ARRAY_SIZE(mvmvif->queue_params); i++) {
+	for (i = 0; i < ARRAY_SIZE(mvmvif->queue_params); i++)
 		pos += scnprintf(buf+pos, bufsz-pos,
 				 "\t%d: txop:%d - cw_min:%d - cw_max = %d - aifs = %d upasd = %d\n",
 				 i, mvmvif->queue_params[i].txop,
@@ -475,7 +463,6 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 				 mvmvif->queue_params[i].cw_max,
 				 mvmvif->queue_params[i].aifs,
 				 mvmvif->queue_params[i].uapsd);
-	}
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
 	    ap_sta_id != IWL_MVM_STATION_COUNT) {
@@ -492,12 +479,11 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-	if (chanctx_conf) {
+	if (chanctx_conf)
 		pos += scnprintf(buf+pos, bufsz-pos,
 				 "idle rx chains %d, active rx chains: %d\n",
 				 chanctx_conf->rx_chains_static,
 				 chanctx_conf->rx_chains_dynamic);
-	}
 	rcu_read_unlock();
 
 	mutex_unlock(&mvm->mutex);
@@ -841,14 +827,10 @@ iwl_dbgfs_scan_ant_rxchain_write(struct file *file,
 				 size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	char buf[8];
-	int buf_size;
+	char buf[8] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
 	u8 scan_rx_ant;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
-
-	/* get the argument from the user and check if it is valid */
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 	if (sscanf(buf, "%hhx", &scan_rx_ant) != 1)
@@ -858,7 +840,6 @@ iwl_dbgfs_scan_ant_rxchain_write(struct file *file,
 	if (scan_rx_ant & ~iwl_fw_valid_rx_ant(mvm->fw))
 		return -EINVAL;
 
-	/* change the rx antennas for scan command */
 	mvm->scan_rx_ant = scan_rx_ant;
 
 	return count;
@@ -918,13 +899,10 @@ static ssize_t iwl_dbgfs_bf_params_write(struct file *file,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->dbgfs_data;
 	enum iwl_dbgfs_bf_mask param;
-	char buf[256];
-	int buf_size;
-	int value;
-	int ret = 0;
+	char buf[256] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
+	int value, ret = 0;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
@@ -1008,11 +986,10 @@ static ssize_t iwl_dbgfs_bf_params_write(struct file *file,
 
 	mutex_lock(&mvm->mutex);
 	iwl_dbgfs_update_bf(vif, param, value);
-	if (param == MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER && !value) {
+	if (param == MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER && !value)
 		ret = iwl_mvm_disable_beacon_filter(mvm, vif);
-	} else {
+	else
 		ret = iwl_mvm_enable_beacon_filter(mvm, vif);
-	}
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
@@ -1074,10 +1051,10 @@ static ssize_t iwl_dbgfs_d3_sram_write(struct file *file,
 {
 	struct iwl_mvm *mvm = file->private_data;
 	char buf[8] = {};
+	size_t buf_size = min(count, sizeof(buf) - 1);
 	int store;
 
-	count = min_t(size_t, count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, count))
+	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
 	if (sscanf(buf, "%d", &store) != 1)
@@ -1133,14 +1110,14 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 #endif
 
 #define MVM_DEBUGFS_READ_FILE_OPS(name)					\
-static const struct file_operations iwl_dbgfs_##name##_ops = {	\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 }
 
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name)				\
-static const struct file_operations iwl_dbgfs_##name##_ops = {	\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = iwl_dbgfs_##name##_write,				\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
@@ -1148,7 +1125,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {	\
 };
 
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name)				\
-static const struct file_operations iwl_dbgfs_##name##_ops = {	\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = iwl_dbgfs_##name##_write,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
-- 
1.7.9.5

