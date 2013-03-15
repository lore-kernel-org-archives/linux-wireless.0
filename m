Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40681 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3COAYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 20:24:33 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211:  Don't restart sta-timer if not associated.
Date: Thu, 14 Mar 2013 17:24:03 -0700
Message-Id: <1363307043-23771-1-git-send-email-greearb@candelatech.com> (sfid-20130315_012436_532333_DCDE8CD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I found another crash when deleting lots of virtual stations
in a congested environment.  I think the problem is that
the ieee80211_mlme_notify_scan_completed could call
ieee80211_restart_sta_timer for a non-associated interface
that was about to be deleted.

With the following patch I am unable to reproduce the
crash.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Be more selective:  Still need to do sdata->work even
  if not associated so that we *can* associate.

:100644 100644 81e0619... da805e2... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 81e0619..da805e2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2935,11 +2935,14 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 
 		/* let's probe the connection once */
 		flags = sdata->local->hw.flags;
-		if (!(flags & IEEE80211_HW_CONNECTION_MONITOR))
+		if ((!(flags & IEEE80211_HW_CONNECTION_MONITOR)) &&
+		    sdata->u.mgd.associated)
 			ieee80211_queue_work(&sdata->local->hw,
 					     &sdata->u.mgd.monitor_work);
+
 		/* and do all the other regular work too */
-		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+		if (ieee80211_sdata_running(sdata))
+			ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
 }
 
-- 
1.7.3.4

