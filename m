Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:33400 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaCaMKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 08:10:34 -0400
Received: by mail-we0-f179.google.com with SMTP id x48so4591941wes.38
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 05:10:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 4/5] mac80211: ignore cqm during csa
Date: Mon, 31 Mar 2014 14:04:18 +0200
Message-Id: <1396267459-9976-5-git-send-email-michal.kazior@tieto.com> (sfid-20140331_141055_545272_DF4E190C)
In-Reply-To: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
References: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
 <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
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
index 07a4324..ecf9681 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -983,6 +983,9 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 
+	ieee80211_sta_reset_beacon_monitor(sdata);
+	ieee80211_sta_reset_conn_monitor(sdata);
+
 out:
 	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
@@ -3570,6 +3573,9 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	if (sdata->vif.csa_active)
+		return;
+
 	sdata->u.mgd.connection_loss = false;
 	ieee80211_queue_work(&sdata->local->hw,
 			     &sdata->u.mgd.beacon_connection_loss_work);
@@ -3585,6 +3591,9 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	if (sdata->vif.csa_active)
+		return;
+
 	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
 }
 
-- 
1.8.5.3

