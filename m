Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HUJ2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 05:28:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luca@coelho.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN into drivers
Date: Wed, 21 Aug 2013 11:27:55 +0200
Message-Id: <1377077275-19429-1-git-send-email-johannes@sipsolutions.net> (sfid-20130821_112808_609524_25DD4221)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 currently sets WIPHY_FLAG_SUPPORTS_SCHED_SCAN based on whether
the start_sched_scan operation is supported or not, but that will not
be correct for all drivers, we're adding scheduled scan to the iwlmvm
driver but it depends on firmware support.

Therefore, move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN into the drivers
so that they can control it regardless of implementing the operation.

This currently only affects the TI drivers since they're the only ones
implementing scheduled scan (in a mac80211 driver.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 ++-
 net/mac80211/main.c                   | 3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d1b19c3..38995f9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5623,7 +5623,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_remain_on_channel_duration = 5000;
 
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
-				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+				WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 
 	/* make sure all our channels fit in the scanned_ch bitmask */
 	BUILD_BUG_ON(ARRAY_SIZE(wl1271_channels) +
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 25eb35b..21d5d44 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -892,9 +892,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (!local->ops->remain_on_channel)
 		local->hw.wiphy->max_remain_on_channel_duration = 5000;
 
-	if (local->ops->sched_scan_start)
-		local->hw.wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-
 	/* mac80211 based drivers don't support internal TDLS setup */
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
-- 
1.8.4.rc2

