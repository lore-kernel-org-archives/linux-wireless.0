Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41756 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755059AbdJRADR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 20:03:17 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq
Date: Tue, 17 Oct 2017 17:03:12 -0700
Message-Id: <1508284992-3574-1-git-send-email-greearb@candelatech.com> (sfid-20171018_020324_933578_A9957310)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This bug appears to have been added between 4.0 (which works for us),
and 4.4, which does not work.

I think this is because the tx-offchannel logic gets in a loop when
ath10k_mac_tx_frm_has_freq(ar) is false, so pkt is never actually
sent to the firmware for transmit.

This patch fixes the problem on 4.9 for me, and now HS20 clients
can work again with my firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c45ca04..f0a7864 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4101,7 +4101,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 			 struct ieee80211_sta *sta,
 			 enum ath10k_hw_txrx_mode txmode,
 			 enum ath10k_mac_tx_path txpath,
-			 struct sk_buff *skb)
+			 struct sk_buff *skb, bool noque_offchan)
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -4134,10 +4134,10 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		}
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+	if ((!noque_offchan) && info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		if (!ath10k_mac_tx_frm_has_freq(ar)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %pK\n",
-				   skb);
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "no-tx-frm-has-freq: queued offchannel skb %pK, len: %d\n",
+				   skb, skb->len);
 
 			skb_queue_tail(&ar->offchan_tx_queue, skb);
 			ieee80211_queue_work(hw, &ar->offchan_tx_work);
@@ -4198,8 +4198,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK\n",
-			   skb);
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "offchan-tx-work: mac offchannel skb %pK len: %d\n",
+			   skb, skb->len);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		peer_addr = ieee80211_get_DA(hdr);
@@ -4245,7 +4245,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 		txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
 
-		ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+		ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb, true);
 		if (ret) {
 			ath10k_warn(ar, "failed to transmit offchannel frame: %d\n",
 				    ret);
@@ -4255,8 +4255,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		time_left =
 		wait_for_completion_timeout(&ar->offchan_tx_completed, 3 * HZ);
 		if (time_left == 0)
-			ath10k_warn(ar, "timed out waiting for offchannel skb %pK\n",
-				    skb);
+			ath10k_warn(ar, "timed out waiting for offchannel skb %pK, len: %d\n",
+				    skb, skb->len);
 
 		if (!peer && tmp_peer_created) {
 			ret = ath10k_peer_delete(ar, vdev_id, peer_addr);
@@ -4513,7 +4513,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb, false);
 	if (unlikely(ret)) {
 		ath10k_warn(ar, "failed to push frame: %d\n", ret);
 
@@ -4802,7 +4802,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb, false);
 	if (ret) {
 		ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
 		if (is_htt) {
-- 
2.4.11
