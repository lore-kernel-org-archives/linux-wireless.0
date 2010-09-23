Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35786 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab0IWUHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 16:07:15 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
Date: Thu, 23 Sep 2010 13:07:10 -0700
Message-Id: <1285272430-9617-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This patch is ported forward from a patch that Patrick McHardy
did for me against 2.6.31.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 504c6d6... 59e79cc... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 7f9d0d3... 34de4ba... M	drivers/net/wireless/ath/ath5k/base.h
:100644 100644 58912cd... 5b179d0... M	drivers/net/wireless/ath/ath5k/reset.c
 drivers/net/wireless/ath/ath5k/base.c  |  243 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath5k/base.h  |   26 +++-
 drivers/net/wireless/ath/ath5k/reset.c |    4 +-
 3 files changed, 228 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 504c6d6..59e79cc 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -509,6 +509,28 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 	}
 }
 
+static void ath5k_update_bssid_mask(struct ath5k_softc *sc)
+{
+	struct ath5k_vif *avf;
+	unsigned int i, j;
+
+	/*
+	 * This doesn't include the address of the default STA device in case
+	 * it is reconfigured since for some reason it is not created through
+	 * ->add_interface().
+	 */
+	memset(sc->bssidmask, 0xff, ETH_ALEN);
+	for (i = 0; i < ATH5K_VIF_MAX; i++) {
+		if (sc->vifs[i] == NULL)
+			continue;
+		avf = (void *)sc->vifs[i]->drv_priv;
+		for (j = 0; j < ETH_ALEN; j++) {
+			sc->bssidmask[j] &= ~(sc->lladdr[j] ^ avf->lladdr[j]);
+		}
+	}
+	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
+}
+
 static void
 ath5k_mode_setup(struct ath5k_softc *sc)
 {
@@ -520,7 +542,7 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	ath5k_hw_set_rx_filter(ah, rfilt);
 
 	if (ath5k_hw_hasbssidmask(ah))
-		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
+		ath5k_update_bssid_mask(sc);
 
 	/* configure operational mode */
 	ath5k_hw_set_opmode(ah, sc->opmode);
@@ -694,13 +716,13 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		flags |= AR5K_TXDESC_RTSENA;
 		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
 		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
-			sc->vif, pktlen, info));
+			NULL, pktlen, info));
 	}
 	if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
 		flags |= AR5K_TXDESC_CTSENA;
 		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
 		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
-			sc->vif, pktlen, info));
+			NULL, pktlen, info));
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), padsize,
@@ -802,10 +824,13 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 		list_add_tail(&bf->list, &sc->txbuf);
 	}
 
-	/* beacon buffer */
-	bf->desc = ds;
-	bf->daddr = da;
-	sc->bbuf = bf;
+	/* beacon buffers */
+	INIT_LIST_HEAD(&sc->bcbuf);
+	for (i = 0; i < ATH_BCBUF; i++, bf++, ds++, da += sizeof(*ds)) {
+		bf->desc = ds;
+		bf->daddr = da;
+		list_add_tail(&bf->list, &sc->bcbuf);
+	}
 
 	return 0;
 err_free:
@@ -820,11 +845,12 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 {
 	struct ath5k_buf *bf;
 
-	ath5k_txbuf_free_skb(sc, sc->bbuf);
 	list_for_each_entry(bf, &sc->txbuf, list)
 		ath5k_txbuf_free_skb(sc, bf);
 	list_for_each_entry(bf, &sc->rxbuf, list)
 		ath5k_rxbuf_free_skb(sc, bf);
+	list_for_each_entry(bf, &sc->bcbuf, list)
+		ath5k_txbuf_free_skb(sc, bf);
 
 	/* Free memory associated with all descriptors */
 	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
@@ -833,7 +859,6 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 
 	kfree(sc->bufptr);
 	sc->bufptr = NULL;
-	sc->bbuf = NULL;
 }
 
 
@@ -1737,6 +1762,7 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	int ret;
 	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 
 	if (WARN_ON(!vif)) {
@@ -1753,11 +1779,34 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	ath5k_txbuf_free_skb(sc, sc->bbuf);
-	sc->bbuf->skb = skb;
-	ret = ath5k_beacon_setup(sc, sc->bbuf);
+	if (!avf->bbuf) {
+		WARN_ON(list_empty(&sc->bcbuf));
+		avf->bbuf = list_first_entry(&sc->bcbuf, struct ath5k_buf,
+					     list);
+		list_del(&avf->bbuf->list);
+
+		/* Assign the vap to a beacon xmit slot. */
+		if (avf->opmode == NL80211_IFTYPE_AP) {
+			int slot;
+
+			avf->bslot = 0;
+			for (slot = 0; slot < ATH_BCBUF; slot++) {
+				if (sc->bslot[slot] == ATH5K_IF_ID_ANY) {
+					avf->bslot = slot;
+					break;
+				}
+			}
+			BUG_ON(sc->bslot[avf->bslot] != ATH5K_IF_ID_ANY);
+			sc->bslot[avf->bslot] = avf->if_id;
+			sc->nbcnvifs++;
+		}
+	}
+
+	ath5k_txbuf_free_skb(sc, avf->bbuf);
+	avf->bbuf->skb = skb;
+	ret = ath5k_beacon_setup(sc, avf->bbuf);
 	if (ret)
-		sc->bbuf->skb = NULL;
+		avf->bbuf->skb = NULL;
 out:
 	return ret;
 }
