Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33801 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaLORVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 12:21:03 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so9757100wiw.15
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 09:21:01 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v9 4/4] cfg80211: avoid intersection when applying self-managed reg
Date: Mon, 15 Dec 2014 19:20:55 +0200
Message-Id: <1418664055-3963-4-git-send-email-arik@wizery.com> (sfid-20141215_182108_101721_461DA0ED)
In-Reply-To: <1418664055-3963-1-git-send-email-arik@wizery.com>
References: <1418664055-3963-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The custom-reg handling function can currently only add flags to a given
channel. This results in stale flags being left applied. In some cases
a channel was disabled and even the orig_flags were changed to reflect
this.

Previously the API was designed for a single invocation before wiphy
registration, so this didn't matter. The previous approach doesn't scale
well to self-managed regulatory devices, particularly when a more
permissive regdom is applied after a restrictive one.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/wireless/reg.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 87ef745..8aaff02 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1686,8 +1686,12 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (IS_ERR(reg_rule)) {
 		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			      chan->center_freq);
-		chan->orig_flags |= IEEE80211_CHAN_DISABLED;
-		chan->flags = chan->orig_flags;
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
+			chan->flags |= IEEE80211_CHAN_DISABLED;
+		} else {
+			chan->orig_flags |= IEEE80211_CHAN_DISABLED;
+			chan->flags = chan->orig_flags;
+		}
 		return;
 	}
 
@@ -1712,7 +1716,13 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	chan->dfs_state = NL80211_DFS_USABLE;
 
 	chan->beacon_found = false;
-	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
+
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		chan->flags = chan->orig_flags | bw_flags |
+			      map_regdom_flags(reg_rule->flags);
+	else
+		chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
+
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_reg_power = chan->max_power =
 		(int) MBM_TO_DBM(power_rule->max_eirp);
-- 
1.9.1

