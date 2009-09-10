Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/10] ath5k: use common curbssid, bssidmask and macaddr
Date: Thu, 10 Sep 2009 15:30:23 -0400
Message-Id: <1252611027-5285-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ah_sta_id was really being used as the macaddr.
ath5k still does not use the association ID now passed
up by mac80211, that can be fixed later.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    9 -------
 drivers/net/wireless/ath/ath5k/attach.c |    7 ++++-
 drivers/net/wireless/ath/ath5k/base.c   |    8 ++++--
 drivers/net/wireless/ath/ath5k/pcu.c    |   38 ++++++++----------------------
 drivers/net/wireless/ath/ath5k/reset.c  |   13 ++++++----
 5 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 93a9c1f..f46a92e 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1060,14 +1060,6 @@ struct ath5k_hw {
 	u8			ah_def_ant;
 	bool			ah_software_retry;
 
-	u8			ah_sta_id[ETH_ALEN];
-
-	/* Current BSSID we are trying to assoc to / create.
-	 * This is passed by mac80211 on config_interface() and cached here for
-	 * use in resets */
-	u8			ah_bssid[ETH_ALEN];
-	u8			ah_bssid_mask[ETH_ALEN];
-
 	int			ah_gpio_npins;
 
 	struct ath5k_capabilities ah_capabilities;
@@ -1196,7 +1188,6 @@ extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
 /* Protocol Control Unit Functions */
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
 /* BSSID Functions */
-extern void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac);
 extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
 extern void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id);
 extern int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 9a009a7..2d262c7 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -104,6 +104,7 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah;
+	struct ath_common *common;
 	struct pci_dev *pdev = sc->pdev;
 	struct ath5k_eeprom_info *ee;
 	int ret;
@@ -118,7 +119,9 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 	}
 
 	ah->ah_sc = sc;
+	ah->ah_sc->ah = ah;
 	ah->ah_iobase = sc->iobase;
+	common = ath5k_hw_common(ah);
 
 	/*
 	 * HW information
@@ -336,8 +339,8 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 	ath5k_hw_set_lladdr(ah, (u8[ETH_ALEN]){});
 
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memcpy(ah->ah_bssid, ath_bcast_mac, ETH_ALEN);
-	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+	memcpy(common->curbssid, ath_bcast_mac, ETH_ALEN);
+	ath5k_hw_set_associd(ah, common->curbssid, 0);
 	ath5k_hw_set_opmode(ah);
 
 	ath5k_hw_rfgain_opt_init(ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a28d795..efee68c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1685,13 +1685,14 @@ static void
 ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 		     struct ieee80211_rx_status *rxs)
 {
+	struct ath_common *common = ath5k_hw_common(sc->ah);
 	u64 tsf, bc_tstamp;
 	u32 hw_tu;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
 	if (ieee80211_is_beacon(mgmt->frame_control) &&
 	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
-	    memcmp(mgmt->bssid, sc->ah->ah_bssid, ETH_ALEN) == 0) {
+	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) == 0) {
 		/*
 		 * Received an IBSS beacon with the same BSSID. Hardware *must*
 		 * have updated the local TSF. We have to work around various
@@ -3177,6 +3178,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	unsigned long flags;
 
 	mutex_lock(&sc->lock);
@@ -3185,10 +3187,10 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_BSSID) {
 		/* Cache for later use during resets */
-		memcpy(ah->ah_bssid, bss_conf->bssid, ETH_ALEN);
+		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
 		 * a clean way of letting us retrieve this yet. */
-		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+		ath5k_hw_set_associd(ah, common->curbssid, 0);
 		mmiowb();
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 7bbcfe4..f03c06d 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -46,6 +46,7 @@
  */
 int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 {
+	struct ath_common *common = ath5k_hw_common(ah);
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
 
@@ -97,8 +98,8 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 	/*
 	 * Set PCU registers
 	 */
-	low_id = get_unaligned_le32(ah->ah_sta_id);
-	high_id = get_unaligned_le16(ah->ah_sta_id + 4);
+	low_id = get_unaligned_le32(common->macaddr);
+	high_id = get_unaligned_le16(common->macaddr + 4);
 	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
 	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
 
@@ -240,28 +241,6 @@ int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 	return 0;
 }
 
