Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44680 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab3IZPrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:40 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 08/13] ath10k: bring back the WMI path for mgmt frames
Date: Thu, 26 Sep 2013 17:47:12 +0200
Message-ID: <1380210437-4391-9-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174801_166022_700D63EA)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is still the only way to submit mgmt frames in case
of 10.X firmware.

This patch introduces wmi_mgmt_tx queue, because of the
fact WMI command can block. This is a problem for
ath10k_tx_htt(), since it's called from atomic context.
The skb queue and worker are introduced to move the mgmt
frame handling out of .tx callback context and not block.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c   |    3 ++
 drivers/net/wireless/ath/ath10k/core.h   |   10 ++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +-
 drivers/net/wireless/ath/ath10k/mac.c    |   70 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.h    |    2 +
 drivers/net/wireless/ath/ath10k/wmi.c    |   51 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h    |    1 +
 7 files changed, 128 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 31860a6..bd74dac 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -520,6 +520,9 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	INIT_WORK(&ar->offchan_tx_work, ath10k_offchan_tx_work);
 	skb_queue_head_init(&ar->offchan_tx_queue);
 
+	INIT_WORK(&ar->wmi_mgmt_tx_work, ath10k_mgmt_over_wmi_tx_work);
+	skb_queue_head_init(&ar->wmi_mgmt_tx_queue);
+
 	init_waitqueue_head(&ar->event_queue);
 
 	INIT_WORK(&ar->restart_work, ath10k_core_restart);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e2a2658..984db11 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -43,15 +43,17 @@
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
 
+#define ATH10K_MAX_NUM_MGMT_PENDING 16
+
 struct ath10k;
 
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
 	bool is_mapped;
 	bool is_aborted;
+	u8 vdev_id;
 
 	struct {
-		u8 vdev_id;
 		u8 tid;
 		bool is_offchan;
 
@@ -284,6 +286,9 @@ enum ath10k_fw_features {
 	/* firmware from 10X branch */
 	ATH10K_FW_FEATURE_WMI_10X = 1,
 
+	/* firmware support tx frame management over WMI, otherwise it's HTT */
+	ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX = 2,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
@@ -393,6 +398,9 @@ struct ath10k {
 	struct completion offchan_tx_completed;
 	struct sk_buff *offchan_tx_skb;
 
+	struct work_struct wmi_mgmt_tx_work;
+	struct sk_buff_head wmi_mgmt_tx_queue;
+
 	enum ath10k_state state;
 
 	struct work_struct restart_work;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 3b93c6a..d9335e9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -308,7 +308,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct sk_buff *txdesc = NULL;
 	struct htt_cmd *cmd;
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
-	u8 vdev_id = skb_cb->htt.vdev_id;
+	u8 vdev_id = skb_cb->vdev_id;
 	int len = 0;
 	int msdu_id = -1;
 	int res;
@@ -384,7 +384,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct sk_buff *txdesc = NULL;
 	bool use_frags;
-	u8 vdev_id = ATH10K_SKB_CB(msdu)->htt.vdev_id;
+	u8 vdev_id = ATH10K_SKB_CB(msdu)->vdev_id;
 	u8 tid;
 	int prefetch_len, desc_len;
 	int msdu_id = -1;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index df4d299..f0bc707 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1486,7 +1486,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar, struct sk_buff *skb)
 static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	int ret;
+	int ret = 0;
 
 	if (ar->htt.target_version_major >= 3) {
 		/* Since HTT 3.0 there is no separate mgmt tx command */
@@ -1494,16 +1494,32 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 		goto exit;
 	}
 
-	if (ieee80211_is_mgmt(hdr->frame_control))
-		ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
-	else if (ieee80211_is_nullfunc(hdr->frame_control))
+	if (ieee80211_is_mgmt(hdr->frame_control)) {
+		if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
+			     ar->fw_features)) {
+			if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
+			    ATH10K_MAX_NUM_MGMT_PENDING) {
+				ath10k_warn("wmi mgmt_tx queue limit reached\n");
+				ret = -EBUSY;
+				goto exit;
+			}
+
+			skb_queue_tail(&ar->wmi_mgmt_tx_queue, skb);
+			ieee80211_queue_work(ar->hw, &ar->wmi_mgmt_tx_work);
+		} else {
+			ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
+		}
+	} else if (!test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
+			     ar->fw_features) &&
+		   ieee80211_is_nullfunc(hdr->frame_control)) {
 		/* FW does not report tx status properly for NullFunc frames
 		 * unless they are sent through mgmt tx path. mac80211 sends
-		 * those frames when it detects link/beacon loss and depends on
-		 * the tx status to be correct. */
+		 * those frames when it detects link/beacon loss and depends
+		 * on the tx status to be correct. */
 		ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
-	else
+	} else {
 		ret = ath10k_htt_tx(&ar->htt, skb);
+	}
 
 exit:
 	if (ret) {
@@ -1554,7 +1570,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		peer_addr = ieee80211_get_DA(hdr);
-		vdev_id = ATH10K_SKB_CB(skb)->htt.vdev_id;
+		vdev_id = ATH10K_SKB_CB(skb)->vdev_id;
 
 		spin_lock_bh(&ar->data_lock);
 		peer = ath10k_peer_find(ar, vdev_id, peer_addr);
@@ -1596,6 +1612,36 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 	}
 }
 
