Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:43541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1FCVIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 17:08:35 -0400
From: Paul Stewart <pstew@chromium.org>
Date: Wed, 11 May 2011 14:38:34 -0700
Subject: [PATCH] mac80211: Start monitor work on restart
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org
Message-Id: <20110603210826.EA010203BB@glenhelen.mtv.corp.google.com> (sfid-20110603_230845_039029_D9330715)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trigger connection monitor on resume from suspend.  Since we
have been sleeping, there is reason to suspect that we might
not still be associated.  The speed of detecting loss of
{connection,authentication} is worth the cost of the small
additional traffic at resume.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 456cccf..41b9809 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2212,6 +2212,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 		add_timer(&ifmgd->chswitch_timer);
 	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_restart_sta_timer(sdata);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.monitor_work);
 }
 #endif
 
-- 
1.7.3.1