-
-/****************\
-* BSSID handling *
-\****************/
-
-/**
- * ath5k_hw_get_lladdr - Get station id
- *
- * @ah: The &struct ath5k_hw
- * @mac: The card's mac address
- *
- * Initialize ah->ah_sta_id using the mac address provided
- * (just a memcpy).
- *
- * TODO: Remove it once we merge ath5k_softc and ath5k_hw
- */
-void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	memcpy(mac, ah->ah_sta_id, ETH_ALEN);
-}
-
 /**
  * ath5k_hw_set_lladdr - Set station id
  *
@@ -272,12 +251,13 @@ void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
  */
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
+	struct ath_common *common = ath5k_hw_common(ah);
 	u32 low_id, high_id;
 	u32 pcu_reg;
 
 	ATH5K_TRACE(ah->ah_sc);
 	/* Set new station ID */
-	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
+	memcpy(common->macaddr, mac, ETH_ALEN);
 
 	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
 
@@ -301,6 +281,7 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
  */
 void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 {
+	struct ath_common *common = ath5k_hw_common(ah);
 	u32 low_id, high_id;
 	u16 tim_offset = 0;
 
@@ -308,10 +289,10 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 * Set simple BSSID mask on 5212
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, get_unaligned_le32(ah->ah_bssid_mask),
+		ath5k_hw_reg_write(ah, get_unaligned_le32(common->bssidmask),
 							AR5K_BSS_IDM0);
 		ath5k_hw_reg_write(ah,
-				   get_unaligned_le16(ah->ah_bssid_mask + 4),
+				   get_unaligned_le16(common->curbssid + 4),
 				   AR5K_BSS_IDM1);
 	}
 
@@ -433,12 +414,13 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
  */
 int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 {
+	struct ath_common *common = ath5k_hw_common(ah);
 	u32 low_id, high_id;
 	ATH5K_TRACE(ah->ah_sc);
 
 	/* Cache bssid mask so that we can restore it
 	 * on reset */
-	memcpy(ah->ah_bssid_mask, mask, ETH_ALEN);
+	memcpy(common->bssidmask, mask, ETH_ALEN);
 	if (ah->ah_version == AR5K_AR5212) {
 		low_id = get_unaligned_le32(mask);
 		high_id = get_unaligned_le16(mask + 4);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 3454dac..51aff76 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -872,6 +872,7 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
+	struct ath_common *common = ath5k_hw_common(ah);
 	u32 s_seq[10], s_ant, s_led[3], staid1_flags, tsf_up, tsf_lo;
 	u32 phy_tst1;
 	u8 mode, freq, ee_mode, ant[2];
@@ -1173,10 +1174,12 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	ath5k_hw_reg_write(ah, s_led[2], AR5K_GPIODO);
 
 	/* Restore sta_id flags and preserve our mac address*/
-	ath5k_hw_reg_write(ah, get_unaligned_le32(ah->ah_sta_id),
-						AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, staid1_flags | get_unaligned_le16(ah->ah_sta_id),
-						AR5K_STA_ID1);
+	ath5k_hw_reg_write(ah,
+			   get_unaligned_le32(common->macaddr),
+			   AR5K_STA_ID0);
+	ath5k_hw_reg_write(ah,
+			   staid1_flags | get_unaligned_le16(common->macaddr),
+			   AR5K_STA_ID1);
 
 
 	/*
@@ -1185,7 +1188,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 	/* Restore bssid and bssid mask */
 	/* XXX: add ah->aid once mac80211 gives this to us */
-	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+	ath5k_hw_set_associd(ah, common->curbssid, 0);
 
 	/* Set PCU config */
 	ath5k_hw_set_opmode(ah);
-- 
1.6.3.3

