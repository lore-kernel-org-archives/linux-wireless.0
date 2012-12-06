Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945983Ab2LFQro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 17/24] regulatory: remove locking from wiphy_apply_custom_regulatory
Date: Thu,  6 Dec 2012 17:47:41 +0100
Message-Id: <1354812468-15709-18-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174850_586510_DB23A081)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
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
index ea6f057..dfab71b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1226,8 +1226,6 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 
-	assert_reg_lock();
-
 	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
 			       desired_bw_khz, &reg_rule, regd);
 
@@ -1272,14 +1270,12 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
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

