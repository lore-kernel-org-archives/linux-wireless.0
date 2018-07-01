Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:42111 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbeGAONX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 10:13:23 -0400
Received: by mail-wr0-f195.google.com with SMTP id p1-v6so13013285wrs.9
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2018 07:13:22 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 15/19] mt76: add mt76x2_common to mt76x2-common module
Date: Sun,  1 Jul 2018 16:12:27 +0200
Message-Id: <20180701141231.25323-16-lorenzo.bianconi@redhat.com> (sfid-20180701_161346_037038_E41EB151)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move core related code shared between mt76x2 and mt76x2u in
mt76x2-common module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  21 ++
 .../wireless/mediatek/mt76/mt76x2_common.c    | 350 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |  21 --
 .../net/wireless/mediatek/mt76/mt76x2_main.c  | 307 ---------------
 5 files changed, 372 insertions(+), 329 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_common.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 8342b4d38220..a184e16a5d54 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -9,7 +9,7 @@ CFLAGS_trace.o := -I$(src)
 
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
-	mt76x2_init_common.o
+	mt76x2_init_common.o mt76x2_common.o
 
 mt76x2e-y := \
 	mt76x2_pci.o mt76x2_dma.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 506a5625b27c..dc0ca50770e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -292,4 +292,25 @@ void mt76x2_init_txpower(struct mt76x2_dev *dev,
 			 struct ieee80211_supported_band *sband);
 void mt76_write_mac_initvals(struct mt76x2_dev *dev);
 
