Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2HAPVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/8] mac80211: fix CSA handling timer
Date: Wed,  1 Aug 2012 17:21:22 +0200
Message-Id: <1343834487-23737-4-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172137_159670_AF8B8BE1)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The time until the channel switch is in TU,
not in milliseconds, so use TU_TO_EXP_TIME()
to correctly program the timer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc1c84b..5eef6bd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -813,9 +813,8 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  jiffies +
-			  msecs_to_jiffies(sw_elem->count *
-					   cbss->beacon_interval));
+			  TU_TO_EXP_TIME(sw_elem->count *
+					 cbss->beacon_interval));
 }
 
 static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-- 
1.7.10.4

