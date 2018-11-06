Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF1DC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC4182085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:30:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4182085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbeKFVzn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 16:55:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:32622 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbeKFVzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 16:55:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 04:30:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,471,1534834800"; 
   d="scan'208";a="277502811"
Received: from localhost.jer.intel.com ([10.12.85.45])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2018 04:30:42 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [RFC] mac80211: fix deauth TX when we disconnect
Date:   Tue,  6 Nov 2018 14:30:40 +0200
Message-Id: <1541507440-21008-1-git-send-email-emmanuel.grumbach@intel.com>
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

There are 2 options I see here:
1) do what I did in this patch (which is pretty awful because
   of the if (lock) thing. If we wake up the queue because of
   a reason which is internal to mac80211, call
   ieee80211_wake_txqs synchronously since we know we are not
   coming from the driver.
2) we could set vif->txqs_stopped to false synchrously and do
   the rest of the job in a tasklet. This would allow the code
   that sends the Tx to put the frame in the queue and the
   driver would actually get it.

Maybe others have better ideas?

Change-Id: I5d3bd20ec765becb91944741c35e35f6e3888981
Cc: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c9cb00a..c731ddb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -299,16 +299,16 @@ out:
 	spin_unlock_bh(&fq->lock);
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+static void _ieee80211_wake_txqs(struct ieee80211_local *local, bool lock)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct ieee80211_sub_if_data *sdata;
 	int n_acs = IEEE80211_NUM_ACS;
 	unsigned long flags;
 	int i;
 
 	rcu_read_lock();
-	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	if (lock)
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
@@ -332,10 +332,18 @@ void ieee80211_wake_txqs(unsigned long data)
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	}
 
-	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	if (lock)
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	rcu_read_unlock();
 }
 
+void ieee80211_wake_txqs(unsigned long data)
+{
+	struct ieee80211_local *local = (struct ieee80211_local *)data;
+
+	_ieee80211_wake_txqs(local, true);
+}
+
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -405,8 +413,12 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	} else
 		tasklet_schedule(&local->tx_pending_tasklet);
 
-	if (local->ops->wake_tx_queue)
-		tasklet_schedule(&local->wake_txqs_tasklet);
+	if (local->ops->wake_tx_queue) {
+		if (reason == IEEE80211_QUEUE_STOP_REASON_DRIVER)
+			tasklet_schedule(&local->wake_txqs_tasklet);
+		else
+			_ieee80211_wake_txqs(local, false);
+	}
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
-- 
2.7.4

