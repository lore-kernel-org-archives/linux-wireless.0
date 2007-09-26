Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:41103 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbXIZSDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 14:03:45 -0400
Message-id: <184631970443030034@pripojeni.net>
In-reply-to: <22584316032010514103@pripojeni.net>
Subject: [PATCH 4/4 try 4] Net: ath5k, remove unused/dead code
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <mcgrof@gmail.com>
Date: Wed, 26 Sep 2007 14:03:45 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k, remove unused/dead code

Remove ifdeffed code, which is currently (and might not be in the future too)
unused. If it was ever really needed, it could be easily ported back from the
madwifi-old-openhal repository.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>

---
commit ec6042026ddc40bf55846c3b3a19a78ff57eda30
tree 3f620c10b52e10204fc08cf042c73795fc8fe027
parent f8eb6398d305c122ed72887a13625c2e7a992981
author Jiri Slaby <jirislaby@gmail.com> Tue, 25 Sep 2007 09:51:21 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 25 Sep 2007 09:51:21 +0200

 drivers/net/wireless/ath5k/hw.c |   71 ---------------------------------------
 1 files changed, 0 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index f74f0ca..3a865cc 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -1140,19 +1140,6 @@ commit:
 	return 0;
 }
 
-#if 0
-/*
- * Get power mode (sleep state)
- * TODO:Remove ?
- */
-enum ath5k_power_mode
-ath5k_hw_get_power_mode(struct ath_hw *hal)
-{
-	AR5K_TRACE;
-	return hal->ah_power_mode;
-}
-#endif
-
 /***********************\
   DMA Related Functions
 \***********************/
@@ -1580,52 +1567,6 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 	return old_mask;
 }
 
-#if 0
-/*
- * Enable HW radar detection
- */
-void
-ath5k_hw_radar_alert(struct ath_hw *hal, bool enable)
-{
-
-	AR5K_TRACE;
-	/*
-	 * Enable radar detection
-	 */
-
-	/*Disable interupts*/
-	ath5k_hw_reg_write(hal, AR5K_IER_DISABLE, AR5K_IER);
-
-	/*
-	 * Set the RXPHY interrupt to be able to detect
-	 * possible radar activity.
-	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		if (enable == true)
-			AR5K_REG_ENABLE_BITS(hal, AR5K_IMR, AR5K_IMR_RXPHY);
-		else
-			AR5K_REG_DISABLE_BITS(hal, AR5K_IMR, AR5K_IMR_RXPHY);
-	} else {
-		/*Also set AR5K_PHY_RADAR register on 5111/5112*/
-		if (enable == true) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_RADAR_ENABLE,
-				AR5K_PHY_RADAR);
-			AR5K_REG_ENABLE_BITS(hal, AR5K_PIMR,
-				AR5K_IMR_RXPHY);
-		} else {
-			ath5k_hw_reg_write(hal, AR5K_PHY_RADAR_DISABLE,
-				AR5K_PHY_RADAR);
-			AR5K_REG_DISABLE_BITS(hal, AR5K_PIMR,
-				AR5K_IMR_RXPHY);
-		}
-	}
-
-	/*Re-enable interrupts*/
-	ath5k_hw_reg_write(hal, AR5K_IER_ENABLE, AR5K_IER);
-}
-#endif
-
-
 
 /*************************\
   EEPROM access functions
@@ -4344,18 +4285,6 @@ yes:
 	return 0;
 }
 
-#if 0
-static bool ath5k_hw_query_pspoll_support(struct ath_hw *hal)
-{
-	AR5K_TRACE;
-
-	if (hal->ah_version == AR5K_AR5210)
-		return true;
-
-	return false;
-}
-#endif
-
 static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
 		u16 assoc_id)
 {
