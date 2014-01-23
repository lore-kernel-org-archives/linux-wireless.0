Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaAWPdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:33:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] cfg80211: re-enable 5/10 MHz support
Date: Thu, 23 Jan 2014 16:33:22 +0100
Message-Id: <1390491202-32360-1-git-send-email-johannes@sipsolutions.net> (sfid-20140123_163341_080761_BFEFCF07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately I forgot this during the merge window, but the
patch seems small enough to go in as a fix. The userspace API
bug that was the reason for disabling it has long been fixed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d89dee2..77fe4c7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -440,9 +440,6 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
-	/* support for 5/10 MHz is broken due to nl80211 API mess - disable */
-	wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_5_10_MHZ;
-
 	/*
 	 * There are major locking problems in nl80211/mac80211 for CSA,
 	 * disable for all drivers until this has been reworked.
-- 
1.8.5.2

