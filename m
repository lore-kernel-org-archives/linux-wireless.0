Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36652 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUNpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:45:39 -0500
Received: by mail-lb0-f172.google.com with SMTP id oh2so23415218lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:45:37 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 01/13] ath10k: refactor tx code
Date: Thu, 21 Jan 2016 14:46:34 +0100
Message-Id: <1453384006-31907-2-git-send-email-michal.kazior@tieto.com> (sfid-20160121_144546_801950_428D1EE4)
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prepares the code for future reuse with
ieee80211_txq and wake_tx_queue() in mind.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 151 +++++++++++++++++++++-------------
 1 file changed, 96 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 368de5e5a04f..a684718f6389 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3275,6 +3275,26 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 	}
 }
 
+static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
+				    struct ieee80211_vif *vif,
+				    struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+
+	cb->flags = 0;
+	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
+		cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
+
+	if (ieee80211_is_mgmt(hdr->frame_control))
+		cb->flags |= ATH10K_SKB_F_MGMT;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		cb->flags |= ATH10K_SKB_F_QOS;
+
+	cb->vif = vif;
+}
+
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
 {
 	/* FIXME: Not really sure since when the behaviour changed. At some
@@ -3310,8 +3330,9 @@ unlock:
 	return ret;
 }
 
-static void ath10k_mac_tx(struct ath10k *ar, enum ath10k_hw_txrx_mode txmode,
-			  struct sk_buff *skb)
+static int ath10k_mac_tx_submit(struct ath10k *ar,
+				enum ath10k_hw_txrx_mode txmode,
+				struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
 	int ret = 0;
@@ -3338,6 +3359,63 @@ static void ath10k_mac_tx(struct ath10k *ar, enum ath10k_hw_txrx_mode txmode,
 			    ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
+
+	return ret;
+}
+
+/* This function consumes the sk_buff regardless of return value as far as
+ * caller is concerned so no freeing is necessary afterwards.
+ */
+static int ath10k_mac_tx(struct ath10k *ar,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta,
+			 enum ath10k_hw_txrx_mode txmode,
+			 struct sk_buff *skb)
+{
+	struct ieee80211_hw *hw = ar->hw;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int ret;
+
+	/* We should disable CCK RATE due to P2P */
+	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "IEEE80211_TX_CTL_NO_CCK_RATE\n");
+
+	switch (txmode) {
+	case ATH10K_HW_TXRX_MGMT:
+	case ATH10K_HW_TXRX_NATIVE_WIFI:
+		ath10k_tx_h_nwifi(hw, skb);
+		ath10k_tx_h_add_p2p_noa_ie(ar, vif, skb);
+		ath10k_tx_h_seq_no(vif, skb);
+		break;
+	case ATH10K_HW_TXRX_ETHERNET:
+		ath10k_tx_h_8023(skb);
+		break;
+	case ATH10K_HW_TXRX_RAW:
+		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+			WARN_ON_ONCE(1);
+			ieee80211_free_txskb(hw, skb);
+			return -ENOTSUPP;
+		}
+	}
+
+	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+		if (!ath10k_mac_tx_frm_has_freq(ar)) {
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
+				   skb);
+
+			skb_queue_tail(&ar->offchan_tx_queue, skb);
+			ieee80211_queue_work(hw, &ar->offchan_tx_work);
+			return 0;
+		}
+	}
+
+	ret = ath10k_mac_tx_submit(ar, txmode, skb);
+	if (ret) {
+		ath10k_warn(ar, "failed to submit frame: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
 }
 
 void ath10k_offchan_tx_purge(struct ath10k *ar)
@@ -3358,12 +3436,12 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 	struct ath10k *ar = container_of(work, struct ath10k, offchan_tx_work);
 	struct ath10k_peer *peer;
 	struct ath10k_vif *arvif;
+	enum ath10k_hw_txrx_mode txmode;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
 	struct sk_buff *skb;
 	const u8 *peer_addr;
-	enum ath10k_hw_txrx_mode txmode;
 	int vdev_id;
 	int ret;
 	unsigned long time_left;
@@ -3428,7 +3506,12 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 
-		ath10k_mac_tx(ar, txmode, skb);
+		ret = ath10k_mac_tx(ar, vif, sta, txmode, skb);
+		if (ret) {
+			ath10k_warn(ar, "failed to transmit offchannel frame: %d\n",
+				    ret);
+			/* not serious */
+		}
 
 		time_left =
 		wait_for_completion_timeout(&ar->offchan_tx_completed, 3 * HZ);
@@ -3642,66 +3725,24 @@ static int ath10k_start_scan(struct ath10k *ar,
 /* mac80211 callbacks */
 /**********************/
 
-static void ath10k_tx(struct ieee80211_hw *hw,
-		      struct ieee80211_tx_control *control,
-		      struct sk_buff *skb)
+static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_control *control,
+			     struct sk_buff *skb)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	enum ath10k_hw_txrx_mode txmode;
+	int ret;
 
-	/* We should disable CCK RATE due to P2P */
-	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "IEEE80211_TX_CTL_NO_CCK_RATE\n");
+	ath10k_mac_tx_h_fill_cb(ar, vif, skb);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 
-	skb_cb->flags = 0;
-	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
-		skb_cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
-
-	if (ieee80211_is_mgmt(hdr->frame_control))
-		skb_cb->flags |= ATH10K_SKB_F_MGMT;
-
-	if (ieee80211_is_data_qos(hdr->frame_control))
-		skb_cb->flags |= ATH10K_SKB_F_QOS;
-
-	skb_cb->vif = vif;
-
-	switch (txmode) {
-	case ATH10K_HW_TXRX_MGMT:
-	case ATH10K_HW_TXRX_NATIVE_WIFI:
-		ath10k_tx_h_nwifi(hw, skb);
-		ath10k_tx_h_add_p2p_noa_ie(ar, vif, skb);
-		ath10k_tx_h_seq_no(vif, skb);
-		break;
-	case ATH10K_HW_TXRX_ETHERNET:
-		ath10k_tx_h_8023(skb);
-		break;
-	case ATH10K_HW_TXRX_RAW:
-		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
-			WARN_ON_ONCE(1);
-			ieee80211_free_txskb(hw, skb);
-			return;
-		}
-	}
-
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
-		if (!ath10k_mac_tx_frm_has_freq(ar)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
-				   skb);
-
-			skb_queue_tail(&ar->offchan_tx_queue, skb);
-			ieee80211_queue_work(hw, &ar->offchan_tx_work);
-			return;
-		}
-	}
-
-	ath10k_mac_tx(ar, txmode, skb);
+	ret = ath10k_mac_tx(ar, vif, sta, txmode, skb);
+	if (ret)
+		ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
 }
 
 /* Must not be called with conf_mutex held as workers can use that also. */
@@ -6792,7 +6833,7 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 }
 
 static const struct ieee80211_ops ath10k_ops = {
-	.tx				= ath10k_tx,
+	.tx				= ath10k_mac_op_tx,
 	.start				= ath10k_start,
 	.stop				= ath10k_stop,
 	.config				= ath10k_config,
-- 
2.1.4

