Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55932 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3KUP4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 10:56:30 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/4] mac80211: don't cancel csa finalize work within stop_ap
Date: Thu, 21 Nov 2013 16:56:22 +0100
Message-Id: <1385049383-5617-4-git-send-email-sw@simonwunderlich.de> (sfid-20131121_165634_773275_025B7589)
In-Reply-To: <1385049383-5617-1-git-send-email-sw@simonwunderlich.de>
References: <1385049383-5617-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current channel switch code has a potential deadlock:
1) * cfg80211_stop_ap acquires wdev-lock
   * ieee80211_stop_ap calls cancel_work_sync for the csa_finalize_work,
     which acquires the associated worker-lock
2) * ieee80211_csa_finalize_work holds the worker-lock when run
   * it calls cfg80211_ch_switch_notify which will claim the wdev-lock,
     and also needs to claim the sdata-lock (which is the same as the
     wdev-lock) to modify the beacons.

It is sufficient to just set the channel switch active to false. If the
worker is running later, it will find the channel switch to not be
active anymore and returns immediately without changing anything.

Canceling the worker is done anyway when the interface goes down
(ieee80211_do_stop).

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/cfg.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a135e6f..9f19cde 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1080,7 +1080,6 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	/* abort any running channel switch */
 	sdata->vif.csa_active = false;
-	cancel_work_sync(&sdata->csa_finalize_work);
 	cancel_work_sync(&sdata->u.ap.request_smps_work);
 
 	/* turn off carrier for this interface and dependent VLANs */
-- 
1.7.10.4

