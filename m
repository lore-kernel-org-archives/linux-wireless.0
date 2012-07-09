Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16404 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GIJQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:31 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41248.899775.758575@gargle.gargle.HOWL> (sfid-20120709_111634_698671_6FD9A061)
Date: Mon, 9 Jul 2012 14:45:12 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 06/11] ath9k: Remove is_bslot_active
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the tx_last_beacon() callback, mac80211's beaconing
status can be used instead. The beacon tasklet doesn't require
it because it is disabled when removing a slot.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  2 +-
 drivers/net/wireless/ath/ath9k/beacon.c | 15 +++++----------
 drivers/net/wireless/ath/ath9k/main.c   |  5 +++--
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 18ef8d3..508ba93 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -360,7 +360,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 
 struct ath_vif {
 	int av_bslot;
-	bool is_bslot_active, primary_sta_vif;
+	bool primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	struct ath_buf *av_bcbuf;
 };
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index f295116..926a2f1 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -134,20 +134,17 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_buf *bf;
-	struct ath_vif *avp;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
-	struct ath_txq *cabq;
+	struct ath_txq *cabq = sc->beacon.cabq;
 	struct ieee80211_tx_info *info;
 	int cabq_depth;
 
-	ath9k_reset_beacon_status(sc);
-
-	avp = (void *)vif->drv_priv;
-	cabq = sc->beacon.cabq;
-
-	if ((avp->av_bcbuf == NULL) || !avp->is_bslot_active)
+	if (avp->av_bcbuf == NULL)
 		return NULL;
 
+	ath9k_reset_beacon_status(sc);
+
 	/* Release the old beacon first */
 
 	bf = avp->av_bcbuf;
@@ -234,7 +231,6 @@ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 	for (slot = 0; slot < ATH_BCBUF; slot++) {
 		if (sc->beacon.bslot[slot] == NULL) {
 			avp->av_bslot = slot;
-			avp->is_bslot_active = false;
 			break;
 		}
 	}
@@ -267,7 +263,6 @@ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 	}
 
 	avp->av_bcbuf = NULL;
-	avp->is_bslot_active = false;
 	sc->beacon.bslot[avp->av_bslot] = NULL;
 	sc->nbcnvifs--;
 	list_add_tail(&bf->list, &sc->beacon.bbuf);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e8bae97..3c2708d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1763,10 +1763,11 @@ static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
 	if (!vif)
 		return 0;
 
-	avp = (void *)vif->drv_priv;
-	if (!avp->is_bslot_active)
+	if (!vif->bss_conf.enable_beacon)
 		return 0;
 
+	avp = (void *)vif->drv_priv;
+
 	if (!sc->beacon.tx_processed && !edma) {
 		tasklet_disable(&sc->bcon_tasklet);
 
-- 
1.7.11.1

