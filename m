Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46347 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2G2NZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 09:25:04 -0400
Received: by weyx8 with SMTP id x8so3067585wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 06:25:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: don't clear sched_scan_sdata on sched scan stop request
Date: Sun, 29 Jul 2012 16:25:10 +0300
Message-Id: <1343568310-20213-1-git-send-email-eliad@wizery.com> (sfid-20120729_152551_624593_9286C24A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_request_sched_scan_stop() cleared
local->sched_scan_sdata. However, sched_scan_sdata
should be cleared only after the driver calls
ieee80211_sched_scan_stopped() (like with normal hw scan).

Clearing sched_scan_sdata too early, caused
ieee80211_sched_scan_stopped_work to exit prematurely
without properly cleaning all the sched scan resources,
and without calling cfg80211_sched_scan_stopped (so
userspace wasn't notified about sched scan completion).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/scan.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b6ca2de..1e06f91 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -996,7 +996,6 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 		}
 
 		drv_sched_scan_stop(local, sdata);
-		rcu_assign_pointer(local->sched_scan_sdata, NULL);
 	}
 out:
 	mutex_unlock(&local->mtx);
-- 
1.7.6.401.g6a319

