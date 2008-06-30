Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759605AbYF3J1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 31/33] iwlwifi: fix iwl4965 temperature callback calibration issue
Date: Mon, 30 Jun 2008 17:23:31 +0800
Message-Id: <1214817813-17639-32-git-send-email-yi.zhu@intel.com> (sfid-20080630_113814_166586_215CAFED)
In-Reply-To: <1214817813-17639-31-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-31-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the temperature calibration issue introduced by the
patch "iwlwifi: move RX stats to core, and move temperature to handler".
It also remove the second parameter "stats" since it is already copied
to priv->statistics.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   14 +-------------
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +--
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   13 ++++++++++---
 4 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e4eab51..8c93f8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1879,21 +1879,9 @@ static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 	return 1;
 }
 
-static void iwl4965_temperature_calib(struct iwl_priv *priv,
-				      struct iwl_notif_statistics *stats)
+static void iwl4965_temperature_calib(struct iwl_priv *priv)
 {
 	s32 temp;
-	int change = ((priv->statistics.general.temperature !=
-		   stats->general.temperature) ||
-		  ((priv->statistics.flag &
-		    STATISTICS_REPLY_FLG_FAT_MODE_MSK) !=
-		   (stats->flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)));
-
-	/* If the hardware hasn't reported a change in
-	 * temperature then don't bother computing a
-	 * calibrated temperature value */
-	if (!change)
-		return;
 
 	temp = iwl4965_hw_get_temperature(priv);
 	if (temp < 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1be6ca4..7cc73e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1422,11 +1422,10 @@ static int  iwl5000_send_tx_power(struct iwl_priv *priv)
 				       NULL);
 }
 
-static void iwl5000_temperature(struct iwl_priv *priv,
-				struct iwl_notif_statistics *stats)
+static void iwl5000_temperature(struct iwl_priv *priv)
 {
 	/* store temperature from statistics (in Celsius) */
-	priv->temperature = le32_to_cpu(stats->general.temperature);
+	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
 }
 
 static struct iwl_hcmd_ops iwl5000_hcmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d7562c3..eb4abe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -140,8 +140,7 @@ struct iwl_lib_ops {
 	int (*set_power)(struct iwl_priv *priv, void *cmd);
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
-	void (*temperature) (struct iwl_priv *priv,
-		struct iwl_notif_statistics *stats);
+	void (*temperature) (struct iwl_priv *priv);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1adb1aa..d379529 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -557,11 +557,18 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
+	int change;
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-
+       
 	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(priv->statistics), pkt->len);
 
+	change = ((priv->statistics.general.temperature !=
+		   pkt->u.stats.general.temperature) ||
+		  ((priv->statistics.flag &
+		    STATISTICS_REPLY_FLG_FAT_MODE_MSK) !=
+		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)));
+
 	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
 
 	set_bit(STATUS_STATISTICS, &priv->status);
@@ -581,8 +588,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 
 	iwl_leds_background(priv);
 
-	if (priv->cfg->ops->lib->temperature)
-		priv->cfg->ops->lib->temperature(priv, &pkt->u.stats);
+	if (priv->cfg->ops->lib->temperature && change)
+		priv->cfg->ops->lib->temperature(priv);
 }
 EXPORT_SYMBOL(iwl_rx_statistics);
 
-- 
1.5.3.6

