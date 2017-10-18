Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52212 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdJRHgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 03:36:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: validate user rate mask before configuring driver
Date: Wed, 18 Oct 2017 09:36:51 +0200
Message-Id: <20171018073651.4725-1-johannes@sipsolutions.net> (sfid-20171018_093658_342007_73E02FE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Ben reported that when the user rate mask is rejected for not
matching any basic rate, the driver had already been configured.
This is clearly an oversight in my original change, fix this by
doing the validation before calling the driver.

Reported-by: Ben Greear <greearb@candelatech.com>
Fixes: e8e4f5280ddd ("mac80211: reject/clear user rate mask if not usable")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a354f1939e49..fb15d3b97cb2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2727,12 +2727,6 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
-	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
-		ret = drv_set_bitrate_mask(local, sdata, mask);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * If active validate the setting and reject it if it doesn't leave
 	 * at least one basic rate usable, since we really have to be able
@@ -2748,6 +2742,12 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 			return -EINVAL;
 	}
 
+	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
+		ret = drv_set_bitrate_mask(local, sdata, mask);
+		if (ret)
+			return ret;
+	}
+
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband = wiphy->bands[i];
 		int j;
-- 
2.14.2
