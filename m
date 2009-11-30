Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45418 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZK3Rck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:32:40 -0500
Date: Mon, 30 Nov 2009 18:32:46 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] mwl8k: do rx/tx ring initialisation after loading firmware
Message-ID: <20091130173246.GX20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whether the firmware we have loaded is AP or STA firmware decides
which receive descriptor format we have to use.  Therefore, move
rx/tx ring initialisation to be after firmware loading.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  104 +++++++++++++++++++++++-------------------
 1 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 427cbb9..9f74dca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -128,20 +128,22 @@ struct mwl8k_tx_queue {
 };
 
 struct mwl8k_priv {
-	void __iomem *sram;
-	void __iomem *regs;
 	struct ieee80211_hw *hw;
-
 	struct pci_dev *pdev;
 
 	struct mwl8k_device_info *device_info;
-	bool ap_fw;
-	struct rxd_ops *rxd_ops;
 
-	/* firmware files and meta data */
+	void __iomem *sram;
+	void __iomem *regs;
+
+	/* firmware */
 	struct firmware *fw_helper;
 	struct firmware *fw_ucode;
 
+	/* hardware/firmware parameters */
+	bool ap_fw;
+	struct rxd_ops *rxd_ops;
+
 	/* firmware access */
 	struct mutex fw_mutex;
 	struct task_struct *fw_mutex_owner;
@@ -548,7 +550,6 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct firmware *fw = priv->fw_ucode;
-	struct mwl8k_device_info *di = priv->device_info;
 	int rc;
 	int loops;
 
@@ -580,7 +581,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 		return rc;
 	}
 
-	if (di->modes & BIT(NL80211_IFTYPE_AP))
+	if (priv->device_info->modes & BIT(NL80211_IFTYPE_AP))
 		iowrite32(MWL8K_MODE_AP, priv->regs + MWL8K_HIU_GEN_PTR);
 	else
 		iowrite32(MWL8K_MODE_STA, priv->regs + MWL8K_HIU_GEN_PTR);
@@ -3301,6 +3302,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		printed_version = 1;
 	}
 
+
 	rc = pci_enable_device(pdev);
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot enable new PCI device\n",
@@ -3317,6 +3319,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
+
 	hw = ieee80211_alloc_hw(sizeof(*priv), &mwl8k_ops);
 	if (hw == NULL) {
 		printk(KERN_ERR "%s: ieee80211 alloc failed\n", MWL8K_NAME);
@@ -3324,17 +3327,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_free_reg;
 	}
 
+	SET_IEEE80211_DEV(hw, &pdev->dev);
+	pci_set_drvdata(pdev, hw);
+
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->pdev = pdev;
 	priv->device_info = &mwl8k_info_tbl[id->driver_data];
-	priv->rxd_ops = priv->device_info->rxd_ops;
-	priv->sniffer_enabled = false;
-	priv->wmm_enabled = false;
-	priv->pending_tx_pkts = 0;
 
-	SET_IEEE80211_DEV(hw, &pdev->dev);
-	pci_set_drvdata(pdev, hw);
 
 	priv->sram = pci_iomap(pdev, 0, 0x10000);
 	if (priv->sram == NULL) {
@@ -3357,6 +3357,37 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		}
 	}
 
+
+	/* Reset firmware and hardware */
+	mwl8k_hw_reset(priv);
+
+	/* Ask userland hotplug daemon for the device firmware */
+	rc = mwl8k_request_firmware(priv);
+	if (rc) {
+		printk(KERN_ERR "%s: Firmware files not found\n",
+		       wiphy_name(hw->wiphy));
+		goto err_stop_firmware;
+	}
+
+	/* Load firmware into hardware */
+	rc = mwl8k_load_firmware(hw);
+	if (rc) {
+		printk(KERN_ERR "%s: Cannot start firmware\n",
+		       wiphy_name(hw->wiphy));
+		goto err_stop_firmware;
+	}
+
+	/* Reclaim memory once firmware is successfully loaded */
+	mwl8k_release_firmware(priv);
+
+
+	priv->rxd_ops = priv->device_info->rxd_ops;
+
+	priv->sniffer_enabled = false;
+	priv->wmm_enabled = false;
+	priv->pending_tx_pkts = 0;
+
+
 	memcpy(priv->channels, mwl8k_channels, sizeof(mwl8k_channels));
 	priv->band.band = IEEE80211_BAND_2GHZ;
 	priv->band.channels = priv->channels;
