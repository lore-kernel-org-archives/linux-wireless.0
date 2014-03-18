Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44713 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaCRN7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:32 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so5301058eei.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 19/21] mac80211: ignore cqm during csa
Date: Tue, 18 Mar 2014 14:53:22 +0100
Message-Id: <1395150804-24090-20-git-send-email-michal.kazior@tieto.com> (sfid-20140318_145939_713487_9CA0D580)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
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
index e729da3..c654a1c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -997,6 +997,9 @@ cleanup:
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 
+	ieee80211_sta_reset_beacon_monitor(sdata);
+	ieee80211_sta_reset_conn_monitor(sdata);
+
 out:
 	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
@@ -3586,6 +3589,9 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	if (sdata->vif.csa_active)
+		return;
+
 	sdata->u.mgd.connection_loss = false;
 	ieee80211_queue_work(&sdata->local->hw,
 			     &sdata->u.mgd.beacon_connection_loss_work);
@@ -3601,6 +3607,9 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	if (sdata->vif.csa_active)
+		return;
+
 	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
 }
 
-- 
1.8.5.3

