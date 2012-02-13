Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab2BMKX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:23:56 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/24] iwlegacy: move debugfs_ops to il_priv
Date: Mon, 13 Feb 2012 11:23:14 +0100
Message-Id: <1329128611-6815-8-git-send-email-sgruszka@redhat.com> (sfid-20120213_112400_217038_318150EE)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-debug.c |    6 ++++++
 drivers/net/wireless/iwlegacy/3945-mac.c   |    3 +++
 drivers/net/wireless/iwlegacy/3945.c       |    8 --------
 drivers/net/wireless/iwlegacy/3945.h       |    8 +-------
 drivers/net/wireless/iwlegacy/4965-debug.c |    6 ++++++
 drivers/net/wireless/iwlegacy/4965-mac.c   |    3 +++
 drivers/net/wireless/iwlegacy/4965.c       |    7 -------
 drivers/net/wireless/iwlegacy/4965.h       |    8 +-------
 drivers/net/wireless/iwlegacy/common.h     |   10 ++++------
 drivers/net/wireless/iwlegacy/debug.c      |    9 ++++++---
 10 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-debug.c b/drivers/net/wireless/iwlegacy/3945-debug.c
index 5e1a19f..f767dd1 100644
--- a/drivers/net/wireless/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/iwlegacy/3945-debug.c
@@ -503,3 +503,9 @@ il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	kfree(buf);
 	return ret;
 }
+
+const struct il_debugfs_ops il3945_debugfs_ops = {
+	.rx_stats_read = il3945_ucode_rx_stats_read,
+	.tx_stats_read = il3945_ucode_tx_stats_read,
+	.general_stats_read = il3945_ucode_general_stats_read,
+};
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 63ec05b..b7d5ebc 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3619,6 +3619,9 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
 	il->ops = &il3945_ops;
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+	il->debugfs_ops = &il3945_debugfs_ops;
+#endif
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
 
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 66a5dc0..4e63e7d 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2651,14 +2651,6 @@ static struct il_lib_ops il3945_lib = {
 	},
 	.send_tx_power = il3945_send_tx_power,
 	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
-
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-	.debugfs_ops = {
-			.rx_stats_read = il3945_ucode_rx_stats_read,
-			.tx_stats_read = il3945_ucode_tx_stats_read,
-			.general_stats_read = il3945_ucode_general_stats_read,
-			},
-#endif
 };
 
 static const struct il_legacy_ops il3945_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index c00a8d3..1d45075 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -595,13 +595,7 @@ struct il3945_tfd {
 } __packed;
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-ssize_t il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos);
-ssize_t il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos);
-ssize_t il3945_ucode_general_stats_read(struct file *file,
-					char __user *user_buf, size_t count,
-					loff_t *ppos);
+extern const struct il_debugfs_ops il3945_debugfs_ops;
 #endif
 
 #endif
diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index 98ec39f..c8153fc 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -744,3 +744,9 @@ il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	kfree(buf);
 	return ret;
 }
+
+const struct il_debugfs_ops il4965_debugfs_ops = {
+	.rx_stats_read = il4965_ucode_rx_stats_read,
+	.tx_stats_read = il4965_ucode_tx_stats_read,
+	.general_stats_read = il4965_ucode_general_stats_read,
+};
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 4560021..36f85f2 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6483,6 +6483,9 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
 	il->ops = &il4965_ops;
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+	il->debugfs_ops = &il4965_debugfs_ops;
+#endif
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index cf49a7a..34fa3db 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1913,13 +1913,6 @@ static struct il_lib_ops il4965_lib = {
 	.temp_ops = {
 		     .temperature = il4965_temperature_calib,
 		     },
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-	.debugfs_ops = {
-			.rx_stats_read = il4965_ucode_rx_stats_read,
-			.tx_stats_read = il4965_ucode_tx_stats_read,
-			.general_stats_read = il4965_ucode_general_stats_read,
-			},
-#endif
 };
 
 static const struct il_legacy_ops il4965_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index befa7e6..b3fcb8f 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -928,13 +928,7 @@ void il4965_calib_free_results(struct il_priv *il);
 
 /* Debug */
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos);
-ssize_t il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos);
-ssize_t il4965_ucode_general_stats_read(struct file *file,
-					char __user *user_buf, size_t count,
-					loff_t *ppos);
+extern const struct il_debugfs_ops il4965_debugfs_ops;
 #endif
 
 /****************************/
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 1c0d969..cd8f27d 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1155,13 +1155,15 @@ struct il_power_mgr {
 };
 
 struct il_priv {
-
-	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
+
 	struct il_cfg *cfg;
 	const struct il_ops *ops;
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+	const struct il_debugfs_ops *debugfs_ops;
+#endif
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
@@ -1624,10 +1626,6 @@ struct il_lib_ops {
 	/* temperature */
 	struct il_temp_ops temp_ops;
 
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-	struct il_debugfs_ops debugfs_ops;
-#endif
-
 };
 
 struct il_led_ops {
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index bb7c956..5091db8 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -901,7 +901,8 @@ il_dbgfs_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	return il->ops->lib->debugfs_ops.rx_stats_read(file, user_buf, count, ppos);
+
+	return il->debugfs_ops->rx_stats_read(file, user_buf, count, ppos);
 }
 
 static ssize_t
@@ -909,7 +910,8 @@ il_dbgfs_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	return il->ops->lib->debugfs_ops.tx_stats_read(file, user_buf, count, ppos);
+
+	return il->debugfs_ops->tx_stats_read(file, user_buf, count, ppos);
 }
 
 static ssize_t
@@ -917,7 +919,8 @@ il_dbgfs_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
 	struct il_priv *il = file->private_data;
-	return il->ops->lib->debugfs_ops.general_stats_read(file, user_buf, count, ppos);
+
+	return il->debugfs_ops->general_stats_read(file, user_buf, count, ppos);
 }
 
 static ssize_t
-- 
1.7.1

