Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18622 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2GIJP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:15:57 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41213.811128.264473@gargle.gargle.HOWL> (sfid-20120709_111600_867337_D9B6EC6A)
Date: Mon, 9 Jul 2012 14:44:37 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 01/11] ath9k: Fix beacon setup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch revamps interface addition and deletion and simplifies
slot allocation. There is no need to setup the beacon buffer
in add/remove interface, remove this and use simple APIs for
assigning/deleting slots.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   4 +-
 drivers/net/wireless/ath/ath9k/beacon.c | 141 ++++++++------------------------
 drivers/net/wireless/ath/ath9k/main.c   |  48 +++--------
 3 files changed, 47 insertions(+), 146 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 79840d6..ea1bd45 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -413,8 +413,8 @@ struct ath_beacon {
 
 void ath_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
-int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
-void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
+void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 int ath_beaconq_config(struct ath_softc *sc);
 void ath_set_beacon(struct ath_softc *sc);
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 40775da..d357002 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -222,132 +222,57 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	return bf;
 }
 
-int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
+void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp;
-	struct ath_buf *bf;
-	struct sk_buff *skb;
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
-	__le64 tstamp;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	int slot;
 
-	avp = (void *)vif->drv_priv;
+	avp->av_bcbuf = list_first_entry(&sc->beacon.bbuf, struct ath_buf, list);
+	list_del(&avp->av_bcbuf->list);
 
-	/* Allocate a beacon descriptor if we haven't done so. */
-	if (!avp->av_bcbuf) {
-		/* Allocate beacon state for hostap/ibss.  We know
-		 * a buffer is available. */
-		avp->av_bcbuf = list_first_entry(&sc->beacon.bbuf,
-						 struct ath_buf, list);
-		list_del(&avp->av_bcbuf->list);
-
-		if (ath9k_uses_beacons(vif->type)) {
-			int slot;
-			/*
-			 * Assign the vif to a beacon xmit slot. As
-			 * above, this cannot fail to find one.
-			 */
-			avp->av_bslot = 0;
-			for (slot = 0; slot < ATH_BCBUF; slot++)
-				if (sc->beacon.bslot[slot] == NULL) {
-					avp->av_bslot = slot;
-					avp->is_bslot_active = false;
-
-					/* NB: keep looking for a double slot */
-					if (slot == 0 || !sc->beacon.bslot[slot-1])
-						break;
-				}
-			BUG_ON(sc->beacon.bslot[avp->av_bslot] != NULL);
-			sc->beacon.bslot[avp->av_bslot] = vif;
-			sc->nbcnvifs++;
+	for (slot = 0; slot < ATH_BCBUF; slot++) {
+		if (sc->beacon.bslot[slot] == NULL) {
+			avp->av_bslot = slot;
+			avp->is_bslot_active = false;
+			break;
 		}
 	}
 
-	/* release the previous beacon frame, if it already exists. */
-	bf = avp->av_bcbuf;
-	if (bf->bf_mpdu != NULL) {
-		skb = bf->bf_mpdu;
-		dma_unmap_single(sc->dev, bf->bf_buf_addr,
-				 skb->len, DMA_TO_DEVICE);
-		dev_kfree_skb_any(skb);
-		bf->bf_mpdu = NULL;
-		bf->bf_buf_addr = 0;
-	}
-
-	/* NB: the beacon data buffer must be 32-bit aligned. */
-	skb = ieee80211_beacon_get(sc->hw, vif);
-	if (skb == NULL)
-		return -ENOMEM;
-
-	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	sc->beacon.bc_tstamp = (u32) le64_to_cpu(tstamp);
-	/* Calculate a TSF adjustment factor required for staggered beacons. */
-	if (avp->av_bslot > 0) {
-		u64 tsfadjust;
-		int intval;
+	sc->beacon.bslot[avp->av_bslot] = vif;
+	sc->nbcnvifs++;
 
-		intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
+	ath_dbg(common, CONFIG, "Added interface at beacon slot: %d\n",
+		avp->av_bslot);
+}
 
-		/*
-		 * Calculate the TSF offset for this beacon slot, i.e., the
-		 * number of usecs that need to be added to the timestamp field
-		 * in Beacon and Probe Response frames. Beacon slot 0 is
-		 * processed at the correct offset, so it does not require TSF
-		 * adjustment. Other slots are adjusted to get the timestamp
-		 * close to the TBTT for the BSS.
-		 */
-		tsfadjust = TU_TO_USEC(intval * avp->av_bslot) / ATH_BCBUF;
-		avp->tsf_adjust = cpu_to_le64(tsfadjust);
+void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ath_buf *bf = avp->av_bcbuf;
 
-		ath_dbg(common, BEACON,
-			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
-			avp->av_bslot, intval, (unsigned long long)tsfadjust);
+	ath_dbg(common, CONFIG, "Removing interface at beacon slot: %d\n",
+		avp->av_bslot);
 
-		((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp =
-			avp->tsf_adjust;
-	} else
-		avp->tsf_adjust = cpu_to_le64(0);
+	tasklet_disable(&sc->bcon_tasklet);
 
-	bf->bf_mpdu = skb;
-	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-					 skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
+	if (bf && bf->bf_mpdu) {
+		struct sk_buff *skb = bf->bf_mpdu;
+		dma_unmap_single(sc->dev, bf->bf_buf_addr,
+				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		bf->bf_buf_addr = 0;
-		ath_err(common, "dma_mapping_error on beacon alloc\n");
-		return -ENOMEM;
 	}
-	avp->is_bslot_active = true;
-
-	return 0;
-}
-
-void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
-{
-	if (avp->av_bcbuf != NULL) {
-		struct ath_buf *bf;
-
-		avp->is_bslot_active = false;
-		if (avp->av_bslot != -1) {
-			sc->beacon.bslot[avp->av_bslot] = NULL;
-			sc->nbcnvifs--;
-			avp->av_bslot = -1;
-		}
 
-		bf = avp->av_bcbuf;
-		if (bf->bf_mpdu != NULL) {
-			struct sk_buff *skb = bf->bf_mpdu;
-			dma_unmap_single(sc->dev, bf->bf_buf_addr,
-					 skb->len, DMA_TO_DEVICE);
-			dev_kfree_skb_any(skb);
-			bf->bf_mpdu = NULL;
-			bf->bf_buf_addr = 0;
-		}
-		list_add_tail(&bf->list, &sc->beacon.bbuf);
+	avp->av_bcbuf = NULL;
+	avp->is_bslot_active = false;
+	sc->beacon.bslot[avp->av_bslot] = NULL;
+	sc->nbcnvifs--;
+	list_add_tail(&bf->list, &sc->beacon.bbuf);
 
-		avp->av_bcbuf = NULL;
-	}
+	tasklet_enable(&sc->bcon_tasklet);
 }
 
 void ath_beacon_tasklet(unsigned long data)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 248e5b2..19a2274 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -841,16 +841,6 @@ bool ath9k_uses_beacons(int type)
 	}
 }
 
-static void ath9k_reclaim_beacon(struct ath_softc *sc,
-				 struct ieee80211_vif *vif)
-{
-	struct ath_vif *avp = (void *)vif->drv_priv;
-
-	ath9k_set_beaconing_status(sc, false);
-	ath_beacon_return(sc, avp);
-	ath9k_set_beaconing_status(sc, true);
-}
-
 static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct ath9k_vif_iter_data *iter_data = data;
@@ -966,22 +956,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	}
 }
 
