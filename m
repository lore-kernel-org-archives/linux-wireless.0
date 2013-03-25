Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57326 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3CYSTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 14:19:49 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/2] mac80211: Be more careful about sending beacon-loss-events.
Date: Mon, 25 Mar 2013 11:19:35 -0700
Message-Id: <1364235575-20268-2-git-send-email-greearb@candelatech.com> (sfid-20130325_191952_187668_19F41606)
In-Reply-To: <1364235575-20268-1-git-send-email-greearb@candelatech.com>
References: <1364235575-20268-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I don't think we should send the events unless it was actually
a beacon that was lost...not just any probe of an AP.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Now against mac80211-next tree.

:100644 100644 9958cb7... fe72749... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9958cb7..fe72749 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1978,13 +1978,15 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	if (beacon)
+	if (beacon) {
 		mlme_dbg_ratelimited(sdata,
 				     "detected beacon loss from AP (missed %d beacons) - probing\n",
 				     beacon_loss_count);
 
-	ieee80211_cqm_rssi_notify(&sdata->vif,
-		NL80211_CQM_RSSI_BEACON_LOSS_EVENT, GFP_KERNEL);
+		ieee80211_cqm_rssi_notify(&sdata->vif,
+					  NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
+					  GFP_KERNEL);
+	}
 
 	/*
 	 * The driver/our work has already reported this event or the
-- 
1.7.3.4

