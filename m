Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54399 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaDHLYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 07:24:50 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so557367eei.14
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 04:24:49 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: improve htc tx credit debugging prints
Date: Tue,  8 Apr 2014 13:18:40 +0200
Message-Id: <1396955920-25863-1-git-send-email-michal.kazior@tieto.com> (sfid-20140408_132454_805935_674E9B8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This way it's easier to track and debug htc tx
credit issues.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7f1bccd..d083198 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -157,7 +157,11 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 			goto err_pull;
 		}
 		ep->tx_credits -= credits;
+		ath10k_dbg(ATH10K_DBG_HTC,
+			   "htc ep %d consumed %d credits (total %d)\n",
+			   eid, credits, ep->tx_credits);
 		spin_unlock_bh(&htc->tx_lock);
+
 	}
 
 	ath10k_htc_prepare_tx_skb(ep, skb);
@@ -185,6 +189,9 @@ err_credits:
 	if (ep->tx_credit_flow_enabled) {
 		spin_lock_bh(&htc->tx_lock);
 		ep->tx_credits += credits;
+		ath10k_dbg(ATH10K_DBG_HTC,
+			   "htc ep %d reverted %d credits back (total %d)\n",
+			   eid, credits, ep->tx_credits);
 		spin_unlock_bh(&htc->tx_lock);
 
 		if (ep->ep_ops.ep_tx_credits)
@@ -234,12 +241,12 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 		if (report->eid >= ATH10K_HTC_EP_COUNT)
 			break;
 
-		ath10k_dbg(ATH10K_DBG_HTC, "ep %d got %d credits\n",
-			   report->eid, report->credits);
-
 		ep = &htc->endpoint[report->eid];
 		ep->tx_credits += report->credits;
 
+		ath10k_dbg(ATH10K_DBG_HTC, "htc ep %d got %d credits (total %d)\n",
+			   report->eid, report->credits, ep->tx_credits);
+
 		if (ep->ep_ops.ep_tx_credits) {
 			spin_unlock_bh(&htc->tx_lock);
 			ep->ep_ops.ep_tx_credits(htc->ar);
-- 
1.8.5.3