-/* Called with sc->mutex held, vif counts set up properly. */
-static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif)
-{
-	struct ath_softc *sc = hw->priv;
-
-	ath9k_calculate_summary_state(hw, vif);
-
-	if (ath9k_uses_beacons(vif->type)) {
-		/* Reserve a beacon slot for the vif */
-		ath9k_set_beaconing_status(sc, false);
-		ath_beacon_alloc(sc, vif);
-		ath9k_set_beaconing_status(sc, true);
-	}
-}
-
 static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif)
 {
@@ -1021,7 +995,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs++;
 
-	ath9k_do_vif_add_setup(hw, vif);
+	ath9k_calculate_summary_state(hw, vif);
+	if (ath9k_uses_beacons(vif->type))
+		ath9k_beacon_assign_slot(sc, vif);
+
 out:
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
@@ -1038,6 +1015,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 
 	ath_dbg(common, CONFIG, "Change Interface\n");
+
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 
@@ -1050,15 +1028,16 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 		}
 	}
 
-	/* Clean up old vif stuff */
 	if (ath9k_uses_beacons(vif->type))
-		ath9k_reclaim_beacon(sc, vif);
+		ath9k_beacon_remove_slot(sc, vif);
 
-	/* Add new settings */
 	vif->type = new_type;
 	vif->p2p = p2p;
 
-	ath9k_do_vif_add_setup(hw, vif);
+	ath9k_calculate_summary_state(hw, vif);
+	if (ath9k_uses_beacons(vif->type))
+		ath9k_beacon_assign_slot(sc, vif);
+
 out:
 	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
@@ -1078,9 +1057,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs--;
 
-	/* Reclaim beacon resources */
 	if (ath9k_uses_beacons(vif->type))
-		ath9k_reclaim_beacon(sc, vif);
+		ath9k_beacon_remove_slot(sc, vif);
 
 	ath9k_calculate_summary_state(hw, NULL);
 
@@ -1598,9 +1576,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	     (changed & BSS_CHANGED_BEACON_ENABLED) ||
 	     (changed & BSS_CHANGED_BEACON_INT))) {
 		ath9k_set_beaconing_status(sc, false);
-		if (bss_conf->enable_beacon)
-			ath_beacon_alloc(sc, vif);
-		else
+		if (!bss_conf->enable_beacon)
 			avp->is_bslot_active = false;
 		ath_beacon_config(sc, vif);
 		ath9k_set_beaconing_status(sc, true);
-- 
1.7.11.1

