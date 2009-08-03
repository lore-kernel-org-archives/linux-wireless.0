Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:47409 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZHCT7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:59:09 -0400
Date: Mon, 3 Aug 2009 21:59:09 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: nico@cam.org
Subject: [PATCH 5/5] mwl8k: prevent module unload hang
Message-ID: <20090803195909.GL18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to unregister our ieee80211_hw before resetting the chip, as
the former causes firmware commands to be issued which will time out
once the chip has been reset.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Acked-by: Nicolas Pitre <nico@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4890f8f..4fc1271 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3743,6 +3743,8 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 	ieee80211_stop_queues(hw);
 
+	ieee80211_unregister_hw(hw);
+
 	/* Remove tx reclaim tasklet */
 	tasklet_kill(&priv->tx_reclaim_task);
 
@@ -3756,8 +3758,6 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_reclaim(hw, i, 1);
 
-	ieee80211_unregister_hw(hw);
-
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_deinit(hw, i);
 
-- 
1.5.6.4
