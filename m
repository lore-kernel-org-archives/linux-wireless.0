Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34320 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYBXEVb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 23:21:31 -0500
Date: Sun, 24 Feb 2008 06:21:15 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 4/8] ath5k: more RF2413 stuff
Message-ID: <20080224042115.GC4426@makis.domain.invalid> (sfid-20080224_042135_441103_9AFCD59B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add AR5K_RF2413 to radio check during hw_reset so it doesn't complain

 * Write ah_phy_spending value we set during attach instead of checking 
each time for radio revision

 * Skip txpower setup for RF2413 because it can't transmit with it 
(weird thing is that RF5413 has no problem with it).


Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 1d7bc1f..3ae5522 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -640,7 +640,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	if (ah->ah_version != AR5K_AR5210) {
 		if (ah->ah_radio != AR5K_RF5111 &&
 			ah->ah_radio != AR5K_RF5112 &&
-			ah->ah_radio != AR5K_RF5413) {
+			ah->ah_radio != AR5K_RF5413 &&
+			ah->ah_radio != AR5K_RF2413) {
 			ATH5K_ERR(ah->ah_sc,
 				"invalid phy radio: %u\n", ah->ah_radio);
 			return -EINVAL;
@@ -1002,9 +1003,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-		ath5k_hw_reg_write(ah, ah->ah_radio == AR5K_RF5111 ?
-			AR5K_PHY_SPENDING_RF5111 : AR5K_PHY_SPENDING_RF5112,
-			AR5K_PHY_SPENDING);
+		ath5k_hw_reg_write(ah, ah->ah_phy_spending, AR5K_PHY_SPENDING);
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index e8378d1..75ded08 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -2177,6 +2177,15 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		return -EINVAL;
 	}
 
+	/* 
+	 * RF2413 for some reason can't
+	 * transmit anything if we call
+	 * this funtion, so we skip it
+	 * until we fix txpower.
+	 */
+	if(ah->ah_radio == AR5K_RF2413)
+		return 0;
+
 	/* Reset TX power values */
 	memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
 	ah->ah_txpower.txp_tpc = tpc;


