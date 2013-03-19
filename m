Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57037 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933Ab3CSVYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 17:24:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] mac80211:  Be more careful about sending beacon-loss-events.
Date: Tue, 19 Mar 2013 14:23:54 -0700
Message-Id: <1363728234-1629-2-git-send-email-greearb@candelatech.com> (sfid-20130319_222412_624378_BDA78077)
In-Reply-To: <1363728234-1629-1-git-send-email-greearb@candelatech.com>
References: <1363728234-1629-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I don't think we should send the events unless it was actually
a beacon that was lost...not just any probe of an AP.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 f46607a... 81e0619... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f46607a..81e0619 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1624,12 +1624,14 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	if (beacon)
+	if (beacon) {
 		mlme_dbg_ratelimited(sdata,
 				     "detected beacon loss from AP - sending probe request\n");
 
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

