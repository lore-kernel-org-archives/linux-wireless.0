Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40063 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753523AbZLAXqK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 18:46:10 -0500
Subject: [PATCH] lib80211: make crypt modules configurable by user
From: Daniel Ritz <daniel.ritz@gmx.ch>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, daniel.ritz-ml@swissonline.ch
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 00:46:14 +0100
Message-ID: <1259711174.13720.17.camel@MacRitz2>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the crypt modules configurable by user. Normally drivers select them
when needed, but out-of-tree drivers can't do that. Having a minimal
kernel with just the things required won't select any of those modules,
resulting in the external driver to be close to useless (ie. it can scan
the networks, but cannot join a single one).

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
---
 net/wireless/Kconfig |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index abf7ca3..48f60ab 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -123,17 +123,30 @@ config LIB80211
 	  This options enables a library of common routines used
 	  by IEEE802.11 wireless LAN drivers.
 
-	  Drivers should select this themselves if needed.  Say Y if
-	  you want this built into your kernel.
+	  Drivers should select this themselves if needed, but for
+	  out-of-tree drivers manually selecting it might be required.
+	  Say Y if you want this built into your kernel.
 
 config LIB80211_CRYPT_WEP
-	tristate
+	tristate "lib80211 WEP support module"
+	depends on LIB80211
+	default m
+	help
+	  This adds WEP support to lib80211.
 
 config LIB80211_CRYPT_CCMP
-	tristate
+	tristate "lib80211 CCMP support module"
+	depends on LIB80211
+	default m
+	help
+	  This adds CCMP support to lib80211.
 
 config LIB80211_CRYPT_TKIP
-	tristate
+	tristate "lib80211 TKIP support module"
+	depends on LIB80211
+	default m
+	help
+	  This adds TKIP support to lib80211.
 
 config LIB80211_DEBUG
 	bool "lib80211 debugging messages"
-- 
1.6.3.3



