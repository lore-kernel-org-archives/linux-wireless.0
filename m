Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42488 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaIEEUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 00:20:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/3] ath9k: Use a subroutine to assign HW queues
Date: Fri,  5 Sep 2014 09:50:55 +0530
Message-Id: <1409890857-6276-2-git-send-email-sujith@msujith.org> (sfid-20140905_062045_647664_895F7384)
In-Reply-To: <1409890857-6276-1-git-send-email-sujith@msujith.org>
References: <1409890857-6276-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Reduces code duplication.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |  2 +-
 drivers/net/wireless/ath/ath9k/main.c | 33 +++++++++++++++++----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1950c04..156a944 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -811,7 +811,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	/* allow 4 queues per channel context +
 	 * 1 cab queue + 1 offchannel tx queue
 	 */
-	hw->queues = 10;
+	hw->queues = ATH9K_NUM_TX_QUEUES;
 	/* last queue for offchannel */
 	hw->offchannel_tx_hw_queue = hw->queues - 1;
 	hw->max_rates = 4;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cdf1e7d..1bc2369 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1104,6 +1104,20 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	ath9k_ps_restore(sc);
 }
 
+static void ath9k_assign_hw_queues(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
+	int i;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		vif->hw_queue[i] = i;
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		vif->cab_queue = hw->queues - 2;
+	else
+		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
+}
+
 static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif)
 {
@@ -1112,7 +1126,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
-	int i;
 
 	mutex_lock(&sc->mutex);
 
@@ -1135,12 +1148,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		avp->chanctx = sc->cur_chan;
 		list_add_tail(&avp->list, &avp->chanctx->vifs);
 	}
-	for (i = 0; i < IEEE80211_NUM_ACS; i++)
-		vif->hw_queue[i] = i;
-	if (vif->type == NL80211_IFTYPE_AP)
-		vif->cab_queue = hw->queues - 2;
-	else
-		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
+
+	ath9k_assign_hw_queues(hw, vif);
 
 	an->sc = sc;
 	an->sta = NULL;
@@ -1160,7 +1169,6 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	int i;
 
 	mutex_lock(&sc->mutex);
 
@@ -1180,14 +1188,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++)
-		vif->hw_queue[i] = i;
-
-	if (vif->type == NL80211_IFTYPE_AP)
-		vif->cab_queue = hw->queues - 2;
-	else
-		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
-
+	ath9k_assign_hw_queues(hw, vif);
 	ath9k_calculate_summary_state(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
-- 
2.1.0

