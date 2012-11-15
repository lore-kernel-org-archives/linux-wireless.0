Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2KOXFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 18:05:48 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] lib80211: hide Kconfig symbol
Date: Fri, 16 Nov 2012 00:06:20 +0100
Message-Id: <1353020780-5459-1-git-send-email-johannes@sipsolutions.net> (sfid-20121116_000551_995132_EBB46C5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to ask the user about lib80211
since it will be selected by drivers requiring
it, hide it from Kconfig.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index fe4adb1..16d08b3 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -140,14 +140,13 @@ config CFG80211_WEXT
 	  extensions with cfg80211-based drivers.
 
 config LIB80211
-	tristate "Common routines for IEEE802.11 drivers"
+	tristate
 	default n
 	help
 	  This options enables a library of common routines used
 	  by IEEE802.11 wireless LAN drivers.
 
-	  Drivers should select this themselves if needed.  Say Y if
-	  you want this built into your kernel.
+	  Drivers should select this themselves if needed.
 
 config LIB80211_CRYPT_WEP
 	tristate
-- 
1.8.0

