Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41612 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0I2AjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:39:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v7] ath5k: Allow ath5k to support virtual STA and AP interfaces.
Date: Tue, 28 Sep 2010 17:39:04 -0700
Message-Id: <1285720744-26246-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Support up to 4 virtual APs and as many virtual STA interfaces
as desired.

This patch is ported forward from a patch that Patrick McHardy
did for me against 2.6.31.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v6 -> v7:  Fix bug that assigned a beacon buffer to all vifs.
      Tested creation of 128 stations, all passed traffic.
v4 -> v6:  Use tx_info's vif instead of NULL, assign beacon
  buffers on device creation (for AP and ADHOC).  Clean up some
  whitespace and un-used variables.

  Did NOT change the beacon buffer linked list to an array.
  It didn't seem to offer any benefits to me.


:100644 100644 94cc335... 499a906... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 7f9d0d3... b9f6d13... M	drivers/net/wireless/ath/ath5k/base.h
:100644 100644 58912cd... 5b179d0... M	drivers/net/wireless/ath/ath5k/reset.c
 drivers/net/wireless/ath/ath5k/base.c  |  264 ++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath5k/base.h  |   19 ++-
 drivers/net/wireless/ath/ath5k/reset.c |    4 +-
 3 files changed, 237 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 94cc335..499a906 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -52,6 +52,7 @@
 #include <linux/ethtool.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/etherdevice.h>
 
 #include <net/ieee80211_radiotap.h>
 
@@ -509,8 +510,69 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 	}
 }
 
+struct ath_vif_iter_data {
+	const u8 *hw_macaddr;
+	u8 mask[ETH_ALEN];
+	u8 active_mac[ETH_ALEN]; /* first active MAC */
+	bool need_set_hw_addr;
+	bool found_active;
+	bool any_assoc;
+};
+
+static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath_vif_iter_data *iter_data = data;
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+
+	if (!iter_data->found_active) {
+		iter_data->found_active = true;
+		memcpy(iter_data->active_mac, mac, ETH_ALEN);
+	}
+
+	if (iter_data->need_set_hw_addr)
+		if (compare_ether_addr(iter_data->hw_macaddr, mac) == 0)
+			iter_data->need_set_hw_addr = false;
+
+	if (!iter_data->any_assoc) {
+		struct ath5k_vif *avf = (void *)vif->drv_priv;
+		if (avf->assoc)
+			iter_data->any_assoc = true;
+	}
+}
+
+void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath5k_hw_common(sc->ah);
+	struct ath_vif_iter_data iter_data;
+
+	/*
+	 * Use the hardware MAC address as reference, the hardware uses it
+	 * together with the BSSID mask when matching addresses.
+	 */
+	iter_data.hw_macaddr = common->macaddr;
+	memset(&iter_data.mask, 0xff, ETH_ALEN);
+	iter_data.found_active = false;
+	iter_data.need_set_hw_addr = true;
+
+	if (vif)
+		ath_vif_iter(&iter_data, vif->addr, vif);
+
+	/* Get list of all active MAC addresses */
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath_vif_iter,
+						   &iter_data);
+	memcpy(sc->bssidmask, iter_data.mask, ETH_ALEN);
+
+	if (iter_data.need_set_hw_addr && iter_data.found_active)
+		ath5k_hw_set_lladdr(sc->ah, iter_data.active_mac);
+
+	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
+}
+
 static void
-ath5k_mode_setup(struct ath5k_softc *sc)
+ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath5k_hw *ah = sc->ah;
 	u32 rfilt;
@@ -520,7 +582,7 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	ath5k_hw_set_rx_filter(ah, rfilt);
 
 	if (ath5k_hw_hasbssidmask(ah))
-		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
+		ath5k_update_bssid_mask(sc, vif);
 
 	/* configure operational mode */
 	ath5k_hw_set_opmode(ah, sc->opmode);
@@ -698,13 +760,13 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		flags |= AR5K_TXDESC_RTSENA;
 		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
 		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
-			sc->vif, pktlen, info));
+			info->control.vif, pktlen, info));
 	}
 	if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
 		flags |= AR5K_TXDESC_CTSENA;
 		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
 		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
-			sc->vif, pktlen, info));
+			info->control.vif, pktlen, info));
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), padsize,
@@ -806,10 +868,13 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
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
@@ -824,11 +889,12 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
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
@@ -837,7 +903,6 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 
 	kfree(sc->bufptr);
 	sc->bufptr = NULL;
-	sc->bbuf = NULL;
 }
 
 
@@ -1083,7 +1148,7 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	spin_unlock_bh(&sc->rxbuflock);
 
 	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
-	ath5k_mode_setup(sc);		/* set filters, etc. */
+	ath5k_mode_setup(sc, NULL);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
 	return 0;
