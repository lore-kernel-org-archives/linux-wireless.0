Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51145 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbaIWVSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:18:10 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 09/10] ath10k: always request htc tx replenishment
Date: Tue, 23 Sep 2014 14:17:24 -0700
Message-Id: <1411507045-18973-9-git-send-email-greearb@candelatech.com> (sfid-20140923_231835_057230_88F23D45)
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This simplifies tx credit management and tries to
address a problem where driver runs out of credits
and is unable to recover when firmware stalls.

This also makes it a little more easy to track and
debug htc tx credit flow since there should be no
laziness involved.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Tested-by: Ben Greear <greearb@candelatech.com>
---

v2:  This is Michal's patch originally.  I think only CT firmware
actually supports this properly, but should not hurt existing
firmware.

 drivers/net/wireless/ath/ath10k/htc.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 676bd4e..7a6b9b0 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -86,21 +86,6 @@ static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 	ep->ep_ops.ep_tx_complete(ep->htc->ar, skb);
 }
 
-/* assumes tx_lock is held */
-static bool ath10k_htc_ep_need_credit_update(struct ath10k_htc_ep *ep)
-{
-	struct ath10k *ar = ep->htc->ar;
-
-	if (!ep->tx_credit_flow_enabled)
-		return false;
-	if (ep->tx_credits >= ep->tx_credits_per_max_message)
-		return false;
-
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "HTC: endpoint %d needs credit update\n",
-		   ep->eid);
-	return true;
-}
-
 static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 				      struct sk_buff *skb)
 {
@@ -115,7 +100,7 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 	spin_lock_bh(&ep->htc->tx_lock);
 	hdr->seq_no = ep->seq_no++;
 
-	if (ath10k_htc_ep_need_credit_update(ep))
+	if (ep->tx_credit_flow_enabled)
 		hdr->flags |= ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE;
 
 	spin_unlock_bh(&ep->htc->tx_lock);
-- 
1.7.11.7

