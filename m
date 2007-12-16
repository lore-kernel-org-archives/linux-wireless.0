Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:44948 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbXLPBBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 20:01:04 -0500
Date: Sun, 16 Dec 2007 03:01:04 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 5/9] ath5k: Reorder reset function to match regdumps
Message-ID: <20071216010104.GE5482@makis.domain.invalid> (sfid-20071216_010107_935281_B0550F80)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Modify reset function to match regdumps, we still have some things to fix.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 72d0432..ed311ae 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -683,7 +683,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	}
 
-	ath5k_hw_write_initvals(ah, mode, change_channel);
+	ret = ath5k_hw_write_initvals(ah, mode, change_channel);
+	if (ret)
+		return ret;
 
 	/*
 	 * 5211/5212 Specific
@@ -699,8 +701,23 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 		mdelay(1);
 
-		if (ah->ah_version == AR5K_AR5212)
-			ath5k_hw_write_rate_duration(ah, driver_mode);
+		/*
+		 * Write some more initial register settings
+		 */
+		if (ah->ah_version > AR5K_AR5211){ /* found on 5213+ */
+			ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
+
+			if (channel->val == CHANNEL_G)
+				ath5k_hw_reg_write(ah, 0x00f80d80, AR5K_PHY(83)); /* 0x00fc0ec0 */
+			else
+				ath5k_hw_reg_write(ah, 0x00000000, AR5K_PHY(83));
+
+			ath5k_hw_reg_write(ah, 0x000001b5, 0xa228); /* 0x000009b5 */
+			ath5k_hw_reg_write(ah, 0x000009b5, 0xa228);
+			ath5k_hw_reg_write(ah, 0x0000000f, 0x8060);
+			ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
+			ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
+		}
 
 		/* Fix for first revision of the RF5112 RF chipset */
 		if (ah->ah_radio >= AR5K_RF5112 &&
@@ -716,12 +733,16 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		}
 
 		/*
-		 * Set TX power (XXX use txpower from net80211)
+		 * Set TX power (FIXME)
 		 */
 		ret = ath5k_hw_txpower(ah, channel, AR5K_TUNE_DEFAULT_TXPOWER);
 		if (ret)
 			return ret;
 
+		/* Write rate duration table */
+		if (ah->ah_version == AR5K_AR5212)
+			ath5k_hw_write_rate_duration(ah, driver_mode);
+
 		/*
 		 * Write RF registers
 		 * TODO:Does this work on 5211 (5111) ?
@@ -754,6 +775,17 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		}
 
 		/*
+		 * Set channel and calibrate the PHY
+		 */
+		ret = ath5k_hw_channel(ah, channel);
+		if (ret)
+			return ret;
+
+		/* Set antenna mode */
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x44),
+			ah->ah_antenna[ee_mode][0], 0xfffffc06);
+
+		/*
 		 * In case a fixed antenna was set as default
 		 * write the same settings on both AR5K_PHY_ANT_SWITCH_TABLE
 		 * registers.
@@ -862,13 +894,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	}
 
 	/*
-	 * Set channel and calibrate the PHY
-	 */
-	ret = ath5k_hw_channel(ah, channel);
-	if (ret)
-		return ret;
-
-	/*
 	 * Enable the PHY and wait until completion
 	 */
 	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);



