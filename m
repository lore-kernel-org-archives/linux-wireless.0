Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:38261 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZLRFxO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 00:53:14 -0500
Subject: [PATCH] ps3_gelic_wireless: Fix build failure due to missing
 WEXT_PRIV
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-wireless@vger.kernel.org
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Geoff Levand <geoffrey.levand@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 16:52:54 +1100
Message-ID: <1261115574.2173.18.camel@pasglop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The option to support the old style PSK interface in the PS3
GELIC wireless drivers requires CONFIG_WEXT_PRIV to be set

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Please send to Linus asap (or I can put it in powerpc.git) as it's
breaking one of my test build configs :-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index e58a653..c0ecc77 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2358,6 +2358,7 @@ config GELIC_WIRELESS
 config GELIC_WIRELESS_OLD_PSK_INTERFACE
        bool "PS3 Wireless private PSK interface (OBSOLETE)"
        depends on GELIC_WIRELESS
+       select WEXT_PRIV
        help
           This option retains the obsolete private interface to pass
           the PSK from user space programs to the driver.  The PSK


