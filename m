Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728629AbeIFNxp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:53:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 04/42] mt76: move mt76x2u_tx_complete_skb in mt76x02-lib moudule
Date: Thu,  6 Sep 2018 11:18:20 +0200
Message-Id: <1536225538-16454-5-git-send-email-sgruszka@redhat.com> (sfid-20180906_111927_271928_AB0CAD35)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Move mt76x2u_tx_complete_skb routine in mt76x02-lib module
and rename it in mt76x02_tx_complete_skb in order to be reused
in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 8 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2u.h      | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c | 8 --------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c | 3 ++-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a8ad3088ad8b..e4cf4e934153 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -404,4 +404,12 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete);
 
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			    struct mt76_queue_entry *e, bool flush)
+{
+	mt76x02_remove_dma_hdr(e->skb);
+	mt76x02_tx_complete(mdev, e->skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 6b6e963454c8..a7c20e6fb4ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -47,4 +47,6 @@ int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 void mt76x02_remove_dma_hdr(struct sk_buff *skb);
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			    struct mt76_queue_entry *e, bool flush);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
index a83c17cb6be5..6946123820e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -74,8 +74,6 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			   struct sk_buff *skb, struct mt76_queue *q,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info);
-void mt76x2u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			     struct mt76_queue_entry *e, bool flush);
 int mt76x2u_skb_dma_info(struct sk_buff *skb, enum dma_msg_port port,
 			 u32 flags);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index 01dcc5382798..7ba5e5c71dc3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -86,11 +86,3 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 
 	return mt76x2u_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
 }
-
-void mt76x2u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			     struct mt76_queue_entry *e, bool flush)
-{
-	mt76x02_remove_dma_hdr(e->skb);
-	mt76x02_tx_complete(mdev, e->skb);
-}
-
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 53ace9d21fc8..f166246da002 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 
 #include "mt76x2u.h"
+#include "mt76x02_util.h"
 #include "mt76x2_eeprom.h"
 
 static void mt76x2u_init_dma(struct mt76x2_dev *dev)
@@ -136,7 +137,7 @@ struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.tx_prepare_skb = mt76x2u_tx_prepare_skb,
-		.tx_complete_skb = mt76x2u_tx_complete_skb,
+		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.tx_status_data = mt76x2u_tx_status_data,
 		.rx_skb = mt76x2_queue_rx_skb,
 	};
-- 
2.7.5
