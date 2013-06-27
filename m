Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:48211 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3F0Qkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:40:33 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp06.msg.oleane.net (MTA) with ESMTP id r5RGeVWK016849
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 18:40:31 +0200
From: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
To: linux-wireless@vger.kernel.org
Cc: "J.P. Tosoni" <jp.tosoni@acksys.fr>
Subject: [RFC v2] mac80211: Use libnl-configurable values for retry counts
Date: Thu, 27 Jun 2013 18:40:27 +0200
Message-Id: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> (sfid-20130627_184036_911240_4D3EDD74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: J.P. Tosoni <jp.tosoni@acksys.fr>

In the rate control algorithms, the maximum retry count is limited by
a) a constant value obtained from the hardware driver
b) a constant limit (6ms) on the time allowed for all
   retries of each frame.

Replace the retry count by existing configurable values from nl80211.
Use wiphy->retry_long for frames whose length exceed rts_threshold.
Use wiphy->retry_short for all other frames.
Check that the configured value does not exceed driver capabilities.
Use the new values as soon as the next frame is transmitted.

Caveat: the retry count for frames sent outside the context of a STA is
still taken from the hardware driver.
---
What I am seeking with this patch:
I believe the configuration of the retries will help making recovery
much faster when an AP (in infrastructure mode) or a peer (in mesh
mode) suddenly disappears.

>From Felix Fietkau's comments:
- short retries arbitrarily reserved for management frames: now it depends on
the use_rts flag which is set when frame length > rts_threshold, which matches
the standard.
- "minstrel_alloc ... never update (long_frame_max_tx_count) again"
The value is now directly used each time we send a frame, the configuration
should now apply immediately. (not yet tested, need to change iw)

 net/mac80211/cfg.c  |    6 ++++++
 net/mac80211/rate.c |   31 ++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 082f270..4f43beb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2203,11 +2203,17 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
 		if (wiphy->retry_short > IEEE80211_MAX_TX_RETRY)
 			return -EINVAL;
+		if (wiphy->retry_short >
+				local->hw.max_rate_tries*local->hw.max_rates)
+			return -EINVAL;
 		local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
 		if (wiphy->retry_long > IEEE80211_MAX_TX_RETRY)
 			return -EINVAL;
+		if (wiphy->retry_long >
+				local->hw.max_rate_tries*local->hw.max_rates)
+			return -EINVAL;
 		local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	}
 	if (changed &
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index a02bef3..a8eaca1 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -537,18 +537,42 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 {
 	struct ieee80211_sta_rates *ratetbl = NULL;
 	int i;
+	int max_retries;
 
 	if (sta && !info->control.skip_table)
 		ratetbl = rcu_dereference(sta->rates);
 
+	if (sta) {
+		struct ieee80211_hw *hw;
+
+		hw = &container_of(sta, struct sta_info, sta)->local->hw;
+		if (info->control.use_rts)
+			max_retries = hw->conf.long_frame_max_tx_count;
+		else
+			max_retries = hw->conf.short_frame_max_tx_count;
+	} else {
+		/*
+		 * No STA, we cannot access hw. Set to a max value, so that
+		 * the values computed by the rate control algorithm will be
+		 * used unlimited.
+		 */
+		max_retries = max_rates * 256; /* garanteed max value of u8 */
+	}
+
 	/* Fill remaining rate slots with data from the sta rate table. */
 	max_rates = min_t(int, max_rates, IEEE80211_TX_RATE_TABLE_SIZE);
 	for (i = 0; i < max_rates; i++) {
-		if (i < ARRAY_SIZE(info->control.rates) &&
+		if (max_retries <= 0) {
+			rates[i].idx = -1;
+			rates[i].count = 0;
+		} else if (i < ARRAY_SIZE(info->control.rates) &&
 		    info->control.rates[i].idx >= 0 &&
 		    info->control.rates[i].count) {
 			if (rates != info->control.rates)
 				rates[i] = info->control.rates[i];
+			if (max_retries < rates[i].count) {
+				rates[i].count = max_retries;
+			}
 		} else if (ratetbl) {
 			rates[i].idx = ratetbl->rate[i].idx;
 			rates[i].flags = ratetbl->rate[i].flags;
@@ -558,6 +582,9 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 				rates[i].count = ratetbl->rate[i].count_cts;
 			else
 				rates[i].count = ratetbl->rate[i].count;
+			if (max_retries < rates[i].count) {
+				rates[i].count = max_retries;
+			}
 		} else {
 			rates[i].idx = -1;
 			rates[i].count = 0;
@@ -565,6 +592,8 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 
 		if (rates[i].idx < 0 || !rates[i].count)
 			break;
+
+		max_retries -= rates[i].count;
 	}
 }
 
-- 
1.7.2.5