+int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_ampdu_params *params);
+int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta);
+int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
+void mt76x2_remove_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif);
+int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key);
+int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   u16 queue, const struct ieee80211_tx_queue_params *params);
+void mt76x2_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags, u64 multicast);
+void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq);
+void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta);
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
new file mode 100644
index 000000000000..a2338ba139b4
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -0,0 +1,350 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mt76x2.h"
+
+void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
+{
+	struct mt76_txq *mtxq;
+
+	if (!txq)
+		return;
+
+	mtxq = (struct mt76_txq *) txq->drv_priv;
+	if (txq->sta) {
+		struct mt76x2_sta *sta;
+
+		sta = (struct mt76x2_sta *) txq->sta->drv_priv;
+		mtxq->wcid = &sta->wcid;
+	} else {
+		struct mt76x2_vif *mvif;
+
+		mvif = (struct mt76x2_vif *) txq->vif->drv_priv;
+		mtxq->wcid = &mvif->group_wcid;
+	}
+
+	mt76_txq_init(&dev->mt76, txq);
+}
+EXPORT_SYMBOL_GPL(mt76x2_txq_init);
+
+int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_ampdu_params *params)
+{
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	struct ieee80211_sta *sta = params->sta;
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct ieee80211_txq *txq = sta->txq[params->tid];
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	struct mt76_txq *mtxq;
+
+	if (!txq)
+		return -EINVAL;
+
+	mtxq = (struct mt76_txq *)txq->drv_priv;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, *ssn, params->buf_size);
+		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
+		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4,
+			   BIT(16 + tid));
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		mtxq->aggr = true;
+		mtxq->send_bar = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		mtxq->aggr = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		mtxq->agg_ssn = *ssn << 4;
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		mtxq->aggr = false;
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x2_ampdu_action);
+
+int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
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
+	mt76x2_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
+	mt76x2_mac_wcid_set_drop(dev, idx, false);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76x2_txq_init(dev, sta->txq[i]);
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
+EXPORT_SYMBOL_GPL(mt76x2_sta_add);
+
+int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	int idx = msta->wcid.idx;
+	int i;
+
+	mutex_lock(&dev->mutex);
+	rcu_assign_pointer(dev->wcid[idx], NULL);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76_txq_remove(&dev->mt76, sta->txq[i]);
+	mt76x2_mac_wcid_set_drop(dev, idx, true);
+	mt76_wcid_free(dev->wcid_mask, idx);
+	mt76x2_mac_wcid_setup(dev, idx, 0, NULL);
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x2_sta_remove);
+
+void mt76x2_remove_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mt76_txq_remove(&dev->mt76, vif->txq);
+}
+EXPORT_SYMBOL_GPL(mt76x2_remove_interface);
+
+int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x2_sta *msta;
+	struct mt76_wcid *wcid;
+	int idx = key->keyidx;
+	int ret;
+
+	/* fall back to sw encryption for unsupported ciphers */
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * The hardware does not support per-STA RX GTK, fall back
+	 * to software mode for these.
+	 */
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
+	msta = sta ? (struct mt76x2_sta *) sta->drv_priv : NULL;
+	wcid = msta ? &msta->wcid : &mvif->group_wcid;
+
+	if (cmd == SET_KEY) {
+		key->hw_key_idx = wcid->idx;
+		wcid->hw_key_idx = idx;
+		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+			wcid->sw_iv = true;
+		}
+	} else {
+		if (idx == wcid->hw_key_idx) {
+			wcid->hw_key_idx = -1;
+			wcid->sw_iv = true;
+		}
+
+		key = NULL;
+	}
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
+
+	if (!msta) {
+		if (key || wcid->hw_key_idx == idx) {
+			ret = mt76x2_mac_wcid_set_key(dev, wcid->idx, key);
+			if (ret)
+				return ret;
+		}
+
+		return mt76x2_mac_shared_key_setup(dev, mvif->idx, idx, key);
+	}
+
+	return mt76x2_mac_wcid_set_key(dev, msta->wcid.idx, key);
+}
+EXPORT_SYMBOL_GPL(mt76x2_set_key);
+
+int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   u16 queue, const struct ieee80211_tx_queue_params *params)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	u8 cw_min = 5, cw_max = 10, qid;
+	u32 val;
+
+	qid = dev->mt76.q_tx[queue].hw_idx;
+
+	if (params->cw_min)
+		cw_min = fls(params->cw_min);
+	if (params->cw_max)
+		cw_max = fls(params->cw_max);
+
+	val = FIELD_PREP(MT_EDCA_CFG_TXOP, params->txop) |
+	      FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
+	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
+	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
+	mt76_wr(dev, MT_EDCA_CFG_AC(qid), val);
+
+	val = mt76_rr(dev, MT_WMM_TXOP(qid));
+	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(qid));
+	val |= params->txop << MT_WMM_TXOP_SHIFT(qid);
+	mt76_wr(dev, MT_WMM_TXOP(qid), val);
+
+	val = mt76_rr(dev, MT_WMM_AIFSN);
+	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(qid));
+	val |= params->aifs << MT_WMM_AIFSN_SHIFT(qid);
+	mt76_wr(dev, MT_WMM_AIFSN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMIN);
+	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(qid));
+	val |= cw_min << MT_WMM_CWMIN_SHIFT(qid);
+	mt76_wr(dev, MT_WMM_CWMIN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMAX);
+	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(qid));
+	val |= cw_max << MT_WMM_CWMAX_SHIFT(qid);
+	mt76_wr(dev, MT_WMM_CWMAX, val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x2_conf_tx);
+
+void mt76x2_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags, u64 multicast)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	u32 flags = 0;
+
+#define MT76_FILTER(_flag, _hw) do { \
+		flags |= *total_flags & FIF_##_flag;			\
+		dev->rxfilter &= ~(_hw);				\
+		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
+	} while (0)
+
+	mutex_lock(&dev->mutex);
+
+	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
+
+	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
+	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
+	MT76_FILTER(CONTROL, MT_RX_FILTR_CFG_ACK |
+			     MT_RX_FILTR_CFG_CTS |
+			     MT_RX_FILTR_CFG_CFEND |
+			     MT_RX_FILTR_CFG_CFACK |
+			     MT_RX_FILTR_CFG_BA |
+			     MT_RX_FILTR_CFG_CTRL_RSV);
+	MT76_FILTER(PSPOLL, MT_RX_FILTR_CFG_PSPOLL);
+
+	*total_flags = flags;
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+
+	mutex_unlock(&dev->mutex);
+}
+EXPORT_SYMBOL_GPL(mt76x2_configure_filter);
+
+void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
+	struct ieee80211_tx_rate rate = {};
+
+	if (!rates)
+		return;
+
+	rate.idx = rates->rate[0].idx;
+	rate.flags = rates->rate[0].flags;
+	mt76x2_mac_wcid_set_rate(dev, &msta->wcid, &rate);
+	msta->wcid.max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(dev, &rate);
+}
+EXPORT_SYMBOL_GPL(mt76x2_sta_rate_tbl_update);
+
+void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	void *rxwi = skb->data;
+
+	if (q == MT_RXQ_MCU) {
+		skb_queue_tail(&dev->mcu.res_q, skb);
+		wake_up(&dev->mcu.wait);
+		return;
+	}
+
+	skb_pull(skb, sizeof(struct mt76x2_rxwi));
+	if (mt76x2_mac_process_rx(dev, skb, rxwi)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	mt76_rx(&dev->mt76, q, skb);
+}
+EXPORT_SYMBOL_GPL(mt76x2_queue_rx_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index fd1ec4743e0b..6720a6a1313f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -66,27 +66,6 @@ mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 	return 0;
 }
 
