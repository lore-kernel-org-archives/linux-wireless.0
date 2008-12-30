Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:20855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYL3Vte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 16:49:34 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1170988ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 13:49:32 -0800 (PST)
Date: Tue, 30 Dec 2008 22:49:28 +0100
From: Erik Ekman <erik@kryo.se>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 2.6.28] Wireless: Fix Kconfig fact error
Message-Id: <20081230224928.c0558274.erik@kryo.se> (sfid-20081230_224938_401951_DDB0C74B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raytheon cards use 2.4 GHz, not 2.4 MHz.
See http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.drivers.html#Raylink

Signed-off-by: Erik Ekman <erik@kryo.se>
---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index ea543fc..e4f9f74 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -111,7 +111,7 @@ config WLAN_80211
 	  lets you choose drivers.
 
 config PCMCIA_RAYCS
-	tristate "Aviator/Raytheon 2.4MHz wireless support"
+	tristate "Aviator/Raytheon 2.4GHz wireless support"
 	depends on PCMCIA && WLAN_80211
 	select WIRELESS_EXT
 	---help---
