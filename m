Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab2LMU3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:29:12 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1815723pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 12:29:12 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 3/3] cfg80211: move world roaming check for beacon hints
Date: Thu, 13 Dec 2012 12:28:54 -0800
Message-Id: <1355430534-7881-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20121213_212939_625045_2E9952C7)
In-Reply-To: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com>
References: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

We should not add new beacon hints even if the wiphy
is not world roaming. Without this we were always adding
a beacon hint if not world roaming for every non world
roaming wiphy interface.

Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f649b5e..bdc42d9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1076,6 +1076,9 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 
 	chan->beacon_found = true;
 
+	if (!reg_is_world_roaming(wiphy))
+		return;
+
 	if (wiphy->flags & WIPHY_FLAG_DISABLE_BEACON_HINTS)
 		return;
 
@@ -1149,8 +1152,6 @@ static void reg_process_beacons(struct wiphy *wiphy)
 	 */
 	if (!last_request)
 		return;
-	if (!reg_is_world_roaming(wiphy))
-		return;
 	wiphy_update_beacon_reg(wiphy);
 }
 
-- 
1.7.10.4

