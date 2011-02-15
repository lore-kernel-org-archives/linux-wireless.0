Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab1BOTMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:12:19 -0500
Received: by bwz15 with SMTP id 15so772120bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 11:12:17 -0800 (PST)
Date: Tue, 15 Feb 2011 22:09:29 +0300
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com, jirislaby@gmail.com
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
Message-Id: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes seqfault on ar2316 and other AHB based chips.

Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 707cde1..35d5273 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -34,7 +34,7 @@ static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
 bool ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath5k_softc *sc = common->priv;
-	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct platform_device *pdev = to_platform_device(wiphy_dev(sc->hw->wiphy));
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	u16 *eeprom, *eeprom_end;
 
@@ -55,7 +55,7 @@ bool ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 int ath5k_hw_read_srev(struct ath5k_hw *ah)
 {
 	struct ath5k_softc *sc = ah->ah_sc;
-	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct platform_device *pdev = to_platform_device(wiphy_dev(sc->hw->wiphy));
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	ah->ah_mac_srev = bcfg->devid;
 	return 0;
@@ -92,7 +92,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	mem = ioremap_nocache(res->start, res->end - res->start + 1);
+	mem = res->start;
 	if (mem == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENOMEM;
@@ -114,10 +114,11 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_out;
 	}
+	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	sc = hw->priv;
 	sc->hw = hw;
-	sc->dev = &pdev->dev;
+	sc->dev = NULL;
 	sc->iobase = mem;
 	sc->irq = irq;
 	sc->devid = bcfg->devid;
@@ -136,7 +137,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		/* Enable WMAC DMA access (assuming 5312 or 231x*/
 		/* TODO: check other platforms */
 		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
-		if (to_platform_device(sc->dev)->id == 0)
+		if (to_platform_device(wiphy_dev(sc->hw->wiphy))->id == 0)
 			reg |= AR5K_AR5312_ENABLE_WLAN0;
 		else
 			reg |= AR5K_AR5312_ENABLE_WLAN1;
@@ -181,7 +182,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	} else {
 		/*Stop DMA access */
 		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
-		if (to_platform_device(sc->dev)->id == 0)
+		if (to_platform_device(wiphy_dev(sc->hw->wiphy))->id == 0)
 			reg &= ~AR5K_AR5312_ENABLE_WLAN0;
 		else
 			reg &= ~AR5K_AR5312_ENABLE_WLAN1;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 09ae4ef..8633762 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2343,7 +2343,6 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	int csz;
 
 	/* Initialize driver private data */
-	SET_IEEE80211_DEV(hw, sc->dev);
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 			IEEE80211_HW_SIGNAL_DBM |
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 7f8c5b0..7fb1eaf 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -216,6 +216,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		ret = -ENOMEM;
 		goto err_map;
 	}
+	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 8420689..2430dfb 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -383,7 +383,7 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 			val |= AR5K_AR2315_RESET_BB_WARM;
 	} else {
 		reg = (u32 *) AR5K_AR5312_RESET;
-		if (to_platform_device(ah->ah_sc->dev)->id == 0) {
+		if (to_platform_device(wiphy_dev(ah->ah_sc->hw->wiphy))->id == 0) {
 			if (mask & AR5K_RESET_CTL_PCU)
 				val |= AR5K_AR5312_RESET_WMAC0;
 			if (mask & AR5K_RESET_CTL_BASEBAND)
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 929c68c..c93c685 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -95,7 +95,7 @@ static struct attribute_group ath5k_attribute_group_ani = {
 int
 ath5k_sysfs_register(struct ath5k_softc *sc)
 {
-	struct device *dev = sc->dev;
+	struct device *dev = wiphy_dev(sc->hw->wiphy);
 	int err;
 
 	err = sysfs_create_group(&dev->kobj, &ath5k_attribute_group_ani);
@@ -110,7 +110,7 @@ ath5k_sysfs_register(struct ath5k_softc *sc)
 void
 ath5k_sysfs_unregister(struct ath5k_softc *sc)
 {
-	struct device *dev = sc->dev;
+	struct device *dev = wiphy_dev(sc->hw->wiphy);
 
 	sysfs_remove_group(&dev->kobj, &ath5k_attribute_group_ani);
 }

-- 
Best regards, Nikolay Ledovskikh.
