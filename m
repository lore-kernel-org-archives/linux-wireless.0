Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:60556 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCJOkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 10:40:42 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: ath9k-devel@qca.qualcomm.com
Cc: Michael Braun <michael-dev@fami-braun.de>,
	<projekt-wlan@fem.tu-ilmenau.de>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC] ath9k: use more than one slot per bss for multicast in staggered mode
Date: Mon, 10 Mar 2014 15:40:35 +0100
Message-Id: <1394462435-23329-1-git-send-email-michael-dev@fami-braun.de> (sfid-20140310_154046_252997_DAD008CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before, ath9k divided time in ATH_BCBUF many equally sized slots.
Each bss then was assigned to a single slot, leaving some or more slots empty.
The beacons of a bss were sent at the beginning of the slot for this bss,
and then the buffered multicast packets might be sent out.

As multicast packets are sent a lowest bitrate, wireless throughput
of multicast packets is very limited, and thus the time available
is crucial to avoid buffer overflow, which I frequently observed.

This patch changes the behaviour of ath9k in two ways:
 1. the time available when processing a slot is increased
    to cover all subsequent unoccupied slots as well.
    This size is tracked in the variable named "slotwidth".
 2. during each slot, buffered packets from *all* bss are
    sent out in a round-robin fashing, skipping those
    bss where stations are currently not listing.
    That could be either due to
      - last dtim did not containt the relevant flag or
      - a multicast packet not containing the "more data"
        flag was sent out.
    The state is tracked in multicastWakeup, which is
    true iff the stations in this bss should already
    be woken up.

I currently don't know whether a non-buffered multicast packet
can slip between buffered packets (or between dtim notification
and the first buffered packet), so that an STA receives a
multicast packet without MOREDATA set while there a still
buffered packets to be received and just short before being
delivered on-air.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Cc: <projekt-wlan@fem.tu-ilmenau.de>
Cc: <ath9k-devel@lists.ath9k.org>
Cc: <linux-wireless@vger.kernel.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  3 +-
 drivers/net/wireless/ath/ath9k/beacon.c | 39 ++++++++++++------
 drivers/net/wireless/ath/ath9k/xmit.c   | 71 +++++++++++++++++++++++++++------
 3 files changed, 87 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f995c374a9b4..8af688225392 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -345,7 +345,7 @@ void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		 struct sk_buff *skb);
+		 const int slotwidth);
 void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -369,6 +369,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 struct ath_vif {
 	struct ath_node mcast_node;
 	int av_bslot;
+	bool multicastWakeup; /* all stations in this bss should be listening */
 	bool primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	struct ath_buf *av_bcbuf;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 02eb4f10332b..ac482498464d 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -109,7 +109,8 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 }
 
 static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
-					     struct ieee80211_vif *vif)
+					     struct ieee80211_vif *vif,
+					     const int slotwidth)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -165,8 +166,6 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 		return NULL;
 	}
 
-	skb = ieee80211_get_buffered_bc(hw, vif);
-
 	/*
 	 * if the CABQ traffic from previous DTIM is pending and the current
 	 *  beacon is also a DTIM.
@@ -189,8 +188,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 
 	ath9k_beacon_setup(sc, vif, bf, info->control.rates[0].idx);
 
-	if (skb)
-		ath_tx_cabq(hw, vif, skb);
+	ath_tx_cabq(hw, vif, slotwidth);
 
 	return bf;
 }
@@ -201,6 +199,7 @@ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	int slot;
 
+	avp->multicastWakeup = 0;
 	avp->av_bcbuf = list_first_entry(&sc->beacon.bbuf, struct ath_buf, list);
 	list_del(&avp->av_bcbuf->list);
 
@@ -327,6 +326,8 @@ void ath9k_beacon_tasklet(unsigned long data)
 	struct ieee80211_vif *vif;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int slot;
+	int slotwidth;
+	int i;
 
 	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
 		ath_dbg(common, RESET,
@@ -334,6 +335,16 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 	}
 
+	/* Check if slot is occupied. Only check for stuck beacons
+	 * if slot is occupied to allow a bss to push out buffered
+	 * multicasts for more than one slot
+	 */
+	slot = ath9k_beacon_choose_slot(sc);
+	vif = sc->beacon.bslot[slot];
+
+	if (!vif || !vif->bss_conf.enable_beacon)
+		return;
+
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not don't try to post another, skip this period
@@ -371,17 +382,21 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 	}
 
-	slot = ath9k_beacon_choose_slot(sc);
-	vif = sc->beacon.bslot[slot];
-
 	/* EDMA devices check that in the tx completion function. */
 	if (!edma && ath9k_csa_is_finished(sc, vif))
 		return;
 
