Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12631 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161753AbcFIGEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 02:04:25 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix deadlock while processing rx_in_ord_ind
Date: Thu, 9 Jun 2016 11:33:55 +0530
Message-ID: <20160609060355.16219-1-rmanohar@qti.qualcomm.com> (sfid-20160609_080440_750236_1CD3DB0E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 5c86d97bcc1d ("ath10k: combine txrx and replenish task")
introduced deadlock while processing rx in order indication message
for qca6174 based devices. While merging replenish and txrx tasklets,
replenish task should be called out of htt rx ring locking since it
is also try to acquire the same lock.

Unfortunately this issue is not exposed by other solutions (qca988x,
qca99x0 & qca4019), as rx_in_ord_ind message is specific to qca6174
based devices. This patch fixes

=============================================
[ INFO: possible recursive locking detected ]
4.7.0-rc2-wt-ath+ #1353 Tainted: G            E
---------------------------------------------
swapper/3/0 is trying to acquire lock:
 (&(&htt->rx_ring.lock)->rlock){+.-...}, at: [<f8d7ef19>]
ath10k_htt_rx_msdu_buff_replenish+0x29/0x90 [ath10k_core]

but task is already holding lock:
 (&(&htt->rx_ring.lock)->rlock){+.-...}, at: [<f8d82cab>]
ath10k_htt_txrx_compl_task+0x21b/0x250 [ath10k_core]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&htt->rx_ring.lock)->rlock);
  lock(&(&htt->rx_ring.lock)->rlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by swapper/3/0:
 #0:  (&(&htt->rx_ring.lock)->rlock){+.-...}, at: [<f8d82cab>]
ath10k_htt_txrx_compl_task+0x21b/0x250 [ath10k_core]

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=119151
Fixes: 5c86d97bcc1d ("ath10k: combine txrx and replenish task")
Reported-by: Mike Lothian <mike@fireburn.co.uk>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 3b35c7ab5680..80e645302b54 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1905,7 +1905,6 @@ static void ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			return;
 		}
 	}
-	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
 static void ath10k_htt_rx_tx_fetch_resp_id_confirm(struct ath10k *ar,
-- 
2.8.3

