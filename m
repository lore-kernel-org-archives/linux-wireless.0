Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49557 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab1AGSBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 13:01:24 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath9k:  Fix incorrect tx-hang detection logic.
Date: Fri,  7 Jan 2011 10:00:59 -0800
Message-Id: <1294423259-8163-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294423259-8163-1-git-send-email-greearb@candelatech.com>
References: <1294423259-8163-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It is not guaranteed that the ath_tx_complete_poll_work runs
after some fixed duration because the channel-reset logic
removes the work and then re-adds it to run immediately.
Two channel-changes 1ms apart, with a transmit was being
attempted, could thus incorrectly trigger a reset by
the ath_tx_complete_poll_work method.

Add a jiffies timestamp to ensure that at least 1 second
has elapsed before triggering the reset.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 3f5c513... 93209d6... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 3aae523... e63de71... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3f5c513..93209d6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -190,6 +190,7 @@ struct ath_txq {
 	spinlock_t axq_lock;
 	u32 axq_depth;
 	u32 axq_ampdu_depth;
+	unsigned long start_tx_timer; /* jiffies */
 	bool stopped;
 	bool axq_tx_inprogress;
 	struct list_head axq_acq;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3aae523..e63de71 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2097,6 +2097,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	struct ath_txq *txq;
 	int i;
 	bool needreset = false;
+	unsigned long timeout = msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i)) {
@@ -2104,11 +2105,16 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 			spin_lock_bh(&txq->axq_lock);
 			if (txq->axq_depth) {
 				if (txq->axq_tx_inprogress) {
-					needreset = true;
-					spin_unlock_bh(&txq->axq_lock);
-					break;
+					if (time_after_eq(jiffies,
+							  txq->start_tx_timer +
+							  timeout)) {
+						needreset = true;
+						spin_unlock_bh(&txq->axq_lock);
+						break;
+					}
 				} else {
 					txq->axq_tx_inprogress = true;
+					txq->start_tx_timer = jiffies;
 				}
 			}
 			spin_unlock_bh(&txq->axq_lock);
@@ -2122,8 +2128,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 		ath9k_ps_restore(sc);
 	}
 
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
-			msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT));
+	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, timeout);
 }
 
 
-- 
1.7.2.3

