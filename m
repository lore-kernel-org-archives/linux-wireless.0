Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:06:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 01/22] mt76: move wcid fields to common mt76_dev struct
Date: Tue,  4 Sep 2018 16:40:54 +0200
Message-Id: <1536072075-6990-2-git-send-email-sgruszka@redhat.com> (sfid-20180904_164133_102414_9AB3B58E)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All current MT devices including new MT7603 type chips support 128
WCIDs, we can unify wcid data in common mt76_dev structure.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 22 +++++++++-------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  5 -----
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  5 -----
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  8 ++++----
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |  4 ++--
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c |  8 ++++----
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |  6 +++---
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |  2 +-
 12 files changed, 40 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e9e46612c7f3..2d0ab28a0977 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -148,6 +148,8 @@ enum mt76_wcid_flags {
 	MT_WCID_FLAG_PS,
 };
 
+#define MT76_N_WCIDS 128
+
 struct mt76_wcid {
 	struct mt76_rx_tid __rcu *aggr[IEEE80211_NUM_TIDS];
 
@@ -348,6 +350,11 @@ struct mt76_dev {
 
 	wait_queue_head_t tx_wait;
 
+	unsigned long wcid_mask[MT76_N_WCIDS / BITS_PER_LONG];
+
+	struct mt76_wcid global_wcid;
+	struct mt76_wcid __rcu *wcid[MT76_N_WCIDS];
+
 	u8 macaddr[ETH_ALEN];
 	u32 rev;
 	unsigned long state;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 80783edd9ca5..b5bf22184a69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -230,17 +230,17 @@ static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
 	u32 *vals;
 	int i, ret;
 
-	vals = kmalloc(sizeof(*vals) * N_WCIDS * 2, GFP_KERNEL);
+	vals = kmalloc(sizeof(*vals) * MT76_N_WCIDS * 2, GFP_KERNEL);
 	if (!vals)
 		return -ENOMEM;
 
-	for (i = 0; i < N_WCIDS; i++)  {
+	for (i = 0; i < MT76_N_WCIDS; i++)  {
 		vals[i * 2] = 0xffffffff;
 		vals[i * 2 + 1] = 0x00ffffff;
 	}
 
 	ret = mt76x0_burst_write_regs(dev, MT_WCID_ADDR_BASE,
-				      vals, N_WCIDS * 2);
+				      vals, MT76_N_WCIDS * 2);
 	kfree(vals);
 
 	return ret;
@@ -259,15 +259,15 @@ static int mt76x0_init_wcid_attr_mem(struct mt76x0_dev *dev)
 	u32 *vals;
 	int i, ret;
 
-	vals = kmalloc(sizeof(*vals) * N_WCIDS * 2, GFP_KERNEL);
+	vals = kmalloc(sizeof(*vals) * MT76_N_WCIDS * 2, GFP_KERNEL);
 	if (!vals)
 		return -ENOMEM;
 
-	for (i = 0; i < N_WCIDS * 2; i++)
+	for (i = 0; i < MT76_N_WCIDS * 2; i++)
 		vals[i] = 1;
 
 	ret = mt76x0_burst_write_regs(dev, MT_WCID_ATTR_BASE,
-				      vals, N_WCIDS * 2);
+				      vals, MT76_N_WCIDS * 2);
 	kfree(vals);
 
 	return ret;
@@ -667,15 +667,11 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
 	 * entry no. 1 like it does in the vendor driver.
 	 */
-	dev->wcid_mask[0] |= 1;
+	dev->mt76.wcid_mask[0] |= 1;
 
 	/* init fake wcid for monitor interfaces */
-	dev->mon_wcid = devm_kmalloc(dev->mt76.dev, sizeof(*dev->mon_wcid),
-				     GFP_KERNEL);
-	if (!dev->mon_wcid)
-		return -ENOMEM;
-	dev->mon_wcid->idx = 0xff;
-	dev->mon_wcid->hw_key_idx = -1;
+	dev->mt76.global_wcid.idx = 0xff;
+	dev->mt76.global_wcid.hw_key_idx = -1;
 
 	SET_IEEE80211_DEV(hw, dev->mt76.dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 0931c1821597..4c4962bcca11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -206,8 +206,8 @@ void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *sta
 	struct mt76x02_sta *msta = NULL;
 
 	rcu_read_lock();
-	if (stat->wcid < ARRAY_SIZE(dev->wcid))
-		wcid = rcu_dereference(dev->wcid[stat->wcid]);
+	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
+		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
 
 	if (wcid) {
 		void *priv;
@@ -408,8 +408,8 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 	int i;
 
 	rcu_read_lock();
-	for (i = 0; i < ARRAY_SIZE(dev->wcid); i++) {
-		wcid = rcu_dereference(dev->wcid[i]);
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid); i++) {
+		wcid = rcu_dereference(dev->mt76.wcid[i]);
 		if (!wcid)
 			continue;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a969fa9fcd57..bbfbd1ac74eb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -81,7 +81,7 @@ static void mt76x0_remove_interface(struct ieee80211_hw *hw,
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	unsigned int wcid = mvif->group_wcid.idx;
 
-	dev->wcid_mask[wcid / BITS_PER_LONG] &= ~BIT(wcid % BITS_PER_LONG);
+	dev->mt76.wcid_mask[wcid / BITS_PER_LONG] &= ~BIT(wcid % BITS_PER_LONG);
 	mt76_txq_remove(&dev->mt76, vif->txq);
 }
 
@@ -169,7 +169,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
 	if (idx < 0) {
 		ret = -ENOSPC;
 		goto out;
@@ -180,7 +180,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
 	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
 	mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
-	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
+	rcu_assign_pointer(dev->mt76.wcid[idx], &msta->wcid);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76x02_txq_init(&dev->mt76, sta->txq[i]);
 	mt76x0_mac_set_ampdu_factor(dev);
@@ -201,9 +201,9 @@ mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int i;
 
 	mutex_lock(&dev->mt76.mutex);
-	rcu_assign_pointer(dev->wcid[idx], NULL);
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
-	mt76_wcid_free(dev->wcid_mask, idx);
+	mt76_wcid_free(dev->mt76.wcid_mask, idx);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index c53ea04e1618..afe592cc7aa9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -96,7 +96,6 @@ struct mt76x0_tx_queue {
  * ...7e: group wcids
  *    7f: reserved
  */
-#define N_WCIDS		128
 #define GROUP_WCID(idx)	(254 - idx)
 
 struct mt76x0_eeprom_params;
@@ -144,7 +143,6 @@ struct mt76x0_dev {
 	u8 in_ep[__MT_EP_IN_MAX];
 	u16 in_max_packet;
 
-	unsigned long wcid_mask[DIV_ROUND_UP(N_WCIDS, BITS_PER_LONG)];
 	unsigned long vif_mask;
 
 	struct delayed_work cal_work;
@@ -153,9 +151,6 @@ struct mt76x0_dev {
 	struct workqueue_struct *stat_wq;
 	struct delayed_work stat_work;
 
-	struct mt76_wcid *mon_wcid;
-	struct mt76_wcid __rcu *wcid[N_WCIDS];
-
 	spinlock_t mac_lock;
 
 	const u16 *beacon_offsets;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index fd2baa5cc92d..73ea6d3097f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -150,7 +150,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
 	struct mt76x02_sta *msta = NULL;
-	struct mt76_wcid *wcid = dev->mon_wcid;
+	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
 	struct mt76_txwi *txwi;
 	int pkt_len = skb->len;
 	int hw_q = skb2q(skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 63e88d9147a8..94c3f0cbee2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -95,8 +95,6 @@ struct mt76x2_dev {
 	struct mutex mutex;
 
 	const u16 *beacon_offsets;
-	unsigned long wcid_mask[128 / BITS_PER_LONG];
-
 	int txpower_conf;
 	int txpower_cur;
 
@@ -113,9 +111,6 @@ struct mt76x2_dev {
 
 	u32 aggr_stats[32];
 
-	struct mt76_wcid global_wcid;
-	struct mt76_wcid __rcu *wcid[128];
-
 	spinlock_t irq_lock;
 	u32 irqmask;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 11ff60360ce6..b613eb760be5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -81,7 +81,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
 	if (idx < 0) {
 		ret = -ENOSPC;
 		goto out;
@@ -101,7 +101,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	ewma_signal_init(&msta->rssi);
 
-	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
+	rcu_assign_pointer(dev->mt76.wcid[idx], &msta->wcid);
 
 out:
 	mutex_unlock(&dev->mt76.mutex);
@@ -119,11 +119,11 @@ int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int i;
 
 	mutex_lock(&dev->mt76.mutex);
-	rcu_assign_pointer(dev->wcid[idx], NULL);
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
-	mt76_wcid_free(dev->wcid_mask, idx);
+	mt76_wcid_free(dev->mt76.wcid_mask, idx);
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mutex_unlock(&dev->mt76.mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 9dca0e92e3f7..424d77a82f06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -213,8 +213,8 @@ void mt76x2_init_device(struct mt76x2_dev *dev)
 	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
 	dev->chainmask = 0x202;
-	dev->global_wcid.idx = 255;
-	dev->global_wcid.hw_key_idx = -1;
+	dev->mt76.global_wcid.idx = 255;
+	dev->mt76.global_wcid.hw_key_idx = -1;
 	dev->slottime = 9;
 
 	/* init antenna configuration */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index bdad454108b9..ec2326cd724b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -186,8 +186,8 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 	struct mt76x02_sta *msta = NULL;
 
 	rcu_read_lock();
-	if (stat->wcid < ARRAY_SIZE(dev->wcid))
-		wcid = rcu_dereference(dev->wcid[stat->wcid]);
+	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
+		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
 
 	if (wcid) {
 		void *priv;
@@ -477,10 +477,10 @@ mt76x2_rx_get_sta(struct mt76x2_dev *dev, u8 idx)
 {
 	struct mt76_wcid *wcid;
 
-	if (idx >= ARRAY_SIZE(dev->wcid))
+	if (idx >= ARRAY_SIZE(dev->mt76.wcid))
 		return NULL;
 
-	wcid = rcu_dereference(dev->wcid[idx]);
+	wcid = rcu_dereference(dev->mt76.wcid[idx]);
 	if (!wcid)
 		return NULL;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 4830ca20a32d..c38855342731 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -311,8 +311,8 @@ int mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev)
 	local_bh_disable();
 	rcu_read_lock();
 
-	for (i = 0; i < ARRAY_SIZE(dev->wcid_mask); i++) {
-		unsigned long mask = dev->wcid_mask[i];
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid_mask); i++) {
+		unsigned long mask = dev->mt76.wcid_mask[i];
 
 		if (!mask)
 			continue;
@@ -321,7 +321,7 @@ int mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev)
 			if (!(mask & 1))
 				continue;
 
-			wcid = rcu_dereference(dev->wcid[j]);
+			wcid = rcu_dereference(dev->mt76.wcid[j]);
 			if (!wcid)
 				continue;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index d968f9ad6f50..b6c6d657b2b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -24,7 +24,7 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mt76x2_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
-	struct mt76_wcid *wcid = &dev->global_wcid;
+	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
 
 	if (control->sta) {
 		struct mt76x02_sta *msta;
-- 
2.7.5
