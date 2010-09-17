Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0IQVXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlagn: adding aggregated frame failure status to debugfs
Date: Fri, 17 Sep 2010 14:24:30 -0700
Message-Id: <1284758674-25297-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Addition to standard tx frame failure report, adding aggregated
frame failure report to debugfs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   51 +++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    5 ++
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index de68dde..52e9869 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -25,7 +25,7 @@
 *  Intel Linux Wireless <ilw@linux.intel.com>
 * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
 *****************************************************************************/
-
+#include "iwl-agn.h"
 #include "iwl-agn-debugfs.h"
 
 static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
@@ -1019,7 +1019,8 @@ ssize_t iwl_reply_tx_error_read(struct file *file,
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = (sizeof(struct reply_tx_error_statistics) * 24) + 200;
+	int bufsz = (sizeof(struct reply_tx_error_statistics) * 24) +
+		(sizeof(struct reply_agg_tx_error_statistics) * 24) + 200;
 	ssize_t ret;
 
 	if (!iwl_is_alive(priv))
@@ -1104,6 +1105,52 @@ ssize_t iwl_reply_tx_error_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "UNKNOWN:\t\t\t%u\n",
 			 priv->_agn.reply_tx_stats.unknown);
 
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "\nStatistics_Agg_TX_Error:\n");
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_UNDERRUN_MSK),
+			 priv->_agn.reply_agg_tx_stats.underrun);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_BT_PRIO_MSK),
+			 priv->_agn.reply_agg_tx_stats.bt_prio);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_FEW_BYTES_MSK),
+			 priv->_agn.reply_agg_tx_stats.few_bytes);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_ABORT_MSK),
+			 priv->_agn.reply_agg_tx_stats.abort);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(
+				AGG_TX_STATE_LAST_SENT_TTL_MSK),
+			 priv->_agn.reply_agg_tx_stats.last_sent_ttl);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(
+				AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK),
+			 priv->_agn.reply_agg_tx_stats.last_sent_try);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(
+				AGG_TX_STATE_LAST_SENT_BT_KILL_MSK),
+			 priv->_agn.reply_agg_tx_stats.last_sent_bt_kill);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_SCD_QUERY_MSK),
+			 priv->_agn.reply_agg_tx_stats.scd_query);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(
+				AGG_TX_STATE_TEST_BAD_CRC32_MSK),
+			 priv->_agn.reply_agg_tx_stats.bad_crc32);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_RESPONSE_MSK),
+			 priv->_agn.reply_agg_tx_stats.response);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_DUMP_TX_MSK),
+			 priv->_agn.reply_agg_tx_stats.dump_tx);
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
+			 iwl_get_agg_tx_fail_reason(AGG_TX_STATE_DELAY_TX_MSK),
+			 priv->_agn.reply_agg_tx_stats.delay_tx);
+	pos += scnprintf(buf + pos, bufsz - pos, "UNKNOWN:\t\t\t%u\n",
+			 priv->_agn.reply_agg_tx_stats.unknown);
+
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index e1f85ae..a372184 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -238,4 +238,9 @@ void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
 void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+const char *iwl_get_agg_tx_fail_reason(u16 status);
+#else
+static inline const char *iwl_get_agg_tx_fail_reason(u16 status) { return ""; }
+#endif
 #endif /* __iwl_agn_h__ */
-- 
1.7.0.4