@@ -3401,11 +3432,11 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Power management cookie */
 	priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
 	if (priv->cookie == NULL)
-		goto err_iounmap;
+		goto err_stop_firmware;
 
 	rc = mwl8k_rxq_init(hw, 0);
 	if (rc)
-		goto err_iounmap;
+		goto err_free_cookie;
 	rxq_refill(hw, 0, INT_MAX);
 
 	mutex_init(&priv->fw_mutex);
@@ -3436,28 +3467,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_free_queues;
 	}
 
-	/* Reset firmware and hardware */
-	mwl8k_hw_reset(priv);
-
-	/* Ask userland hotplug daemon for the device firmware */
-	rc = mwl8k_request_firmware(priv);
-	if (rc) {
-		printk(KERN_ERR "%s: Firmware files not found\n",
-		       wiphy_name(hw->wiphy));
-		goto err_free_irq;
-	}
-
-	/* Load firmware into hardware */
-	rc = mwl8k_load_firmware(hw);
-	if (rc) {
-		printk(KERN_ERR "%s: Cannot start firmware\n",
-		       wiphy_name(hw->wiphy));
-		goto err_stop_firmware;
-	}
-
-	/* Reclaim memory once firmware is successfully loaded */
-	mwl8k_release_firmware(priv);
-
 	/*
 	 * Temporarily enable interrupts.  Initial firmware host
 	 * commands use interrupts and avoids polling.  Disable
@@ -3476,14 +3485,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot initialise firmware\n",
 		       wiphy_name(hw->wiphy));
-		goto err_stop_firmware;
+		goto err_free_irq;
 	}
 
 	/* Turn radio off */
 	rc = mwl8k_cmd_radio_disable(hw);
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot disable\n", wiphy_name(hw->wiphy));
-		goto err_stop_firmware;
+		goto err_free_irq;
 	}
 
 	/* Clear MAC address */
@@ -3491,7 +3500,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot clear MAC address\n",
 		       wiphy_name(hw->wiphy));
-		goto err_stop_firmware;
+		goto err_free_irq;
 	}
 
 	/* Disable interrupts */
@@ -3502,7 +3511,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot register device\n",
 		       wiphy_name(hw->wiphy));
-		goto err_stop_firmware;
+		goto err_free_irq;
 	}
 
 	printk(KERN_INFO "%s: %s v%d, %pM, %s firmware %u.%u.%u.%u\n",
@@ -3514,10 +3523,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	return 0;
 
-err_stop_firmware:
-	mwl8k_hw_reset(priv);
-	mwl8k_release_firmware(priv);
-
 err_free_irq:
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 	free_irq(priv->pdev->irq, hw);
@@ -3527,11 +3532,16 @@ err_free_queues:
 		mwl8k_txq_deinit(hw, i);
 	mwl8k_rxq_deinit(hw, 0);
 
-err_iounmap:
+err_free_cookie:
 	if (priv->cookie != NULL)
 		pci_free_consistent(priv->pdev, 4,
 				priv->cookie, priv->cookie_dma);
 
+err_stop_firmware:
+	mwl8k_hw_reset(priv);
+	mwl8k_release_firmware(priv);
+
+err_iounmap:
 	if (priv->regs != NULL)
 		pci_iounmap(pdev, priv->regs);
 
-- 
1.5.6.4
