Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48232 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaCGNiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:14 -0500
Received: by mail-ea0-f171.google.com with SMTP id n15so2318384ead.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:13 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 7/8] cfg80211: Use 5MHz bandwidth when checking usable channels
Date: Fri,  7 Mar 2014 14:37:54 +0100
Message-Id: <1394199475-5208-8-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143842_317104_7AF144E0)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current code checks if the 20MHz BW is allowed for particular
channel -- if it is not, the channel is disabled. Since we
need to use 5/10 MHz channels, this code is modified in the way
that the default BW to check is 5MHz. If 5MHz is greater than
the maximum bandwidth supported by the channel, the channel is
disabled. If it is smaller than the maximum BW, the channel is
used and the flags are set according to the BW supported by the
channel.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/wireless/reg.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b897fc..582e623 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -805,7 +805,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(5));
 
 		if (band_rule_found && bw_fits)
 			return rr;
@@ -888,10 +888,10 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 }
 #endif
 
-/*
- * Note that right now we assume the desired channel bandwidth
- * is always 20 MHz for each individual channel (HT40 uses 20 MHz
- * per channel, the primary and the extension channel).
+/* Find an ieee80211_reg_rule such that a 5MHz channel with frequency
+ * @chan->center_freq fits there.
+ * If there is no such reg_rule, disable the channel, otherwise set the
+ * flags corresponding to the bandwidths allowed in the particular reg_rule
  */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
@@ -944,8 +944,12 @@ static void handle_channel(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
@@ -1351,8 +1355,12 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
-- 
1.8.5.1

