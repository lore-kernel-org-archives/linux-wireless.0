Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30464 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZBIIAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:51 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57814.730042.880863@gargle.gargle.HOWL> (sfid-20090209_090100_312639_BCA367A4)
Date: Mon, 9 Feb 2009 13:27:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 06/10] ath9k: Remove duplicate variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few variables (bssid, bssidmask, curaid) were duplicated in
struct ath_softc and in ath_hal, remove them.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath9k/hw.c    |   71 ++++++++++--------------------------
 drivers/net/wireless/ath9k/hw.h    |   14 ++-----
 drivers/net/wireless/ath9k/main.c  |   24 +++++++------
 drivers/net/wireless/ath9k/recv.c  |    4 +-
 5 files changed, 38 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d60b2e7..03e4d0b 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -580,7 +580,6 @@ struct ath_softc {
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
-	u8 macaddr[ETH_ALEN];
 	u8 bssidmask[ETH_ALEN];
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 9eafada..5d72875 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -392,8 +392,6 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 					      void __iomem *mem,
 					      int *status)
 {
-	static const u8 defbssidmask[ETH_ALEN] =
-		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 	struct ath_hal_5416 *ahp;
 	struct ath_hal *ah;
 
@@ -432,7 +430,6 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 	ahp->ah_acktimeout = (u32) -1;
 	ahp->ah_ctstimeout = (u32) -1;
 	ahp->ah_globaltxtimeout = (u32) -1;
-	memcpy(&ahp->ah_bssidmask, defbssidmask, ETH_ALEN);
 
 	ahp->ah_gBeaconRate = 0;
 
@@ -488,19 +485,18 @@ static int ath9k_hw_init_macaddr(struct ath_hal *ah)
 	u32 sum;
 	int i;
 	u16 eeval;
-	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	sum = 0;
 	for (i = 0; i < 3; i++) {
 		eeval = ath9k_hw_get_eeprom(ah, AR_EEPROM_MAC(i));
 		sum += eeval;
-		ahp->ah_macaddr[2 * i] = eeval >> 8;
-		ahp->ah_macaddr[2 * i + 1] = eeval & 0xff;
+		ah->macaddr[2 * i] = eeval >> 8;
+		ah->macaddr[2 * i + 1] = eeval & 0xff;
 	}
 	if (sum == 0 || sum == 0xffff * 3) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"mac address read failed: %pM\n",
-			ahp->ah_macaddr);
+			ah->macaddr);
 		return -EADDRNOTAVAIL;
 	}
 
@@ -2251,8 +2247,8 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_decrease_chain_power(ah, chan);
 
-	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(ahp->ah_macaddr));
-	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(ahp->ah_macaddr + 4)
+	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(ah->macaddr));
+	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(ah->macaddr + 4)
 		  | macStaId1
 		  | AR_STA_ID1_RTS_USE_DEF
 		  | (ah->ah_config.
@@ -2260,14 +2256,14 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		  | ahp->ah_staId1Defaults);
 	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
 
-	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(ahp->ah_bssidmask));
-	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(ahp->ah_bssidmask + 4));
+	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(sc->bssidmask));
+	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(sc->bssidmask + 4));
 
 	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
 
-	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(ahp->ah_bssid));
-	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(ahp->ah_bssid + 4) |
-		  ((ahp->ah_assocId & 0x3fff) << AR_BSS_ID1_AID_S));
+	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(sc->curbssid));
+	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(sc->curbssid + 4) |
+		  ((sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 
 	REG_WRITE(ah, AR_ISR, ~0);
 
@@ -3669,20 +3665,9 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit)
 	return true;
 }
 
-void ath9k_hw_getmac(struct ath_hal *ah, u8 *mac)
-{
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	memcpy(mac, ahp->ah_macaddr, ETH_ALEN);
-}
-
-bool ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac)
+void ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	memcpy(ahp->ah_macaddr, mac, ETH_ALEN);
-
-	return true;
+	memcpy(ah->macaddr, mac, ETH_ALEN);
 }
 
 void ath9k_hw_setopmode(struct ath_hal *ah)
@@ -3696,35 +3681,17 @@ void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0, u32 filter1)
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
 }
 
-void ath9k_hw_getbssidmask(struct ath_hal *ah, u8 *mask)
+void ath9k_hw_setbssidmask(struct ath_softc *sc)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	memcpy(mask, ahp->ah_bssidmask, ETH_ALEN);
+	REG_WRITE(sc->sc_ah, AR_BSSMSKL, get_unaligned_le32(sc->bssidmask));
+	REG_WRITE(sc->sc_ah, AR_BSSMSKU, get_unaligned_le16(sc->bssidmask + 4));
 }
 
