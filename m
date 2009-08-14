Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbZHNUaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:30:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
Date: Fri, 14 Aug 2009 16:25:57 -0400
Message-Id: <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can now remove that comment about mac80211 requiring
cfg80211 and do that for the user.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/Kconfig |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d4d3dca..6293b21 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -1,6 +1,6 @@
 config MAC80211
 	tristate "mac80211 - SoftMAC device support"
-	depends on CFG80211
+	select CFG80211
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_ARC4
@@ -28,10 +28,6 @@ config MAC80211
 	  When built as a module mac80211 will be built as mac80211.ko, if not sure
 	  you should build this as a module.
 
-
-comment "CFG80211 needs to be enabled for MAC80211"
-	depends on CFG80211=n
-
 menu "Rate control algorithm selection"
 	depends on MAC80211 != n
 
-- 
1.6.2.5

