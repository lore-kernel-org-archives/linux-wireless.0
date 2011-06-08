Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1FHN2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:28:54 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/6] iwlegacy: remove unused agg_tids_count
Date: Wed,  8 Jun 2011 15:28:28 +0200
Message-Id: <1307539709-11320-5-git-send-email-sgruszka@redhat.com> (sfid-20110608_152904_109059_E62F3A90)
In-Reply-To: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
References: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-dev.h      |    6 ------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   11 -----------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index fd792e1..62e8cc0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -1164,12 +1164,6 @@ struct iwl_priv {
 #endif
 #if defined(CONFIG_IWL4965) || defined(CONFIG_IWL4965_MODULE)
 		struct {
-			/*
-			 * reporting the number of tids has AGG on. 0 means
-			 * no AGGREGATION
-			 */
-			u8 agg_tids_count;
-
 			struct iwl_rx_phy_res last_phy_res;
 			bool last_phy_res_valid;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 98e42a1..c0ea858 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2442,20 +2442,10 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwl4965_tx_agg_start(priv, vif, sta, tid, ssn);
-		if (ret == 0) {
-			priv->_4965.agg_tids_count++;
-			IWL_DEBUG_HT(priv, "priv->_4965.agg_tids_count = %u\n",
-				     priv->_4965.agg_tids_count);
-		}
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
 		ret = iwl4965_tx_agg_stop(priv, vif, sta, tid);
-		if ((ret == 0) && (priv->_4965.agg_tids_count > 0)) {
-			priv->_4965.agg_tids_count--;
-			IWL_DEBUG_HT(priv, "priv->_4965.agg_tids_count = %u\n",
-				     priv->_4965.agg_tids_count);
-		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			ret = 0;
 		break;
@@ -2796,7 +2786,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
-	priv->_4965.agg_tids_count = 0;
 
 	/* initialize force reset */
 	priv->force_reset.reset_duration = IWL_DELAY_NEXT_FORCE_FW_RELOAD;
-- 
1.7.1

