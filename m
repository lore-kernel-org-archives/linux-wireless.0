Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab1KRIX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 77/77] iwlegacy: debugfs_ops should depend on CONFIG_IWLEGACY_DEBUGFS
Date: Fri, 18 Nov 2011 09:22:39 +0100
Message-Id: <1321604559-10707-77-git-send-email-sgruszka@redhat.com> (sfid-20111118_092342_523132_BC4DB472)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Only setup structs related to debugfs_ops when CONFIG_IWLEGACY_DEBUGFS is set.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c   |    2 ++
 drivers/net/wireless/iwlegacy/3945.h   |   21 ---------------------
 drivers/net/wireless/iwlegacy/4965.c   |    2 ++
 drivers/net/wireless/iwlegacy/4965.h   |   21 ---------------------
 drivers/net/wireless/iwlegacy/common.h |    4 ++++
 5 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 7367dbb..863664f 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2671,11 +2671,13 @@ static struct il_lib_ops il3945_lib = {
 	.send_tx_power = il3945_send_tx_power,
 	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
 
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	.debugfs_ops = {
 			.rx_stats_read = il3945_ucode_rx_stats_read,
 			.tx_stats_read = il3945_ucode_tx_stats_read,
 			.general_stats_read = il3945_ucode_general_stats_read,
 			},
+#endif
 };
 
 static const struct il_legacy_ops il3945_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 00d3336..2b2895c 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -621,27 +621,6 @@ ssize_t il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 ssize_t il3945_ucode_general_stats_read(struct file *file,
 					char __user *user_buf, size_t count,
 					loff_t *ppos);
-#else
-static ssize_t
-il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t
-il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t
-il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	return 0;
-}
 #endif
 
 #endif
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index ac80a00..84c54dc 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2333,11 +2333,13 @@ static struct il_lib_ops il4965_lib = {
 	.temp_ops = {
 		     .temperature = il4965_temperature_calib,
 		     },
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	.debugfs_ops = {
 			.rx_stats_read = il4965_ucode_rx_stats_read,
 			.tx_stats_read = il4965_ucode_tx_stats_read,
 			.general_stats_read = il4965_ucode_general_stats_read,
 			},
+#endif
 };
 
 static const struct il_legacy_ops il4965_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index ded8b92..7447231 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -956,27 +956,6 @@ ssize_t il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 ssize_t il4965_ucode_general_stats_read(struct file *file,
 					char __user *user_buf, size_t count,
 					loff_t *ppos);
-#else
-static ssize_t
-il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t
-il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t
-il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	return 0;
-}
 #endif
 
 /****************************/
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index d0975ab..1bc0b02 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1631,6 +1631,7 @@ struct il_apm_ops {
 	void (*config) (struct il_priv *il);
 };
 
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 struct il_debugfs_ops {
 	ssize_t(*rx_stats_read) (struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos);
@@ -1640,6 +1641,7 @@ struct il_debugfs_ops {
 				      char __user *user_buf, size_t count,
 				      loff_t *ppos);
 };
+#endif
 
 struct il_temp_ops {
 	void (*temperature) (struct il_priv *il);
@@ -1683,7 +1685,9 @@ struct il_lib_ops {
 	/* temperature */
 	struct il_temp_ops temp_ops;
 
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	struct il_debugfs_ops debugfs_ops;
+#endif
 
 };
 
-- 
1.7.1

