Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40791 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaK1LPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 06:15:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: make WEXT compatibility unselectable
Date: Fri, 28 Nov 2014 12:15:24 +0100
Message-Id: <1417173324-29898-1-git-send-email-johannes@sipsolutions.net> (sfid-20141128_121540_684391_8EC1B8DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will signal people who are actually still using it even
though it has been deprecated and disabled for a long time.

They can still get it back, but only by patching the kernel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 29c8675f9a11..22ba971741e5 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -175,7 +175,7 @@ config CFG80211_INTERNAL_REGDB
 	  Most distributions have a CRDA package.  So if unsure, say N.
 
 config CFG80211_WEXT
-	bool "cfg80211 wireless extensions compatibility"
+	bool
 	depends on CFG80211
 	select WEXT_CORE
 	help
-- 
2.1.1

