Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.130]:56097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaCJOGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 10:06:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Gang Zhao <gamerh2o@gmail.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: wireless: Kconfig: add missing dependency for airo_cs
Date: Mon, 10 Mar 2014 15:05:25 +0100
Message-ID: <1398887.G3HYkOfaVN@wuerfel> (sfid-20140310_150713_275578_61D1E552)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 4c59ff221e070 "wireless: Kconfig: add missing dependency" added a number
of 'depends on CFG80211' statements, but missed the AIRO_CS driver that
also causes the airo.c file to be built. This adds the (hopefully) last
such missing statement
    
Cc: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index d1fab43..9c2c285 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -116,7 +116,7 @@ config AT76C50X_USB
 
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
-	depends on PCMCIA && (BROKEN || !M32R)
+	depends on CFG80211 && PCMCIA && (BROKEN || !M32R)
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
