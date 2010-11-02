Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58915 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0KBA43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 20:56:29 -0400
Received: by mail-pw0-f46.google.com with SMTP id 3so1423603pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 17:56:29 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 5/7] mwl8k: factor out firmware loading and hw init code
Date: Mon,  1 Nov 2010 17:55:49 -0700
Message-Id: <1288659351-22313-5-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is in preparation for supporting different fw images
for different interface types.

Based on a patch from Pradeep Nemavat <pnemavat@marvell.com>

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  265 +++++++++++++++++++++++-------------------
 1 files changed, 148 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 99cc48d..bbf8222 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3961,6 +3961,142 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
 
+static int mwl8k_init_firmware(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	int rc;
+
+	/* Reset firmware and hardware */
+	mwl8k_hw_reset(priv);
+
+	/* Ask userland hotplug daemon for the device firmware */
+	rc = mwl8k_request_firmware(priv);
+	if (rc) {
+		wiphy_err(hw->wiphy, "Firmware files not found\n");
+		return rc;
+	}
+
+	/* Load firmware into hardware */
+	rc = mwl8k_load_firmware(hw);
+	if (rc)
+		wiphy_err(hw->wiphy, "Cannot start firmware\n");
+
+	/* Reclaim memory once firmware is successfully loaded */
+	mwl8k_release_firmware(priv);
+
+	return rc;
+}
+
+/* initialize hw after successfully loading a firmware image */
+static int mwl8k_probe_hw(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	int rc = 0;
+	int i;
+
+	if (priv->ap_fw) {
+		priv->rxd_ops = priv->device_info->ap_rxd_ops;
+		if (priv->rxd_ops == NULL) {
+			wiphy_err(hw->wiphy,
+				  "Driver does not have AP firmware image support for this hardware\n");
+			goto err_stop_firmware;
+		}
+		priv->txd_size = MWL8K_TX_DESC_SIZE_AP;
+	} else {
+		priv->rxd_ops = &rxd_sta_ops;
+		priv->txd_size = MWL8K_TX_DESC_SIZE_STA;
+	}
+
+	priv->sniffer_enabled = false;
+	priv->wmm_enabled = false;
+	priv->pending_tx_pkts = 0;
+
+	rc = mwl8k_rxq_init(hw, 0);
+	if (rc)
+		goto err_stop_firmware;
+	rxq_refill(hw, 0, INT_MAX);
+
+	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+		rc = mwl8k_txq_init(hw, i);
+		if (rc)
+			goto err_free_queues;
+	}
+
+	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
+	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	iowrite32(MWL8K_A2H_INT_TX_DONE | MWL8K_A2H_INT_RX_READY,
+		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
+	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
+
+	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
+			 IRQF_SHARED, MWL8K_NAME, hw);
+	if (rc) {
+		wiphy_err(hw->wiphy, "failed to register IRQ handler\n");
+		goto err_free_queues;
+	}
+
+	/*
+	 * Temporarily enable interrupts.  Initial firmware host
+	 * commands use interrupts and avoid polling.  Disable
+	 * interrupts when done.
+	 */
+	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+
+	/* Get config data, mac addrs etc */
+	if (priv->ap_fw) {
+		rc = mwl8k_cmd_get_hw_spec_ap(hw);
+		if (!rc)
+			rc = mwl8k_cmd_set_hw_spec(hw);
+	} else {
+		rc = mwl8k_cmd_get_hw_spec_sta(hw);
+	}
+	if (rc) {
+		wiphy_err(hw->wiphy, "Cannot initialise firmware\n");
+		goto err_free_irq;
+	}
+
+	/* Turn radio off */
+	rc = mwl8k_cmd_radio_disable(hw);
+	if (rc) {
+		wiphy_err(hw->wiphy, "Cannot disable\n");
+		goto err_free_irq;
+	}
+
+	/* Clear MAC address */
+	rc = mwl8k_cmd_set_mac_addr(hw, NULL, "\x00\x00\x00\x00\x00\x00");
+	if (rc) {
+		wiphy_err(hw->wiphy, "Cannot clear MAC address\n");
+		goto err_free_irq;
+	}
+
+	/* Disable interrupts */
+	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	free_irq(priv->pdev->irq, hw);
+
+	wiphy_info(hw->wiphy, "%s v%d, %pm, %s firmware %u.%u.%u.%u\n",
+		   priv->device_info->part_name,
+		   priv->hw_rev, hw->wiphy->perm_addr,
+		   priv->ap_fw ? "AP" : "STA",
+		   (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
+		   (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
+
+	return 0;
+
+err_free_irq:
+	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	free_irq(priv->pdev->irq, hw);
+
+err_free_queues:
+	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+		mwl8k_txq_deinit(hw, i);
+	mwl8k_rxq_deinit(hw, 0);
+
+err_stop_firmware:
+	mwl8k_hw_reset(priv);
+
+	return rc;
+}
+
 static int __devinit mwl8k_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
@@ -4028,45 +4164,9 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		}
 	}
 
