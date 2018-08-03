Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728412AbeHCNkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 09:40:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 1/2] mt76x0: raname mt76_* functions
Date: Fri,  3 Aug 2018 13:44:39 +0200
Message-Id: <1533296680-7236-1-git-send-email-sgruszka@redhat.com> (sfid-20180803_134507_104285_B476DC79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mt76_* functions conflicts with mt7601u driver what prevents to build
those drivers in the kernel or use both drivers modules at once.

Patch fixes build errors like this:
ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x30): multiple definition of `mt76_mac_tx_rate_val'; drivers/net/wireless/mediatek/mt7601u/mac.o:(.opd+0x30): first defined here

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 14 +++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    | 12 ++++++------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c   |  4 ++--
 7 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
index 2cf71283de3f..d91b1bb8fcc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -44,7 +44,7 @@ mt76x0_rx_skb_from_seg(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi,
 	if (!skb)
 		return NULL;
 
-	true_len = mt76_mac_process_rx(dev, skb, data, rxwi);
+	true_len = mt76x0_mac_process_rx(dev, skb, data, rxwi);
 	if (!true_len || true_len > seg_len)
 		goto bad_frame;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 7b32777c06e9..5f12724eeb62 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -116,7 +116,7 @@ mt76_mac_fill_tx_status(struct mt76x0_dev *dev, struct ieee80211_tx_info *info,
 		info->flags |= IEEE80211_TX_STAT_ACK;
 }
 
-u16 mt76_mac_tx_rate_val(struct mt76x0_dev *dev,
+u16 mt76x0_mac_tx_rate_val(struct mt76x0_dev *dev,
 			 const struct ieee80211_tx_rate *rate, u8 *nss_val)
 {
 	u16 rateval;
@@ -166,13 +166,13 @@ u16 mt76_mac_tx_rate_val(struct mt76x0_dev *dev,
 	return cpu_to_le16(rateval);
 }
 
-void mt76_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
+void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
 			    const struct ieee80211_tx_rate *rate)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->mt76.lock, flags);
-	wcid->tx_rate = mt76_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
+	wcid->tx_rate = mt76x0_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
 	wcid->tx_rate_set = true;
 	spin_unlock_irqrestore(&dev->mt76.lock, flags);
 }
@@ -198,7 +198,7 @@ struct mt76_tx_status mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev)
 	return stat;
 }
 
-void mt76_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat, u8 *update)
+void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat, u8 *update)
 {
 	struct ieee80211_tx_info info = {};
 	struct ieee80211_sta *sta = NULL;
@@ -527,7 +527,7 @@ mt76x0_rx_is_our_beacon(struct mt76x0_dev *dev, u8 *data)
 		ether_addr_equal(hdr->addr2, dev->ap_bssid);
 }
 
-u32 mt76_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
+u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -594,7 +594,7 @@ mt76_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 	}
 }
 
-int mt76_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
+int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 			  struct ieee80211_key_conf *key)
 {
 	enum mt76_cipher_type cipher;
@@ -635,7 +635,7 @@ int mt76_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 	return 0;
 }
 
-int mt76_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
+int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
 			      struct ieee80211_key_conf *key)
 {
 	enum mt76_cipher_type cipher;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index 947eba253553..bea067b71c13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -136,19 +136,19 @@ struct mt76_txwi {
 
 #define MT_TXWI_PKTID_PROBE             BIT(7)
 
-u32 mt76_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
+u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi);
-int mt76_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
+int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 			  struct ieee80211_key_conf *key);
-void mt76_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
+void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
 			    const struct ieee80211_tx_rate *rate);
 
-int mt76_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
+int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
 			      struct ieee80211_key_conf *key);
-u16 mt76_mac_tx_rate_val(struct mt76x0_dev *dev,
+u16 mt76x0_mac_tx_rate_val(struct mt76x0_dev *dev,
 			 const struct ieee80211_tx_rate *rate, u8 *nss_val);
 struct mt76_tx_status
 mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev);
-void mt76_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat, u8 *update);
+void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat, u8 *update);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 0c521f3485c9..cf6ffb1ba4a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -300,15 +300,15 @@ mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!msta) {
 		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76_mac_wcid_set_key(dev, wcid->idx, key);
+			ret = mt76x0_mac_wcid_set_key(dev, wcid->idx, key);
 			if (ret)
 				return ret;
 		}
 
-		return mt76_mac_shared_key_setup(dev, mvif->idx, idx, key);
+		return mt76x0_mac_shared_key_setup(dev, mvif->idx, idx, key);
 	}
 
-	return mt76_mac_wcid_set_key(dev, msta->wcid.idx, key);
+	return mt76x0_mac_wcid_set_key(dev, msta->wcid.idx, key);
 }
 
 static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
@@ -375,7 +375,7 @@ mt76_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	rate.idx = rates->rate[0].idx;
 	rate.flags = rates->rate[0].flags;
-	mt76_mac_wcid_set_rate(dev, &msta->wcid, &rate);
+	mt76x0_mac_wcid_set_rate(dev, &msta->wcid, &rate);
 
 out:
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 9e60fcb14687..c1feca3ea016 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -324,8 +324,8 @@ void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb);
 void mt76x0_tx_stat(struct work_struct *work);
 
 /* util */
-void mt76_remove_hdr_pad(struct sk_buff *skb);
-int mt76_insert_hdr_pad(struct sk_buff *skb);
+void mt76x0_remove_hdr_pad(struct sk_buff *skb);
+int mt76x0_insert_hdr_pad(struct sk_buff *skb);
 
 int mt76x0_dma_init(struct mt76x0_dev *dev);
 void mt76x0_dma_cleanup(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 28b8e1508016..976d3ee91f67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -35,7 +35,7 @@ static void mt76x0_tx_skb_remove_dma_overhead(struct sk_buff *skb,
 
 	skb_pull(skb, sizeof(struct mt76_txwi) + 4);
 	if (ieee80211_get_hdrlen_from_skb(skb) % 4)
-		mt76_remove_hdr_pad(skb);
+		mt76x0_remove_hdr_pad(skb);
 
 	skb_trim(skb, pkt_len);
 }
@@ -93,7 +93,7 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 		rate_ctl = wcid->tx_rate;
 		nss = wcid->tx_rate_nss;
 	} else {
-		rate_ctl = mt76_mac_tx_rate_val(dev, rate, &nss);
+		rate_ctl = mt76x0_mac_tx_rate_val(dev, rate, &nss);
 	}
 	spin_unlock_irqrestore(&dev->mt76.lock, flags);
 
@@ -158,7 +158,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
 	info->status.status_driver_data[0] = (void *)(unsigned long)pkt_len;
 
-	if (mt76x0_skb_rooms(dev, skb) || mt76_insert_hdr_pad(skb)) {
+	if (mt76x0_skb_rooms(dev, skb) || mt76x0_insert_hdr_pad(skb)) {
 		ieee80211_free_txskb(dev->mt76.hw, skb);
 		return;
 	}
@@ -194,7 +194,7 @@ void mt76x0_tx_stat(struct work_struct *work)
 		if (!stat.valid)
 			break;
 
-		mt76_send_tx_status(dev, &stat, &update);
+		mt76x0_send_tx_status(dev, &stat, &update);
 
 		cleaned++;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/util.c b/drivers/net/wireless/mediatek/mt76/mt76x0/util.c
index 148be47d822f..7856dd760419 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/util.c
@@ -13,7 +13,7 @@
 
 #include "mt76x0.h"
 
-void mt76_remove_hdr_pad(struct sk_buff *skb)
+void mt76x0_remove_hdr_pad(struct sk_buff *skb)
 {
 	int len = ieee80211_get_hdrlen_from_skb(skb);
 
@@ -21,7 +21,7 @@ void mt76_remove_hdr_pad(struct sk_buff *skb)
 	skb_pull(skb, 2);
 }
 
-int mt76_insert_hdr_pad(struct sk_buff *skb)
+int mt76x0_insert_hdr_pad(struct sk_buff *skb)
 {
 	int len = ieee80211_get_hdrlen_from_skb(skb);
 	int ret;
-- 
2.7.5
