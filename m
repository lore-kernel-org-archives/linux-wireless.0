Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:19 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 20/22] mt76x0: reserve enough space in mac80211
Date: Tue,  4 Sep 2018 16:41:13 +0200
Message-Id: <1536072075-6990-21-git-send-email-sgruszka@redhat.com> (sfid-20180904_164316_094184_4DA62041)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocate skg with enough headroom by mac80211 , this eliminate need
to add extra skb headroom by the mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c   | 17 +----------------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 84fc306d2cbf..45c9f1f7a89a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -685,6 +685,7 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
+	hw->extra_tx_headroom = sizeof(struct mt76x02_txwi) + 4 + 2;
 
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index fa902ac227ec..35db38523e3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -55,18 +55,6 @@ void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb)
 	spin_unlock(&dev->mac_lock);
 }
 
-static int mt76x0_skb_rooms(struct mt76x0_dev *dev, struct sk_buff *skb)
-{
-	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
-	u32 need_head;
-
-	need_head = sizeof(struct mt76x02_txwi) + 4;
-	if (hdr_len % 4)
-		need_head += 2;
-
-	return skb_cow(skb, need_head);
-}
-
 static struct mt76x02_txwi *
 mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 		  struct ieee80211_sta *sta, struct mt76_wcid *wcid,
@@ -158,10 +146,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
 	info->status.status_driver_data[0] = (void *)(unsigned long)pkt_len;
 
-	if (mt76x0_skb_rooms(dev, skb) || mt76x0_insert_hdr_pad(skb)) {
-		ieee80211_free_txskb(dev->mt76.hw, skb);
-		return;
-	}
+	mt76x0_insert_hdr_pad(skb);
 
 	if (sta) {
 		msta = (struct mt76x02_sta *) sta->drv_priv;
-- 
2.7.5
