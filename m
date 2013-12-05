Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49047 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3LEJVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:21:38 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so11190204eak.39
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:21:37 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	Barak Bercovitz <barak@wizery.com>
Subject: [PATCH 1/4] cfg80211: stop sched scan only when needed
Date: Thu,  5 Dec 2013 11:21:26 +0200
Message-Id: <1386235289-27278-1-git-send-email-eliad@wizery.com> (sfid-20131205_102143_852813_761051DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Barak Bercovitz <barak@wizery.com>

cfg80211_leave stops sched scan when any station vif
is leaving. Add an explicit check and call it only
when the relevant vif (the one we scan on) is leaving.

Signed-off-by: Barak Bercovitz <barak@wizery.com>
[Eliad - changed the commit message a bit]
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/wireless/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 32af857..a8e48c7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -775,7 +775,8 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		__cfg80211_stop_sched_scan(rdev, false);
+		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
+			__cfg80211_stop_sched_scan(rdev, false);
 
 		wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
-- 
1.8.5.rc1

