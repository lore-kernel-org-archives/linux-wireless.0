Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58837 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2BSNVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 08:21:41 -0500
Received: by wgbdt10 with SMTP id dt10so3987767wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 05:21:39 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: don't queue monitor work for HW_CONNECTION_MONITOR
Date: Sun, 19 Feb 2012 15:26:09 +0200
Message-Id: <1329657970-22751-1-git-send-email-eliad@wizery.com> (sfid-20120219_142215_177317_45EE28B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices that monitor the connection in the hw don't need
the monitor work in the driver.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 52133da..7ece99a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2974,13 +2974,17 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
+	u32 flags;
+
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sdata->u.mgd.flags &= ~(IEEE80211_STA_BEACON_POLL |
 					IEEE80211_STA_CONNECTION_POLL);
 
 		/* let's probe the connection once */
-		ieee80211_queue_work(&sdata->local->hw,
-			   &sdata->u.mgd.monitor_work);
+		flags = sdata->local->hw.flags;
+		if (!(flags & IEEE80211_HW_CONNECTION_MONITOR))
+			ieee80211_queue_work(&sdata->local->hw,
+					     &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
 		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
-- 
1.7.6.401.g6a319

