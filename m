Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48991 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752000Ab2FYCRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 22:17:30 -0400
Message-ID: <4FE7CA1C.9030204@xenotime.net> (sfid-20120625_041733_929597_F2C0067B)
Date: Sun, 24 Jun 2012 19:17:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH] wlcore: drop INET dependency
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Mainline build reports:

warning: (WL12XX) selects WLCORE which has unmet direct dependencies (NETDEVICES && WLAN && WL_TI && GENERIC_HARDIRQS && MAC80211 && INET)

The INET dependency was added in commit
3c6af5b54fe74b6e56efadc22927e4055d00e9fc:
    wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_
notifier'
    wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_no
tifier'
    
    Driver is doing some filtering based on IP addresses...

but this driver no longer has that code and it builds fine even when
CONFIG_INET is not enabled, so drop that dependency and eliminate the
kconfig warning message.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ti/wlcore/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- lnx-35-rc3.orig/drivers/net/wireless/ti/wlcore/Kconfig
+++ lnx-35-rc3/drivers/net/wireless/ti/wlcore/Kconfig
@@ -1,7 +1,6 @@
 config WLCORE
 	tristate "TI wlcore support"
 	depends on WL_TI && GENERIC_HARDIRQS && MAC80211
-	depends on INET
 	select FW_LOADER
 	---help---
 	  This module contains the main code for TI WLAN chips.  It abstracts
