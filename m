Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1KSTKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 14:10:42 -0500
Received: by bke11 with SMTP id 11so4790760bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 11:10:40 -0800 (PST)
Message-Id: <b30e06a145950db50eb9d8c0a2e3a699faf08772.1321729714.git.chunkeey@googlemail.com> (sfid-20111119_201046_358441_E8F7E36D)
In-Reply-To: <6fa261d3570aa403491add7399e1b8b8c4fac143.1321729714.git.chunkeey@googlemail.com>
References: <6fa261d3570aa403491add7399e1b8b8c4fac143.1321729714.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 19 Nov 2011 19:30:20 +0100
Subject: [PATCH 2/2] carl9170: use ieee80211_free_txskb
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the past, it was fine to simply call
dev_kfree_skb when it was impossible to
transmit a skb. However, with the new
tx status API:
"mac80211: implement wifi TX status"
Every loose skb needs to be handed back
to mac80211.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 59472e1..d19a9ee 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -314,7 +314,7 @@ static void carl9170_tx_release(struct kref *ref)
 			 *    feedback either [CTL_REQ_TX_STATUS not set]
 			 */
 
-			dev_kfree_skb_any(skb);
+			ieee80211_free_txskb(ar->hw, skb);
 			return;
 		} else {
 			/*
@@ -1432,7 +1432,7 @@ void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 err_free:
 	ar->tx_dropped++;
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(ar->hw, skb);
 }
 
 void carl9170_tx_scheduler(struct ar9170 *ar)
-- 
1.7.7.3