@@ -1773,16 +1822,18 @@ out:
 static void
 ath5k_beacon_send(struct ath5k_softc *sc)
 {
-	struct ath5k_buf *bf = sc->bbuf;
 	struct ath5k_hw *ah = sc->ah;
+	struct ieee80211_vif *vif;
+	struct ath5k_vif *avf;
+	struct ath5k_buf *bf;
 	struct sk_buff *skb;
+	u64 tsf;
+	u32 tsftu;
+	u16 intval;
+	int slot, if_id;
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
-	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION)) {
-		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
-		return;
-	}
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not, don't don't try to post another: skip this
@@ -1811,6 +1862,29 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		sc->bmisscount = 0;
 	}
 
+	intval = sc->bintval ? sc->bintval : ATH5K_DEFAULT_BINTVAL;
+
+	tsf = ath5k_hw_get_tsf64(ah);
+	tsftu = TSF_TO_TU(tsf);
+	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
+	if_id = sc->bslot[(slot + 1) % ATH_BCBUF];
+
+	pr_debug("tsf %llx tsftu %x intval %u slot %u if_id %x\n",
+		 (unsigned long long)tsf, tsftu, intval, slot, if_id);
+
+	if (if_id != ATH5K_IF_ID_ANY) {
+		vif = sc->vifs[if_id];
+		avf = (void *)vif->drv_priv;
+	} else
+		return;
+
+	bf = avf->bbuf;
+	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
+			sc->opmode == NL80211_IFTYPE_MONITOR)) {
+		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
+		return;
+	}
+
 	/*
 	 * Stop any current dma and put the new frame on the queue.
 	 * This should never fail since we check above that no frames
@@ -1823,17 +1897,17 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 
 	/* refresh the beacon for AP mode */
 	if (sc->opmode == NL80211_IFTYPE_AP)
-		ath5k_beacon_update(sc->hw, sc->vif);
+		ath5k_beacon_update(sc->hw, vif);
 
 	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_start_tx_dma(ah, sc->bhalq);
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
 		sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
 
-	skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
+	skb = ieee80211_get_buffered_bc(sc->hw, vif);
 	while (skb) {
 		ath5k_tx_queue(sc->hw, skb, sc->cabq);
-		skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
+		skb = ieee80211_get_buffered_bc(sc->hw, vif);
 	}
 
 	sc->bsent++;
@@ -1863,6 +1937,12 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 	u64 hw_tsf;
 
 	intval = sc->bintval & AR5K_BEACON_PERIOD;
+	if (sc->opmode == NL80211_IFTYPE_AP) {
+		intval /= ATH_BCBUF;	/* staggered multi-bss beacons */
+		if (intval < 15)
+			ATH5K_WARN(sc, "intval %u is too low, min 15\n",
+				   intval);
+	}
 	if (WARN_ON(!intval))
 		return;
 
@@ -2052,6 +2132,15 @@ ath5k_intr(int irq, void *dev_id)
 
 	do {
 		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
+		{
+			static unsigned int irq_counter;
+			if ((++irq_counter % 10000) == 9999) {
+				ATH5K_WARN(sc, "status 0x%x/0x%x  dev_id: %p"
+					   "  counter: %i  irq_counter: %i\n",
+					   status, sc->imask, dev_id, counter,
+					   irq_counter);
+			}
+		}
 		ATH5K_DBG(sc, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
 				status, sc->imask);
 		if (unlikely(status & AR5K_INT_FATAL)) {
@@ -2307,6 +2396,10 @@ ath5k_init(struct ath5k_softc *sc)
 		ath_hw_keyreset(common, (u16) i);
 
 	ath5k_hw_set_ack_bitrate_high(ah, true);
+
+	for (i = 0; i < ARRAY_SIZE(sc->bslot); i++)
+		sc->bslot[i] = ATH5K_IF_ID_ANY;
+
 	ret = 0;
 done:
 	mmiowb();
@@ -2366,7 +2459,6 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
 				"putting device to sleep\n");
 	}
