Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:25182 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYGCQ5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 12:57:39 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1087838rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2008 09:57:38 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Only flush workqueue when last interface was removed
Date: Thu, 3 Jul 2008 19:02:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807031902.44808.IvDoorn@gmail.com> (sfid-20080703_185741_622738_760012A5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the ieee80211_hw->workqueue is flushed each time
an interface is being removed. However most scheduled work
is not interface specific but device specific, for example things like
periodic work for link tuners.

This patch will move the flush_workqueue() call to directly behind
the call to ops->stop() to make sure the workqueue is only flushed
when all interfaces are gone and there really shouldn't be any scheduled
work in the drivers left.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 074f71a..577845e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -533,8 +533,6 @@ static int ieee80211_stop(struct net_device *dev)
 				local->sta_hw_scanning = 0;
 		}
 
-		flush_workqueue(local->hw.workqueue);
-
 		sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
 		kfree(sdata->u.sta.extra_ie);
 		sdata->u.sta.extra_ie = NULL;
@@ -558,6 +556,8 @@ static int ieee80211_stop(struct net_device *dev)
 
 		ieee80211_led_radio(local, 0);
 
+		flush_workqueue(local->hw.workqueue);
+
 		tasklet_disable(&local->tx_pending_tasklet);
 		tasklet_disable(&local->tasklet);
 	}