@@ -1750,6 +1815,7 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	int ret;
 	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 
 	if (WARN_ON(!vif)) {
@@ -1766,11 +1832,11 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	ath5k_txbuf_free_skb(sc, sc->bbuf);
-	sc->bbuf->skb = skb;
-	ret = ath5k_beacon_setup(sc, sc->bbuf);
+	ath5k_txbuf_free_skb(sc, avf->bbuf);
+	avf->bbuf->skb = skb;
+	ret = ath5k_beacon_setup(sc, avf->bbuf);
 	if (ret)
-		sc->bbuf->skb = NULL;
+		avf->bbuf->skb = NULL;
 out:
 	return ret;
 }
@@ -1786,16 +1852,17 @@ out:
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
+	int slot;
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
-	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION)) {
-		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
-		return;
-	}
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not, don't don't try to post another: skip this
@@ -1824,6 +1891,27 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		sc->bmisscount = 0;
 	}
 
+	tsf = ath5k_hw_get_tsf64(ah);
+	tsftu = TSF_TO_TU(tsf);
+	slot = ((tsftu % sc->bintval) * ATH_BCBUF) / sc->bintval;
+	vif = sc->bslot[(slot + 1) % ATH_BCBUF];
+
+	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+		  "tsf %llx tsftu %x intval %u slot %u vif %p\n",
+		 (unsigned long long)tsf, tsftu, sc->bintval, slot, vif);
+
+	if (vif)
+		avf = (void *)vif->drv_priv;
+	else
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
@@ -1836,17 +1924,17 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 
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
@@ -1876,6 +1964,12 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
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
 
@@ -2323,6 +2417,10 @@ ath5k_init(struct ath5k_softc *sc)
 		ath_hw_keyreset(common, (u16) i);
 
 	ath5k_hw_set_ack_bitrate_high(ah, true);
+
+	for (i = 0; i < ARRAY_SIZE(sc->bslot); i++)
+		sc->bslot[i] = NULL;
+
 	ret = 0;
 done:
 	mmiowb();
@@ -2382,7 +2480,6 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
 				"putting device to sleep\n");
 	}
-	ath5k_txbuf_free_skb(sc, sc->bbuf);
 
 	mmiowb();
 	mutex_unlock(&sc->lock);
@@ -2587,9 +2684,9 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	}
 
 	SET_IEEE80211_PERM_ADDR(hw, mac);
+	memcpy(&sc->lladdr, mac, ETH_ALEN);
 	/* All MAC address bits matter for ACKs */
-	memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
-	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
+	ath5k_update_bssid_mask(sc, NULL);
 
 	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
 	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
@@ -2687,31 +2784,79 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 {
 	struct ath5k_softc *sc = hw->priv;
 	int ret;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
 
 	mutex_lock(&sc->lock);
-	if (sc->vif) {
-		ret = 0;
+
+	if ((vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_ADHOC)
+	    && (sc->num_ap_vifs + sc->num_adhoc_vifs) >= ATH_BCBUF) {
+		ret = -ELNRNG;
 		goto end;
 	}
-
-	sc->vif = vif;
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
 
+	/* Assign the vap/adhoc to a beacon xmit slot. */
+	if ((avf->opmode == NL80211_IFTYPE_AP) ||
+	    (avf->opmode == NL80211_IFTYPE_ADHOC)) {
+		int slot;
+
+		WARN_ON(list_empty(&sc->bcbuf));
+		avf->bbuf = list_first_entry(&sc->bcbuf, struct ath5k_buf,
+					     list);
+		list_del(&avf->bbuf->list);
+
+		avf->bslot = 0;
+		for (slot = 0; slot < ATH_BCBUF; slot++) {
+			if (!sc->bslot[slot]) {
+				avf->bslot = slot;
+				break;
+			}
+		}
+		BUG_ON(sc->bslot[avf->bslot] != NULL);
+		sc->bslot[avf->bslot] = vif;
+		if (avf->opmode == NL80211_IFTYPE_AP)
+			sc->num_ap_vifs++;
+		else
+			sc->num_adhoc_vifs++;
+	}
+
+	/* Set combined mode - when APs are configured, operate in AP mode.
+	 * Otherwise use the mode of the new interface. This can currently
+	 * only deal with combinations of APs and STAs I think ...
+	 * TODO:  What to do about mixed ADHOC + STA ?
+	 */
+	if (sc->num_ap_vifs)
+		sc->opmode = NL80211_IFTYPE_AP;
+	else
+		sc->opmode = vif->type;
+
+	ath5k_hw_set_opmode(ah, sc->opmode);
+
+	/* Any MAC address is fine, all others are included through the
+	 * filter.
+	 */
+	memcpy(&sc->lladdr, vif->addr, ETH_ALEN);
 	ath5k_hw_set_lladdr(sc->ah, vif->addr);
-	ath5k_mode_setup(sc);
+
+	memcpy(&avf->lladdr, vif->addr, ETH_ALEN);
+
+	ath5k_mode_setup(sc, vif);
 
 	ret = 0;
 end:
@@ -2724,15 +2869,29 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif)
 {
 	struct ath5k_softc *sc = hw->priv;
-	u8 mac[ETH_ALEN] = {};
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
+	unsigned int i;
 
 	mutex_lock(&sc->lock);
-	if (sc->vif != vif)
-		goto end;
+	sc->nvifs--;
+
+	if (avf->bbuf) {
+		ath5k_txbuf_free_skb(sc, avf->bbuf);
+		list_add_tail(&avf->bbuf->list, &sc->bcbuf);
+		for (i = 0; i < ATH_BCBUF; i++) {
+			if (sc->bslot[i] == vif) {
+				sc->bslot[i] = NULL;
+				break;
+			}
+		}
+		avf->bbuf = NULL;
+	}
+	if (avf->opmode == NL80211_IFTYPE_AP)
+		sc->num_ap_vifs--;
+	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
+		sc->num_adhoc_vifs--;
 
-	ath5k_hw_set_lladdr(sc->ah, mac);
-	sc->vif = NULL;
-end:
+	ath5k_update_bssid_mask(sc, NULL);
 	mutex_unlock(&sc->lock);
 }
 
@@ -2815,6 +2974,18 @@ static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
 	return ((u64)(mfilt[1]) << 32) | mfilt[0];
 }
 
