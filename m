Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2DWVw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/29] iwlwifi: move iwl_cmd_echo_test
Date: Mon, 23 Apr 2012 14:47:26 -0700
Message-Id: <1335217660-21950-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235322_788187_97B5E701)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function can be static with the only user.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |   17 -----------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   17 +++++++++++++++++
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2a09678..a476397 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -275,20 +275,3 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 	}
 }
 #endif
-
-int iwl_cmd_echo_test(struct iwl_priv *priv)
-{
-	int ret;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_ECHO,
-		.len = { 0 },
-		.flags = CMD_SYNC,
-	};
-
-	ret = iwl_dvm_send_cmd(priv, &cmd);
-	if (ret)
-		IWL_ERR(priv, "echo testing fail: 0X%x\n", ret);
-	else
-		IWL_DEBUG_INFO(priv, "echo testing pass\n");
-	return ret;
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index de7f6cd..3ec011b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -76,7 +76,6 @@ struct iwl_cmd;
  *   L i b                 *
  ***************************/
 
-int iwl_cmd_echo_test(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 11ca48e..f4a9910 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2383,6 +2383,23 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	return count;
 }
 
+static int iwl_cmd_echo_test(struct iwl_priv *priv)
+{
+	int ret;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_ECHO,
+		.len = { 0 },
+		.flags = CMD_SYNC,
+	};
+
+	ret = iwl_dvm_send_cmd(priv, &cmd);
+	if (ret)
+		IWL_ERR(priv, "echo testing fail: 0X%x\n", ret);
+	else
+		IWL_DEBUG_INFO(priv, "echo testing pass\n");
+	return ret;
+}
+
 static ssize_t iwl_dbgfs_echo_test_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
-- 
1.7.0.4

