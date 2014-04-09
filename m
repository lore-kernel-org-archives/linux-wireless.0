Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49412 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbaDIKza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:55:30 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1733808eei.14
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:55:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFTv2 1/5] ath10k: always request htc tx replenishment
Date: Wed,  9 Apr 2014 12:48:47 +0200
Message-Id: <1397040531-6224-2-git-send-email-michal.kazior@tieto.com> (sfid-20140409_125535_993916_5EE060EA)
In-Reply-To: <1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
 <1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This simplifies tx credit management and tries to
address a problem where driver runs out of credits
and is unable to recover when firmware stalls.

This also makes it a little more easy to track and
debug htc tx credit flow since there should be no
laziness involved.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7f1bccd..c2a290a 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -86,19 +86,6 @@ static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 	ep->ep_ops.ep_tx_complete(ep->htc->ar, skb);
 }
 
-/* assumes tx_lock is held */
-static bool ath10k_htc_ep_need_credit_update(struct ath10k_htc_ep *ep)
-{
-	if (!ep->tx_credit_flow_enabled)
-		return false;
-	if (ep->tx_credits >= ep->tx_credits_per_max_message)
-		return false;
-
-	ath10k_dbg(ATH10K_DBG_HTC, "HTC: endpoint %d needs credit update\n",
-		   ep->eid);
-	return true;
-}
-
 static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 				      struct sk_buff *skb)
 {
@@ -113,7 +100,7 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 	spin_lock_bh(&ep->htc->tx_lock);
 	hdr->seq_no = ep->seq_no++;
 
-	if (ath10k_htc_ep_need_credit_update(ep))
+	if (ep->tx_credit_flow_enabled)
 		hdr->flags |= ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE;
 
 	spin_unlock_bh(&ep->htc->tx_lock);
-- 
1.8.5.3

