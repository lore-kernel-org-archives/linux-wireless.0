Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40806 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933534AbaDINwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:52:00 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1941038eei.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:51:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 4/5] mac80211: ignore cqm during csa
Date: Wed,  9 Apr 2014 15:45:36 +0200
Message-Id: <1397051137-26201-5-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155248_675001_269587BB)
In-Reply-To: <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not guaranteed that multi-vif channel
switching is tightly synchronized. It makes sense
to ignore cqm (missing beacons, et al) while csa
is progressing and re-check it after it completes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/mlme.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f87cbf6..417db18 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1006,6 +1006,9 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 
+	ieee80211_sta_reset_beacon_monitor(sdata);
+	ieee80211_sta_reset_conn_monitor(sdata);
+
 out:
 	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
@@ -3593,6 +3596,9 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	if (sdata->vif.csa_active)
+		return;
+
 	sdata->u.mgd.connection_loss = false;
 	ieee80211_queue_work(&sdata->local->hw,
 			     &sdata->u.mgd.beacon_connection_loss_work);
@@ -3608,6 +3614,9 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	if (sdata->vif.csa_active)
+		return;
+
 	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
 }
 
-- 
1.8.5.3

