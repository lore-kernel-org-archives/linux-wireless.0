Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59622 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbZJVSxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:49 -0400
Date: Thu, 22 Oct 2009 20:20:43 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 14/28] mwl8k: pci BAR mapping changes
Message-ID: <20091022182043.GP1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Map BAR0 as well, as we need to write to it during init on some chips.

Also, if BAR0 is a 64bit BAR, the register BAR becomes BAR2, so try
mapping BAR2 if mapping BAR1 fails.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f282550..7aea8eb 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -123,6 +123,7 @@ struct mwl8k_firmware {
 };
 
 struct mwl8k_priv {
+	void __iomem *sram;
 	void __iomem *regs;
 	struct ieee80211_hw *hw;
 
@@ -2986,13 +2987,27 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
-	priv->regs = pci_iomap(pdev, 1, 0x10000);
-	if (priv->regs == NULL) {
-		printk(KERN_ERR "%s: Cannot map device memory\n",
+	priv->sram = pci_iomap(pdev, 0, 0x10000);
+	if (priv->sram == NULL) {
+		printk(KERN_ERR "%s: Cannot map device SRAM\n",
 		       wiphy_name(hw->wiphy));
 		goto err_iounmap;
 	}
 
+	/*
+	 * If BAR0 is a 32 bit BAR, the register BAR will be BAR1.
+	 * If BAR0 is a 64 bit BAR, the register BAR will be BAR2.
+	 */
+	priv->regs = pci_iomap(pdev, 1, 0x10000);
+	if (priv->regs == NULL) {
+		priv->regs = pci_iomap(pdev, 2, 0x10000);
+		if (priv->regs == NULL) {
+			printk(KERN_ERR "%s: Cannot map device registers\n",
+			       wiphy_name(hw->wiphy));
+			goto err_iounmap;
+		}
+	}
+
 	memcpy(priv->channels, mwl8k_channels, sizeof(mwl8k_channels));
 	priv->band.band = IEEE80211_BAND_2GHZ;
 	priv->band.channels = priv->channels;
@@ -3164,6 +3179,9 @@ err_iounmap:
 	if (priv->regs != NULL)
 		pci_iounmap(pdev, priv->regs);
 
+	if (priv->sram != NULL)
+		pci_iounmap(pdev, priv->sram);
+
 	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 
@@ -3211,6 +3229,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 	pci_free_consistent(priv->pdev, 4, priv->cookie, priv->cookie_dma);
 
 	pci_iounmap(pdev, priv->regs);
+	pci_iounmap(pdev, priv->sram);
 	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 	pci_release_regions(pdev);
-- 
1.5.6.4