-	ath5k_txbuf_free_skb(sc, sc->bbuf);
 
 	mmiowb();
 	mutex_unlock(&sc->lock);
@@ -2571,9 +2663,9 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	}
 
 	SET_IEEE80211_PERM_ADDR(hw, mac);
+	memcpy(&sc->lladdr, mac, ETH_ALEN);
 	/* All MAC address bits matter for ACKs */
-	memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
-	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
+	ath5k_update_bssid_mask(sc);
 
 	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
 	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
@@ -2671,30 +2763,63 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 {
 	struct ath5k_softc *sc = hw->priv;
 	int ret;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
+	unsigned int i;
 
 	mutex_lock(&sc->lock);
-	if (sc->vif) {
-		ret = 0;
+
+	if (sc->nvifs >= ATH5K_VIF_MAX ||
+	    (vif->type == NL80211_IFTYPE_AP && sc->nbcnvifs >= ATH_BCBUF)) {
+		ret = -ELNRNG;
 		goto end;
 	}
-
-	sc->vif = vif;
+	for (i = 0; i < ATH5K_VIF_MAX; i++) {
+		if (sc->vifs[i] != NULL)
+			continue;
+		sc->vifs[i] = vif;
+		avf->if_id = i;
+		break;
+	}
+	sc->nvifs++;
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-		sc->opmode = vif->type;
+		avf->opmode = vif->type;
 		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto end;
 	}
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "add interface mode %d\n", sc->opmode);
+	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "add interface mode %d\n", avf->opmode);
 
+	/* Set combined mode - when APs are configured, operate in AP mode.
+	 * Otherwise use the mode of the new interface. This can currently
+	 * only deal with combinations of APs and STAs I think ...
+	 */
+	if (sc->nbcnvifs)
+		sc->opmode = NL80211_IFTYPE_AP;
+	else
+		sc->opmode = vif->type;
+
+	ath5k_hw_set_opmode(ah, sc->opmode);
+
+	/* Set to a reasonable value. Note that this will
+	 * be set to mac80211's value at ath5k_config(). */
+	sc->bintval = ATH5K_DEFAULT_BINTVAL;
+
+	/* Any MAC address is finee, all others are included through the
+	 * filter.
+	 */
+	memcpy(&sc->lladdr, vif->addr, ETH_ALEN);
 	ath5k_hw_set_lladdr(sc->ah, vif->addr);
+
+	memcpy(&avf->lladdr, vif->addr, ETH_ALEN);
+
 	ath5k_mode_setup(sc);
 
 	ret = 0;
@@ -2708,15 +2833,32 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif)
 {
 	struct ath5k_softc *sc = hw->priv;
-	u8 mac[ETH_ALEN] = {};
+	struct ath5k_vif *avf = (void *)vif->drv_priv, *avf2;
+	u8 null_mac[ETH_ALEN] = {}, *mac = null_mac;
+	unsigned int i;
 
 	mutex_lock(&sc->lock);
-	if (sc->vif != vif)
-		goto end;
+	sc->vifs[avf->if_id] = NULL;
+	sc->nvifs--;
+
+	for (i = 0; i < ATH5K_VIF_MAX; i++) {
+		if (sc->vifs[i] == NULL)
+			continue;
+		avf2 = (void *)sc->vifs[i]->drv_priv;
+		mac = avf2->lladdr;
+		break;
+	}
+
+	if (avf->bbuf) {
+		ath5k_txbuf_free_skb(sc, avf->bbuf);
+		list_add_tail(&avf->bbuf->list, &sc->bcbuf);
+		sc->bslot[avf->bslot] = ATH5K_IF_ID_ANY;
+		sc->nbcnvifs--;
+		avf->bbuf = NULL;
+	}
 
 	ath5k_hw_set_lladdr(sc->ah, mac);
-	sc->vif = NULL;
-end:
+	ath5k_update_bssid_mask(sc);
 	mutex_unlock(&sc->lock);
 }
 
@@ -2799,6 +2941,23 @@ static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
 	return ((u64)(mfilt[1]) << 32) | mfilt[0];
 }
 
+static bool ath_any_vif_assoc(struct ath5k_softc *sc)
+{
+	int i;
+	int seen = 0;
+	for (i = 0; i < ATH5K_VIF_MAX; i++) {
+		if (sc->vifs[i]) {
+			struct ath5k_vif *avf = (void *)sc->vifs[i]->drv_priv;
+			seen++;
+			if (avf->assoc)
+				return true;
+			if (seen >= sc->nvifs)
+				break;
+		}
+	}
+	return false;
+}
+
 #define SUPPORTED_FIF_FLAGS \
 	FIF_PROMISC_IN_BSS |  FIF_ALLMULTI | FIF_FCSFAIL | \
 	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
