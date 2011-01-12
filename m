Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1ALMOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:14:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Pczab-0001RW-M2
	for linux-wireless@vger.kernel.org; Wed, 12 Jan 2011 13:14:09 +0100
Message-Id: <20110112121418.037714947@sipsolutions.net>
Date: Wed, 12 Jan 2011 13:13:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] iwlwifi: use maximum aggregation size
References: <20110112121322.702618109@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the values from the peer to set up the ucode
for the right maximum number of subframes in an
aggregate. Since the ucode only tracks this per
station, use the minimum across all aggregation
sessions with this peer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    5 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   32 +++++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 
 3 files changed, 32 insertions(+), 6 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2011-01-12 13:08:22.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2011-01-12 13:10:58.000000000 +0100
@@ -2889,6 +2889,8 @@ static void rs_fill_link_cmd(struct iwl_
 	u8 ant_toggle_cnt = 0;
 	u8 use_ht_possible = 1;
 	u8 valid_tx_ant = 0;
+	struct iwl_station_priv *sta_priv =
+		container_of(lq_sta, struct iwl_station_priv, lq_sta);
 	struct iwl_link_quality_cmd *lq_cmd = &lq_sta->lq;
 
 	/* Override starting rate (index 0) if needed for debug purposes */
@@ -3007,7 +3009,8 @@ static void rs_fill_link_cmd(struct iwl_
 		repeat_rate--;
 	}
 
-	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+	lq_cmd->agg_params.agg_frame_cnt_limit =
+		sta_priv->max_agg_bufsize ?: LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 
 	lq_cmd->agg_params.agg_time_limit =
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-01-12 13:03:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-01-12 13:11:50.000000000 +0100
@@ -3421,6 +3421,7 @@ int iwlagn_mac_ampdu_action(struct ieee8
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
+	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
@@ -3475,11 +3476,28 @@ int iwlagn_mac_ampdu_action(struct ieee8
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
@@ -3487,9 +3505,13 @@ int iwlagn_mac_ampdu_action(struct ieee8
 
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
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2011-01-12 13:03:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-dev.h	2011-01-12 13:03:31.000000000 +0100
@@ -509,6 +509,7 @@ struct iwl_station_priv {
 	atomic_t pending_frames;
 	bool client;
 	bool asleep;
+	u8 max_agg_bufsize;
 };
 
 /**


