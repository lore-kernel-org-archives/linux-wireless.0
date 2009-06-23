Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZFWLSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:18:03 -0400
Subject: [PATCH] wext: default to y
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 13:18:01 +0200
Message-Id: <1245755881.4184.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The way I initially thought we could do wireless extensions
is by making all the compat code in cfg80211 be independent
of CONFIG_WIRELESS_EXT, but this is turning out to not be
feasible. Therefore, fix the Kconfig help text and make the
option default to yes, so people won't get a nasty surprise
when mac80211 will get rid of its 'select WIRELESS_EXT' any
time now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/Kconfig |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/wireless/Kconfig	2009-06-23 13:11:05.000000000 +0200
+++ wireless-testing/net/wireless/Kconfig	2009-06-23 13:15:02.000000000 +0200
@@ -51,19 +51,13 @@ config WIRELESS_OLD_REGULATORY
 
 config WIRELESS_EXT
 	bool "Wireless extensions"
-	default n
+	default y
 	---help---
 	  This option enables the legacy wireless extensions
 	  (wireless network interface configuration via ioctls.)
 
-	  Wireless extensions will be replaced by cfg80211 and
-	  will be required only by legacy drivers that implement
-	  wireless extension handlers. This option does not
-	  affect the wireless-extension backward compatibility
-	  code in cfg80211.
-
-	  Say N (if you can) unless you know you need wireless
-	  extensions for external modules.
+	  Say Y unless you've upgraded all your userspace to use
+	  nl80211 instead of wireless extensions.
 
 config WIRELESS_EXT_SYSFS
 	bool "Wireless extensions sysfs files"