-void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
-			 struct sk_buff *skb)
-{
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
-	void *rxwi = skb->data;
-
-	if (q == MT_RXQ_MCU) {
-		skb_queue_tail(&dev->mcu.res_q, skb);
-		wake_up(&dev->mcu.wait);
-		return;
-	}
-
-	skb_pull(skb, sizeof(struct mt76x2_rxwi));
-	if (mt76x2_mac_process_rx(dev, skb, rxwi)) {
-		dev_kfree_skb(skb);
-		return;
-	}
-
-	mt76_rx(&dev->mt76, q, skb);
-}
-
 static int
 mt76x2_init_rx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 3c0ebe6d231c..f521cace760b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -53,30 +53,6 @@ mt76x2_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&dev->mutex);
 }
 
-static void
-mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
-{
-	struct mt76_txq *mtxq;
-
-	if (!txq)
-		return;
-
-	mtxq = (struct mt76_txq *) txq->drv_priv;
-	if (txq->sta) {
-		struct mt76x2_sta *sta;
-
-		sta = (struct mt76x2_sta *) txq->sta->drv_priv;
-		mtxq->wcid = &sta->wcid;
-	} else {
-		struct mt76x2_vif *mvif;
-
-		mvif = (struct mt76x2_vif *) txq->vif->drv_priv;
-		mtxq->wcid = &mvif->group_wcid;
-	}
-
-	mt76_txq_init(&dev->mt76, txq);
-}
-
 static int
 mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -111,14 +87,6 @@ mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	return 0;
 }
 
-static void
-mt76x2_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-{
-	struct mt76x2_dev *dev = hw->priv;
-
-	mt76_txq_remove(&dev->mt76, vif->txq);
-}
-
 static int
 mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 {
@@ -193,39 +161,6 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 
-static void
-mt76x2_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
-			unsigned int *total_flags, u64 multicast)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	u32 flags = 0;
-
-#define MT76_FILTER(_flag, _hw) do { \
-		flags |= *total_flags & FIF_##_flag;			\
-		dev->rxfilter &= ~(_hw);				\
-		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
-	} while (0)
-
-	mutex_lock(&dev->mutex);
-
-	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
-
-	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
-	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
-	MT76_FILTER(CONTROL, MT_RX_FILTR_CFG_ACK |
-			     MT_RX_FILTR_CFG_CTS |
-			     MT_RX_FILTR_CFG_CFEND |
-			     MT_RX_FILTR_CFG_CFACK |
-			     MT_RX_FILTR_CFG_BA |
-			     MT_RX_FILTR_CFG_CTRL_RSV);
-	MT76_FILTER(PSPOLL, MT_RX_FILTR_CFG_PSPOLL);
-
-	*total_flags = flags;
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
-
-	mutex_unlock(&dev->mutex);
-}
-
 static void
 mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *info, u32 changed)
@@ -263,68 +198,6 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mutex);
 }
 
-static int
-mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-	       struct ieee80211_sta *sta)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
-	int ret = 0;
-	int idx = 0;
-	int i;
-
-	mutex_lock(&dev->mutex);
-
-	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
-	if (idx < 0) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	msta->vif = mvif;
-	msta->wcid.sta = 1;
-	msta->wcid.idx = idx;
-	msta->wcid.hw_key_idx = -1;
-	mt76x2_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
-	mt76x2_mac_wcid_set_drop(dev, idx, false);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x2_txq_init(dev, sta->txq[i]);
-
-	if (vif->type == NL80211_IFTYPE_AP)
-		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
-
-	ewma_signal_init(&msta->rssi);
-
-	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
-
-out:
-	mutex_unlock(&dev->mutex);
-
-	return ret;
-}
-
-static int
-mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		  struct ieee80211_sta *sta)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
-	int idx = msta->wcid.idx;
-	int i;
-
-	mutex_lock(&dev->mutex);
-	rcu_assign_pointer(dev->wcid[idx], NULL);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76_txq_remove(&dev->mt76, sta->txq[i]);
-	mt76x2_mac_wcid_set_drop(dev, idx, true);
-	mt76_wcid_free(dev->wcid_mask, idx);
-	mt76x2_mac_wcid_setup(dev, idx, 0, NULL);
-	mutex_unlock(&dev->mutex);
-
-	return 0;
-}
-
 void
 mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 {
@@ -336,117 +209,6 @@ mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	mt76x2_mac_wcid_set_drop(dev, idx, ps);
 }
 