-bool ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask)
+void ath9k_hw_write_associd(struct ath_softc *sc)
 {
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	memcpy(ahp->ah_bssidmask, mask, ETH_ALEN);
-
-	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(ahp->ah_bssidmask));
-	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(ahp->ah_bssidmask + 4));
-
-	return true;
-}
-
-void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid, u16 assocId)
-{
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	memcpy(ahp->ah_bssid, bssid, ETH_ALEN);
-	ahp->ah_assocId = assocId;
-
-	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(ahp->ah_bssid));
-	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(ahp->ah_bssid + 4) |
-		  ((assocId & 0x3fff) << AR_BSS_ID1_AID_S));
+	REG_WRITE(sc->sc_ah, AR_BSS_ID0, get_unaligned_le32(sc->curbssid));
+	REG_WRITE(sc->sc_ah, AR_BSS_ID1, get_unaligned_le16(sc->curbssid + 4) |
+		  ((sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 }
 
 u64 ath9k_hw_gettsf64(struct ath_hal *ah)
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 3fdf962..f4bf702 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -427,6 +427,7 @@ struct ath_hal {
 	struct ath9k_hw_capabilities ah_caps;
 	struct ath9k_regulatory regulatory;
 	u32 ah_flags;
+	u8 macaddr[ETH_ALEN];
 
 	enum ath9k_power_mode ah_power_mode;
 	enum ath9k_power_mode ah_restore_mode;
@@ -457,11 +458,6 @@ struct ath_hal_5416 {
 	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
 	void __iomem *ah_cal_mem;
 
-	u8 ah_macaddr[ETH_ALEN];
-	u8 ah_bssid[ETH_ALEN];
-	u8 ah_bssidmask[ETH_ALEN];
-	u16 ah_assocId;
-
 	int16_t ah_curchanRadIndex;
 	u32 ah_maskReg;
 	u32 ah_txOkInterruptMask;
@@ -633,13 +629,11 @@ void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hal *ah);
 bool ath9k_hw_disable(struct ath_hal *ah);
 bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit);
-void ath9k_hw_getmac(struct ath_hal *ah, u8 *mac);
-bool ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac);
+void ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac);
 void ath9k_hw_setopmode(struct ath_hal *ah);
 void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0, u32 filter1);
-void ath9k_hw_getbssidmask(struct ath_hal *ah, u8 *mask);
-bool ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask);
-void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid, u16 assocId);
+void ath9k_hw_setbssidmask(struct ath_softc *sc);
+void ath9k_hw_write_associd(struct ath_softc *sc);
 u64 ath9k_hw_gettsf64(struct ath_hal *ah);
 void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hal *ah);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index a1c76ec..bafefbe 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -905,8 +905,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		/* New association, store aid */
 		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
 			sc->curaid = bss_conf->aid;
-			ath9k_hw_write_associd(sc->sc_ah, sc->curbssid,
-					       sc->curaid);
+			ath9k_hw_write_associd(sc);
 		}
 
 		/* Configure the beacon */
@@ -1514,11 +1513,10 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
-	ath9k_hw_getmac(ah, sc->macaddr);
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
-		ath9k_hw_getbssidmask(ah, sc->bssidmask);
+		memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
 		ATH_SET_VIF_BSSID_MASK(sc->bssidmask);
-		ath9k_hw_setbssidmask(ah, sc->bssidmask);
+		ath9k_hw_setbssidmask(sc);
 	}
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
@@ -1577,7 +1575,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	/* get mac address from hardware and set in mac80211 */
 
-	SET_IEEE80211_PERM_ADDR(hw, sc->macaddr);
+	SET_IEEE80211_PERM_ADDR(hw, sc->sc_ah->macaddr);
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
@@ -2285,7 +2283,9 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	    ah->ah_opmode != NL80211_IFTYPE_AP) {
 		ah->ah_opmode = NL80211_IFTYPE_STATION;
 		ath9k_hw_setopmode(ah);
-		ath9k_hw_write_associd(ah, sc->macaddr, 0);
+		memcpy(sc->curbssid, sc->sc_ah->macaddr, ETH_ALEN);
+		sc->curaid = 0;
+		ath9k_hw_write_associd(sc);
 		/* Request full reset to get hw opmode changed properly */
 		sc->sc_flags |= SC_OP_FULL_RESET;
 	}
@@ -2298,8 +2298,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			/* Set BSSID */
 			memcpy(sc->curbssid, conf->bssid, ETH_ALEN);
 			sc->curaid = 0;
-			ath9k_hw_write_associd(sc->sc_ah, sc->curbssid,
-					       sc->curaid);
+			ath9k_hw_write_associd(sc);
 
 			/* Set aggregation protection mode parameters */
 			sc->config.ath_aggr_prot = 0;
@@ -2382,8 +2381,11 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			ath9k_hw_write_associd(sc->sc_ah, ath_bcast_mac, 0);
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
+			memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
+			sc->curaid = 0;
+			ath9k_hw_write_associd(sc);
+		}
 	}
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilter);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index e8e4a32..c51c085 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -242,13 +242,13 @@ static void ath_opmode_init(struct ath_softc *sc)
 
 	/* configure bssid mask */
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath9k_hw_setbssidmask(ah, sc->bssidmask);
+		ath9k_hw_setbssidmask(sc);
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
 
 	/* Handle any link-level address change. */
-	ath9k_hw_setmac(ah, sc->macaddr);
+	ath9k_hw_setmac(ah, sc->sc_ah->macaddr);
 
 	/* calculate and install multicast filter */
 	mfilt[0] = mfilt[1] = ~0;
-- 
1.6.1

