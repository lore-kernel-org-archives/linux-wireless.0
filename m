Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1KILOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:14:20 -0500
Subject: [PATCH] mac80211: fix race between connection monitor & suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Meyer <thomas@m3y3r.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 12:14:16 +0100
Message-ID: <1320837256.3845.36.camel@jlt3.sipsolutions.net> (sfid-20111109_121424_402576_5F422D3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the connection monitor timer fires right before
suspend, the following will happen:
 timer fires -> monitor_work gets queued
 suspend calls ieee80211_sta_quiesce
 ieee80211_sta_quiesce:
  - deletes timer
  - cancels monitor_work synchronously, running it
  [note wrong order of these steps]
 monitor_work runs, re-arming the timer
 later, timer fires while system should be quiesced

This causes a warning:

WARNING: at net/mac80211/util.c:540 ieee80211_can_queue_work+0x35/0x40 [mac80211]()

but is otherwise harmless. I'm not completely sure
this is the scenario Thomas stumbled across, but it
is the only way I can right now see the warning in
a scenario like the one he reported.

Reported-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c	2011-11-09 12:05:44.000000000 +0100
+++ b/net/mac80211/mlme.c	2011-11-09 12:07:11.000000000 +0100
@@ -2288,6 +2288,7 @@ void ieee80211_sta_quiesce(struct ieee80
 
 	cancel_work_sync(&ifmgd->request_smps_work);
 
+	cancel_work_sync(&ifmgd->monitor_work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
@@ -2296,7 +2297,6 @@ void ieee80211_sta_quiesce(struct ieee80
 	if (del_timer_sync(&ifmgd->chswitch_timer))
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
 
-	cancel_work_sync(&ifmgd->monitor_work);
 	/* these will just be re-established on connection */
 	del_timer_sync(&ifmgd->conn_mon_timer);
 	del_timer_sync(&ifmgd->bcn_mon_timer);


