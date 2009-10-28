Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:61789 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZJ1XNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 19:13:53 -0400
Date: Wed, 28 Oct 2009 16:08:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linville@tuxdriver.com
Subject: [PATCH -next] wireless: airo_cs needs WEXT_SPY
Message-Id: <20091028160832.411ff31d.randy.dunlap@oracle.com>
In-Reply-To: <20091028190643.627f10aa.sfr@canb.auug.org.au>
References: <20091028190643.627f10aa.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

airo_cs uses spy interfaces so it needs to select WEXT_SPY.

ERROR: "iw_handler_set_thrspy" [drivers/net/wireless/airo.ko] undefined!
ERROR: "wireless_spy_update" [drivers/net/wireless/airo.ko] undefined!
ERROR: "iw_handler_get_spy" [drivers/net/wireless/airo.ko] undefined!
ERROR: "iw_handler_get_thrspy" [drivers/net/wireless/airo.ko] undefined!
ERROR: "iw_handler_set_spy" [drivers/net/wireless/airo.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091028.orig/drivers/net/wireless/Kconfig
+++ linux-next-20091028/drivers/net/wireless/Kconfig
@@ -111,6 +111,7 @@ config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
 	depends on PCMCIA && (BROKEN || !M32R)
 	select WIRELESS_EXT
+	select WEXT_SPY
 	select CRYPTO
 	select CRYPTO_AES
 	---help---
