Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbeIFNyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 13/42] mt76x0: simplify mt76_mac_process_rx signature
Date: Thu,  6 Sep 2018 11:18:29 +0200
Message-Id: <1536225538-16454-14-git-send-email-sgruszka@redhat.com> (sfid-20180906_111943_087312_3A6CDC6F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Remove data pointer from mt76_mac_process_rx routine signature

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
index f29402861ced..82c2b37d0896 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -44,7 +44,7 @@ mt76x0_rx_skb_from_seg(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi,
 	if (!skb)
 		return NULL;
 
-	true_len = mt76x0_mac_process_rx(dev, skb, data, rxwi);
+	true_len = mt76x0_mac_process_rx(dev, skb, rxwi);
 	if (!true_len || true_len > seg_len)
 		goto bad_frame;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 99e2e1225d55..2d8abeb413ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -213,7 +213,7 @@ mt76x0_rx_is_our_beacon(struct mt76x0_dev *dev, u8 *data)
 }
 
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
-			u8 *data, void *rxi)
+			void *rxi)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x02_rxwi *rxwi = rxi;
@@ -239,7 +239,7 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	mt76x02_mac_process_rate(status, rate);
 
 	spin_lock_bh(&dev->con_mon_lock);
-	if (mt76x0_rx_is_our_beacon(dev, data)) {
+	if (mt76x0_rx_is_our_beacon(dev, skb->data)) {
 		mt76x0_rx_monitor_beacon(dev, rxwi, rate, rssi);
 	} else if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST)) {
 		if (dev->avg_rssi == 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index abce22a51c87..b887693a56b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -16,5 +16,5 @@
 #define __MT76_MAC_H
 
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
-			u8 *data, void *rxi);
+			void *rxi);
 #endif
-- 
2.7.5
