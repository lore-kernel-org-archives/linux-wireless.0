Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54848 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab3IMMRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 08:17:07 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 2/7] ath10k: add HTC TX credits replenishing notification
Date: Fri, 13 Sep 2013 14:16:53 +0200
Message-ID: <1379074618-30534-3-git-send-email-michal.kazior@tieto.com> (sfid-20130913_141713_309465_4471EAFA)
In-Reply-To: <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
 <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow higher layers to anticipate and
act upon TX credits renewal. This will be
important for some future rework of WMI command
submission.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |    9 +++++++++
 drivers/net/wireless/ath/ath10k/htc.h |    1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 1da0f82..49da4e5 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -150,6 +150,9 @@ err:
 	ep->tx_credits += credits;
 	spin_unlock_bh(&htc->tx_lock);
 
+	if (ep->ep_ops.ep_tx_credits)
+		ep->ep_ops.ep_tx_credits(htc->ar);
+
 	/* this is the simplest way to handle out-of-resources for non-credit
 	 * based endpoints. credit based endpoints can still get -ENOSR, but
 	 * this is highly unlikely as credit reservation should prevent that */
@@ -302,6 +305,12 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 		ep = &htc->endpoint[report->eid];
 		ep->tx_credits += report->credits;
 
+		if (ep->ep_ops.ep_tx_credits) {
+			spin_unlock_bh(&htc->tx_lock);
+			ep->ep_ops.ep_tx_credits(htc->ar);
+			spin_lock_bh(&htc->tx_lock);
+		}
+
 		if (ep->tx_credits && !skb_queue_empty(&ep->tx_queue))
 			queue_work(htc->ar->workqueue, &ep->send_work);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index e1dd8c7..92ca29b 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -276,6 +276,7 @@ struct ath10k_htc_ops {
 struct ath10k_htc_ep_ops {
 	void (*ep_tx_complete)(struct ath10k *, struct sk_buff *);
 	void (*ep_rx_complete)(struct ath10k *, struct sk_buff *);
+	void (*ep_tx_credits)(struct ath10k *);
 };
 
 /* service connection information */
-- 
1.7.9.5

