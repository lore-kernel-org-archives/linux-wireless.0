Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:59589 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbXLPAzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 19:55:51 -0500
Date: Sun, 16 Dec 2007 02:55:52 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 3/9] ath5k: Fix diversity
Message-ID: <20071216005552.GC5482@makis.domain.invalid> (sfid-20071216_005553_798188_969514FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Fix diversity support

We have to write all antenna information on AR5K_PHY_ANT_SWITCH_TABLE if antenna mode is not fixed.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index aea9589..8357cac 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -578,7 +578,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	ATH5K_TRACE(ah->ah_sc);
 
 	s_seq = 0;
-	s_ant = 1;
+	s_ant = 0;
 	ee_mode = 0;
 	freq = 0;
 	mode = 0;
@@ -753,14 +753,20 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 				    AR5K_TXCFG_B_MODE);
 		}
 
-		/* Set antenna mode */
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x44),
-			ah->ah_antenna[ee_mode][0], 0xfffffc06);
-
-		if (freq == AR5K_INI_RFGAIN_2GHZ)
-			ant[0] = ant[1] = AR5K_ANT_FIXED_B;
-		else
-			ant[0] = ant[1] = AR5K_ANT_FIXED_A;
+		/*
+		 * In case a fixed antenna was set as default
+		 * write the same settings on both AR5K_PHY_ANT_SWITCH_TABLE
+		 * registers.
+		 */
+		if (s_ant != 0){
+			if (s_ant == AR5K_ANT_FIXED_A) /* 1 - Main */
+				ant[0] = ant[1] = AR5K_ANT_FIXED_A;
+			else	/* 2 - Aux */
+				ant[0] = ant[1] = AR5K_ANT_FIXED_B;
+		} else {
+			ant[0] = AR5K_ANT_FIXED_A;
+			ant[1] = AR5K_ANT_FIXED_B;
+		}
 
 		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[0]],
 			AR5K_PHY_ANT_SWITCH_TABLE_0);



