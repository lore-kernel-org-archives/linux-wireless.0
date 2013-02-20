Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36269 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3BTRlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 12:41:20 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/2] mac80211:  Stop timers before canceling work items.
Date: Wed, 20 Feb 2013 09:41:08 -0800
Message-Id: <1361382069-31729-1-git-send-email-greearb@candelatech.com> (sfid-20130220_184123_653697_BABBBF90)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Re-order the quiesce code so that timers are
always stopped before work-items are flushed.  This was
not the problem I saw, but I think it may still be more
correct.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/mlme.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 164ecf0..4001d1c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2946,6 +2946,13 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	/* Stop timers before deleting work items, as timers could
+	 * race and re-add the work-items.
+	 * These will be re-established on connection.
+	 */
+	del_timer_sync(&ifmgd->conn_mon_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
+
 	/*
 	 * we need to use atomic bitops for the running bits
 	 * only because both timers might fire at the same
@@ -2960,13 +2967,9 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
 
-	cancel_work_sync(&ifmgd->chswitch_work);
 	if (del_timer_sync(&ifmgd->chswitch_timer))
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
-
-	/* these will just be re-established on connection */
-	del_timer_sync(&ifmgd->conn_mon_timer);
-	del_timer_sync(&ifmgd->bcn_mon_timer);
+	cancel_work_sync(&ifmgd->chswitch_work);
 }
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
-- 
1.7.3.4

