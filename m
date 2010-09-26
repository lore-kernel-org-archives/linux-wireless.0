Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39511 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab0I0R7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:06 -0400
Received: by bwz11 with SMTP id 11so3540060bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:04 -0700 (PDT)
Message-Id: <4a4af8c40fea084b9e0f469249dc316dc7836db3.1285544496.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1285544496.git.chunkeey@googlemail.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Sep 2010 22:49:34 +0200
Subject: [PATCH 4/6] carl9170: fix tx_ampdu_upload counter
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx_ampdu_upload was not decreased when an a-MPDU
frame had to be kicked out from the tx_pending
queues.

This broke ampdu aggregation, because the scheduler
waits until tx_ampdu_upload drops to zero, before
making the next aggregate.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index d28b4ff..a8b0cec 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -230,8 +230,15 @@ static void carl9170_flush(struct ar9170 *ar, bool drop_queued)
 		for (i = 0; i < ar->hw->queues; i++) {
 			struct sk_buff *skb;
 
-			while ((skb = skb_dequeue(&ar->tx_pending[i])))
+			while ((skb = skb_dequeue(&ar->tx_pending[i]))) {
+				struct ieee80211_tx_info *info;
+
+				info = IEEE80211_SKB_CB(skb);
+				if (info->flags & IEEE80211_TX_CTL_AMPDU)
+					atomic_dec(&ar->tx_ampdu_upload);
+
 				carl9170_tx_status(ar, skb, false);
+			}
 		}
 	}
 
@@ -1462,6 +1469,7 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 			skb_queue_walk_safe(&ar->tx_pending[i], skb, tmp) {
 				struct _carl9170_tx_superframe *super;
 				struct ieee80211_hdr *hdr;
+				struct ieee80211_tx_info *info;
 
 				super = (void *) skb->data;
 				hdr = (void *) super->frame_data;
@@ -1470,6 +1478,11 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 					continue;
 
 				__skb_unlink(skb, &ar->tx_pending[i]);
+
+				info = IEEE80211_SKB_CB(skb);
+				if (info->flags & IEEE80211_TX_CTL_AMPDU)
+					atomic_dec(&ar->tx_ampdu_upload);
+
 				carl9170_tx_status(ar, skb, false);
 			}
 			spin_unlock_bh(&ar->tx_pending[i].lock);
-- 
1.7.1

