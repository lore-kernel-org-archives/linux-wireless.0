Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6296FC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3CE20848
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D3CE20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbeLCTP4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 14:15:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:52465 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbeLCTP4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 14:15:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2018 11:15:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,311,1539673200"; 
   d="scan'208";a="106667879"
Received: from localhost.jer.intel.com ([10.12.190.32])
  by fmsmga008.fm.intel.com with ESMTP; 03 Dec 2018 11:15:51 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix deauth TX when we disconnect
Date:   Mon,  3 Dec 2018 21:15:49 +0200
Message-Id: <1543864549-16859-1-git-send-email-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The iTXQs stop/wake queue mechanism involves a whole bunch
of locks and this is probably why the call to
ieee80211_wake_txqs is deferred to a tasklet when called from
__ieee80211_wake_queue.

Another advantage of that is that ieee80211_wake_txqs might
call the wake_tx_queue() callback and then the driver may
call mac80211 which will call it back in the same context.

The bug I saw is that when we send a deauth frame as a
station we do:

flush(drop=1)
tx deauth
flush(drop=0)

While we flush we stop the queues and wake them up
immediately after we finished flushing. The problem here is
that the tasklet that de-facto enables the queue may not have
run until we send the deauth. Then the deauth frame is sent
to the driver (which is surprising by itself), but the driver
won't get anything useful from ieee80211_tx_dequeue because
the queue is stopped (or more precisely because
vif->txqs_stopped[0] is true).
Then the deauth is not sent. Later on, the tasklet will run,
but that'll be too late. We'll already have removed all the
vif etc...

Fix this by calling ieee80211_wake_txqs synchronously if we
are not waking up the queues from the driver (we check the
reason to determine that). This makes the code really
convoluted because we may call ieee80211_wake_txqs from
__ieee80211_wake_queue. The latter assumes that
queue_stop_reason_lock has been taken by the caller and
ieee80211_wake_txqs may release the lock to send the frames.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bec4243..40ea41a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -299,16 +299,17 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	spin_unlock_bh(&fq->lock);
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+static void
+__releases(&local->queue_stop_reason_lock)
+__acquires(&local->queue_stop_reason_lock)
+_ieee80211_wake_txqs(struct ieee80211_local *local,
+				 unsigned long *flags)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct ieee80211_sub_if_data *sdata;
 	int n_acs = IEEE80211_NUM_ACS;
-	unsigned long flags;
 	int i;
 
 	rcu_read_lock();
-	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
@@ -317,7 +318,7 @@ void ieee80211_wake_txqs(unsigned long data)
 		if (local->queue_stop_reasons[i])
 			continue;
 
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, *flags);
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 			int ac;
 
@@ -329,13 +330,22 @@ void ieee80211_wake_txqs(unsigned long data)
 					__ieee80211_wake_txqs(sdata, ac);
 			}
 		}
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		spin_lock_irqsave(&local->queue_stop_reason_lock, *flags);
 	}
 
-	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	rcu_read_unlock();
 }
 
+void ieee80211_wake_txqs(unsigned long data)
+{
+	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	_ieee80211_wake_txqs(local, &flags);
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -371,7 +381,8 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 
 static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason,
-				   bool refcounted)
+				   bool refcounted,
+				   unsigned long *flags)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -405,8 +416,19 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	} else
 		tasklet_schedule(&local->tx_pending_tasklet);
 
-	if (local->ops->wake_tx_queue)
-		tasklet_schedule(&local->wake_txqs_tasklet);
+	/*
+	 * Calling _ieee80211_wake_txqs here can be a problem because it may
+	 * release queue_stop_reason_lock which has been taken by
+	 * __ieee80211_wake_queue's caller. It is certainly not very nice to
+	 * release someone's lock, but it is fine because all the callers of
+	 * __ieee80211_wake_queue call it right before releasing the lock.
+	 */
+	if (local->ops->wake_tx_queue) {
+		if (reason == IEEE80211_QUEUE_STOP_REASON_DRIVER)
+			tasklet_schedule(&local->wake_txqs_tasklet);
+		else
+			_ieee80211_wake_txqs(local, flags);
+	}
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
@@ -417,7 +439,7 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_wake_queue(hw, queue, reason, refcounted);
+	__ieee80211_wake_queue(hw, queue, reason, refcounted, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -514,7 +536,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       false);
 	__skb_queue_tail(&local->pending[queue], skb);
 	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
-			       false);
+			       false, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -547,7 +569,7 @@ void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i,
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
-			false);
+			false, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -605,7 +627,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	for_each_set_bit(i, &queues, hw->queues)
-		__ieee80211_wake_queue(hw, i, reason, refcounted);
+		__ieee80211_wake_queue(hw, i, reason, refcounted, &flags);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
-- 
2.7.4

