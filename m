Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab1ALMjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:39:55 -0500
Subject: [PATCH] mac80211: fix lockdep warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Miles Lane <miles.lane@gmail.com>, Sujith <m.sujith@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 13:40:33 +0100
Message-ID: <1294836033.3639.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the introduction of the fixes for the
reorder timer, mac80211 will cause lockdep
warnings because lockdep confuses
local->skb_queue and local->rx_skb_queue
and treats their lock as the same.

However, their locks are different, and are
valid in different contexts (the former is
used in IRQ context, the latter in BH only)
and the only thing to be done is mark the
former as a different lock class so that
lockdep can tell the difference.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Sujith <m.sujith@gmail.com>
Reported-by: Miles Lane <miles.lane@gmail.com>
Tested-by: Sujith <m.sujith@gmail.com>
Tested-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/main.c	2011-01-12 09:58:07.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2011-01-12 10:02:03.000000000 +0100
@@ -39,6 +39,8 @@ module_param(ieee80211_disable_40mhz_24g
 MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
 		 "Disable 40MHz support in the 2.4GHz band");
 
+static struct lock_class_key ieee80211_rx_skb_queue_class;
+
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;
@@ -569,7 +571,15 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
-	skb_queue_head_init(&local->rx_skb_queue);
+	/*
+	 * The rx_skb_queue is only accessed from tasklets,
+	 * but other SKB queues are used from within IRQ
+	 * context. Therefore, this one needs a different
+	 * locking class so our direct, non-irq-safe use of
+	 * the queue's lock doesn't throw lockdep warnings.
+	 */
+	skb_queue_head_init_class(&local->rx_skb_queue,
+				  &ieee80211_rx_skb_queue_class);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 


