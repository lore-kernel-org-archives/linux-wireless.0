Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:47032 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbXLPAxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 19:53:17 -0500
Date: Sun, 16 Dec 2007 02:53:18 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 2/9] ath5k: Fix nic_wakeup for 5210
Message-ID: <20071216005318.GB5482@makis.domain.invalid> (sfid-20071216_005320_975551_85D6C557)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reset PCI after chip reset for 5210 at nic_wakeup. This fixes the system hang during 5210 attach.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 83fd241..aea9589 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -294,6 +294,13 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 	ATH5K_TRACE(ah->ah_sc);
 
+	/* Wakeup the device */
+	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+	if (ret) {
+		ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
+		return ret;
+	}
+
 	if (ah->ah_version != AR5K_AR5210) {
 		/*
 		 * Get channel mode flags
@@ -319,7 +326,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 				 * CCK headers) operation. We need to test
 				 * this, 5211 might support ofdm-only g after
 				 * all, there are also initial register values
-				 * in the code for g mode (see ath5k_hw.h). */
+				 * in the code for g mode (see initvals.c). */
 				if (ah->ah_version == AR5K_AR5211)
 					mode |= AR5K_PHY_MODE_MOD_OFDM;
 				else
@@ -347,38 +354,12 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 		if (flags & CHANNEL_TURBO)
 			turbo = AR5K_PHY_TURBO_MODE | AR5K_PHY_TURBO_SHORT;
-	} else { /* Reset and wakeup the device */
-		if (initial == true) {
-			/* ...reset hardware */
-			if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCI)) {
-				ATH5K_ERR(ah->ah_sc,
-					"failed to reset the PCI chipset\n");
-				return -EIO;
-			}
-
-			mdelay(1);
-		}
-
-		/* ...wakeup */
-		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
-		if (ret) {
-			ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
-			return ret;
-		}
+	} else { /* Reset the device */
 
 		/* ...enable Atheros turbo mode if requested */
 		if (flags & CHANNEL_TURBO)
 			ath5k_hw_reg_write(ah, AR5K_PHY_TURBO_MODE,
 					AR5K_PHY_TURBO);
-
-		/* ...reset chipset */
-		if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_CHIP)) {
-			ATH5K_ERR(ah->ah_sc,
-				"failed to reset the AR5210 chipset\n");
-			return -EIO;
-		}
-
-		mdelay(1);
 	}
 
 	/* ...reset chipset and PCI device */
@@ -391,7 +372,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	if (ah->ah_version == AR5K_AR5210)
 		udelay(2300);
 
-	/* ...wakeup */
+	/* ...wakeup again!*/
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
 		ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");



