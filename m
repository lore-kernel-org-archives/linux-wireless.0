Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9452C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7CA20881
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697429;
	bh=eyHQhMgm0jHj8K/A97uVAsVEQfD8OFZh2k7pWtmd1Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zQOQ5PjJWrAFBOUYiVZdqbLlResa4ZENAAmr6s0BF7nlmT5OrODe5B0NZtugBQNXJ
	 nAKoPWo9jE+YMwmfmsc5dui6ORAKdbtT/sztj44lMfqExk8Mx1WNHcHw4e6AmxS6sV
	 hWpChpUwJy7LeNcGcidStC9ag8o9fyw+VB8OE9sk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfA1Rnn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbfA1Pt1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:49:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BA42147A;
        Mon, 28 Jan 2019 15:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690566;
        bh=eyHQhMgm0jHj8K/A97uVAsVEQfD8OFZh2k7pWtmd1Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFKuUYUxiJOeLfakrvpRpVolY8/BTzde3c5BAt9SiKrf1xBwtDJvngKK/XShsQKtZ
         STIIWKE8I+fe0dm5ExpVmstcRfJ3To2k91dPetuJYacPJQb9VXqqEX+oF3EFDmvTdr
         r2QnOymK5HhmkNtu2XsD2Y4nk/VyMvtX0FaBhfec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 127/304] mac80211: fix deauth TX when we disconnect
Date:   Mon, 28 Jan 2019 10:40:44 -0500
Message-Id: <20190128154341.47195-127-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit f6c7f03f69f7422bc237bc79599e152d390b74e0 ]

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
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 49 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bec424316ea4..dddfff7cf44f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -299,16 +299,16 @@ out:
 	spin_unlock_bh(&fq->lock);
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+static void
+__releases(&local->queue_stop_reason_lock)
+__acquires(&local->queue_stop_reason_lock)
+_ieee80211_wake_txqs(struct ieee80211_local *local, unsigned long *flags)
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
@@ -317,7 +317,7 @@ void ieee80211_wake_txqs(unsigned long data)
 		if (local->queue_stop_reasons[i])
 			continue;
 
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, *flags);
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 			int ac;
 
@@ -329,13 +329,22 @@ void ieee80211_wake_txqs(unsigned long data)
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
@@ -371,7 +380,8 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 
 static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason,
-				   bool refcounted)
+				   bool refcounted,
+				   unsigned long *flags)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -405,8 +415,19 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
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
@@ -417,7 +438,7 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_wake_queue(hw, queue, reason, refcounted);
+	__ieee80211_wake_queue(hw, queue, reason, refcounted, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -514,7 +535,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       false);
 	__skb_queue_tail(&local->pending[queue], skb);
 	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
-			       false);
+			       false, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -547,7 +568,7 @@ void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i,
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
-			false);
+			false, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -605,7 +626,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	for_each_set_bit(i, &queues, hw->queues)
-		__ieee80211_wake_queue(hw, i, reason, refcounted);
+		__ieee80211_wake_queue(hw, i, reason, refcounted, &flags);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
-- 
2.19.1

