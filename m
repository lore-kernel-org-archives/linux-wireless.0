Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-150-144.gdrpmi.dsl-w.verizon.net ([71.115.150.144]:41486
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZHHVxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:53:48 -0400
From: Pat Erley <pat-lkml@erley.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Pat Erley <pat-lkml@erley.org>
Subject: [PATCH] mac80211: remove max_bandwidth
Date: Sat,  8 Aug 2009 17:53:19 -0400
Message-Id: <1249768399-16855-1-git-send-email-pat-lkml@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the max_bandwidth attribute.  It is only ever
written to, and is duplicated by max_bandwidth_khz in the
regulatory code.

Signed-off-by: Pat Erley <pat-lkml@erley.org>
---
 include/net/cfg80211.h |    2 --
 net/wireless/reg.c     |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5756c9..2239134 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -80,7 +80,6 @@ enum ieee80211_channel_flags {
  * with cfg80211.
  *
  * @center_freq: center frequency in MHz
- * @max_bandwidth: maximum allowed bandwidth for this channel, in MHz
  * @hw_value: hardware-specific value for the channel
  * @flags: channel flags from &enum ieee80211_channel_flags.
  * @orig_flags: channel flags at registration time, used by regulatory
@@ -97,7 +96,6 @@ enum ieee80211_channel_flags {
 struct ieee80211_channel {
 	enum ieee80211_band band;
 	u16 center_freq;
-	u8 max_bandwidth;
 	u16 hw_value;
 	u32 flags;
 	int max_antenna_gain;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0f61ae6..fc7a484 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1018,7 +1018,6 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 			map_regdom_flags(reg_rule->flags) | bw_flags;
 		chan->max_antenna_gain = chan->orig_mag =
 			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
-		chan->max_bandwidth = KHZ_TO_MHZ(desired_bw_khz);
 		chan->max_power = chan->orig_mpwr =
 			(int) MBM_TO_DBM(power_rule->max_eirp);
 		return;
@@ -1027,7 +1026,6 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-	chan->max_bandwidth = KHZ_TO_MHZ(desired_bw_khz);
 	if (chan->orig_mpwr)
 		chan->max_power = min(chan->orig_mpwr,
 			(int) MBM_TO_DBM(power_rule->max_eirp));
@@ -1329,7 +1327,6 @@ static void handle_channel_custom(struct wiphy *wiphy,
 
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
-	chan->max_bandwidth = KHZ_TO_MHZ(desired_bw_khz);
 	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-- 
1.6.4

