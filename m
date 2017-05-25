Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33432 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164693AbdEYALn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:43 -0400
Received: by mail-pf0-f172.google.com with SMTP id e193so150313259pfh.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:43 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 11/14] mwifiex: utilize netif_tx_{wake,stop}_all_queues()
Date: Wed, 24 May 2017 17:11:16 -0700
Message-Id: <20170525001119.64791-11-briannorris@chromium.org> (sfid-20170525_021436_318556_90C9EDA0)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're open-coding these. Just use the helpers.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 80bdf1c5f77f..d3b8ca402d08 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -332,17 +332,9 @@ void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
 					struct mwifiex_adapter *adapter)
 {
 	unsigned long dev_queue_flags;
-	unsigned int i;
 
 	spin_lock_irqsave(&adapter->queue_lock, dev_queue_flags);
-
-	for (i = 0; i < netdev->num_tx_queues; i++) {
-		struct netdev_queue *txq = netdev_get_tx_queue(netdev, i);
-
-		if (netif_tx_queue_stopped(txq))
-			netif_tx_wake_queue(txq);
-	}
-
+	netif_tx_wake_all_queues(netdev);
 	spin_unlock_irqrestore(&adapter->queue_lock, dev_queue_flags);
 }
 
@@ -353,17 +345,9 @@ void mwifiex_stop_net_dev_queue(struct net_device *netdev,
 					struct mwifiex_adapter *adapter)
 {
 	unsigned long dev_queue_flags;
-	unsigned int i;
 
 	spin_lock_irqsave(&adapter->queue_lock, dev_queue_flags);
-
-	for (i = 0; i < netdev->num_tx_queues; i++) {
-		struct netdev_queue *txq = netdev_get_tx_queue(netdev, i);
-
-		if (!netif_tx_queue_stopped(txq))
-			netif_tx_stop_queue(txq);
-	}
-
+	netif_tx_stop_all_queues(netdev);
 	spin_unlock_irqrestore(&adapter->queue_lock, dev_queue_flags);
 }
 
-- 
2.13.0.219.gdb65acc882-goog
