Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48664 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934104AbeAXPTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 7/8] mt76: pass the per-vif wcid to the core for multicast rx
Date: Wed, 24 Jan 2018 16:19:16 +0100
Message-Id: <20180124151917.70962-7-nbd@nbd.name> (sfid-20180124_161941_306377_578A16BB)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for adding software rx CCMP PN validation

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 15 ++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c |  1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a12dfce8c0d1..17df17afd9bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -144,6 +144,7 @@ struct mt76x2_vif {
 struct mt76x2_sta {
 	struct mt76_wcid wcid; /* must be first */
 
+	struct mt76x2_vif *vif;
 	struct mt76x2_tx_status status;
 	int n_frames;
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index b96d8a88656c..f56a8f459fe6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -266,12 +266,20 @@ static void mt76x2_remove_hdr_pad(struct sk_buff *skb)
 }
 
 static struct mt76_wcid *
-mt76x2_rx_get_wcid(struct mt76x2_dev *dev, u8 idx)
+mt76x2_rx_get_sta_wcid(struct mt76x2_dev *dev, u8 idx, bool unicast)
 {
+	struct mt76x2_sta *sta;
+	struct mt76_wcid *wcid;
+
 	if (idx >= ARRAY_SIZE(dev->wcid))
 		return NULL;
 
-	return rcu_dereference(dev->wcid[idx]);
+	wcid = rcu_dereference(dev->wcid[idx]);
+	if (unicast || !wcid)
+		return wcid;
+
+	sta = container_of(wcid, struct mt76x2_sta, wcid);
+	return &sta->vif->group_wcid;
 }
 
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
@@ -282,11 +290,12 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
 	u16 tid_sn = le16_to_cpu(rxwi->tid_sn);
+	bool unicast = rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST);
 	u8 wcid;
 	int len;
 
 	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
-	status->wcid = mt76x2_rx_get_wcid(dev, wcid);
+	status->wcid = mt76x2_rx_get_sta_wcid(dev, wcid, unicast);
 
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD))
 		mt76x2_remove_hdr_pad(skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index bc08040123b9..08fe804c6a43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -273,6 +273,7 @@ mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 	}
 
+	msta->vif = mvif;
 	msta->wcid.sta = 1;
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
-- 
2.14.2
