Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34810 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754530AbcHSBdE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 21:33:04 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/3] ath10k:  Grab rcu_read_lock before the txqs spinlock.
Date: Thu, 18 Aug 2016 18:26:34 -0700
Message-Id: <1471569995-10028-2-git-send-email-greearb@candelatech.com> (sfid-20160819_033758_807905_5AF27B2F)
In-Reply-To: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I was seeing some spin-lock hangs in this area of the code,
and it seems more proper to do the rcu-read-lock outside of
the spin lock.  I am not sure how much this matters, however.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 916119c..d96c06e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4307,8 +4307,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 	int max;
 	int loop_max = 2000;
 
-	spin_lock_bh(&ar->txqs_lock);
 	rcu_read_lock();
+	spin_lock_bh(&ar->txqs_lock);
 
 	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
 	while (!list_empty(&ar->txqs)) {
@@ -4342,8 +4342,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 			break;
 	}
 
-	rcu_read_unlock();
 	spin_unlock_bh(&ar->txqs_lock);
+	rcu_read_unlock();
 }
 
 /************/
-- 
2.4.11
