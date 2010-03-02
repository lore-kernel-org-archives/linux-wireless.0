Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:12713 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753418Ab0CBH6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:58:33 -0500
Received: from vs30m.wh2.ocn.ne.jp (125.206.180.150)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0682556712
	for <linux-wireless@vger.kernel.org>; Tue,  2 Mar 2010 16:58:32 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 1/4] ath5k: remove double opmode definition
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 02 Mar 2010 16:58:31 +0900
Message-ID: <20100302075831.20555.99308.stgit@void>
In-Reply-To: <20100302075526.20555.14622.stgit@void>
References: <20100302075526.20555.14622.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

opmode (operating mode) was defined in struct ath5k_hw and struct ath5k_softc.
remove it from ath5k_hw and use only from ath5k_softc (sc->opmode).

(btw: what's the meaning of opmode when we have multiple interfaces?)

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/ath/ath5k/ath5k.h  |    3 +--
 drivers/net/wireless/ath/ath5k/attach.c |    3 +--
 drivers/net/wireless/ath/ath5k/base.c   |    7 ++++---
 drivers/net/wireless/ath/ath5k/pcu.c    |   14 +++++++-------
 drivers/net/wireless/ath/ath5k/reset.c  |    9 ++-------
 5 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ac67f02..cb79d44 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1036,7 +1036,6 @@ struct ath5k_hw {
 
 	enum ath5k_int		ah_imr;
 
-	enum nl80211_iftype	ah_op_mode;
 	struct ieee80211_channel *ah_current_channel;
 	bool			ah_turbo;
 	bool			ah_calibration;
@@ -1199,7 +1198,7 @@ extern int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
 
 /* Protocol Control Unit Functions */
-extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
+extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
 extern void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
 /* BSSID Functions */
 extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index c8bb102..66758cb 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -113,7 +113,6 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	/*
 	 * HW information
 	 */
-	ah->ah_op_mode = NL80211_IFTYPE_STATION;
 	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
 	ah->ah_turbo = false;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
@@ -328,7 +327,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
 	memcpy(common->curbssid, ath_bcast_mac, ETH_ALEN);
 	ath5k_hw_set_associd(ah);
-	ath5k_hw_set_opmode(ah);
+	ath5k_hw_set_opmode(ah, sc->opmode);
 
 	ath5k_hw_rfgain_opt_init(ah);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ced13fd..cb13f87 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1137,8 +1137,6 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	struct ath5k_hw *ah = sc->ah;
 	u32 rfilt;
 
-	ah->ah_op_mode = sc->opmode;
-
 	/* configure rx filter */
 	rfilt = sc->filter_flags;
 	ath5k_hw_set_rx_filter(ah, rfilt);
@@ -1147,8 +1145,9 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 		ath5k_hw_set_bssid_mask(ah, sc->bssidmask);
 
 	/* configure operational mode */
-	ath5k_hw_set_opmode(ah);
+	ath5k_hw_set_opmode(ah, sc->opmode);
 
+	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d\n", sc->opmode);
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
@@ -2855,6 +2854,8 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 		goto end;
 	}
 
+	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "add interface mode %d\n", sc->opmode);
+
 	ath5k_hw_set_lladdr(sc->ah, vif->addr);
 	ath5k_mode_setup(sc);
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index aefe84f..b597b99 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -39,16 +39,16 @@
  * ath5k_hw_set_opmode - Set PCU operating mode
  *
  * @ah: The &struct ath5k_hw
+ * @op_mode: &enum nl80211_iftype operating mode
  *
  * Initialize PCU for the various operating modes (AP/STA etc)
- *
- * NOTE: ah->ah_op_mode must be set before calling this.
  */
-int ath5k_hw_set_opmode(struct ath5k_hw *ah)
+int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
+	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_MODE, "mode %d\n", op_mode);
 
 	/* Preserve rest settings */
 	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
@@ -61,7 +61,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 
 	ATH5K_TRACE(ah->ah_sc);
 
-	switch (ah->ah_op_mode) {
+	switch (op_mode) {
 	case NL80211_IFTYPE_ADHOC:
 		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_KEYSRCH_MODE;
 		beacon_reg |= AR5K_BCR_ADHOC;
@@ -651,7 +651,7 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	/*
 	 * Set the additional timers by mode
 	 */
-	switch (ah->ah_op_mode) {
+	switch (ah->ah_sc->opmode) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_STATION:
 		/* In STA mode timer1 is used as next wakeup
@@ -688,8 +688,8 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	 * Set the beacon register and enable all timers.
 	 */
 	/* When in AP or Mesh Point mode zero timer0 to start TSF */
-	if (ah->ah_op_mode == NL80211_IFTYPE_AP ||
-	    ah->ah_op_mode == NL80211_IFTYPE_MESH_POINT)
+	if (ah->ah_sc->opmode == NL80211_IFTYPE_AP ||
+	    ah->ah_sc->opmode == NL80211_IFTYPE_MESH_POINT)
 		ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
 
 	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index c780b55..6d9a1e8 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1014,11 +1014,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	if (ret)
 		return ret;
 
-	/*
-	 * Initialize operating mode
-	 */
-	ah->ah_op_mode = op_mode;
-
 	/* PHY access enable */
 	if (ah->ah_mac_srev >= AR5K_SREV_AR5211)
 		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
@@ -1189,7 +1184,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	ath5k_hw_set_associd(ah);
 
 	/* Set PCU config */
-	ath5k_hw_set_opmode(ah);
+	ath5k_hw_set_opmode(ah, op_mode);
 
 	/* Clear any pending interrupts
 	 * PISR/SISR Not available on 5210 */
@@ -1375,7 +1370,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * external 32KHz crystal when sleeping if one
 	 * exists */
 	if (ah->ah_version == AR5K_AR5212 &&
-	    ah->ah_op_mode != NL80211_IFTYPE_AP)
+	    op_mode != NL80211_IFTYPE_AP)
 		ath5k_hw_set_sleep_clock(ah, true);
 
 	/*

