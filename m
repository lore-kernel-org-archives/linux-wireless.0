Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760992AbZJIQRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 12:17:42 -0400
Subject: [PATCH] wireless: make wireless drivers select core
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Oct 2009 18:17:05 +0200
Message-Id: <1255105025.4095.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is somewhat non-sensical to allow selecting wireless
drivers without showing wireless core code options, and
since the wext refactoring this has made it possible to
generate configurations that will not build. Avoid this
and make wireless drivers select the wireless options.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/Kconfig	2009-10-08 20:25:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/Kconfig	2009-10-08 20:27:38.000000000 +0200
@@ -5,6 +5,7 @@
 menuconfig WLAN
 	bool "Wireless LAN"
 	depends on !S390
+	select WIRELESS
 	default y
 	---help---
 	  This section contains all the pre 802.11 and 802.11 wireless


