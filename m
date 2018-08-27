Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726972AbeH0SoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 14:44:05 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 10/17] mt76: unify mac_wcid_setup
Date: Mon, 27 Aug 2018 16:56:24 +0200
Message-Id: <1535381791-14908-11-git-send-email-sgruszka@redhat.com> (sfid-20180827_165713_209199_5AB397F7)
In-Reply-To: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x{0,2}_mac_wcid_setup into common code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 17 ----------------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 23 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 23 ----------------------
 9 files changed, 31 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 2fcdedd0cadc..2bf5c81ecf10 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -399,23 +399,6 @@ void mt76x0_mac_work(struct work_struct *work)
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work, 10 * HZ);
 }
 
-void
-mt76x0_mac_wcid_setup(struct mt76x0_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
-{
-	u8 zmac[ETH_ALEN] = {};
-	u32 attr;
-
-	attr = FIELD_PREP(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
-	       FIELD_PREP(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
-
-	mt76_wr(dev, MT_WCID_ATTR(idx), attr);
-
-	if (mac)
-		memcpy(zmac, mac, sizeof(zmac));
-
-	mt76x0_addr_wr(dev, MT_WCID_ADDR(idx), zmac);
-}
-
 void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 {
 	struct ieee80211_sta *sta;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 5b39f4d28072..2c15c7ae12ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -156,7 +156,7 @@ mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 static int
 mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		struct ieee80211_sta *sta)
+	       struct ieee80211_sta *sta)
 {
 	struct mt76x0_dev *dev = hw->priv;
 	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
@@ -174,7 +174,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
-	mt76x0_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
+	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
 	mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
 	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
 	mt76x0_mac_set_ampdu_factor(dev);
@@ -197,7 +197,7 @@ mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	mt76_set(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
 	dev->wcid_mask[idx / BITS_PER_LONG] &= ~BIT(idx % BITS_PER_LONG);
-	mt76x0_mac_wcid_setup(dev, idx, 0, NULL);
+	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mt76x0_mac_set_ampdu_factor(dev);
 	mutex_unlock(&dev->mt76.mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 967b262495e7..7ad68dc2df30 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -301,8 +301,6 @@ void mt76x0_mac_set_protection(struct mt76x0_dev *dev, bool legacy_prot,
 				int ht_mode);
 void mt76x0_mac_set_short_preamble(struct mt76x0_dev *dev, bool short_preamb);
 void mt76x0_mac_config_tsf(struct mt76x0_dev *dev, bool enable, int interval);
-void
-mt76x0_mac_wcid_setup(struct mt76x0_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev);
 
 /* TX */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 3261c510a8c8..119229b2dd71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -96,3 +96,26 @@ int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_key);
+
+void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
+{
+	struct mt76_wcid_addr addr = {};
+	u32 attr;
+
+	attr = FIELD_PREP(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
+	       FIELD_PREP(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
+
+	__mt76_wr(dev, MT_WCID_ATTR(idx), attr);
+
+	__mt76_wr(dev, MT_WCID_TX_RATE(idx), 0);
+	__mt76_wr(dev, MT_WCID_TX_RATE(idx) + 4, 0);
+
+	if (idx >= 128)
+		return;
+
+	if (mac)
+		memcpy(addr.macaddr, mac, ETH_ALEN);
+
+	__mt76_wr_copy(dev, MT_WCID_ADDR(idx), &addr, sizeof(addr));
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_setup);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index aebc7dcf7435..2fb8b581bf4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -46,4 +46,5 @@ int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
 				struct ieee80211_key_conf *key);
 int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key);
+void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 1de191c4f6a0..706dedee8674 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -115,7 +115,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.sta = 1;
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
-	mt76x2_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
+	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
 	mt76x2_mac_wcid_set_drop(dev, idx, false);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76x2_txq_init(dev, sta->txq[i]);
@@ -148,7 +148,7 @@ int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76x2_mac_wcid_set_drop(dev, idx, true);
 	mt76_wcid_free(dev->wcid_mask, idx);
-	mt76x2_mac_wcid_setup(dev, idx, 0, NULL);
+	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 1c5c3552a719..f5cf01f912b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -160,10 +160,10 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 		mt76_wr(dev, MT_WCID_DROP_BASE + i * 4, 0);
 
 	for (i = 0; i < 256; i++)
-		mt76x2_mac_wcid_setup(dev, i, 0, NULL);
+		mt76x02_mac_wcid_setup(&dev->mt76, i, 0, NULL);
 
 	for (i = 0; i < MT_MAX_VIFS; i++)
-		mt76x2_mac_wcid_setup(dev, MT_VIF_WCID(i), i, NULL);
+		mt76x02_mac_wcid_setup(&dev->mt76, MT_VIF_WCID(i), i, NULL);
 
 	for (i = 0; i < 16; i++)
 		for (k = 0; k < 4; k++)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 77dd01da9bb9..1b156a04fb7f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -168,7 +168,6 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len);
-void mt76x2_mac_wcid_setup(struct mt76x2_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate);
 void mt76x2_mac_wcid_set_drop(struct mt76x2_dev *dev, u8 idx, bool drop);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index c218434af347..f4e72a280132 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -394,29 +394,6 @@ void mt76x2_mac_wcid_set_drop(struct mt76x2_dev *dev, u8 idx, bool drop)
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_wcid_set_drop);
 
-void mt76x2_mac_wcid_setup(struct mt76x2_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
-{
-	struct mt76_wcid_addr addr = {};
-	u32 attr;
-
-	attr = FIELD_PREP(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
-	       FIELD_PREP(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
-
-	mt76_wr(dev, MT_WCID_ATTR(idx), attr);
-
-	mt76_wr(dev, MT_WCID_TX_RATE(idx), 0);
-	mt76_wr(dev, MT_WCID_TX_RATE(idx) + 4, 0);
-
-	if (idx >= 128)
-		return;
-
-	if (mac)
-		memcpy(addr.macaddr, mac, ETH_ALEN);
-
-	mt76_wr_copy(dev, MT_WCID_ADDR(idx), &addr, sizeof(addr));
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_wcid_setup);
-
 static int
 mt76x2_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 {
-- 
2.7.5
