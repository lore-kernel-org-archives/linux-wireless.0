Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42872 "EHLO sipsolutions.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbbDHHTh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 03:19:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jim Davis <jim.epost@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: don't allow disabling WEXT if it's required
Date: Wed,  8 Apr 2015 09:19:12 +0200
Message-Id: <1428477552-10304-1-git-send-email-johannes@sipsolutions.net> (sfid-20150408_091940_665156_EAD900A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The change to only export WEXT symbols when required could break
the build if CONFIG_CFG80211_WEXT was explicitly disabled while
a driver like orinoco selected it.

Fix this by hiding the symbol when it's required so it can't be
disabled in that case.

Fixes: 2afe38d15cee ("cfg80211-wext: export symbols only when needed")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index b13dfb4ff001..4f5543dd2524 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -175,7 +175,7 @@ config CFG80211_INTERNAL_REGDB
 	  Most distributions have a CRDA package.  So if unsure, say N.
 
 config CFG80211_WEXT
-	bool "cfg80211 wireless extensions compatibility"
+	bool "cfg80211 wireless extensions compatibility" if !CFG80211_WEXT_EXPORT
 	depends on CFG80211
 	select WEXT_CORE
 	default y if CFG80211_WEXT_EXPORT
-- 
2.1.4

