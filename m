Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:56617 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2BNCrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 21:47:48 -0500
Received: by qafk1 with SMTP id k1so18622qaf.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 18:47:48 -0800 (PST)
Message-ID: <4F39CB51.8080904@gmail.com> (sfid-20120214_034752_183461_542F0926)
Date: Mon, 13 Feb 2012 21:47:45 -0500
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k:Remove __raw_read and __raw_write
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,
This is my first patch submission so hopefully everything goes well. :-)
By swithing from our __raw_read and __raw_write functions to ioread32 and iowrite32,
benchmarks on my desk with iperf went from 11MBps to 18.1MBps using the AHB bus
on an EnGenius ECB3500 running OpenWRT.

Signed-off-by: Jonathan Bither <jonbither@gmail.com>


--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1656,12 +1656,12 @@
 
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
-	return __raw_readl(ath5k_ahb_reg(ah, reg));
+	return ioread32(ath5k_ahb_reg(ah, reg));
 }
 
 static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 {
-	__raw_writel(val, ath5k_ahb_reg(ah, reg));
+	iowrite32(val, ath5k_ahb_reg(ah, reg));
 }
 
 #else

--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -140,23 +140,23 @@
 
 	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
 		/* Enable WMAC AHB arbitration */
-		reg = __raw_readl((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		reg = ioread32((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
 		reg |= AR5K_AR2315_AHB_ARB_CTL_WLAN;
-		__raw_writel(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		iowrite32(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
 
 		/* Enable global WMAC swapping */
-		reg = __raw_readl((void __iomem *) AR5K_AR2315_BYTESWAP);
+		reg = ioread32((void __iomem *) AR5K_AR2315_BYTESWAP);
 		reg |= AR5K_AR2315_BYTESWAP_WMAC;
-		__raw_writel(reg, (void __iomem *) AR5K_AR2315_BYTESWAP);
+		iowrite32(reg, (void __iomem *) AR5K_AR2315_BYTESWAP);
 	} else {
 		/* Enable WMAC DMA access (assuming 5312 or 231x*/
 		/* TODO: check other platforms */
-		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
+		reg = ioread32((void __iomem *) AR5K_AR5312_ENABLE);
 		if (to_platform_device(ah->dev)->id == 0)
 			reg |= AR5K_AR5312_ENABLE_WLAN0;
 		else
 			reg |= AR5K_AR5312_ENABLE_WLAN1;
-		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+		iowrite32(reg, (void __iomem *) AR5K_AR5312_ENABLE);
 
 		/*
 		 * On a dual-band AR5312, the multiband radio is only
@@ -203,17 +203,17 @@
 
 	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
 		/* Disable WMAC AHB arbitration */
-		reg = __raw_readl((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		reg = ioread32((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
 		reg &= ~AR5K_AR2315_AHB_ARB_CTL_WLAN;
-		__raw_writel(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		iowrite32(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
 	} else {
 		/*Stop DMA access */
-		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
+		reg = ioread32((void __iomem *) AR5K_AR5312_ENABLE);
 		if (to_platform_device(ah->dev)->id == 0)
 			reg &= ~AR5K_AR5312_ENABLE_WLAN0;
 		else
 			reg &= ~AR5K_AR5312_ENABLE_WLAN1;
-		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+		iowrite32(reg, (void __iomem *) AR5K_AR5312_ENABLE);
 	}
 
 	ath5k_deinit_ah(ah);

--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -473,14 +473,14 @@
 	}
 
 	/* Put BB/MAC into reset */
-	regval = __raw_readl(reg);
-	__raw_writel(regval | val, reg);
-	regval = __raw_readl(reg);
+	regval = ioread32(reg);
+	iowrite32(regval | val, reg);
+	regval = ioread32(reg);
 	usleep_range(100, 150);
 
 	/* Bring BB/MAC out of reset */
-	__raw_writel(regval & ~val, reg);
-	regval = __raw_readl(reg);
+	iowrite32(regval & ~val, reg);
+	regval = ioread32(reg);
 
 	/*
 	 * Reset configuration register (for hw byte-swap). Note that this
