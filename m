Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40307 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0IQXHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:07:08 -0400
Received: by bwz11 with SMTP id 11so3127681bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:07:07 -0700 (PDT)
Message-Id: <d0b84a26b9f242fed538cc0dd82dea549ff84abb.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 18 Sep 2010 00:15:13 +0200
Subject: [PATCH 7/7] carl9170: fix hang in AP mode when HT STA does PSM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a obvious bug, skb_queue_walk does not
work if the iterator gets removed from the queue.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index ea49d54..43de9df 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1412,7 +1412,7 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 {
 	struct ar9170 *ar = hw->priv;
 	struct carl9170_sta_info *sta_info = (void *) sta->drv_priv;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *tmp;
 	struct sk_buff_head free;
 	int i;
 
@@ -1462,7 +1462,7 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 
 		for (i = 0; i < ar->hw->queues; i++) {
 			spin_lock_bh(&ar->tx_pending[i].lock);
-			skb_queue_walk(&ar->tx_pending[i], skb) {
+			skb_queue_walk_safe(&ar->tx_pending[i], skb, tmp) {
 				struct _carl9170_tx_superframe *super;
 				struct ieee80211_hdr *hdr;
 
-- 
1.7.1

