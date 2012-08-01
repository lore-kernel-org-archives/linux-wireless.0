Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2HAJDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 05:03:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: use correct (original) max power
Date: Wed,  1 Aug 2012 11:03:39 +0200
Message-Id: <1343811819-15582-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_110350_289489_AA41BA81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When calculating the maximum TX power for a channel,
the original maximum power should be restricted to
the current regulatory TX power. Restricting the
current maximum TX power has the effect that it'll
never be possible to increase the power again when
the regulatory requirement changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2303ee7..070b88c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -901,7 +901,7 @@ static void handle_channel(struct wiphy *wiphy,
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
-	chan->max_power = min(chan->max_power, chan->max_reg_power);
+	chan->max_power = min(chan->orig_mpwr, chan->max_reg_power);
 }
 
 static void handle_band(struct wiphy *wiphy,
-- 
1.7.10.4

