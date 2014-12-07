Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43019 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaLGQDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2014 11:03:49 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so2696953wiw.13
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2014 08:03:48 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] cfg80211: avoid intersection when applying custom reg
Date: Sun,  7 Dec 2014 18:03:45 +0200
Message-Id: <1417968225-17518-1-git-send-email-arik@wizery.com> (sfid-20141207_170524_482778_BC240F77)
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
 net/wireless/reg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8941e1c..e4f4619 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1686,8 +1686,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (IS_ERR(reg_rule)) {
 		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			      chan->center_freq);
-		chan->orig_flags |= IEEE80211_CHAN_DISABLED;
-		chan->flags = chan->orig_flags;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
@@ -1712,7 +1711,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	chan->dfs_state = NL80211_DFS_USABLE;
 
 	chan->beacon_found = false;
-	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
+	chan->flags = map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_reg_power = chan->max_power =
 		(int) MBM_TO_DBM(power_rule->max_eirp);
-- 
1.9.1

