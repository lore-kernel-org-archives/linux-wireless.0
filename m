Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1AaVxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/11] iwlwifi: use maximum aggregation size
Date: Mon, 31 Jan 2011 13:40:43 -0800
Message-Id: <1296510047-24576-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the values from the peer to set up the ucode
for the right maximum number of subframes in an
aggregate. Since the ucode only tracks this per
station, use the minimum across all aggregation
sessions with this peer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    5 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   32 ++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 20d01a3..d03b473 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2890,6 +2890,8 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	u8 ant_toggle_cnt = 0;
 	u8 use_ht_possible = 1;
 	u8 valid_tx_ant = 0;
+	struct iwl_station_priv *sta_priv =
+		container_of(lq_sta, struct iwl_station_priv, lq_sta);
 	struct iwl_link_quality_cmd *lq_cmd = &lq_sta->lq;
 
 	/* Override starting rate (index 0) if needed for debug purposes */
@@ -3008,7 +3010,8 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		repeat_rate--;
 	}
 
-	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+	lq_cmd->agg_params.agg_frame_cnt_limit =
+		sta_priv->max_agg_bufsize ?: LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 
 	lq_cmd->agg_params.agg_time_limit =
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dcc4b2d..cf285f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3429,6 +3429,7 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
+	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
@@ -3483,11 +3484,28 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		/*
+		 * If the limit is 0, then it wasn't initialised yet,
+		 * use the default. We can do that since we take the
+		 * minimum below, and we don't want to go above our
+		 * default due to hardware restrictions.
+		 */
+		if (sta_priv->max_agg_bufsize == 0)
+			sta_priv->max_agg_bufsize =
+				LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+
+		/*
+		 * Even though in theory the peer could have different
+		 * aggregation reorder buffer sizes for different sessions,
+		 * our ucode doesn't allow for that and has a global limit
+		 * for each station. Therefore, use the minimum of all the
+		 * aggregation sessions and our default value.
+		 */
+		sta_priv->max_agg_bufsize =
+			min(sta_priv->max_agg_bufsize, buf_size);
+
 		if (priv->cfg->ht_params &&
 		    priv->cfg->ht_params->use_rts_for_aggregation) {
-			struct iwl_station_priv *sta_priv =
-				(void *) sta->drv_priv;
-
 			/*
 			 * switch to RTS/CTS if it is the prefer protection
 			 * method for HT traffic
@@ -3495,9 +3513,13 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 			sta_priv->lq_sta.lq.general_params.flags |=
 				LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
-			iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
-					&sta_priv->lq_sta.lq, CMD_ASYNC, false);
 		}
+
+		sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
+			sta_priv->max_agg_bufsize;
+
+		iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
+				&sta_priv->lq_sta.lq, CMD_ASYNC, false);
 		ret = 0;
 		break;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b5f21e0..c56b797 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -509,6 +509,7 @@ struct iwl_station_priv {
 	atomic_t pending_frames;
 	bool client;
 	bool asleep;
+	u8 max_agg_bufsize;
 };
 
 /**
-- 
1.7.0.4

