Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab2C1JHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:07:22 -0400
Message-Id: <20120328090432.832972620@sipsolutions.net> (sfid-20120328_110729_294287_06CF7B5B)
Date: Wed, 28 Mar 2012 11:04:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] mac80211: debounce queue stop/wake
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the queue status changes we need to do a fair
bit of work, so ignore no-op changes early.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/util.c	2012-03-28 09:33:36.000000000 +0200
+++ b/net/mac80211/util.c	2012-03-28 09:45:03.000000000 +0200
@@ -276,6 +276,9 @@ static void __ieee80211_wake_queue(struc
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
+	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
+		return;
+
 	__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
 	if (local->queue_stop_reasons[queue] != 0)
@@ -323,6 +326,9 @@ static void __ieee80211_stop_queue(struc
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
+	if (test_bit(reason, &local->queue_stop_reasons[queue]))
+		return;
+
 	__set_bit(reason, &local->queue_stop_reasons[queue]);
 
 	rcu_read_lock();


