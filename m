Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42018 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0KFNHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 09:07:16 -0400
Received: by bwz11 with SMTP id 11so3492094bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 06:07:14 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: tx path review
Date: Sat, 6 Nov 2010 14:07:10 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011061407.11139.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a few shortcomings in the tx path.

 * move temp. ampdu_[ack]_len out of txinfo->pad.

 * fix WARN_ON from tx.c:line 300 when tx_ampdu_queue
   fails to queue the frame.

 * In tx_prepare, we already have a local pointer
   to the station's ieee80211_sta struct.

 * remove a second !sta check, tx_prepare already takes
   care of that.
    
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index b27969c..688eede 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -242,9 +242,11 @@ static void carl9170_tx_release(struct kref *ref)
 			ar->tx_ampdu_schedule = true;
 
 		if (txinfo->flags & IEEE80211_TX_STAT_AMPDU) {
-			txinfo->status.ampdu_len = txinfo->pad[0];
-			txinfo->status.ampdu_ack_len = txinfo->pad[1];
-			txinfo->pad[0] = txinfo->pad[1] = 0;
+			struct _carl9170_tx_superframe *super;
+
+			super = (void *)skb->data;
+			txinfo->status.ampdu_len = super->s.rix;
+			txinfo->status.ampdu_ack_len = super->s.cnt;
 		} else if (txinfo->flags & IEEE80211_TX_STAT_ACK) {
 			/*
 			 * drop redundant tx_status reports:
@@ -337,7 +339,8 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	u8 tid;
 
 	if (!(txinfo->flags & IEEE80211_TX_CTL_AMPDU) ||
-	    txinfo->flags & IEEE80211_TX_CTL_INJECTED)
+	    txinfo->flags & IEEE80211_TX_CTL_INJECTED ||
+	   (!(super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_AGGR))))
 		return;
 
 	tx_info = IEEE80211_SKB_CB(skb);
@@ -389,8 +392,8 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 		sta_info->stats[tid].ampdu_ack_len++;
 
 	if (super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_IMM_BA)) {
-		txinfo->pad[0] = sta_info->stats[tid].ampdu_len;
-		txinfo->pad[1] = sta_info->stats[tid].ampdu_ack_len;
+		super->s.rix = sta_info->stats[tid].ampdu_len;
+		super->s.cnt = sta_info->stats[tid].ampdu_ack_len;
 		txinfo->flags |= IEEE80211_TX_STAT_AMPDU;
 		sta_info->stats[tid].clear = true;
 	}
@@ -896,10 +899,8 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 		if (unlikely(!sta || !cvif))
 			goto err_out;
 
-		factor = min_t(unsigned int, 1u,
-			 info->control.sta->ht_cap.ampdu_factor);
-
-		density = info->control.sta->ht_cap.ampdu_density;
+		factor = min_t(unsigned int, 1u, sta->ht_cap.ampdu_factor);
+		density = sta->ht_cap.ampdu_density;
 
 		if (density) {
 			/*
@@ -1260,6 +1261,7 @@ static void carl9170_tx(struct ar9170 *ar)
 static bool carl9170_tx_ampdu_queue(struct ar9170 *ar,
 	struct ieee80211_sta *sta, struct sk_buff *skb)
 {
+	struct _carl9170_tx_superframe *super = (void *) super;
 	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *agg;
 	struct sk_buff *iter;
@@ -1328,6 +1330,7 @@ err_unlock:
 
 err_unlock_rcu:
 	rcu_read_unlock();
+	super->f.mac_control &= ~cpu_to_le16(AR9170_TX_MAC_AGGR);
 	carl9170_tx_status(ar, skb, false);
 	ar->tx_dropped++;
 	return false;
@@ -1356,9 +1359,6 @@ int carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		if (WARN_ON_ONCE(!sta))
-			goto err_free;
-
 		run = carl9170_tx_ampdu_queue(ar, sta, skb);
 		if (run)
 			carl9170_tx_ampdu(ar);
