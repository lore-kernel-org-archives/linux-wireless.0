Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574Ab0EMVuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/17] iwlwifi: separate statistics flag function for agn & 3945
Date: Thu, 13 May 2010 14:49:45 -0700
Message-Id: <1273787399-9280-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Since agn and 3945 have different statistics_notif data structure, each
should has its own statistics_flag function.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c |   28 ++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c  |   27 +++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   22 ------------------
 3 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
index 6a9c64a..ef0835b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
@@ -28,6 +28,28 @@
 
 #include "iwl-3945-debugfs.h"
 
+
+static int iwl3945_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
+{
+	int p = 0;
+
+	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
+		       le32_to_cpu(priv->_3945.statistics.flag));
+	if (le32_to_cpu(priv->_3945.statistics.flag) &
+			UCODE_STATISTICS_CLEAR_MSK)
+		p += scnprintf(buf + p, bufsz - p,
+			       "\tStatistics have been cleared\n");
+	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
+		       (le32_to_cpu(priv->_3945.statistics.flag) &
+			UCODE_STATISTICS_FREQUENCY_MSK)
+			? "2.4 GHz" : "5.2 GHz");
+	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
+		       (le32_to_cpu(priv->_3945.statistics.flag) &
+			UCODE_STATISTICS_NARROW_BAND_MSK)
+			? "enabled" : "disabled");
+	return p;
+}
+
 ssize_t iwl3945_ucode_rx_stats_read(struct file *file,
 				    char __user *user_buf,
 				    size_t count, loff_t *ppos)
@@ -70,7 +92,7 @@ ssize_t iwl3945_ucode_rx_stats_read(struct file *file,
 	max_cck = &priv->_3945.max_delta.rx.cck;
 	max_general = &priv->_3945.max_delta.rx.general;
 
-	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += iwl3945_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_Rx - OFDM:");
@@ -331,7 +353,7 @@ ssize_t iwl3945_ucode_tx_stats_read(struct file *file,
 	accum_tx = &priv->_3945.accum_statistics.tx;
 	delta_tx = &priv->_3945.delta_statistics.tx;
 	max_tx = &priv->_3945.max_delta.tx;
-	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += iwl3945_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_Tx:");
@@ -438,7 +460,7 @@ ssize_t iwl3945_ucode_general_stats_read(struct file *file,
 	accum_div = &priv->_3945.accum_statistics.general.div;
 	delta_div = &priv->_3945.delta_statistics.general.div;
 	max_div = &priv->_3945.max_delta.general.div;
-	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += iwl3945_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_General:");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 90be033..75d6bfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -28,6 +28,27 @@
 
 #include "iwl-agn-debugfs.h"
 
+static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
+{
+	int p = 0;
+
+	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
+		       le32_to_cpu(priv->_agn.statistics.flag));
+	if (le32_to_cpu(priv->_agn.statistics.flag) &
+			UCODE_STATISTICS_CLEAR_MSK)
+		p += scnprintf(buf + p, bufsz - p,
+			       "\tStatistics have been cleared\n");
+	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
+		       (le32_to_cpu(priv->_agn.statistics.flag) &
+			UCODE_STATISTICS_FREQUENCY_MSK)
+			? "2.4 GHz" : "5.2 GHz");
+	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
+		       (le32_to_cpu(priv->_agn.statistics.flag) &
+			UCODE_STATISTICS_NARROW_BAND_MSK)
+			? "enabled" : "disabled");
+	return p;
+}
+
 ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
   {
@@ -75,7 +96,7 @@ ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	max_general = &priv->_agn.max_delta.rx.general;
 	max_ht = &priv->_agn.max_delta.rx.ofdm_ht;
 
-	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_Rx - OFDM:");
@@ -543,7 +564,7 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 	accum_tx = &priv->_agn.accum_statistics.tx;
 	delta_tx = &priv->_agn.delta_statistics.tx;
 	max_tx = &priv->_agn.max_delta.tx;
-	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,  "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_Tx:");
@@ -768,7 +789,7 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	accum_div = &priv->_agn.accum_statistics.general.div;
 	delta_div = &priv->_agn.delta_statistics.general.div;
 	max_div = &priv->_agn.max_delta.general.div;
-	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_General:");
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c248373..9793050 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -100,28 +100,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.open = iwl_dbgfs_open_file_generic,                            \
 };
 
-int iwl_dbgfs_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
-{
-	int p = 0;
-
-	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
-		       le32_to_cpu(priv->_agn.statistics.flag));
-	if (le32_to_cpu(priv->_agn.statistics.flag) &
-			UCODE_STATISTICS_CLEAR_MSK)
-		p += scnprintf(buf + p, bufsz - p,
-			       "\tStatistics have been cleared\n");
-	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
-		       (le32_to_cpu(priv->_agn.statistics.flag) &
-			UCODE_STATISTICS_FREQUENCY_MSK)
-			? "2.4 GHz" : "5.2 GHz");
-	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
-		       (le32_to_cpu(priv->_agn.statistics.flag) &
-			UCODE_STATISTICS_NARROW_BAND_MSK)
-			? "enabled" : "disabled");
-	return p;
-}
-EXPORT_SYMBOL(iwl_dbgfs_statistics_flag);
-
 static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos) {
-- 
1.6.3.3

