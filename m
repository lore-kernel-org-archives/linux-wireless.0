Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41656 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZAHBoA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:44:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:44:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] cfg80211: make handle_band() and handle_channel() wiphy specific
Date: Wed, 7 Jan 2009 17:43:33 -0800
Message-ID: <1231379017-28363-3-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024406_377044_65819890)
In-Reply-To: <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to make more wiphy specific judgements when
handling the channels later on.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2f2ba92..87b3011 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -778,13 +778,22 @@ static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 	return !max_bandwidth;
 }
 
-static void handle_channel(struct ieee80211_channel *chan)
+static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
+			   unsigned int chan_idx)
 {
 	int r;
-	u32 flags = chan->orig_flags;
+	u32 flags;
 	u32 max_bandwidth = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+
+	sband = wiphy->bands[band];
+	BUG_ON(chan_idx >= sband->n_channels);
+	chan = &sband->channels[chan_idx];
+
+	flags = chan->orig_flags;
 
 	r = freq_reg_info(MHZ_TO_KHZ(chan->center_freq),
 		&max_bandwidth, &reg_rule);
@@ -808,12 +817,16 @@ static void handle_channel(struct ieee80211_channel *chan)
 		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-static void handle_band(struct ieee80211_supported_band *sband)
+static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
 {
-	int i;
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	BUG_ON(!wiphy->bands[band]);
+	sband = wiphy->bands[band];
 
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel(&sband->channels[i]);
+		handle_channel(wiphy, band, i);
 }
 
 static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
@@ -840,7 +853,7 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 	enum ieee80211_band band;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
-			handle_band(wiphy->bands[band]);
+			handle_band(wiphy, band);
 	}
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, setby);
-- 
1.6.1.rc3.51.g5832d

