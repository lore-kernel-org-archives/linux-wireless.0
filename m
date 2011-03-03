Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55184 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759010Ab1CCWjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 17:39:10 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath5k:  Put hardware in PROMISC mode if there is more than 1 stations.
Date: Thu,  3 Mar 2011 14:39:05 -0800
Message-Id: <1299191945-13257-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It seems ath5k has issues receiving broadcast packets (ARPs) when
using multiple STA interfaces associated with multiple APs.
This patch ensures the NIC is always in PROMISC mode if there
are more than 1 stations associated.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 91411e9... e6ff62e... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 8f919dc... 8d1df1f... M	drivers/net/wireless/ath/ath5k/base.h
:100644 100644 1fbe3c0... c9b0b67... M	drivers/net/wireless/ath/ath5k/mac80211-ops.c
 drivers/net/wireless/ath/ath5k/base.c         |   52 +++++++++++--------------
 drivers/net/wireless/ath/ath5k/base.h         |   13 ++++++
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   19 ++++++++-
 3 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 91411e9..e6ff62e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -442,19 +442,9 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	return ath5k_reset(sc, chan, true);
 }
 
-struct ath_vif_iter_data {
-	const u8	*hw_macaddr;
-	u8		mask[ETH_ALEN];
-	u8		active_mac[ETH_ALEN]; /* first active MAC */
-	bool		need_set_hw_addr;
-	bool		found_active;
-	bool		any_assoc;
-	enum nl80211_iftype opmode;
-};
-
-static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
-	struct ath_vif_iter_data *iter_data = data;
+	struct ath5k_vif_iter_data *iter_data = data;
 	int i;
 	struct ath5k_vif *avf = (void *)vif->drv_priv;
 
@@ -484,9 +474,12 @@ static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	 */
 	if (avf->opmode == NL80211_IFTYPE_AP)
 		iter_data->opmode = NL80211_IFTYPE_AP;
-	else
+	else {
+		if (avf->opmode == NL80211_IFTYPE_STATION)
+			iter_data->n_stas++;
 		if (iter_data->opmode == NL80211_IFTYPE_UNSPECIFIED)
 			iter_data->opmode = avf->opmode;
+	}
 }
 
 void
@@ -494,7 +487,8 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 				   struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath5k_hw_common(sc->ah);
-	struct ath_vif_iter_data iter_data;
+	struct ath5k_vif_iter_data iter_data;
+	u32 rfilt;
 
 	/*
 	 * Use the hardware MAC address as reference, the hardware uses it
@@ -505,12 +499,13 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 	iter_data.found_active = false;
 	iter_data.need_set_hw_addr = true;
 	iter_data.opmode = NL80211_IFTYPE_UNSPECIFIED;
+	iter_data.n_stas = 0;
 
 	if (vif)
-		ath_vif_iter(&iter_data, vif->addr, vif);
+		ath5k_vif_iter(&iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath_vif_iter,
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath5k_vif_iter,
 						   &iter_data);
 	memcpy(sc->bssidmask, iter_data.mask, ETH_ALEN);
 
@@ -528,20 +523,19 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 
 	if (ath5k_hw_hasbssidmask(sc->ah))
 		ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
-}
 
-void
-ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif)
-{
-	struct ath5k_hw *ah = sc->ah;
-	u32 rfilt;
+	/* Set up RX Filter */
+	if (iter_data.n_stas > 1) {
+		/* If you have multiple STA interfaces connected to
+		 * different APs, ARPs are not received (most of the time?)
+		 * Enabling PROMISC appears to fix that probem.
+		 */
+		sc->filter_flags |= AR5K_RX_FILTER_PROM;
+	}
 
-	/* configure rx filter */
 	rfilt = sc->filter_flags;
-	ath5k_hw_set_rx_filter(ah, rfilt);
+	ath5k_hw_set_rx_filter(sc->ah, rfilt);
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
-
-	ath5k_update_bssid_mask_and_opmode(sc, vif);
 }
 
 static inline int
@@ -1117,7 +1111,7 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	spin_unlock_bh(&sc->rxbuflock);
 
 	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
-	ath5k_mode_setup(sc, NULL);		/* set filters, etc. */
+	ath5k_update_bssid_mask_and_opmode(sc, NULL); /* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
 	return 0;
@@ -2923,13 +2917,13 @@ ath5k_deinit_softc(struct ath5k_softc *sc)
 bool
 ath_any_vif_assoc(struct ath5k_softc *sc)
 {
-	struct ath_vif_iter_data iter_data;
+	struct ath5k_vif_iter_data iter_data;
 	iter_data.hw_macaddr = NULL;
 	iter_data.any_assoc = false;
 	iter_data.need_set_hw_addr = false;
 	iter_data.found_active = true;
 
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath_vif_iter,
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath5k_vif_iter,
 						   &iter_data);
 	return iter_data.any_assoc;
 }
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 8f919dc..8d1df1f 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -259,6 +259,19 @@ struct ath5k_softc {
 	struct survey_info	survey;		/* collected survey info */
 };
 
+struct ath5k_vif_iter_data {
+	const u8	*hw_macaddr;
+	u8		mask[ETH_ALEN];
+	u8		active_mac[ETH_ALEN]; /* first active MAC */
+	bool		need_set_hw_addr;
+	bool		found_active;
+	bool		any_assoc;
+	enum nl80211_iftype opmode;
+	int n_stas;
+};
+void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif);
+
+
 #define ath5k_hw_hasbssidmask(_ah) \
 	(ath5k_hw_get_capability(_ah, AR5K_CAP_BSSIDMASK, 0, NULL) == 0)
 #define ath5k_hw_hasveol(_ah) \
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 1fbe3c0..c9b0b67 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -158,8 +158,7 @@ ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	memcpy(&avf->lladdr, vif->addr, ETH_ALEN);
 
-	ath5k_mode_setup(sc, vif);
-
+	ath5k_update_bssid_mask_and_opmode(sc, vif);
 	ret = 0;
 end:
 	mutex_unlock(&sc->lock);
@@ -381,6 +380,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	u32 mfilt[2], rfilt;
+	struct ath5k_vif_iter_data iter_data; /* to count STA interfaces */
 
 	mutex_lock(&sc->lock);
 
@@ -454,6 +454,21 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 		break;
 	}
 
+	iter_data.hw_macaddr = NULL;
+	iter_data.n_stas = 0;
+	iter_data.need_set_hw_addr = false;
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath5k_vif_iter,
+						   &iter_data);
+
+	/* Set up RX Filter */
+	if (iter_data.n_stas > 1) {
+		/* If you have multiple STA interfaces connected to
+		 * different APs, ARPs are not received (most of the time?)
+		 * Enabling PROMISC appears to fix that probem.
+		 */
+		rfilt |= AR5K_RX_FILTER_PROM;
+	}
+
 	/* Set filters */
 	ath5k_hw_set_rx_filter(ah, rfilt);
 
-- 
1.7.2.3

