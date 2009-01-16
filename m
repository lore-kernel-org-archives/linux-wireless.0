Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11011 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbZAPANQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:13:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:13:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 07/13] cfg80211: only export disable flag on channel disablement
Date: Thu, 15 Jan 2009 16:12:20 -0800
Message-ID: <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> (sfid-20090116_011327_228652_9E85659E)
In-Reply-To: <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a channel is disabled there is no need to stuff it
with more flags.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b7c6de1..499bbbe 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -867,7 +867,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 			   unsigned int chan_idx)
 {
 	int r;
-	u32 flags;
+	u32 flags, rule_flags;
 	u32 max_bandwidth = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
@@ -913,15 +913,19 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 					"Country IE\n",
 					chan->center_freq, wiphy_name(wiphy));
 #endif
-			flags |= IEEE80211_CHAN_DISABLED;
-			chan->flags = flags;
+			chan->flags = IEEE80211_CHAN_DISABLED;
 		}
 		return;
 	}
 
 	power_rule = &reg_rule->power_rule;
 
-	chan->flags = flags | map_regdom_flags(reg_rule->flags);
+	rule_flags = map_regdom_flags(reg_rule->flags);
+	if (flags & IEEE80211_CHAN_DISABLED)
+		chan->flags = IEEE80211_CHAN_DISABLED;
+	else
+		chan->flags = flags | rule_flags;
+
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
-- 
1.6.1.rc3.51.g5832d

