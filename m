Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:39313 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZHXNmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 09:42:45 -0400
Date: Mon, 24 Aug 2009 15:42:46 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mwl8k: fix pci dma mapping leak in mwl8k_post_cmd() error path
Message-ID: <20090824134246.GD6102@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4d3353c..a4336f4 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1439,8 +1439,11 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 		return -ENOMEM;
 
 	rc = mwl8k_fw_lock(hw);
-	if (rc)
+	if (rc) {
+		pci_unmap_single(priv->pdev, dma_addr, dma_size,
+						PCI_DMA_BIDIRECTIONAL);
 		return rc;
+	}
 
 	priv->hostcmd_wait = &cmd_wait;
 	iowrite32(dma_addr, regs + MWL8K_HIU_GEN_PTR);
-- 
1.5.6.4