+static bool ath_any_vif_assoc(struct ath5k_softc *sc)
+{
+	struct ath_vif_iter_data iter_data;
+	iter_data.any_assoc = false;
+	iter_data.need_set_hw_addr = false;
+	iter_data.found_active = true;
+
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath_vif_iter,
+						   &iter_data);
+	return iter_data.any_assoc;
+}
+
 #define SUPPORTED_FIF_FLAGS \
 	FIF_PROMISC_IN_BSS |  FIF_ALLMULTI | FIF_FCSFAIL | \
 	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
@@ -2885,7 +3056,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 
 	/* FIF_BCN_PRBRESP_PROMISC really means to enable beacons
 	* and probes for any BSSID */
-	if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
+	if ((*new_flags & FIF_BCN_PRBRESP_PROMISC) || (sc->nvifs > 1))
 		rfilt |= AR5K_RX_FILTER_BEACON;
 
 	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
@@ -3070,14 +3241,13 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
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
-		goto unlock;
 
 	if (changes & BSS_CHANGED_BSSID) {
 		/* Cache for later use during resets */
@@ -3091,7 +3261,12 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
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
@@ -3119,7 +3294,6 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		       BSS_CHANGED_BEACON_INT))
 		ath5k_beacon_config(sc);
 
- unlock:
 	mutex_unlock(&sc->lock);
 }
 
@@ -3394,6 +3568,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		hw->max_rate_tries = 11;
 	}
 
+	hw->vif_data_size = sizeof(struct ath5k_vif);
+
 	/* Finish private driver data initialization */
 	ret = ath5k_attach(pdev, hw);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 7f9d0d3..b9f6d13 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -58,8 +58,7 @@
 
 #define	ATH_RXBUF	40		/* number of RX buffers */
 #define	ATH_TXBUF	200		/* number of TX buffers */
-#define ATH_BCBUF	1		/* number of beacon buffers */
-
+#define ATH_BCBUF	4		/* number of beacon buffers */
 #define ATH5K_TXQ_LEN_MAX	(ATH_TXBUF / 4)		/* bufs per queue */
 #define ATH5K_TXQ_LEN_LOW	(ATH5K_TXQ_LEN_MAX / 2)	/* low mark */
 
@@ -152,6 +151,14 @@ struct ath5k_statistics {
 #define ATH_CHAN_MAX	(14+14+14+252+20)
 #endif
 
+struct ath5k_vif {
+	bool			assoc; /* are we associated or not */
+	enum nl80211_iftype	opmode;
+	int			bslot;
+	struct ath5k_buf	*bbuf; /* beacon buffer */
+	u8			lladdr[ETH_ALEN];
+};
+
 /* Software Carrier, keeps track of the driver state
  * associated with an instance of a device */
 struct ath5k_softc {
@@ -188,10 +195,11 @@ struct ath5k_softc {
 	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
-	struct ieee80211_vif *vif;
+	u16			nvifs;
 
 	enum ath5k_int		imask;		/* interrupt mask copy */
 
+	u8			lladdr[ETH_ALEN];
 	u8			bssidmask[ETH_ALEN];
 
 	unsigned int		led_pin,	/* GPIO pin for driving LED */
@@ -219,7 +227,10 @@ struct ath5k_softc {
 
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
-	struct ath5k_buf	*bbuf;		/* beacon buffer */
+	struct list_head	bcbuf;		/* beacon buffer */
+	struct ieee80211_vif	*bslot[ATH_BCBUF];
+	u16			num_ap_vifs;
+	u16			num_adhoc_vifs;
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval in TU */
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

