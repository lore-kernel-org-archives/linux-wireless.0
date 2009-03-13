Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZCMKoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:44:12 -0400
Subject: [PATCH] mac80211: stop queues across suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 11:43:36 +0100
Message-Id: <1236941016.5235.10.camel@johannes.local> (sfid-20090313_114414_606928_A13727F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though userland probably cannot submit packets, there might
still be some coming, and that's no good when the driver doesn't
expect them. Stop the queues across suspend/resume.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/pm.c          |    6 ++++++
 2 files changed, 7 insertions(+)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-13 11:40:31.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-13 11:40:41.000000000 +0100
@@ -598,6 +598,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_PS,
 	IEEE80211_QUEUE_STOP_REASON_CSA,
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
+	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 };
 
 struct ieee80211_master_priv {
--- wireless-testing.orig/net/mac80211/pm.c	2009-03-13 11:40:12.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-03-13 11:40:56.000000000 +0100
@@ -11,6 +11,9 @@ int __ieee80211_suspend(struct ieee80211
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 
+	ieee80211_stop_queues_by_reason(hw,
+			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+
 	flush_workqueue(local->hw.workqueue);
 
 	/* disable keys */
@@ -113,5 +116,8 @@ int __ieee80211_resume(struct ieee80211_
 	ieee80211_configure_filter(local);
 	netif_addr_unlock_bh(local->mdev);
 
+	ieee80211_wake_queues_by_reason(hw,
+			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+
 	return 0;
 }


