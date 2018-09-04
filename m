Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:06:56 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 02/22] mt76: unify sta_add / sta_remove
Date: Tue,  4 Sep 2018 16:40:55 +0200
Message-Id: <1536072075-6990-3-git-send-email-sgruszka@redhat.com> (sfid-20180904_164137_928084_3C7004E9)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x0 and mt76x0 sta add/remove callback. We drop
mt76x0_mac_set_ampdu_factor() for now. Need to consider to add
it to common code, but mt76x2 don't do it so perhaps mt76x0 don't
need it as well.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 61 +--------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 63 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 62 ---------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  4 +-
 6 files changed, 73 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index bbfbd1ac74eb..e248298563bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -156,63 +156,6 @@ mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-static int
-mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-	       struct ieee80211_sta *sta)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	int ret = 0;
-	int idx = 0;
-	int i;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
-	if (idx < 0) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	msta->wcid.idx = idx;
-	msta->wcid.hw_key_idx = -1;
-	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
-	mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
-	rcu_assign_pointer(dev->mt76.wcid[idx], &msta->wcid);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x02_txq_init(&dev->mt76, sta->txq[i]);
-	mt76x0_mac_set_ampdu_factor(dev);
-
-out:
-	mutex_unlock(&dev->mt76.mutex);
-
-	return ret;
-}
-
-static int
-mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   struct ieee80211_sta *sta)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	int idx = msta->wcid.idx;
-	int i;
-
-	mutex_lock(&dev->mt76.mutex);
-	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
-	mt76_wcid_free(dev->mt76.wcid_mask, idx);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76_txq_remove(&dev->mt76, sta->txq[i]);
-	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
-	mt76x0_mac_set_ampdu_factor(dev);
-	mutex_unlock(&dev->mt76.mutex);
-
-	return 0;
-}
-
 static void
 mt76x0_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
@@ -363,8 +306,8 @@ const struct ieee80211_ops mt76x0_ops = {
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x0_bss_info_changed,
-	.sta_add = mt76x0_sta_add,
-	.sta_remove = mt76x0_sta_remove,
+	.sta_add = mt76x02_sta_add,
+	.sta_remove = mt76x02_sta_remove,
 	.sta_notify = mt76x0_sta_notify,
 	.set_key = mt76x0_set_key,
 	.conf_tx = mt76x0_conf_tx,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 971e2d9f9ca3..07df1e979be5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -17,6 +17,7 @@
 
 #include "mt76.h"
 #include "mt76x02_regs.h"
+#include "mt76x02_mac.h"
 
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			     unsigned int changed_flags,
@@ -52,4 +53,66 @@ void mt76x02_configure_filter(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_configure_filter);
 
+int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
+	int ret = 0;
+	int idx = 0;
+	int i;
+
+	mutex_lock(&dev->mutex);
+
+	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
+	if (idx < 0) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	msta->vif = mvif;
+	msta->wcid.sta = 1;
+	msta->wcid.idx = idx;
+	msta->wcid.hw_key_idx = -1;
+	mt76x02_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
+	mt76x02_mac_wcid_set_drop(dev, idx, false);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76x02_txq_init(dev, sta->txq[i]);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
+
+	ewma_signal_init(&msta->rssi);
+
+	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
+
+out:
+	mutex_unlock(&dev->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76x02_sta_add);
+
+int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
+	int idx = msta->wcid.idx;
+	int i;
+
+	mutex_lock(&dev->mutex);
+	rcu_assign_pointer(dev->wcid[idx], NULL);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76_txq_remove(dev, sta->txq[i]);
+	mt76x02_mac_wcid_set_drop(dev, idx, true);
+	mt76_wcid_free(dev->wcid_mask, idx);
+	mt76x02_mac_wcid_setup(dev, idx, 0, NULL);
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 7ff3d473bc75..5d2acc685a35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -21,5 +21,8 @@
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			     unsigned int changed_flags,
 			     unsigned int *total_flags, u64 multicast);
-
+int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta);
+int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index b613eb760be5..5d5d2701aed8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -69,68 +69,6 @@ int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x2_ampdu_action);
 
-int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   struct ieee80211_sta *sta)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	int ret = 0;
-	int idx = 0;
-	int i;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
-	if (idx < 0) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	msta->vif = mvif;
-	msta->wcid.sta = 1;
-	msta->wcid.idx = idx;
-	msta->wcid.hw_key_idx = -1;
-	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x02_txq_init(&dev->mt76, sta->txq[i]);
-
-	if (vif->type == NL80211_IFTYPE_AP)
-		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
-
-	ewma_signal_init(&msta->rssi);
-
-	rcu_assign_pointer(dev->mt76.wcid[idx], &msta->wcid);
-
-out:
-	mutex_unlock(&dev->mt76.mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(mt76x2_sta_add);
-
-int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	int idx = msta->wcid.idx;
-	int i;
-
-	mutex_lock(&dev->mt76.mutex);
-	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76_txq_remove(&dev->mt76, sta->txq[i]);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
-	mt76_wcid_free(dev->mt76.wcid_mask, idx);
-	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
-	mutex_unlock(&dev->mt76.mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76x2_sta_remove);
-
 void mt76x2_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index f212f329cebe..9b1b3dfdd0dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -323,8 +323,8 @@ const struct ieee80211_ops mt76x2_ops = {
 	.config = mt76x2_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x2_bss_info_changed,
-	.sta_add = mt76x2_sta_add,
-	.sta_remove = mt76x2_sta_remove,
+	.sta_add = mt76x02_sta_add,
+	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x2_set_key,
 	.conf_tx = mt76x2_conf_tx,
 	.sw_scan_start = mt76x2_sw_scan,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 1b6a04d202bb..6b110c695b4b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -171,8 +171,8 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.stop = mt76x2u_stop,
 	.add_interface = mt76x2u_add_interface,
 	.remove_interface = mt76x2_remove_interface,
-	.sta_add = mt76x2_sta_add,
-	.sta_remove = mt76x2_sta_remove,
+	.sta_add = mt76x02_sta_add,
+	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x2_set_key,
 	.ampdu_action = mt76x2_ampdu_action,
 	.config = mt76x2u_config,
-- 
2.7.5
