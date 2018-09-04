Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727595AbeIDTHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 10/22] mt76: unify conf_tx
Date: Tue,  4 Sep 2018 16:41:03 +0200
Message-Id: <1536072075-6990-11-git-send-email-sgruszka@redhat.com> (sfid-20180904_164250_211655_3D384267)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use one conf_tx implementation in mt76x0 and mt76x2. Note this change
conf_tx for mt76x0, but it should work with mt76x2 version.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 -
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 57 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 44 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 44 -----------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  2 +-
 8 files changed, 49 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 24fe92febe50..f87103aea868 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -219,7 +219,7 @@ const struct ieee80211_ops mt76x0_ops = {
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
-	.conf_tx = mt76x0_conf_tx,
+	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x0_sw_scan,
 	.sw_scan_complete = mt76x0_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 3fc2b6efeda3..e65e6c09877c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -246,8 +246,6 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev);
 /* TX */
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
-int mt76x0_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		    u16 queue, const struct ieee80211_tx_queue_params *params);
 void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb);
 void mt76x0_tx_stat(struct work_struct *work);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index acf830bc9b4e..ce80763ec557 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -211,60 +211,3 @@ void mt76x0_tx_stat(struct work_struct *work)
 		clear_bit(MT76_READING_STATS, &dev->mt76.state);
 	spin_unlock_irqrestore(&dev->tx_lock, flags);
 }
-
-int mt76x0_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		    u16 queue, const struct ieee80211_tx_queue_params *params)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	u8 cw_min = 5, cw_max = 10, hw_q = mt76_ac_to_hwq(queue);
-	u32 val;
-
-	/* TODO: should we do funny things with the parameters?
-	 *	 See what mt76x0_set_default_edca() used to do in init.c.
-	 */
-
-	if (params->cw_min)
-		cw_min = fls(params->cw_min);
-	if (params->cw_max)
-		cw_max = fls(params->cw_max);
-
-	WARN_ON(params->txop > 0xff);
-	WARN_ON(params->aifs > 0xf);
-	WARN_ON(cw_min > 0xf);
-	WARN_ON(cw_max > 0xf);
-
-	val = FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
-	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
-	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
-	/* TODO: based on user-controlled EnableTxBurst var vendor drv sets
-	 *	 a really long txop on AC0 (see connect.c:2009) but only on
-	 *	 connect? When not connected should be 0.
-	 */
-	if (!hw_q)
-		val |= 0x60;
-	else
-		val |= FIELD_PREP(MT_EDCA_CFG_TXOP, params->txop);
-	mt76_wr(dev, MT_EDCA_CFG_AC(hw_q), val);
-
-	val = mt76_rr(dev, MT_WMM_TXOP(hw_q));
-	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(hw_q));
-	val |= params->txop << MT_WMM_TXOP_SHIFT(hw_q);
-	mt76_wr(dev, MT_WMM_TXOP(hw_q), val);
-
-	val = mt76_rr(dev, MT_WMM_AIFSN);
-	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(hw_q));
-	val |= params->aifs << MT_WMM_AIFSN_SHIFT(hw_q);
-	mt76_wr(dev, MT_WMM_AIFSN, val);
-
-	val = mt76_rr(dev, MT_WMM_CWMIN);
-	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(hw_q));
-	val |= cw_min << MT_WMM_CWMIN_SHIFT(hw_q);
-	mt76_wr(dev, MT_WMM_CWMIN, val);
-
-	val = mt76_rr(dev, MT_WMM_CWMAX);
-	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(hw_q));
-	val |= cw_max << MT_WMM_CWMAX_SHIFT(hw_q);
-	mt76_wr(dev, MT_WMM_CWMAX, val);
-
-	return 0;
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 4375fce0606d..706f522f11d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -244,4 +244,48 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_key);
 
+int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   u16 queue, const struct ieee80211_tx_queue_params *params)
+{
+	struct mt76_dev *dev = hw->priv;
+	u8 cw_min = 5, cw_max = 10, qid;
+	u32 val;
+
+	qid = mt76_ac_to_hwq(queue);
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
+	__mt76_wr(dev, MT_EDCA_CFG_AC(qid), val);
+
+	val = __mt76_rr(dev, MT_WMM_TXOP(qid));
+	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(qid));
+	val |= params->txop << MT_WMM_TXOP_SHIFT(qid);
+	__mt76_wr(dev, MT_WMM_TXOP(qid), val);
+
+	val = __mt76_rr(dev, MT_WMM_AIFSN);
+	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(qid));
+	val |= params->aifs << MT_WMM_AIFSN_SHIFT(qid);
+	__mt76_wr(dev, MT_WMM_AIFSN, val);
+
+	val = __mt76_rr(dev, MT_WMM_CWMIN);
+	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(qid));
+	val |= cw_min << MT_WMM_CWMIN_SHIFT(qid);
+	__mt76_wr(dev, MT_WMM_CWMIN, val);
+
+	val = __mt76_rr(dev, MT_WMM_CWMAX);
+	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(qid));
+	val |= cw_max << MT_WMM_CWMAX_SHIFT(qid);
+	__mt76_wr(dev, MT_WMM_CWMAX, val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_conf_tx);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 31f144d7f6d5..54f895d8cdbe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -31,8 +31,9 @@ void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 
 int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_ampdu_params *params);
-
 int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		   struct ieee80211_key_conf *key);
+int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   u16 queue, const struct ieee80211_tx_queue_params *params);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index ead53faa1fb3..5ce9fbc654a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -27,50 +27,6 @@ void mt76x2_remove_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x2_remove_interface);
 
-int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   u16 queue, const struct ieee80211_tx_queue_params *params)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	u8 cw_min = 5, cw_max = 10, qid;
-	u32 val;
-
-	qid = mt76_ac_to_hwq(queue);
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
-EXPORT_SYMBOL_GPL(mt76x2_conf_tx);
-
 void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 143d8abed403..87302845d582 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -321,7 +321,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
-	.conf_tx = mt76x2_conf_tx,
+	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x2_sw_scan,
 	.sw_scan_complete = mt76x2_sw_scan_complete,
 	.flush = mt76x2_flush,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 62d0eb75cac3..1dcc6ced15a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -173,7 +173,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.bss_info_changed = mt76x2u_bss_info_changed,
 	.configure_filter = mt76x02_configure_filter,
-	.conf_tx = mt76x2_conf_tx,
+	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x2u_sw_scan,
 	.sw_scan_complete = mt76x2u_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x2_sta_rate_tbl_update,
-- 
2.7.5
