Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:47403 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZHCT6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:47 -0400
Date: Mon, 3 Aug 2009 21:58:47 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: nico@cam.org
Subject: [PATCH 3/5] mwl8k: call pci_unmap_single() before accessing command structure again
Message-ID: <20090803195847.GJ18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Acked-by: Nicolas Pitre <nico@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c211495..a92752e 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1593,6 +1593,9 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	timeout = wait_for_completion_timeout(&cmd_wait,
 				msecs_to_jiffies(MWL8K_CMD_TIMEOUT_MS));
 
+	pci_unmap_single(priv->pdev, dma_addr, dma_size,
+					PCI_DMA_BIDIRECTIONAL);
+
 	result = &cmd->result;
 	if (!timeout) {
 		spin_lock_irq(&priv->fw_lock);
@@ -1612,8 +1615,6 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 			       *result);
 	}
 
-	pci_unmap_single(priv->pdev, dma_addr, dma_size,
-					PCI_DMA_BIDIRECTIONAL);
 	return rc;
 }
 
-- 
1.5.6.4