@@ -2869,7 +3028,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 
 	/* FIF_BCN_PRBRESP_PROMISC really means to enable beacons
 	* and probes for any BSSID */
-	if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
+	if ((*new_flags & FIF_BCN_PRBRESP_PROMISC) || (sc->nvifs > 1))
 		rfilt |= AR5K_RX_FILTER_BEACON;
 
 	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
@@ -3054,13 +3213,14 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 				    struct ieee80211_bss_conf *bss_conf,
 				    u32 changes)
 {
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	unsigned long flags;
 
 	mutex_lock(&sc->lock);
-	if (WARN_ON(sc->vif != vif))
+	if (WARN_ON(sc->vifs[avf->if_id] != vif))
 		goto unlock;
 
 	if (changes & BSS_CHANGED_BSSID) {
@@ -3075,7 +3235,12 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		sc->bintval = bss_conf->beacon_int;
 
 	if (changes & BSS_CHANGED_ASSOC) {
-		sc->assoc = bss_conf->assoc;
+		avf->assoc = bss_conf->assoc;
+		if (bss_conf->assoc)
+			sc->assoc = bss_conf->assoc;
+		else
+			sc->assoc = ath_any_vif_assoc(sc);
+
 		if (sc->opmode == NL80211_IFTYPE_STATION)
 			set_beacon_filter(hw, sc->assoc);
 		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
@@ -3378,6 +3543,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		hw->max_rate_tries = 11;
 	}
 
+	hw->vif_data_size = sizeof(struct ath5k_vif);
+
 	/* Finish private driver data initialization */
 	ret = ath5k_attach(pdev, hw);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 7f9d0d3..34de4ba 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -58,8 +58,8 @@
 
 #define	ATH_RXBUF	40		/* number of RX buffers */
 #define	ATH_TXBUF	200		/* number of TX buffers */
-#define ATH_BCBUF	1		/* number of beacon buffers */
-
+#define ATH_BCBUF	4		/* number of beacon buffers */
+#define ATH5K_DEFAULT_BINTVAL	1000
 #define ATH5K_TXQ_LEN_MAX	(ATH_TXBUF / 4)		/* bufs per queue */
 #define ATH5K_TXQ_LEN_LOW	(ATH5K_TXQ_LEN_MAX / 2)	/* low mark */
 
@@ -152,6 +152,18 @@ struct ath5k_statistics {
 #define ATH_CHAN_MAX	(14+14+14+252+20)
 #endif
 
+#define ATH5K_VIF_MAX	2048
+#define ATH5K_IF_ID_ANY	-1
+
+struct ath5k_vif {
+	bool			assoc; /* are we associated or not */
+	int			if_id;
+	enum nl80211_iftype	opmode;
+	int			bslot;
+	struct ath5k_buf	*bbuf;		/* beacon buffer */
+	u8			lladdr[ETH_ALEN];
+};
+
 /* Software Carrier, keeps track of the driver state
  * associated with an instance of a device */
 struct ath5k_softc {
@@ -188,10 +200,12 @@ struct ath5k_softc {
 	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
-	struct ieee80211_vif *vif;
+	u16			nvifs;
+	struct ieee80211_vif *vifs[ATH5K_VIF_MAX];
 
 	enum ath5k_int		imask;		/* interrupt mask copy */
 
+	u8			lladdr[ETH_ALEN];
 	u8			bssidmask[ETH_ALEN];
 
 	unsigned int		led_pin,	/* GPIO pin for driving LED */
@@ -219,7 +233,9 @@ struct ath5k_softc {
 
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
-	struct ath5k_buf	*bbuf;		/* beacon buffer */
+	struct list_head	bcbuf;		/* beacon buffer */
+	int			bslot[ATH_BCBUF];
+	u16			nbcnvifs;
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval in TU */
@@ -228,7 +244,7 @@ struct ath5k_softc {
 	struct ath5k_txq	*cabq;		/* content after beacon */
 
 	int 			power_level;	/* Requested tx power in dbm */
-	bool			assoc;		/* associate state */
+	bool                    assoc;          /* associate state */
 	bool			enable_beacon;	/* true if beacons are on */
 
 	struct ath5k_statistics	stats;
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 58912cd..5b179d0 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -167,7 +167,7 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
 		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
-							sc->vif, 10, rate));
+							NULL, 10, rate));
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
@@ -1060,7 +1060,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		 * XXX: rethink this after new mode changes to
 		 * mac80211 are integrated */
 		if (ah->ah_version == AR5K_AR5212 &&
-			ah->ah_sc->vif != NULL)
+			ah->ah_sc->nvifs)
 			ath5k_hw_write_rate_duration(ah, mode);
 
 		/*
-- 
1.7.2.2

