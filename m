Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2GHJfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 05:35:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use full power if off-channel
Date: Sun,  8 Jul 2012 11:35:30 +0200
Message-Id: <1341740130-6199-1-git-send-email-johannes@sipsolutions.net> (sfid-20120708_113538_937734_1D8FE822)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using full power when scanning, use
full power when off-channel. This is different
since off-channel can be remain-on-channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e706f9e..35c4b1d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -148,9 +148,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_HW_SCANNING, &local->scanning))
+	if (local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		power = chan->max_power;
 	else
 		power = local->power_constr_level ?
-- 
1.7.10.4

