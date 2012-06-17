Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61482 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2FQU6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 16:58:37 -0400
Received: by eaak11 with SMTP id k11so1356351eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2012 13:58:36 -0700 (PDT)
From: Lekensteyn <lekensteyn@gmail.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: fix Oops on reading debugfs log_event
Date: Sun, 17 Jun 2012 22:58:30 +0200
Message-ID: <7841457.8s9HYuaGXa@penguin> (sfid-20120617_225841_623189_7D659120)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before this patch, reading log_event would print the event log to syslog and
crash if CONFIG_IWLWIFI_DEBUG was disabled (while CONFIG_IWLWIFI_DEBUGFS was
enabled of course). The crash was caused by (1) iwl_dbgfs_log_event_read failing
to initialize variable buf, thereby causing the following kfree(buf) to be
executed. (2) iwl_dump_nic_event_log does not initialize buf if
CONFIG_IWLWIFI_DEBUG was disabled.

Tested-by: Lekensteyn <lekensteyn@gmail.com>
Signed-off-by: Lekensteyn <lekensteyn@gmail.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 8a2d9e6..e315dc7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2233,7 +2233,7 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	char *buf;
+	char *buf = NULL;
 	int pos = 0;
 	ssize_t ret = -ENOMEM;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index e620af3..b28ab67 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1915,7 +1915,6 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
 		size);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
 	if (display) {
 		if (full_log)
 			bufsz = capacity * 48;
@@ -1925,6 +1924,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		if (!*buf)
 			return -ENOMEM;
 	}
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_have_debug_level(IWL_DL_FW_ERRORS) || full_log) {
 		/*
 		 * if uCode has wrapped back to top of log,
-- 
1.7.9.5


