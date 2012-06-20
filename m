Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2FTGqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:46:31 -0400
Message-ID: <1340174785.4655.6.camel@jlt3.sipsolutions.net> (sfid-20120620_084634_235634_63B42DD6)
Subject: [PATCH 3.5] iwlwifi: remove log_event debugfs file debugging is
 disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lekensteyn <lekensteyn@gmail.com>
Date: Wed, 20 Jun 2012 08:46:25 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When debugging is disabled, the event log functions aren't
functional in the way that the debugfs file expects. This
leads to the debugfs access crashing. Since the event log
functions aren't functional then, remove the debugfs file
when CONFIG_IWLWIFI_DEBUG is not set.

Cc: stable@kernel.org
Reported-by: Lekensteyn <lekensteyn@gmail.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
John, I didn't think sending you a pull request for a single patch was
worthwhile, can you apply this straggler patch I have for 3.5?

 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e7c157e..7f97dec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2239,6 +2239,7 @@ static ssize_t iwl_dbgfs_echo_test_write(struct file *file,
 	return count;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -2276,6 +2277,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 
 	return count;
 }
+#endif
 
 static ssize_t iwl_dbgfs_calib_disabled_read(struct file *file,
 					 char __user *user_buf,
@@ -2345,7 +2347,9 @@ DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
 DEBUGFS_WRITE_FILE_OPS(echo_test);
+#ifdef CONFIG_IWLWIFI_DEBUG
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+#endif
 DEBUGFS_READ_WRITE_FILE_OPS(calib_disabled);
 
 /*
@@ -2405,7 +2409,9 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(echo_test, dir_debug, S_IWUSR);
+#ifdef CONFIG_IWLWIFI_DEBUG
 	DEBUGFS_ADD_FILE(log_event, dir_debug, S_IWUSR | S_IRUSR);
+#endif
 
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
-- 
1.7.10