-
-	/* Reset firmware and hardware */
-	mwl8k_hw_reset(priv);
-
-	/* Ask userland hotplug daemon for the device firmware */
-	rc = mwl8k_request_firmware(priv);
-	if (rc) {
-		wiphy_err(hw->wiphy, "Firmware files not found\n");
-		goto err_stop_firmware;
-	}
-
-	/* Load firmware into hardware */
-	rc = mwl8k_load_firmware(hw);
-	if (rc) {
-		wiphy_err(hw->wiphy, "Cannot start firmware\n");
+	rc = mwl8k_init_firmware(hw);
+	if (rc)
 		goto err_stop_firmware;
-	}
-
-	/* Reclaim memory once firmware is successfully loaded */
-	mwl8k_release_firmware(priv);
-
-
-	if (priv->ap_fw) {
-		priv->rxd_ops = priv->device_info->ap_rxd_ops;
-		if (priv->rxd_ops == NULL) {
-			wiphy_err(hw->wiphy,
-				  "Driver does not have AP firmware image support for this hardware\n");
-			goto err_stop_firmware;
-		}
-		priv->txd_size = MWL8K_TX_DESC_SIZE_AP;
-	} else {
-		priv->rxd_ops = &rxd_sta_ops;
-		priv->txd_size = MWL8K_TX_DESC_SIZE_STA;
-	}
-
-	priv->sniffer_enabled = false;
-	priv->wmm_enabled = false;
-	priv->pending_tx_pkts = 0;
-
 
 	/*
 	 * Extra headroom is the size of the required DMA header
@@ -4102,13 +4202,10 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	/* Power management cookie */
 	priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
-	if (priv->cookie == NULL)
+	if (priv->cookie == NULL) {
+		rc = -ENOMEM;
 		goto err_stop_firmware;
-
-	rc = mwl8k_rxq_init(hw, 0);
-	if (rc)
-		goto err_free_cookie;
-	rxq_refill(hw, 0, INT_MAX);
+	}
 
 	mutex_init(&priv->fw_mutex);
 	priv->fw_mutex_owner = NULL;
@@ -4119,90 +4216,25 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	priv->tx_wait = NULL;
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
-		rc = mwl8k_txq_init(hw, i);
-		if (rc)
-			goto err_free_queues;
-	}
-
-	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	iowrite32(MWL8K_A2H_INT_TX_DONE | MWL8K_A2H_INT_RX_READY,
-		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
-	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
-
-	rc = request_irq(priv->pdev->irq, mwl8k_interrupt,
-			 IRQF_SHARED, MWL8K_NAME, hw);
-	if (rc) {
-		wiphy_err(hw->wiphy, "failed to register IRQ handler\n");
-		goto err_free_queues;
-	}
-
-	/*
-	 * Temporarily enable interrupts.  Initial firmware host
-	 * commands use interrupts and avoid polling.  Disable
-	 * interrupts when done.
-	 */
-	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-
-	/* Get config data, mac addrs etc */
-	if (priv->ap_fw) {
-		rc = mwl8k_cmd_get_hw_spec_ap(hw);
-		if (!rc)
-			rc = mwl8k_cmd_set_hw_spec(hw);
-	} else {
-		rc = mwl8k_cmd_get_hw_spec_sta(hw);
-	}
-	if (rc) {
-		wiphy_err(hw->wiphy, "Cannot initialise firmware\n");
-		goto err_free_irq;
-	}
+	rc = mwl8k_probe_hw(hw);
+	if (rc)
+		goto err_free_cookie;
 
 	hw->wiphy->interface_modes = 0;
-	if (priv->ap_macids_supported)
+	if (priv->ap_macids_supported || priv->device_info->fw_image_ap)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
-	if (priv->sta_macids_supported)
+	if (priv->sta_macids_supported || priv->device_info->fw_image_sta)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
 
-
-	/* Turn radio off */
-	rc = mwl8k_cmd_radio_disable(hw);
-	if (rc) {
-		wiphy_err(hw->wiphy, "Cannot disable\n");
-		goto err_free_irq;
-	}
-
-	/* Clear MAC address */
-	rc = mwl8k_cmd_set_mac_addr(hw, NULL, "\x00\x00\x00\x00\x00\x00");
-	if (rc) {
-		wiphy_err(hw->wiphy, "Cannot clear MAC address\n");
-		goto err_free_irq;
-	}
-
-	/* Disable interrupts */
-	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	free_irq(priv->pdev->irq, hw);
-
 	rc = ieee80211_register_hw(hw);
 	if (rc) {
 		wiphy_err(hw->wiphy, "Cannot register device\n");
-		goto err_free_queues;
+		goto err_unprobe_hw;
 	}
 
-	wiphy_info(hw->wiphy, "%s v%d, %pm, %s firmware %u.%u.%u.%u\n",
-		   priv->device_info->part_name,
-		   priv->hw_rev, hw->wiphy->perm_addr,
-		   priv->ap_fw ? "AP" : "STA",
-		   (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
-		   (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
-
 	return 0;
 
-err_free_irq:
-	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	free_irq(priv->pdev->irq, hw);
-
-err_free_queues:
+err_unprobe_hw:
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_deinit(hw, i);
 	mwl8k_rxq_deinit(hw, 0);
@@ -4214,7 +4246,6 @@ err_free_cookie:
 
 err_stop_firmware:
 	mwl8k_hw_reset(priv);
-	mwl8k_release_firmware(priv);
 
 err_iounmap:
 	if (priv->regs != NULL)
-- 
1.7.1.1