+void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	for (;;) {
+		skb = skb_dequeue(&ar->wmi_mgmt_tx_queue);
+		if (!skb)
+			break;
+
+		ieee80211_free_txskb(ar->hw, skb);
+	}
+}
+
+void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
+{
+	struct ath10k *ar = container_of(work, struct ath10k, wmi_mgmt_tx_work);
+	struct sk_buff *skb;
+	int ret;
+
+	for (;;) {
+		skb = skb_dequeue(&ar->wmi_mgmt_tx_queue);
+		if (!skb)
+			break;
+
+		ret = ath10k_wmi_mgmt_tx(ar, skb);
+		if (ret)
+			ath10k_warn("wmi mgmt_tx failed (%d)\n", ret);
+	}
+}
+
 /************/
 /* Scanning */
 /************/
@@ -1754,14 +1800,14 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ath10k_tx_h_seq_no(skb);
 	}
 
+	ATH10K_SKB_CB(skb)->vdev_id = vdev_id;
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
-	ATH10K_SKB_CB(skb)->htt.vdev_id = vdev_id;
 	ATH10K_SKB_CB(skb)->htt.tid = tid;
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		spin_lock_bh(&ar->data_lock);
 		ATH10K_SKB_CB(skb)->htt.is_offchan = true;
-		ATH10K_SKB_CB(skb)->htt.vdev_id = ar->scan.vdev_id;
+		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
 		spin_unlock_bh(&ar->data_lock);
 
 		ath10k_dbg(ATH10K_DBG_MAC, "queued offchannel skb %p\n", skb);
@@ -1783,6 +1829,7 @@ void ath10k_halt(struct ath10k *ar)
 
 	del_timer_sync(&ar->scan.timeout);
 	ath10k_offchan_tx_purge(ar);
+	ath10k_mgmt_over_wmi_tx_purge(ar);
 	ath10k_peer_cleanup_all(ar);
 	ath10k_core_stop(ar);
 	ath10k_hif_power_down(ar);
@@ -1859,7 +1906,10 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	ar->state = ATH10K_STATE_OFF;
 	mutex_unlock(&ar->conf_mutex);
 
+	ath10k_mgmt_over_wmi_tx_purge(ar);
+
 	cancel_work_sync(&ar->offchan_tx_work);
+	cancel_work_sync(&ar->wmi_mgmt_tx_work);
 	cancel_work_sync(&ar->restart_work);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 6fce9bf..ba10219 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -34,6 +34,8 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id);
 void ath10k_reset_scan(unsigned long ptr);
 void ath10k_offchan_tx_purge(struct ath10k *ar);
 void ath10k_offchan_tx_work(struct work_struct *work);
+void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar);
+void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work);
 void ath10k_halt(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 97ba23e..8c22367 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -410,6 +410,57 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 	return ret;
 }
 
+int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
+{
+	int ret = 0;
+	struct wmi_mgmt_tx_cmd *cmd;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *wmi_skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int len;
+	u16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
+
+	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control)))
+		return -EINVAL;
+
+	len = sizeof(cmd->hdr) + skb->len;
+	len = round_up(len, 4);
+
+	wmi_skb = ath10k_wmi_alloc_skb(len);
+	if (!wmi_skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_mgmt_tx_cmd *)wmi_skb->data;
+
+	cmd->hdr.vdev_id = __cpu_to_le32(ATH10K_SKB_CB(skb)->vdev_id);
+	cmd->hdr.tx_rate = 0;
+	cmd->hdr.tx_power = 0;
+	cmd->hdr.buf_len = __cpu_to_le32((u32)(skb->len));
+
+	memcpy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr), ETH_ALEN);
+	memcpy(cmd->buf, skb->data, skb->len);
+
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
+		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
+		   fc & IEEE80211_FCTL_STYPE);
+
+	/* Send the management frame buffer to the target */
+	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
+	if (ret) {
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	/* TODO: report tx status to mac80211 - temporary just ACK */
+	info->flags |= IEEE80211_TX_STAT_ACK;
+	ieee80211_tx_status_irqsafe(ar->hw, skb);
+
+	return ret;
+}
+
 static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_scan_event *event = (struct wmi_scan_event *)skb->data;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 56339d2..1c515d6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3483,5 +3483,6 @@ int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 			     enum wmi_force_fw_hang_type type, u32 delay_ms);
+int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
 
 #endif /* _WMI_H_ */
-- 
1.7.10

