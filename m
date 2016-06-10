Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:36829 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbcFJMy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:54:59 -0400
Received: by mail-qg0-f65.google.com with SMTP id k43so5177929qgk.3
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 05:54:58 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath10k: fix potential null dereference bugs
Date: Fri, 10 Jun 2016 08:52:44 -0400
Message-Id: <1465563164-783-1-git-send-email-me@bobcopeland.com> (sfid-20160610_145504_275762_DD202546)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch warns about a number of cases in ath10k where a pointer is
null-checked after it has already been dereferenced, in code involving
ath10k private virtual interface pointers.

Fix these by making the dereference happen later.

Addresses the following smatch warnings:

drivers/net/wireless/ath/ath10k/mac.c:3651 ath10k_mac_txq_init() warn: variable dereferenced before check 'txq' (see line 3649)
drivers/net/wireless/ath/ath10k/mac.c:3664 ath10k_mac_txq_unref() warn: variable dereferenced before check 'txq' (see line 3659)
drivers/net/wireless/ath/ath10k/htt_tx.c:70 __ath10k_htt_tx_txq_recalc() warn: variable dereferenced before check 'txq->sta' (see line 52)
drivers/net/wireless/ath/ath10k/htt_tx.c:740 ath10k_htt_tx_get_vdev_id() warn: variable dereferenced before check 'cb->vif' (see line 736)
drivers/net/wireless/ath/ath10k/txrx.c:86 ath10k_txrx_tx_unref() warn: variable dereferenced before check 'txq' (see line 84)
drivers/net/wireless/ath/ath10k/wmi.c:1837 ath10k_wmi_op_gen_mgmt_tx() warn: variable dereferenced before check 'cb->vif' (see line 1825)

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
Although I glanced at a few cases, by and large I didn't check
whether the if() tests were correct but assumed they were.

Also, I only compile-tested this.

 drivers/net/wireless/ath/ath10k/htt_tx.c | 15 +++++++++------
 drivers/net/wireless/ath/ath10k/mac.c    |  6 ++++--
 drivers/net/wireless/ath/ath10k/txrx.c   |  5 +++--
 drivers/net/wireless/ath/ath10k/wmi.c    |  8 +++++---
 4 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 6269c61..dfcc43d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -49,7 +49,7 @@ static void __ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
 				       struct ieee80211_txq *txq)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_sta *arsta = (void *)txq->sta->drv_priv;
+	struct ath10k_sta *arsta;
 	struct ath10k_vif *arvif = (void *)txq->vif->drv_priv;
 	unsigned long frame_cnt;
 	unsigned long byte_cnt;
@@ -67,10 +67,12 @@ static void __ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
 	if (ar->htt.tx_q_state.mode != HTT_TX_MODE_SWITCH_PUSH_PULL)
 		return;
 
-	if (txq->sta)
+	if (txq->sta) {
+		arsta = (void *)txq->sta->drv_priv;
 		peer_id = arsta->peer_id;
-	else
+	} else {
 		peer_id = arvif->peer_id;
+	}
 
 	tid = txq->tid;
 	bit = BIT(peer_id % 32);
@@ -733,13 +735,14 @@ static u8 ath10k_htt_tx_get_vdev_id(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
-	struct ath10k_vif *arvif = (void *)cb->vif->drv_priv;
+	struct ath10k_vif *arvif;
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
 		return ar->scan.vdev_id;
-	else if (cb->vif)
+	else if (cb->vif) {
+		arvif = (void *)cb->vif->drv_priv;
 		return arvif->vdev_id;
-	else if (ar->monitor_started)
+	} else if (ar->monitor_started)
 		return ar->monitor_vdev_id;
 	else
 		return 0;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6dd1d26..4eee4b9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3646,17 +3646,18 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 
 static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+	struct ath10k_txq *artxq;
 
 	if (!txq)
 		return;
 
+	artxq = (void *)txq->drv_priv;
 	INIT_LIST_HEAD(&artxq->list);
 }
 
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+	struct ath10k_txq *artxq;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
 	int msdu_id;
@@ -3664,6 +3665,7 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 	if (!txq)
 		return;
 
+	artxq = (void *)txq->drv_priv;
 	spin_lock_bh(&ar->txqs_lock);
 	if (!list_empty(&artxq->list))
 		list_del_init(&artxq->list);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 576e7c4..9f17863 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -81,10 +81,11 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	skb_cb = ATH10K_SKB_CB(msdu);
 	txq = skb_cb->txq;
-	artxq = (void *)txq->drv_priv;
 
-	if (txq)
+	if (txq) {
+		artxq = (void *)txq->drv_priv;
 		artxq->num_fw_queued--;
+	}
 
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2c30032..60f78a6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1822,7 +1822,7 @@ static struct sk_buff *
 ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 {
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(msdu);
-	struct ath10k_vif *arvif = (void *)cb->vif->drv_priv;
+	struct ath10k_vif *arvif;
 	struct wmi_mgmt_tx_cmd *cmd;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
@@ -1834,10 +1834,12 @@ ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 	hdr = (struct ieee80211_hdr *)msdu->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (cb->vif)
+	if (cb->vif) {
+		arvif = (void *)cb->vif->drv_priv;
 		vdev_id = arvif->vdev_id;
-	else
+	} else {
 		vdev_id = 0;
+	}
 
 	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control)))
 		return ERR_PTR(-EINVAL);
-- 
2.1.4

