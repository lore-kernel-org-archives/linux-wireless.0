Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58837 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2BSNVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 08:21:42 -0500
Received: by mail-ww0-f44.google.com with SMTP id dt10so3987767wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 05:21:41 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: remove redundant monitor_work enqueueing
Date: Sun, 19 Feb 2012 15:26:10 +0200
Message-Id: <1329657970-22751-2-git-send-email-eliad@wizery.com> (sfid-20120219_142215_757972_8DD7D483)
In-Reply-To: <1329657970-22751-1-git-send-email-eliad@wizery.com>
References: <1329657970-22751-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_restart_sta_timer() takes care for enqueueing
monitor_work if needed, so no need to do it again.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7ece99a..586d4fb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3048,7 +3048,6 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 		add_timer(&ifmgd->chswitch_timer);
 	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_restart_sta_timer(sdata);
-	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.monitor_work);
 }
 #endif
 
-- 
1.7.6.401.g6a319

