Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:38840 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaD3NOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 09:14:36 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so1666754wes.34
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 06:14:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: fix nested rtnl locking on ieee80211_reconfig
Date: Wed, 30 Apr 2014 16:14:24 +0300
Message-Id: <1398863664-20193-2-git-send-email-eliad@wizery.com> (sfid-20140430_151439_063701_814B4A39)
In-Reply-To: <1398863664-20193-1-git-send-email-eliad@wizery.com>
References: <1398863664-20193-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_reconfig already holds rtnl, so calling
cfg80211_sched_scan_stopped results in deadlock.

Use the rtnl-version of this function instead.

Fixes: d43c6b6 ("mac80211: reschedule sched scan after HW restart")
Cc: stable@vger.kernel.org (3.14+)
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ad05875..c08bd4a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1777,7 +1777,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mutex_unlock(&local->mtx);
 
 	if (sched_scan_stopped)
-		cfg80211_sched_scan_stopped(local->hw.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
 
 	/*
 	 * If this is for hw restart things are still running.
-- 
1.8.5.2.229.g4448466.dirty

