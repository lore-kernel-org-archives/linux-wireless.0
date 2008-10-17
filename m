Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:23643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYJQTQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 15:16:04 -0400
Received: by rv-out-0506.google.com with SMTP id k40so710592rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:16:03 -0700 (PDT)
Message-ID: <48F8E470.8000103@gmail.com> (sfid-20081017_211613_016433_4020F041)
Date: Fri, 17 Oct 2008 12:16:00 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@gmail.com
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: reduce checkpatch.pl errors
Content-Type: multipart/mixed;
 boundary="------------040606050505000705070402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040606050505000705070402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A few changes to reduce checkpatch.pl errors in the ath5k driver.  For 
the most part, I only fixed cosmetic things, and left the actual 'code 
flow' untouched (hopefully)!

Diff is against wireless-testing HEAD.

Signed-off-by: John Daiker <daikerjohn@gmail.com>

---



--------------040606050505000705070402
Content-Type: text/x-diff;
 name="ath5k.checkpatch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ath5k.checkpatch.diff"

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1a24a22..e5888af 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2521,8 +2521,7 @@ ath5k_register_led(struct ath5k_softc *sc, struct ath5k_led *led,
 	led->led_dev.brightness_set = ath5k_led_brightness_set;
 
 	err = led_classdev_register(&sc->pdev->dev, &led->led_dev);
-	if (err)
-	{
+	if (err) {
 		ATH5K_WARN(sc, "could not register LED %s\n", name);
 		led->sc = NULL;
 	}
@@ -2882,9 +2881,9 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		if (*new_flags & FIF_PROMISC_IN_BSS) {
 			rfilt |= AR5K_RX_FILTER_PROM;
 			__set_bit(ATH_STAT_PROMISC, sc->status);
-		}
-		else
+		} else {
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
+		}
 	}
 
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
@@ -2947,7 +2946,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 	}
 
 	/* Set filters */
-	ath5k_hw_set_rx_filter(ah,rfilt);
+	ath5k_hw_set_rx_filter(ah, rfilt);
 
 	/* Set multicast bits */
 	ath5k_hw_set_mcast_filter(ah, mfilt[0], mfilt[1]);
@@ -2964,7 +2963,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct ath5k_softc *sc = hw->priv;
 	int ret = 0;
 
-	switch(key->alg) {
+	switch (key->alg) {
 	case ALG_WEP:
 	/* XXX: fix hardware encryption, its not working. For now
 	 * allow software encryption */
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index ea2e1a2..f9c31d8 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1679,7 +1679,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 	 */
 
 	/* For AR5212 and combatible */
-	if (ah->ah_version == AR5K_AR5212){
+	if (ah->ah_version == AR5K_AR5212) {
 
 		/* First set of mode-specific settings */
 		ath5k_hw_ini_mode_registers(ah,
@@ -1693,7 +1693,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					ar5212_ini, change_channel);
 
 		/* Second set of mode-specific settings */
-		if (ah->ah_radio == AR5K_RF5111){
+		if (ah->ah_radio == AR5K_RF5111) {
 
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5111_ini_mode_end),
@@ -1704,7 +1704,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					ARRAY_SIZE(rf5111_ini_bbgain),
 					rf5111_ini_bbgain, change_channel);
 
-		} else if (ah->ah_radio == AR5K_RF5112){
+		} else if (ah->ah_radio == AR5K_RF5112) {
 
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5112_ini_mode_end),
@@ -1714,7 +1714,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
 
-		} else if (ah->ah_radio == AR5K_RF5413){
+		} else if (ah->ah_radio == AR5K_RF5413) {
 
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(rf5413_ini_mode_end),
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index e43f656..69625bf 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1412,7 +1412,8 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 		rf_ini = rfregs_2112a;
 		rf_size = ARRAY_SIZE(rfregs_5112a);
 		if (mode < 2) {
-			ATH5K_ERR(ah->ah_sc,"invalid channel mode: %i\n",mode);
+			ATH5K_ERR(ah->ah_sc, "invalid channel mode: %i\n",
+				  mode);
 			return -EINVAL;
 		}
 		mode = mode - 2; /*no a/turboa modes for 2112*/
@@ -1708,7 +1709,7 @@ enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah)
 		if (ah->ah_radio >= AR5K_RF5112) {
 			ath5k_hw_rfregs_gainf_corr(ah);
 			ah->ah_gain.g_current =
-				ah->ah_gain.g_current>=ah->ah_gain.g_f_corr ?
+				ah->ah_gain.g_current >= ah->ah_gain.g_f_corr ?
 				(ah->ah_gain.g_current-ah->ah_gain.g_f_corr) :
 				0;
 		}

--------------040606050505000705070402--
