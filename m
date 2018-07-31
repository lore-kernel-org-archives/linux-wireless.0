Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37199 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbeGaJsl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id n11-v6so2087068wmc.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:32 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 08/19] mt76x2: add buffer len to mt76x2_mac_write_txwi signature
Date: Tue, 31 Jul 2018 10:09:09 +0200
Message-Id: <9dbcce17e9faa7a10e92c3e54429771360b6e246.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100937_185802_59A64F0D)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add frame length to mt76x2_mac_write_txwi routine signature and do not
fetch it from skb since txwi data structure is added at the beginning of
the skb for usb based devices and mt76x2_mac_write_txwi will be shared
between pci and usb related code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index bff0b7268467..010c1cbfcd6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -167,7 +167,7 @@ void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
 
 void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
-			   struct ieee80211_sta *sta)
+			   struct ieee80211_sta *sta, int len)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
@@ -254,7 +254,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 		txwi_flags |= MT_TXWI_FLAGS_TS;
 
 	txwi->flags |= cpu_to_le16(txwi_flags);
-	txwi->len_ctl = cpu_to_le16(skb->len);
+	txwi->len_ctl = cpu_to_le16(len);
 }
 
 static void mt76x2_remove_hdr_pad(struct sk_buff *skb, int len)
@@ -732,7 +732,7 @@ mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x2_txwi)))
 		return -ENOSPC;
 
-	mt76x2_mac_write_txwi(dev, &txwi, skb, NULL, NULL);
+	mt76x2_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
 
 	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
 	offset += sizeof(txwi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index c048cd06df6b..5af0107ba748 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -166,7 +166,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi);
 void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
-			   struct ieee80211_sta *sta);
+			   struct ieee80211_sta *sta, int len);
 void mt76x2_mac_wcid_setup(struct mt76x2_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 560376dd1133..241a1513ec55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -159,7 +159,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
 		mt76x2_mac_wcid_set_drop(dev, wcid->idx, false);
 
-	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta);
+	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
 
 	ret = mt76x2_insert_hdr_pad(skb);
 	if (ret < 0)
-- 
2.17.1