-static int
-mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-	       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-	       struct ieee80211_key_conf *key)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
-	struct mt76x2_sta *msta;
-	struct mt76_wcid *wcid;
-	int idx = key->keyidx;
-	int ret;
-
-	/* fall back to sw encryption for unsupported ciphers */
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
-	case WLAN_CIPHER_SUITE_TKIP:
-	case WLAN_CIPHER_SUITE_CCMP:
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	/*
-	 * The hardware does not support per-STA RX GTK, fall back
-	 * to software mode for these.
-	 */
-	if ((vif->type == NL80211_IFTYPE_ADHOC ||
-	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
-	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
-	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
-	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
-		return -EOPNOTSUPP;
-
-	msta = sta ? (struct mt76x2_sta *) sta->drv_priv : NULL;
-	wcid = msta ? &msta->wcid : &mvif->group_wcid;
-
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
-			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
-			wcid->sw_iv = true;
-		}
-	} else {
-		if (idx == wcid->hw_key_idx) {
-			wcid->hw_key_idx = -1;
-			wcid->sw_iv = true;
-		}
-
-		key = NULL;
-	}
-	mt76_wcid_key_setup(&dev->mt76, wcid, key);
-
-	if (!msta) {
-		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x2_mac_wcid_set_key(dev, wcid->idx, key);
-			if (ret)
-				return ret;
-		}
-
-		return mt76x2_mac_shared_key_setup(dev, mvif->idx, idx, key);
-	}
-
-	return mt76x2_mac_wcid_set_key(dev, msta->wcid.idx, key);
-}
-
-static int
-mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
-	       const struct ieee80211_tx_queue_params *params)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	u8 cw_min = 5, cw_max = 10, qid;
-	u32 val;
-
-	qid = dev->mt76.q_tx[queue].hw_idx;
-
-	if (params->cw_min)
-		cw_min = fls(params->cw_min);
-	if (params->cw_max)
-		cw_max = fls(params->cw_max);
-
-	val = FIELD_PREP(MT_EDCA_CFG_TXOP, params->txop) |
-	      FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
-	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
-	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
-	mt76_wr(dev, MT_EDCA_CFG_AC(qid), val);
-
-	val = mt76_rr(dev, MT_WMM_TXOP(qid));
-	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(qid));
-	val |= params->txop << MT_WMM_TXOP_SHIFT(qid);
-	mt76_wr(dev, MT_WMM_TXOP(qid), val);
-
-	val = mt76_rr(dev, MT_WMM_AIFSN);
-	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(qid));
-	val |= params->aifs << MT_WMM_AIFSN_SHIFT(qid);
-	mt76_wr(dev, MT_WMM_AIFSN, val);
-
-	val = mt76_rr(dev, MT_WMM_CWMIN);
-	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(qid));
-	val |= cw_min << MT_WMM_CWMIN_SHIFT(qid);
-	mt76_wr(dev, MT_WMM_CWMIN, val);
-
-	val = mt76_rr(dev, MT_WMM_CWMAX);
-	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(qid));
-	val |= cw_max << MT_WMM_CWMAX_SHIFT(qid);
-	mt76_wr(dev, MT_WMM_CWMAX, val);
-
-	return 0;
-}
-
 static void
 mt76x2_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       const u8 *mac)
@@ -485,75 +247,6 @@ mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
 	return 0;
 }
 
-static int
-mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		    struct ieee80211_ampdu_params *params)
-{
-	enum ieee80211_ampdu_mlme_action action = params->action;
-	struct ieee80211_sta *sta = params->sta;
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
-	struct ieee80211_txq *txq = sta->txq[params->tid];
-	u16 tid = params->tid;
-	u16 *ssn = &params->ssn;
-	struct mt76_txq *mtxq;
-
-	if (!txq)
-		return -EINVAL;
-
-	mtxq = (struct mt76_txq *)txq->drv_priv;
-
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, *ssn, params->buf_size);
-		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
-		break;
-	case IEEE80211_AMPDU_RX_STOP:
-		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
-		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4,
-			   BIT(16 + tid));
-		break;
-	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		mtxq->aggr = true;
-		mtxq->send_bar = false;
-		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
-		break;
-	case IEEE80211_AMPDU_TX_STOP_FLUSH:
-	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		mtxq->aggr = false;
-		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
-		break;
-	case IEEE80211_AMPDU_TX_START:
-		mtxq->agg_ssn = *ssn << 4;
-		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-	case IEEE80211_AMPDU_TX_STOP_CONT:
-		mtxq->aggr = false;
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-	}
-
-	return 0;
-}
-
-static void
-mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			   struct ieee80211_sta *sta)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
-	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
-	struct ieee80211_tx_rate rate = {};
-
-	if (!rates)
-		return;
-
-	rate.idx = rates->rate[0].idx;
-	rate.flags = rates->rate[0].flags;
-	mt76x2_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-	msta->wcid.max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(dev, &rate);
-}
-
 static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
 				      s16 coverage_class)
 {
-- 
2.18.0
