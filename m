Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/10] atheros/ath9k: move macaddr, curaid, curbssid and bssidmask to common
Date: Thu, 10 Sep 2009 15:30:21 -0400
Message-Id: <1252611027-5285-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are common amongst ath9k and ath5k, so put them into the
common structure and make ath9k to use it. ar9170 can use macaddr,
and curbssid. We'll change ath5k and ar9170 separately.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h           |    4 +++
 drivers/net/wireless/ath/ath9k/ath9k.h   |    3 --
 drivers/net/wireless/ath/ath9k/hw.c      |   26 ++++++++++++++---------
 drivers/net/wireless/ath/ath9k/hw.h      |    1 -
 drivers/net/wireless/ath/ath9k/main.c    |   33 ++++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/recv.c    |    7 ++++-
 drivers/net/wireless/ath/ath9k/virtual.c |   18 +++++++++-------
 7 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 44f885a..7589b2a 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -41,6 +41,10 @@ struct ath_regulatory {
 
 struct ath_common {
 	u16 cachelsz;
+	u16 curaid;
+	u8 macaddr[ETH_ALEN];
+	u8 curbssid[ETH_ALEN];
+	u8 bssidmask[ETH_ALEN];
 	struct ath_regulatory regulatory;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e54fac3..757f17f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -581,12 +581,9 @@ struct ath_softc {
 	spinlock_t sc_pm_lock;
 	struct mutex mutex;
 
-	u8 curbssid[ETH_ALEN];
-	u8 bssidmask[ETH_ALEN];
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
 	u16 curtxpow;
-	u16 curaid;
 	u8 nbcnvifs;
 	u16 nvifs;
 	u8 tx_chainmask;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e370c8f..234decc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -511,6 +511,7 @@ static int ath9k_hw_rf_claim(struct ath_hw *ah)
 
 static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 sum;
 	int i;
 	u16 eeval;
@@ -519,8 +520,8 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	for (i = 0; i < 3; i++) {
 		eeval = ah->eep_ops->get_eeprom(ah, AR_EEPROM_MAC(i));
 		sum += eeval;
-		ah->macaddr[2 * i] = eeval >> 8;
-		ah->macaddr[2 * i + 1] = eeval & 0xff;
+		common->macaddr[2 * i] = eeval >> 8;
+		common->macaddr[2 * i + 1] = eeval & 0xff;
 	}
 	if (sum == 0 || sum == 0xffff * 3)
 		return -EADDRNOTAVAIL;
@@ -2334,6 +2335,7 @@ static void ath9k_enable_rfkill(struct ath_hw *ah)
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		    bool bChannelChange)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 saveLedState;
 	struct ath_softc *sc = ah->ah_sc;
 	struct ath9k_channel *curchan = ah->curchan;
@@ -2445,8 +2447,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_decrease_chain_power(ah, chan);
 
-	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(ah->macaddr));
-	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(ah->macaddr + 4)
+	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
+	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
 		  | macStaId1
 		  | AR_STA_ID1_RTS_USE_DEF
 		  | (ah->config.
@@ -3967,7 +3969,7 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 
 void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
 {
-	memcpy(ah->macaddr, mac, ETH_ALEN);
+	memcpy(ath9k_hw_common(ah)->macaddr, mac, ETH_ALEN);
 }
 
 void ath9k_hw_setopmode(struct ath_hw *ah)
@@ -3983,15 +3985,19 @@ void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
 
 void ath9k_hw_setbssidmask(struct ath_hw *ah)
 {
-	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(ah->ah_sc->bssidmask));
-	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(ah->ah_sc->bssidmask + 4));
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(common->bssidmask));
+	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(common->bssidmask + 4));
 }
 
 void ath9k_hw_write_associd(struct ath_hw *ah)
 {
-	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(ah->ah_sc->curbssid));
-	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(ah->ah_sc->curbssid + 4) |
-		  ((ah->ah_sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(common->curbssid));
+	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(common->curbssid + 4) |
+		  ((common->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 }
 
 u64 ath9k_hw_gettsf64(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d7b2a35..f8e7919 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -451,7 +451,6 @@ struct ath_hw {
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
-	u8 macaddr[ETH_ALEN];
 	u16 tx_trig_level;
 	u16 rfsilent;
 	u32 rfkill_gpio;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0eeb514..838b704 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -976,13 +976,14 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_bss_conf *bss_conf)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (bss_conf->assoc) {
 		DPRINTF(ah, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
-			bss_conf->aid, sc->curbssid);
+			bss_conf->aid, common->curbssid);
 
 		/* New association, store aid */
-		sc->curaid = bss_conf->aid;
+		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(ah);
 
 		/*
@@ -1001,7 +1002,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_start_ani(sc);
 	} else {
 		DPRINTF(ah, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
-		sc->curaid = 0;
+		common->curaid = 0;
 		/* Stop ANI */
 		del_timer_sync(&sc->ani.timer);
 	}
@@ -1501,6 +1502,7 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 {
 	struct ath_hw *ah = NULL;
+	struct ath_common *common;
 	int r = 0, i;
 	int csz = 0;
 	int qnum;
@@ -1679,8 +1681,10 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
+	common = ath9k_hw_common(ah);
+
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
+		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
 
@@ -1784,6 +1788,7 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
 {
 	struct ieee80211_hw *hw = sc->hw;
+	struct ath_common *common;
 	struct ath_hw *ah;
 	int error = 0, i;
 	struct ath_regulatory *reg;
@@ -1795,19 +1800,20 @@ int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
 		return error;
 
 	ah = sc->sc_ah;
+	common = ath9k_hw_common(ah);
 
 	/* get mac address from hardware and set in mac80211 */
 
-	SET_IEEE80211_PERM_ADDR(hw, ah->macaddr);
+	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 
 	ath_set_hw_capab(sc, hw);
 
-	error = ath_regd_init(&sc->common.regulatory, sc->hw->wiphy,
+	error = ath_regd_init(&common->regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
 	if (error)
 		return error;
 
-	reg = &sc->common.regulatory;
+	reg = &common->regulatory;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
@@ -2791,6 +2797,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	u32 rfilt = 0;
 	int error, i;
@@ -2806,8 +2813,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	    ah->opmode != NL80211_IFTYPE_AP) {
 		ah->opmode = NL80211_IFTYPE_STATION;
 		ath9k_hw_setopmode(ah);
-		memcpy(sc->curbssid, sc->sc_ah->macaddr, ETH_ALEN);
-		sc->curaid = 0;
+		memcpy(common->curbssid, common->macaddr, ETH_ALEN);
+		common->curaid = 0;
 		ath9k_hw_write_associd(ah);
 		/* Request full reset to get hw opmode changed properly */
 		sc->sc_flags |= SC_OP_FULL_RESET;
@@ -2820,9 +2827,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_MESH_POINT:
 			/* Set BSSID */
-			memcpy(sc->curbssid, bss_conf->bssid, ETH_ALEN);
+			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 			memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
-			sc->curaid = 0;
+			common->curaid = 0;
 			ath9k_hw_write_associd(ah);
 
 			/* Set aggregation protection mode parameters */
@@ -2830,7 +2837,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 				"RX filter 0x%x bssid %pM aid 0x%x\n",
-				rfilt, sc->curbssid, sc->curaid);
+				rfilt, common->curbssid, common->curaid);
 
 			/* need to reconfigure the beacon */
 			sc->sc_flags &= ~SC_OP_BEACONS ;
@@ -2869,7 +2876,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
 				ath9k_hw_keysetmac(sc->sc_ah,
 						   (u16)i,
-						   sc->curbssid);
+						   common->curbssid);
 	}
 
 	/* Only legacy IBSS for now */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 529cab6..3bdd4e6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -272,6 +272,8 @@ rx_next:
 static void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	u32 rfilt, mfilt[2];
 
 	/* configure rx filter */
@@ -286,7 +288,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setopmode(ah);
 
 	/* Handle any link-level address change. */
-	ath9k_hw_setmac(ah, sc->sc_ah->macaddr);
+	ath9k_hw_setmac(ah, common->macaddr);
 
 	/* calculate and install multicast filter */
 	mfilt[0] = mfilt[1] = ~0;
@@ -527,12 +529,13 @@ static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	if (skb->len < 24 + 8 + 2 + 2)
 		return;
 
 	mgmt = (struct ieee80211_mgmt *)skb->data;
-	if (memcmp(sc->curbssid, mgmt->bssid, ETH_ALEN) != 0)
+	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0)
 		return; /* not from our current AP */
 
 	sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 52becd3..7b763b6 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -40,6 +40,7 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_vif_iter_data iter_data;
 	int i, j;
 	u8 mask[ETH_ALEN];
@@ -51,7 +52,7 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	 */
 	iter_data.addr = kmalloc(ETH_ALEN, GFP_ATOMIC);
 	if (iter_data.addr) {
-		memcpy(iter_data.addr, sc->sc_ah->macaddr, ETH_ALEN);
+		memcpy(iter_data.addr, common->macaddr, ETH_ALEN);
 		iter_data.count = 1;
 	} else
 		iter_data.count = 0;
@@ -86,12 +87,12 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	kfree(iter_data.addr);
 
 	/* Invert the mask and configure hardware */
-	sc->bssidmask[0] = ~mask[0];
-	sc->bssidmask[1] = ~mask[1];
-	sc->bssidmask[2] = ~mask[2];
-	sc->bssidmask[3] = ~mask[3];
-	sc->bssidmask[4] = ~mask[4];
-	sc->bssidmask[5] = ~mask[5];
+	common->bssidmask[0] = ~mask[0];
+	common->bssidmask[1] = ~mask[1];
+	common->bssidmask[2] = ~mask[2];
+	common->bssidmask[3] = ~mask[3];
+	common->bssidmask[4] = ~mask[4];
+	common->bssidmask[5] = ~mask[5];
 
 	ath9k_hw_setbssidmask(sc->sc_ah);
 }
@@ -100,6 +101,7 @@ int ath9k_wiphy_add(struct ath_softc *sc)
 {
 	int i, error;
 	struct ath_wiphy *aphy;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_hw *hw;
 	u8 addr[ETH_ALEN];
 
@@ -138,7 +140,7 @@ int ath9k_wiphy_add(struct ath_softc *sc)
 	sc->sec_wiphy[i] = aphy;
 	spin_unlock_bh(&sc->wiphy_lock);
 
-	memcpy(addr, sc->sc_ah->macaddr, ETH_ALEN);
+	memcpy(addr, common->macaddr, ETH_ALEN);
 	addr[0] |= 0x02; /* Locally managed address */
 	/*
 	 * XOR virtual wiphy index into the least significant bits to generate
-- 
1.6.3.3

