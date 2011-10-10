Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab1JJPQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/34] iwlagn: don't stop rts/cts until last aggregation queue close
Date: Mon, 10 Oct 2011 07:27:09 -0700
Message-Id: <1318256839-31837-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171716_668874_F400AC82)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once enable rts/cts for aggregation queue, do not disable until the
last aggregation queue closed.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index afd4b4c..f00484e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2418,11 +2418,6 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
-		if (ret == 0) {
-			priv->agg_tids_count++;
-			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
-				     priv->agg_tids_count);
-		}
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
@@ -2434,7 +2429,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 			ret = 0;
-		if (priv->cfg->ht_params &&
+		if (!priv->agg_tids_count && priv->cfg->ht_params &&
 		    priv->cfg->ht_params->use_rts_for_aggregation) {
 			/*
 			 * switch off RTS/CTS if it was previously enabled
@@ -2481,6 +2476,9 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			sta_priv->lq_sta.lq.general_params.flags |=
 				LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
 		}
+		priv->agg_tids_count++;
+		IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
+			     priv->agg_tids_count);
 
 		sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
 			sta_priv->max_agg_bufsize;
-- 
1.7.0.4

