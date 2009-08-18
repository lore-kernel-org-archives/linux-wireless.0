Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40191 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbZHRDxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:53:19 -0400
Date: Tue, 18 Aug 2009 05:53:20 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 15/29] mwl8k: no need to hold ->tx_lock while setting the hardware interrupt mask
Message-ID: <20090818035320.GT18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f482922..e46cf3c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2768,9 +2768,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 		printk(KERN_ERR "%s() timed out\n", __func__);
 
 	/* Disable interrupts */
-	spin_lock_irq(&priv->tx_lock);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	spin_unlock_irq(&priv->tx_lock);
 	free_irq(priv->pdev->irq, hw);
 
 	/* Stop finalize join worker */
@@ -3461,9 +3459,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	/* Disable interrupts */
-	spin_lock_irq(&priv->tx_lock);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	spin_unlock_irq(&priv->tx_lock);
 	free_irq(priv->pdev->irq, hw);
 
 	rc = ieee80211_register_hw(hw);
@@ -3487,9 +3483,7 @@ err_stop_firmware:
 	mwl8k_release_firmware(priv);
 
 err_free_irq:
-	spin_lock_irq(&priv->tx_lock);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	spin_unlock_irq(&priv->tx_lock);
 	free_irq(priv->pdev->irq, hw);
 
 err_free_queues:
-- 
1.5.6.4
