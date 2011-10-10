Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1JJPQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/34] iwlagn: add "echo test" command to debugfs
Date: Mon, 10 Oct 2011 07:26:51 -0700
Message-Id: <1318256839-31837-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171724_615343_1BD8EB05)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For command queue testing, add "echo test" to debugfs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |    8 +++++++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    1 +
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9cb6c75..2cc6399 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1734,12 +1734,18 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 int iwl_cmd_echo_test(struct iwl_priv *priv)
 {
+	int ret;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ECHO,
 		.flags = CMD_SYNC,
 	};
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	if (ret)
+		IWL_ERR(priv, "echo testing fail: 0X%x\n", ret);
+	else
+		IWL_DEBUG_INFO(priv, "echo testing pass\n");
+	return ret;
 }
 
 static inline int iwl_check_stuck_queue(struct iwl_priv *priv, int txq)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 6d49dfb..ea1452c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2444,6 +2444,23 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_echo_test_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	iwl_cmd_echo_test(priv);
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2467,6 +2484,7 @@ DEBUGFS_WRITE_FILE_OPS(wd_timeout);
 DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
+DEBUGFS_WRITE_FILE_OPS(echo_test);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static ssize_t iwl_dbgfs_debug_level_read(struct file *file,
@@ -2575,6 +2593,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(echo_test, dir_debug, S_IWUSR);
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index bcd7f64..bbd6740 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -47,6 +47,7 @@ const char *get_cmd_string(u8 cmd)
 	switch (cmd) {
 		IWL_CMD(REPLY_ALIVE);
 		IWL_CMD(REPLY_ERROR);
+		IWL_CMD(REPLY_ECHO);
 		IWL_CMD(REPLY_RXON);
 		IWL_CMD(REPLY_RXON_ASSOC);
 		IWL_CMD(REPLY_QOS_PARAM);
-- 
1.7.0.4

