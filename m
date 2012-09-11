Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7042 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108Ab2IKLwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 07:52:35 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1] cfg80211: Fix regulatory check for 60GHz band frequencies
Date: Tue, 11 Sep 2012 14:52:09 +0300
Message-ID: <1347364329-19443-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120911_135238_462538_5A410BD0)
In-Reply-To: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove freq_in_rule_band, that was used to optimize regulatory rules check.
Approach used in the freq_in_rule_band is incorrect for 60GHz band,
where channel spacing is 2.160GHz.
Also, it does not really add any optimization, since real check for frequency fit is
always performed.

Issue exposed in the following way: 60g band defines 3 channels supported wold-wide:
channels 1..3 or 58320, 60480, 62640 MHz, and channel 4, or 64800 MHz,
in the most of the world, with 2160 MHz spacing.
Corresponded regulatory rule for channels 1..3 would be
(57240 - 63720 @ 2160)

And, when regulatory applies to the channel 2 (60480), it get disabled since it is
more then 2GHz from either frequency boundary and freq_in_rule_band fails

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/reg.c |   54 ++++++----------------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad04e5..5b0dc05 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -497,31 +497,6 @@ static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
 	return false;
 }
 
-/**
- * freq_in_rule_band - tells us if a frequency is in a frequency band
- * @freq_range: frequency rule we want to query
- * @freq_khz: frequency we are inquiring about
- *
- * This lets us know if a specific frequency rule is or is not relevant to
- * a specific frequency's band. Bands are device specific and artificial
- * definitions (the "2.4 GHz band" and the "5 GHz band"), however it is
- * safe for now to assume that a frequency rule should not be part of a
- * frequency's band if the start freq or end freq are off by more than 2 GHz.
- * This resolution can be lowered and should be considered as we add
- * regulatory rule support for other "bands".
- **/
-static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
-	u32 freq_khz)
-{
-#define ONE_GHZ_IN_KHZ	1000000
-	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
-		return true;
-	if (abs(freq_khz - freq_range->end_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
-		return true;
-	return false;
-#undef ONE_GHZ_IN_KHZ
-}
-
 /*
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
@@ -692,9 +667,7 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 			      const struct ieee80211_regdomain *custom_regd)
 {
 	int i;
-	bool band_rule_found = false;
 	const struct ieee80211_regdomain *regd;
-	bool bw_fits = false;
 
 	if (!desired_bw_khz)
 		desired_bw_khz = MHZ_TO_KHZ(20);
@@ -715,33 +688,18 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 		return -EINVAL;
 
 	for (i = 0; i < regd->n_reg_rules; i++) {
-		const struct ieee80211_reg_rule *rr;
-		const struct ieee80211_freq_range *fr = NULL;
+		const struct ieee80211_reg_rule *rr = &regd->reg_rules[i];
+		const struct ieee80211_freq_range *fr = &rr->freq_range;
+		bool bw_fits = reg_does_bw_fit(fr,
+					       center_freq,
+					       desired_bw_khz);
 
-		rr = &regd->reg_rules[i];
-		fr = &rr->freq_range;
-
-		/*
-		 * We only need to know if one frequency rule was
-		 * was in center_freq's band, that's enough, so lets
-		 * not overwrite it once found
-		 */
-		if (!band_rule_found)
-			band_rule_found = freq_in_rule_band(fr, center_freq);
-
-		bw_fits = reg_does_bw_fit(fr,
-					  center_freq,
-					  desired_bw_khz);
-
-		if (band_rule_found && bw_fits) {
+		if (bw_fits) {
 			*reg_rule = rr;
 			return 0;
 		}
 	}
 
-	if (!band_rule_found)
-		return -ERANGE;
-
 	return -EINVAL;
 }
 
-- 
1.7.9.5

