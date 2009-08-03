Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:47400 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbZHCT6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:39 -0400
Date: Mon, 3 Aug 2009 21:58:39 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: nico@cam.org
Subject: [PATCH 2/5] mwl8k: add various missing GET_HW_SPEC endian conversions
Message-ID: <20090803195839.GI18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Acked-by: Nicolas Pitre <nico@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f437fab..c211495 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1656,18 +1656,18 @@ static int mwl8k_cmd_get_hw_spec(struct ieee80211_hw *hw)
 	memset(cmd->perm_addr, 0xff, sizeof(cmd->perm_addr));
 	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
 	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rx_desc_dma);
-	cmd->num_tx_queues = MWL8K_TX_QUEUES;
+	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].tx_desc_dma);
-	cmd->num_tx_desc_per_queue = MWL8K_TX_DESCS;
-	cmd->total_rx_desc = MWL8K_RX_DESCS;
+	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
+	cmd->total_rx_desc = cpu_to_le32(MWL8K_RX_DESCS);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 
 	if (!rc) {
 		SET_IEEE80211_PERM_ADDR(hw, cmd->perm_addr);
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
-		priv->fw_rev = cmd->fw_rev;
+		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
 		priv->region_code = le16_to_cpu(cmd->region_code);
 	}
-- 
1.5.6.4
