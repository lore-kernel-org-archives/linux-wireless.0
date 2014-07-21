Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:41750 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaGULIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 07:08:14 -0400
Message-ID: <53CCF498.8000800@imgtec.com> (sfid-20140721_130818_006767_FBF110C1)
Date: Mon, 21 Jul 2014 16:38:08 +0530
From: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH-v2] mac80211: Requeue work for all iftypes after scan completion
References: <53BEB909.3030802@imgtec.com>
In-Reply-To: <53BEB909.3030802@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Sachin Kulkarni<sachin.kulkarni@imgtec.com>

During a hw scan ieee80211_iface_work ignores work items for all vifs. However
after the scan complete work is requeued only for STA, ADHOC and MESH iftypes.
This occasionally results in event processing getting delayed for iftype AP when
it coexists with a STA, and when the scan durations are very long.

Signed-off-by: Sachin Kulkarni<sachin.kulkarni@imgtec.com>
Cc: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
---
v2: Fix white space after comma

We have a test scenario where there are 2 VIFs: one STA and one AP. The STA is
not connected to anyone while the AP has a station connected to it. The hardware
we are using currently has scan durations of ~8 sec and a new scan request is
generated every 10 s. This results in a window of only 2 s when work items can
be processed by ieee80211_iface_work. We came across scenarios where the AP is
trying to tear down a AMPDU session, and the IEEE80211_SDATA_QUEUE_AGG_STOP
event gets queued. However the work item for this gets ignored by the ieee80211_iface_work
since a hw scan is in progress most of the time. When the scan completes however
the work item for the AP does not get requeued, and by the time the
IEEE80211_SDATA_QUEUE_AGG_STOP gets processed in some other work items context,
the TX frames just keep getting queued up, since the tid has not been destroyed.
This results in disconnections since things like ARP timeouts etc start
happening.
---
  net/mac80211/mlme.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 931330b..49af420 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3647,9 +3647,10 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
  		if (!(flags&   IEEE80211_HW_CONNECTION_MONITOR))
  			ieee80211_queue_work(&sdata->local->hw,
  					&sdata->u.mgd.monitor_work);
-		/* and do all the other regular work too */
-		ieee80211_queue_work(&sdata->local->hw,&sdata->work);
  	}
+
+	/* and do all the other regular work too */
+	ieee80211_queue_work(&sdata->local->hw,&sdata->work);
  }

  #ifdef CONFIG_PM



