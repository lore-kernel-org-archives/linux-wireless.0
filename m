Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbeIFNyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 15/42] mt76x0: unify tx/rx datapath with mt76x2u driver
Date: Thu,  6 Sep 2018 11:18:31 +0200
Message-Id: <1536225538-16454-16-git-send-email-sgruszka@redhat.com> (sfid-20180906_111944_390995_7E297E6F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Use mt76/mt76-usb shared routine for tx/rx datapath.
Initialize mt76-usb tx/rx queues in mt76x0_init_hardware and
deallocate them in mt76x0_cleanup routine.
Moreover remove data padding in mt76_mac_process_rx routine.
Furthermore remove unused skb2q routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c |  9 ++---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c  |  8 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c   | 46 +++++++-----------------
 3 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index b28ea45a7282..33730c93c63f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -417,8 +417,9 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	ret = mt76x0_mcu_cmd_init(dev);
 	if (ret)
 		goto err;
-	ret = mt76x0_dma_init(dev);
-	if (ret)
+
+	ret = mt76u_alloc_queues(&dev->mt76);
+	if (ret < 0)
 		goto err_mcu;
 
 	mt76x0_init_mac_registers(dev);
@@ -464,7 +465,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	return 0;
 
 err_rx:
-	mt76x0_dma_cleanup(dev);
+	mt76u_queues_deinit(&dev->mt76);
 err_mcu:
 	mt76u_mcu_deinit(&dev->mt76);
 err:
@@ -478,7 +479,7 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 		return;
 
 	mt76x0_stop_hardware(dev);
-	mt76x0_dma_cleanup(dev);
+	mt76u_queues_deinit(&dev->mt76);
 	mt76u_mcu_deinit(&dev->mt76);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 2d8abeb413ac..8fdc246964b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -15,6 +15,7 @@
 
 #include "mt76x0.h"
 #include "trace.h"
+#include "../mt76x02_util.h"
 #include <linux/etherdevice.h>
 
 void mt76x0_mac_set_protection(struct mt76x0_dev *dev, bool legacy_prot,
@@ -219,7 +220,7 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	struct mt76x02_rxwi *rxwi = rxi;
 	u32 len, ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
-	int rssi;
+	int rssi, pad_len = 0;
 
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	if (WARN_ON(len < 10))
@@ -230,6 +231,11 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
 	}
 
+	if (rxwi->rxinfo & MT_RXINFO_L2PAD)
+		pad_len += 2;
+
+	mt76x02_remove_hdr_pad(skb, pad_len);
+
 	status->chains = BIT(0);
 	rssi = mt76x0_phy_get_rssi(dev, rxwi);
 	status->chain_signal[0] = status->signal = rssi;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 7de739b7c46c..2b7ca7cd48c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -16,19 +16,6 @@
 #include "trace.h"
 #include "../mt76x02_util.h"
 
-/* Take mac80211 Q id from the skb and translate it to hardware Q id */
-static u8 skb2q(struct sk_buff *skb)
-{
-	int qid = skb_get_queue_mapping(skb);
-
-	if (WARN_ON(qid >= MT_TXQ_PSD)) {
-		qid = MT_TXQ_BE;
-		skb_set_queue_mapping(skb, qid);
-	}
-
-	return mt76_ac_to_hwq(qid);
-}
-
 void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -82,38 +69,31 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 }
 
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
-		struct sk_buff *skb)
+	       struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mt76x0_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
-	struct ieee80211_sta *sta = control->sta;
-	struct mt76x02_sta *msta = NULL;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
-	struct mt76x02_txwi *txwi;
-	int pkt_len = skb->len;
-	int hw_q = skb2q(skb);
 
-	BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
-	info->status.status_driver_data[0] = (void *)(unsigned long)pkt_len;
+	if (control->sta) {
+		struct mt76x02_sta *msta;
 
-	mt76x02_insert_hdr_pad(skb);
-
-	if (sta) {
-		msta = (struct mt76x02_sta *) sta->drv_priv;
+		msta = (struct mt76x02_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
-	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != 0xff)) {
-		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
-
-		wcid = &mvif->group_wcid;
+		/* sw encrypted frames */
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
+			control->sta = NULL;
 	}
 
-	txwi = mt76x0_push_txwi(dev, skb, sta, wcid, pkt_len);
+	if (vif && !control->sta) {
+		struct mt76x02_vif *mvif;
 
-	if (mt76x0_dma_enqueue_tx(dev, skb, wcid, hw_q))
-		return;
+		mvif = (struct mt76x02_vif *)vif->drv_priv;
+		wcid = &mvif->group_wcid;
+	}
 
-	trace_mt76x0_tx(&dev->mt76, skb, msta, txwi);
+	mt76_tx(&dev->mt76, control->sta, wcid, skb);
 }
 
 int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-- 
2.7.5
