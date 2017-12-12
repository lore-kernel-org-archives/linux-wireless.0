Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:37355 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbdLLB6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 20:58:07 -0500
Date: Tue, 12 Dec 2017 12:58:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?=
        <toke@toke.dk>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: linux-next: build failure after merge of the mac80211-next tree
Message-ID: <20171212125805.5f7813fd@canb.auug.org.au> (sfid-20171212_025844_313354_81ADFE7C)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

After merging the mac80211-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/mediatek/mt76/mt76x2_main.c:539:19: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .wake_tx_queue = mt76_wake_tx_queue,
                   ^
drivers/net/wireless/mediatek/mt76/mt76x2_main.c:539:19: note: (near initialization for 'mt76x2_ops.wake_tx_queue')

Caused by commits

  17f1de56df05 ("mt76: add common code shared between multiple chipsets")
  7bc04215a66b ("mt76: add driver code for MT76x2e")

from the wireless-drivers-next tree interacting with commit

  e937b8da5a59 ("mac80211: Add TXQ scheduling API")

from the mac80211-next tree.

I applied the below hack merge fix ... please let me know if something
more/better is required.  Someone needs to remember to tell Dave when
these trees meet in his tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 12 Dec 2017 12:50:40 +1100
Subject: [PATCH] mt76: fix up for "mac80211: Add TXQ scheduling API"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 +-
 drivers/net/wireless/mediatek/mt76/tx.c   | 10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index aa0880bbea7f..e395d3859212 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -338,7 +338,7 @@ void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	     struct mt76_wcid *wcid, struct sk_buff *skb);
 void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
-void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+void mt76_wake_tx_queue(struct ieee80211_hw *hw);
 void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			 bool send_bar);
 void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *hwq);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 4eef69bd8a9e..ad414af0750f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -463,12 +463,16 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 }
 EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 
-void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+void mt76_wake_tx_queue(struct ieee80211_hw *hw)
 {
+	struct ieee80211_txq *txq;
 	struct mt76_dev *dev = hw->priv;
-	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
-	struct mt76_queue *hwq = mtxq->hwq;
+	struct mt76_txq *mtxq;
+	struct mt76_queue *hwq;
 
+	txq = ieee80211_next_txq(hw);
+	mtxq = (struct mt76_txq *) txq->drv_priv;
+	hwq = mtxq->hwq;
 	spin_lock_bh(&hwq->lock);
 	if (list_empty(&mtxq->list))
 		list_add_tail(&mtxq->list, &hwq->swq);
-- 
2.15.0

-- 
Cheers,
Stephen Rothwell
