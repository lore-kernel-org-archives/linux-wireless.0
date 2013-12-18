Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54356 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRNBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 08:01:51 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so5843103pab.8
        for <linux-wireless@vger.kernel.org>; Wed, 18 Dec 2013 05:01:51 -0800 (PST)
From: ZHAO Gang <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: remove function reg_process_beacons()
Date: Wed, 18 Dec 2013 20:56:38 +0800
Message-Id: <db1bee094cd6ead618cb41fb7831503be0b4e3ef.1387371372.git.gamerh2o@gmail.com> (sfid-20131218_140155_009844_B9C9CC50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since pointer last_request is initialized to &core_request_world, the
if check in reg_process_beacons() is useless, and
reg_process_beacons() is only called by wiphy_update_regulatory(), so
we can let wiphy_update_regulatory() calls wiphy_update_beacon_reg()
directly and remove unnecesssary reg_process_beacons().

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 net/wireless/reg.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec54e1a..b833bea 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1163,18 +1163,6 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 	}
 }
 
-/* Reap the advantages of previously found beacons */
-static void reg_process_beacons(struct wiphy *wiphy)
-{
-	/*
-	 * Means we are just firing up cfg80211, so no beacons would
-	 * have been processed yet.
-	 */
-	if (!last_request)
-		return;
-	wiphy_update_beacon_reg(wiphy);
-}
-
 static bool is_ht40_allowed(struct ieee80211_channel *chan)
 {
 	if (!chan)
@@ -1281,7 +1269,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
 		handle_band(wiphy, initiator, wiphy->bands[band]);
 
-	reg_process_beacons(wiphy);
+	wiphy_update_beacon_reg(wiphy);
 	reg_process_ht_flags(wiphy);
 	reg_call_notifier(wiphy, lr);
 }
-- 
1.8.3.1

