Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14565 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2GQLrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:47:23 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20485.20603.389613.955872@gargle.gargle.HOWL> (sfid-20120717_134726_456100_F5B25D9C)
Date: Tue, 17 Jul 2012 17:16:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] ath9k: Remove is_bslot_active
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
index a4dd5b1..641ca9e 100644
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
index a79ec45..2962b3e 100644
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
index 6a7dfbb..e58c657 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1787,10 +1787,11 @@ static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
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
1.7.11.2

