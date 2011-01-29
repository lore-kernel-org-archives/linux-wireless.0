Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38827 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1A2NvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 08:51:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
Subject: [PATCH] cfg80211: fix maximum tx power handling
Date: Sat, 29 Jan 2011 14:51:12 +0100
Message-Id: <1296309072-47452-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting a new regulatory domain after the initial one had been set by
the driver, the original maximum power is overwritten with the new regulatory
power value. This is wrong because chan->orig_mpwr is supposed to contain the
hardware tx power limit.
Because of this, the displayed tx power is often much higher than what the
hardware is actually capable of using.

Fix this by always using chan->orig_mpwr as a maximum and never overwriting
it in the regulatory handling code.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 net/wireless/reg.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c565689..2eb6eca 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -838,6 +838,12 @@ static void handle_channel(struct wiphy *wiphy,
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
 
+	if (chan->orig_mpwr)
+		chan->max_power = min(chan->orig_mpwr,
+			(int) MBM_TO_DBM(power_rule->max_eirp));
+	else
+		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+
 	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
@@ -850,19 +856,12 @@ static void handle_channel(struct wiphy *wiphy,
 			map_regdom_flags(reg_rule->flags) | bw_flags;
 		chan->max_antenna_gain = chan->orig_mag =
 			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
-		chan->max_power = chan->orig_mpwr =
-			(int) MBM_TO_DBM(power_rule->max_eirp);
 		return;
 	}
 
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-	if (chan->orig_mpwr)
-		chan->max_power = min(chan->orig_mpwr,
-			(int) MBM_TO_DBM(power_rule->max_eirp));
-	else
-		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
 static void handle_band(struct wiphy *wiphy,
-- 
1.7.3.2

