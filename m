Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2LDOtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:49:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 15/18] regulatory: remove locking from wiphy_apply_custom_regulatory
Date: Tue,  4 Dec 2012 15:48:57 +0100
Message-Id: <1354632540-21207-16-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154924_258860_E18C30F4)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

wiphy_apply_custom_regulatory() doesn't have to hold
the regulatory mutex as it only modifies the given
wiphy with the given regulatory domain, it doesn't
access any global regulatory data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e0a7312..958f164 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1234,8 +1234,6 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 
-	assert_reg_lock();
-
 	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
 			       desired_bw_khz, &reg_rule, regd);
 
@@ -1280,14 +1278,12 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
 	unsigned int bands_set = 0;
 
-	mutex_lock(&reg_mutex);
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
 		handle_band_custom(wiphy, wiphy->bands[band], regd);
 		bands_set++;
 	}
-	mutex_unlock(&reg_mutex);
 
 	/*
 	 * no point in calling this if it won't have any effect
-- 
1.8.0

