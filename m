Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56322 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaG1Na0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 09:30:26 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so7338181wgh.27
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 06:30:25 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] cfg80211: re-enable CSA for drivers that support it
Date: Mon, 28 Jul 2014 15:21:05 +0200
Message-Id: <1406553665-16355-1-git-send-email-michal.kazior@tieto.com> (sfid-20140728_153033_387747_D4EF6E65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit dda444d52496aa8ddc501561bca580f1374a96a9.

Channel switching code has been reworked and
improved significantly since the time original
locking issues were found.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index afee5e0..a207eb1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -492,12 +492,6 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
-	/*
-	 * There are major locking problems in nl80211/mac80211 for CSA,
-	 * disable for all drivers until this has been reworked.
-	 */
-	wiphy->flags &= ~WIPHY_FLAG_HAS_CHANNEL_SWITCH;
-
 #ifdef CONFIG_PM
 	if (WARN_ON(wiphy->wowlan &&
 		    (wiphy->wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
-- 
1.8.5.3

