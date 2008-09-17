Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:51378 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbYIQAdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 20:33:01 -0400
Date: Wed, 17 Sep 2008 03:33:19 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	tbm@cyrius.com
Subject: [PATCH] ath5k: Fix bad udelay calls on AR5210 code
Message-ID: <20080917003319.GA928@makis> (sfid-20080917_023317_705941_792205E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Fix bad udelay calls (using > 2000us) in AR5210 code and clean up 
 some bits on nic_reset (AR5210 support is still in bad shape)

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 1ea8ed9..e43f656 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -2124,7 +2124,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
 	ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
 
-	udelay(2300);
+	mdelay(2);
 
 	/*
 	 * Set the channel (with AGC turned off)
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index a988323..410f99a 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -820,8 +820,6 @@
 #define AR5K_RESET_CTL_MAC	0x00000004	/* MAC reset (PCU+Baseband ?) [5210] */
 #define AR5K_RESET_CTL_PHY	0x00000008	/* PHY reset [5210] */
 #define AR5K_RESET_CTL_PCI	0x00000010	/* PCI Core reset (interrupts etc) */
-#define AR5K_RESET_CTL_CHIP	(AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_DMA |	\
-				AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_PHY)
 
 /*
  * Sleep control register
diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index f5c3de8..953ba3b 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -173,8 +173,10 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 	udelay(15);
 
 	if (ah->ah_version == AR5K_AR5210) {
-		val &= AR5K_RESET_CTL_CHIP;
-		mask &= AR5K_RESET_CTL_CHIP;
+		val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_DMA
+			| AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_PHY;
+		mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_DMA
+			| AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_PHY;
 	} else {
 		val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
 		mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
@@ -361,16 +363,20 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
 
 	/* Reset chipset */
-	ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
-		AR5K_RESET_CTL_BASEBAND | bus_flags);
+	if (ah->ah_version == AR5K_AR5210) {
+		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
+			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
+			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
+			mdelay(2);
+	} else {
+		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
+			AR5K_RESET_CTL_BASEBAND | bus_flags);
+	}
 	if (ret) {
 		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip\n");
 		return -EIO;
 	}
 
-	if (ah->ah_version == AR5K_AR5210)
-		udelay(2300);
-
 	/* ...wakeup again!*/
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
