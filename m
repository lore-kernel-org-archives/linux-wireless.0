Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727428AbeHXOuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:50:17 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 16/17] mt76x0: initalize custom tx queues
Date: Fri, 24 Aug 2018 13:15:20 +0200
Message-Id: <1535109321-17126-17-git-send-email-sgruszka@redhat.com> (sfid-20180824_131619_369625_94FB3E2A)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 2d655e715ee8..36ab4fc8432c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -69,6 +69,7 @@ static int mt76x0_add_interface(struct ieee80211_hw *hw,
 	mvif->idx = idx;
 	mvif->group_wcid.idx = GROUP_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
+	mt76xx_txq_init(&dev->mt76, vif->txq);
 
 	return 0;
 }
@@ -81,6 +82,7 @@ static void mt76x0_remove_interface(struct ieee80211_hw *hw,
 	unsigned int wcid = mvif->group_wcid.idx;
 
 	dev->wcid_mask[wcid / BITS_PER_LONG] &= ~BIT(wcid % BITS_PER_LONG);
+	mt76_txq_remove(&dev->mt76, vif->txq);
 }
 
 static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
@@ -163,6 +165,7 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	struct mt76xx_vif *mvif = (struct mt76xx_vif *) vif->drv_priv;
 	int ret = 0;
 	int idx = 0;
+	int i;
 
 	mutex_lock(&dev->mt76.mutex);
 
@@ -178,6 +181,8 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	mt76xx_mac_wcid_set_drop(&dev->mt76, idx, false);
 	mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
 	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76xx_txq_init(&dev->mt76, sta->txq[i]);
 	mt76x0_mac_set_ampdu_factor(dev);
 
 out:
@@ -193,11 +198,14 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	struct mt76x0_dev *dev = hw->priv;
 	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
 	int idx = msta->wcid.idx;
+	int i;
 
 	mutex_lock(&dev->mt76.mutex);
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	mt76xx_mac_wcid_set_drop(&dev->mt76, idx, true);
 	mt76_wcid_free(dev->wcid_mask, idx);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76xx_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mt76x0_mac_set_ampdu_factor(dev);
 	mutex_unlock(&dev->mt76.mutex);
-- 
1.9.3
