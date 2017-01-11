Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33464 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030464AbdAKPhw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:37:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: calculate min channel width correctly
Date: Wed, 11 Jan 2017 16:37:47 +0100
Message-Id: <20170111153748.797-2-johannes@sipsolutions.net> (sfid-20170111_163803_024169_C421F32E)
In-Reply-To: <20170111153748.797-1-johannes@sipsolutions.net>
References: <20170111153748.797-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the current minimum chandef code there's an issue in that the
recalculation can happen after rate control is initialized for a
station that has a wider bandwidth than the current chanctx, and
then rate control can immediately start using those higher rates
which could cause problems.

Observe that first of all that this problem is because we don't
take non-associated and non-uploaded stations into account. The
restriction to non-associated is quite pointless and is one of
the causes for the problem described above, since the rate init
will happen before the station is set to associated; no frames
could actually be sent until associated, but the rate table can
already contain higher rates and that might cause problems.

Also, rejecting non-uploaded stations is wrong, since the rate
control can select higher rates for those as well.

Secondly, it's then necessary to recalculate the minimal config
before initializing rate control, so that when rate control is
initialized, the higher rates are already available. This can be
done easily by adding the necessary function call in rate init.

Change-Id: Ib9bc02d34797078db55459d196993f39dcd43070
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c | 3 ---
 net/mac80211/rate.c | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e75cbf6ecc26..a0d901d8992e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -231,9 +231,6 @@ ieee80211_get_max_required_bw(struct ieee80211_sub_if_data *sdata)
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
 
-		if (!sta->uploaded || !test_sta_flag(sta, WLAN_STA_ASSOC))
-			continue;
-
 		max_bw = max(max_bw, ieee80211_get_sta_bw(&sta->sta));
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 206698bc93f4..9e2641d45587 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -40,6 +40,8 @@ void rate_control_rate_init(struct sta_info *sta)
 
 	ieee80211_sta_set_rx_nss(sta);
 
+	ieee80211_recalc_min_chandef(sta->sdata);
+
 	if (!ref)
 		return;
 
-- 
2.9.3
