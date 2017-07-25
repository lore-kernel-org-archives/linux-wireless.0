Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33998 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756768AbdGYBOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:22 -0400
Received: by mail-pf0-f179.google.com with SMTP id q85so53114452pfq.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:21 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 11/20] mwifiex: utilize netif_tx_{wake,stop}_all_queues()
Date: Mon, 24 Jul 2017 18:13:27 -0700
Message-Id: <20170725011336.99993-12-briannorris@chromium.org> (sfid-20170725_031828_170498_91CB0495)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're open-coding these. Just use the helpers.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: no change
---
 drivers/net/wireless/marvell/mwifiex/init.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index de974e8bb9c6..e11919db7818 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -337,17 +337,9 @@ void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
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
 
@@ -358,17 +350,9 @@ void mwifiex_stop_net_dev_queue(struct net_device *netdev,
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
2.14.0.rc0.284.gd933b75aa4-goog
