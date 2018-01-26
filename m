Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53400 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbeAZKrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 05:47:45 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] mt76: implement AP_LINK_PS
Date: Fri, 26 Jan 2018 11:47:42 +0100
Message-Id: <20180126104742.14315-1-nbd@nbd.name> (sfid-20180126_114750_250759_D744C1D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With software A-MPDU reordering in place, frames that notify mac80211 of
powersave changes are reordered as well, which can cause connection
stalls. Fix this by implementing powersave state processing in the
driver.

Fixes: aee5b8cf2477 ("mt76: implement A-MPDU rx reordering in the driver code")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 52 +++++++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h        | 10 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 28 ++++++-------
 5 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5fcb2deb89a2..85f8d324ebf8 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -276,6 +276,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	ieee80211_hw_set(hw, TX_AMSDU);
 	ieee80211_hw_set(hw, TX_FRAG_LIST);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, AP_LINK_PS);
 
 	wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
@@ -470,6 +471,53 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 	return 0;
 }
 
+static void
+mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sta *sta;
+	struct mt76_wcid *wcid = status->wcid;
+	bool ps;
+
+	if (!wcid || !wcid->sta)
+		return;
+
+	sta = container_of((void *) wcid, struct ieee80211_sta, drv_priv);
+
+	if (!test_bit(MT_WCID_FLAG_CHECK_PS, &wcid->flags))
+		return;
+
+	if (ieee80211_is_pspoll(hdr->frame_control)) {
+		ieee80211_sta_pspoll(sta);
+		return;
+	}
+
+	if (ieee80211_has_morefrags(hdr->frame_control) ||
+		!(ieee80211_is_mgmt(hdr->frame_control) ||
+		  ieee80211_is_data(hdr->frame_control)))
+		return;
+
+	ps = ieee80211_has_pm(hdr->frame_control);
+
+	if (ps && (ieee80211_is_data_qos(hdr->frame_control) ||
+		   ieee80211_is_qos_nullfunc(hdr->frame_control)))
+		ieee80211_sta_uapsd_trigger(sta, status->tid);
+
+	if (!!test_bit(MT_WCID_FLAG_PS, &wcid->flags) == ps)
+		return;
+
+	if (ps) {
+		set_bit(MT_WCID_FLAG_PS, &wcid->flags);
+		mt76_stop_tx_queues(dev, sta, true);
+	} else {
+		clear_bit(MT_WCID_FLAG_PS, &wcid->flags);
+	}
+
+	ieee80211_sta_ps_transition(sta, ps);
+	dev->drv->sta_ps(dev, sta, ps);
+}
+
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		      int queue)
 {
@@ -498,8 +546,10 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 
 	__skb_queue_head_init(&frames);
 
-	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL)
+	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL) {
+		mt76_check_ps(dev, skb);
 		mt76_rx_aggr_reorder(skb, &frames);
+	}
 
 	mt76_rx_complete(dev, &frames, q);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 129015c9d116..d2ce15093edd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -121,11 +121,18 @@ struct mt76_queue_ops {
 	void (*kick)(struct mt76_dev *dev, struct mt76_queue *q);
 };
 
+enum mt76_wcid_flags {
+	MT_WCID_FLAG_CHECK_PS,
+	MT_WCID_FLAG_PS,
+};
+
 struct mt76_wcid {
 	struct mt76_rx_tid __rcu *aggr[IEEE80211_NUM_TIDS];
 
 	struct work_struct aggr_work;
 
+	unsigned long flags;
+
 	u8 idx;
 	u8 hw_key_idx;
 
@@ -206,6 +213,9 @@ struct mt76_driver_ops {
 		       struct sk_buff *skb);
 
 	void (*rx_poll_complete)(struct mt76_dev *dev, enum mt76_rxq_id q);
+
+	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
+		       bool ps);
 };
 
 struct mt76_channel_state {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 17df17afd9bf..e62131b88102 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -218,6 +218,8 @@ void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
 void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
 
+void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
+
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
 s8 mt76x2_tx_get_max_txpwr_adj(struct mt76x2_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 1b00ae4465a2..9dbf94947324 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -630,6 +630,7 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.tx_complete_skb = mt76x2_tx_complete_skb,
 		.rx_skb = mt76x2_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
+		.sta_ps = mt76x2_sta_ps,
 	};
 	struct ieee80211_hw *hw;
 	struct mt76x2_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index bf26284b9989..205043b470b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -282,6 +282,9 @@ mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76x2_txq_init(dev, sta->txq[i]);
 
+	if (vif->type == NL80211_IFTYPE_AP)
+		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
+
 	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
 
 out:
@@ -311,23 +314,14 @@ mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 
-static void
-mt76x2_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
+void
+mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 {
 	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 	int idx = msta->wcid.idx;
 
-	switch (cmd) {
-	case STA_NOTIFY_SLEEP:
-		mt76x2_mac_wcid_set_drop(dev, idx, true);
-		mt76_stop_tx_queues(&dev->mt76, sta, true);
-		break;
-	case STA_NOTIFY_AWAKE:
-		mt76x2_mac_wcid_set_drop(dev, idx, false);
-		break;
-	}
+	mt76x2_mac_wcid_set_drop(dev, idx, ps);
 }
 
 static int
@@ -549,6 +543,12 @@ static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mutex);
 }
 
+static int
+mt76x2_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
+{
+	return 0;
+}
+
 const struct ieee80211_ops mt76x2_ops = {
 	.tx = mt76x2_tx,
 	.start = mt76x2_start,
@@ -560,7 +560,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.bss_info_changed = mt76x2_bss_info_changed,
 	.sta_add = mt76x2_sta_add,
 	.sta_remove = mt76x2_sta_remove,
-	.sta_notify = mt76x2_sta_notify,
 	.set_key = mt76x2_set_key,
 	.conf_tx = mt76x2_conf_tx,
 	.sw_scan_start = mt76x2_sw_scan,
@@ -573,5 +572,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x2_set_coverage_class,
 	.get_survey = mt76_get_survey,
+	.set_tim = mt76x2_set_tim,
 };
 
-- 
2.14.2