-	if (!vif || !vif->bss_conf.enable_beacon)
-		return;
-
-	bf = ath9k_beacon_generate(sc->hw, vif);
+	/* calculate width of current slot, that is the number of
+	 * slots following this slot that are unoccupied
+	 */
+	slotwidth = 1;
+	for (i = slot + 1; i < ATH_BCBUF && !sc->beacon.bslot[i]; i++)
+		slotwidth++;
+	if (i == ATH_BCBUF)
+		for (i = 0; i < slot && !sc->beacon.bslot[i]; i++)
+			slotwidth++;
+
+	bf = ath9k_beacon_generate(sc->hw, vif, slotwidth);
 
 	if (sc->beacon.bmisscnt != 0) {
 		ath_dbg(common, BSTUCK, "resume beacon xmit after %u misses\n",
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fafacfed44ea..57720ada5778 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2239,9 +2239,10 @@ out:
 }
 
 void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		 struct sk_buff *skb)
+		 const int slotwidth)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_tx_control txctl = {
 		.txq = sc->beacon.cabq
 	};
@@ -2252,12 +2253,64 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	LIST_HEAD(bf_q);
 	int duration = 0;
 	int max_duration;
+	int slot;
+	int skippedSlots = 0;
+	struct sk_buff *skb;
+	struct ath_buf *lastbf[ATH_BCBUF] = {};
 
 	max_duration =
 		sc->cur_beacon_conf.beacon_interval * 1000 *
+		slotwidth *
 		sc->cur_beacon_conf.dtim_period / ATH_BCBUF;
 
-	do {
+	skb = ieee80211_get_buffered_bc(hw, vif);
+	if (skb) {
+		((struct ath_vif *) vif->drv_priv)->multicastWakeup = 1;
+	}
+
+	for (slot = ((struct ath_vif *) vif->drv_priv)->av_bslot;
+	     skippedSlots < ATH_BCBUF;
+	     slot = ((slot >= ATH_BCBUF - 1) ? 0 : (slot + 1))) {
+		vif = sc->beacon.bslot[slot];
+		if (!vif ||
+		    !(((struct ath_vif *) vif->drv_priv)->multicastWakeup)) {
+			/* there is no vif for this slot or
+			 * this bss is not woken up
+			 */
+			skippedSlots++;
+			continue;
+		};
+
+		if (!skb) /* keep first skb */
+			skb = ieee80211_get_buffered_bc(hw, vif);
+
+		if (!skb && lastbf[slot]) {
+			/* this slot has no more entries but a frame was
+			 * recently sent. Clear MOREDATA flag if required
+			 */
+			bf = lastbf[slot];
+			hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
+
+			if (hdr->frame_control & IEEE80211_FCTL_MOREDATA) {
+				hdr->frame_control &= ~IEEE80211_FCTL_MOREDATA;
+				dma_sync_single_for_device(sc->dev,
+					bf->bf_buf_addr, sizeof(*hdr),
+					DMA_TO_DEVICE);
+			}
+			/* next time MOREDATE flag cannot be set here */
+			lastbf[slot] = NULL;
+			/* make sure bf does not accidentially get referenced */
+			bf = NULL;
+		};
+
+		if (!skb) {
+			/* this slot has no more entries */
+			((struct ath_vif *) vif->drv_priv)->multicastWakeup = 0;
+			skippedSlots++;
+			continue;
+		} else
+			skippedSlots = 0;
+
 		struct ath_frame_info *fi = get_frame_info(skb);
 
 		if (ath_tx_prepare(hw, skb, &txctl))
@@ -2267,6 +2320,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (!bf)
 			break;
 
+		lastbf[slot] = bf;
+
 		bf->bf_lastbf = bf;
 		ath_set_rates(vif, NULL, bf);
 		ath_buf_set_rate(sc, bf, &info, fi->framelen, false);
@@ -2280,9 +2335,7 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		if (duration > max_duration)
 			break;
-
-		skb = ieee80211_get_buffered_bc(hw, vif);
-	} while(skb);
+	};
 
 	if (skb)
 		ieee80211_free_txskb(hw, skb);
@@ -2291,14 +2344,6 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		return;
 
 	bf = list_first_entry(&bf_q, struct ath_buf, list);
-	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
-
-	if (hdr->frame_control & IEEE80211_FCTL_MOREDATA) {
-		hdr->frame_control &= ~IEEE80211_FCTL_MOREDATA;
-		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
-			sizeof(*hdr), DMA_TO_DEVICE);
-	}
-
 	ath_txq_lock(sc, txctl.txq);
 	ath_tx_fill_desc(sc, bf, txctl.txq, 0);
 	ath_tx_txqaddbuf(sc, txctl.txq, &bf_q, false);
-- 
1.8.3.2

