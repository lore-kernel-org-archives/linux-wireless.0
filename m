Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYF3J1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/33] iwlwifi: remove obsolete lq_ready use
Date: Mon, 30 Jun 2008 17:23:13 +0800
Message-Id: <1214817813-17639-14-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_709830_5CD71AED)
In-Reply-To: <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes the use of lq_ready, once used to sync between link
quality commands to avoid race conditions, but no longer needed as
bss_info_changed is in use.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   19 +------------------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    8 --------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    3 +--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ---
 5 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 2023031..c2f21d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -822,9 +822,6 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
-	if (!priv->lq_mngr.lq_ready)
-		goto out;
-
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
 	    !lq_sta->ibss_sta_added)
 		goto out;
@@ -1678,10 +1675,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (!sta || !sta->rate_ctrl_priv)
 		return;
 
-	if (!priv->lq_mngr.lq_ready) {
-		IWL_DEBUG_RATE("still rate scaling not ready\n");
-		return;
-	}
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
@@ -2279,9 +2272,6 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	lq_sta->drv = priv;
 #endif
 
-	if (priv->assoc_station_added)
-		priv->lq_mngr.lq_ready = 1;
-
 	rs_initialize_lq(priv, conf, sta);
 }
 
@@ -2421,7 +2411,7 @@ static void rs_clear(void *priv_rate)
 
 	IWL_DEBUG_RATE("enter\n");
 
-	priv->lq_mngr.lq_ready = 0;
+	/* TODO - add rate scale state reset */
 
 	IWL_DEBUG_RATE("leave\n");
 }
@@ -2716,13 +2706,6 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 	return cnt;
 }
 
-void iwl4965_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	priv->lq_mngr.lq_ready = 1;
-}
-
 int iwl4965_rate_control_register(void)
 {
 	return ieee80211_rate_control_register(&rs_ops);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index cbd1264..9b99728 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -296,14 +296,6 @@ static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 extern int iwl4965_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
 
 /**
- * iwl4965_rate_scale_init - Initialize the rate scale table based on assoc info
- *
- * The specific throughput table used is based on the type of network
- * the associated with, including A, B, G, and G w/ TGG protection
- */
-extern void iwl4965_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
-
-/**
  * iwl4965_rate_control_register - Register the rate control algorithm callbacks
  *
  * Since the rate control algorithm is hardware specific, there is no need
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 79a6941..d1289cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -693,7 +693,6 @@ struct iwl4965_lq_mngr {
 	unsigned long stamp_last;
 	u32 flush_time;
 	u32 tx_packets;
-	u8 lq_ready;
 };
 
 /* Sensitivity and chain noise calibration */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c81ab5f..6d1467d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -825,8 +825,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 
 	iwl_dump_lq_cmd(priv,lq);
 
-	if (iwl_is_associated(priv) && priv->assoc_station_added &&
-	    priv->lq_mngr.lq_ready)
+	if (iwl_is_associated(priv) && priv->assoc_station_added)
 		return  iwl_send_cmd(priv, &cmd);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a87e870..bb3e61c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2483,7 +2483,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	switch (priv->iw_mode) {
 	case IEEE80211_IF_TYPE_STA:
-		iwl4965_rate_scale_init(priv->hw, IWL_AP_ID);
 		break;
 
 	case IEEE80211_IF_TYPE_IBSS:
@@ -2492,7 +2491,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 		priv->assoc_id = 1;
 
 		iwl_rxon_add_station(priv, priv->bssid, 0);
-		iwl4965_rate_scale_init(priv->hw, IWL_STA_ID);
 		iwl4965_send_beacon_cmd(priv);
 
 		break;
@@ -3425,7 +3423,6 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-	priv->lq_mngr.lq_ready = 0;
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.5.3.6

