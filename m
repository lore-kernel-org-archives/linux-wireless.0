Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbeH0SoL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 14:44:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 13/17] mt76: unify mt76x02_vif struct
Date: Mon, 27 Aug 2018 16:56:27 +0200
Message-Id: <1535381791-14908-14-git-send-email-sgruszka@redhat.com> (sfid-20180827_170843_853657_4322315D)
In-Reply-To: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Private vif structures definitions are the same for mt76x2 and mt76x0.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c        | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c        | 8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h      | 6 ------
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c          | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h        | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h             | 8 +-------
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c      | 8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h         | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c        | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c          | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c   | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c       | 2 +-
 13 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 33924643946d..41c9c7b5deea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -689,7 +689,7 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	hw->max_rate_tries = 1;
 
 	hw->sta_data_size = sizeof(struct mt76_sta);
-	hw->vif_data_size = sizeof(struct mt76_vif);
+	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
 	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 66e8389d489f..1cf06bffaa71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -56,7 +56,7 @@ static int mt76x0_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76_vif *mvif = (struct mt76_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	unsigned int idx;
 
 	idx = ffs(~dev->vif_mask);
@@ -77,7 +77,7 @@ static void mt76x0_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76_vif *mvif = (struct mt76_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	unsigned int wcid = mvif->group_wcid.idx;
 
 	dev->wcid_mask[wcid / BITS_PER_LONG] &= ~BIT(wcid % BITS_PER_LONG);
@@ -160,7 +160,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt76x0_dev *dev = hw->priv;
 	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
-	struct mt76_vif *mvif = (struct mt76_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	int ret = 0;
 	int idx = 0;
 
@@ -242,7 +242,7 @@ mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		struct ieee80211_key_conf *key)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76_vif *mvif = (struct mt76_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	struct mt76_sta *msta = sta ? (struct mt76_sta *) sta->drv_priv : NULL;
 	struct mt76_wcid *wcid = msta ? &msta->wcid : &mvif->group_wcid;
 	int idx = key->keyidx;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 7ad68dc2df30..a1b9a705b173 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -219,12 +219,6 @@ struct mt76x0_wcid {
 	u8 tx_rate_nss;
 };
 
-struct mt76_vif {
-	u8 idx;
-
-	struct mt76_wcid group_wcid;
-};
-
 struct mt76_tx_status {
 	u8 valid:1;
 	u8 success:1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index c45d05d5aab1..0c0ac2283c35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -167,7 +167,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		msta = (struct mt76_sta *) sta->drv_priv;
 		wcid = &msta->wcid;
 	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != 0xff)) {
-		struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
+		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
 		wcid = &mvif->group_wcid;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 7dc11cf70f7e..fa9532cdf6b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -18,6 +18,12 @@
 #ifndef __MT76X02_MAC_H
 #define __MT76X02_MAC_H
 
+struct mt76x02_vif {
+	u8 idx;
+
+	struct mt76_wcid group_wcid;
+};
+
 static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 {
 	const u32 MAC_CSR0 = 0x1000;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index e9b57fce9685..703d5c041b2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -144,16 +144,10 @@ struct mt76x2_dev {
 	struct mt76x2_dfs_pattern_detector dfs_pd;
 };
 
-struct mt76x2_vif {
-	u8 idx;
-
-	struct mt76_wcid group_wcid;
-};
-
 struct mt76x2_sta {
 	struct mt76_wcid wcid; /* must be first */
 
-	struct mt76x2_vif *vif;
+	struct mt76x02_vif *vif;
 	struct mt76x2_tx_status status;
 	int n_frames;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 9ef692930d89..93e6e57f1ba3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -32,9 +32,9 @@ void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
 		sta = (struct mt76x2_sta *) txq->sta->drv_priv;
 		mtxq->wcid = &sta->wcid;
 	} else {
-		struct mt76x2_vif *mvif;
+		struct mt76x02_vif *mvif;
 
-		mvif = (struct mt76x2_vif *) txq->vif->drv_priv;
+		mvif = (struct mt76x02_vif *) txq->vif->drv_priv;
 		mtxq->wcid = &mvif->group_wcid;
 	}
 
@@ -98,7 +98,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt76x2_dev *dev = hw->priv;
 	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	int ret = 0;
 	int idx = 0;
 	int i;
@@ -169,7 +169,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		   struct ieee80211_key_conf *key)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	struct mt76x2_sta *msta;
 	struct mt76_wcid *wcid;
 	int idx = key->keyidx;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 324b2a4b8b67..5885c4fff4c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -209,7 +209,7 @@ void mt76x2_init_device(struct mt76x2_dev *dev)
 	hw->extra_tx_headroom = 2;
 
 	hw->sta_data_size = sizeof(struct mt76x2_sta);
-	hw->vif_data_size = sizeof(struct mt76x2_vif);
+	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
 	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
 	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index ad22d375c847..5e29887e443b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -22,7 +22,7 @@
 
 struct mt76x2_dev;
 struct mt76x2_sta;
-struct mt76x2_vif;
+struct mt76x02_vif;
 struct mt76x2_txwi;
 
 struct mt76x2_tx_status {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 7d2b4a419566..80d33bca7f90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -58,7 +58,7 @@ static int
 mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	unsigned int idx = 0;
 
 	if (vif->addr[0] & BIT(1))
@@ -167,7 +167,7 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 
 	mutex_lock(&dev->mt76.mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 6874db52b846..5338e8efa606 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -58,7 +58,7 @@ static void
 mt76x2_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct mt76x2_dev *dev = (struct mt76x2_dev *) priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	struct sk_buff *skb = NULL;
 
 	if (!(dev->beacon_mask & BIT(mvif->idx)))
@@ -76,7 +76,7 @@ mt76x2_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct beacon_bc_data *data = priv;
 	struct mt76x2_dev *dev = data->dev;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 
@@ -164,7 +164,7 @@ void mt76x2_pre_tbtt_tasklet(unsigned long arg)
 	while ((skb = __skb_dequeue(&data.q)) != NULL) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_vif *vif = info->control.vif;
-		struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+		struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 
 		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
 				      NULL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index c0ca0df84ed8..16086ad12320 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -37,9 +37,9 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	}
 
 	if (vif && !control->sta) {
-		struct mt76x2_vif *mvif;
+		struct mt76x02_vif *mvif;
 
-		mvif = (struct mt76x2_vif *)vif->drv_priv;
+		mvif = (struct mt76x02_vif *)vif->drv_priv;
 		wcid = &mvif->group_wcid;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 9180debc0946..fde334877bc5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -49,7 +49,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *)vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	unsigned int idx = 0;
 
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
-- 
2.7.5
