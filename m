Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:13579 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGUOyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 10:54:36 -0400
From: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [PATCH-v3] mac80211: Requeue work for all iftypes after scan
 completion
Date: Mon, 21 Jul 2014 14:54:30 +0000
Message-ID: <595BC7E78B8E074B8ACE72C46C1F6A2C2A79FF56@hbmail01.hb.imgtec.org> (sfid-20140721_165443_147472_883F2A79)
References: <595BC7E78B8E074B8ACE72C46C1F6A2C2A79FF28@hbmail01.hb.imgtec.org>
In-Reply-To: <595BC7E78B8E074B8ACE72C46C1F6A2C2A79FF28@hbmail01.hb.imgtec.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
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
v3: Fix white space after comma

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
 		if (!(flags & IEEE80211_HW_CONNECTION_MONITOR))
 			ieee80211_queue_work(&sdata->local->hw,
 					     &sdata->u.mgd.monitor_work);
-		/* and do all the other regular work too */
-		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
+
+	/* and do all the other regular work too */
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
 #ifdef CONFIG_PM