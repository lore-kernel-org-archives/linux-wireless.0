Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZG0Idb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 04:33:31 -0400
Subject: [PATCH] mac80211: verify info->control.vif is not NULL
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 10:33:31 +0200
Message-Id: <1248683611.19945.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When enqueuing packets on the internal packet queue, we
need to ensure that we have a valid vif pointer since
that is required since the net namespace work. Add some
assertions to verify this, but also don't crash is for
some reason we don't end up with a vif pointer -- warn
and drop the packet in all these cases.

Since this code touches a number of hotpaths, it is
intended to be temporary, or maybe configurable in the
future, at least the bit that is in the path that gets
hit for every packet, ieee80211_tx_pending().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c   |    5 +++++
 net/mac80211/util.c |   13 +++++++++++++
 2 files changed, 18 insertions(+)

--- wireless-testing.orig/net/mac80211/util.c	2009-07-27 10:24:01.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-07-27 10:25:14.000000000 +0200
@@ -336,6 +336,12 @@ void ieee80211_add_pending_skb(struct ie
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long flags;
 	int queue = skb_get_queue_mapping(skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if (WARN_ON(!info->control.vif)) {
+		kfree(skb);
+		return;
+	}
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
@@ -358,6 +364,13 @@ int ieee80211_add_pending_skbs(struct ie
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
 
 	while ((skb = skb_dequeue(skbs))) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+		if (WARN_ON(!info->control.vif)) {
+			kfree(skb);
+			continue;
+		}
+
 		ret++;
 		queue = skb_get_queue_mapping(skb);
 		__skb_queue_tail(&local->pending[queue], skb);
--- wireless-testing.orig/net/mac80211/tx.c	2009-07-27 10:23:12.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-07-27 10:26:55.000000000 +0200
@@ -1889,6 +1889,11 @@ void ieee80211_tx_pending(unsigned long 
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			struct ieee80211_sub_if_data *sdata;
 
+			if (WARN_ON(!info->control.vif)) {
+				kfree_skb(skb);
+				continue;
+			}
+
 			sdata = vif_to_sdata(info->control.vif);
 			dev_hold(sdata->dev);
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,


