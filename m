Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 12/20] wireless: move AIRO_CS closer to AIRO_CS
Date: Thu, 13 Aug 2009 15:31:41 -0400
Message-Id: <1250191909-21682-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 694b632..3be8623 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -213,6 +213,26 @@ config AIRO
 
 	  The driver can be compiled as a module and will be named "airo".
 
+config AIRO_CS
+	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
+	depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
+	select WIRELESS_EXT
+	select CRYPTO
+	select CRYPTO_AES
+	---help---
+	  This is the standard Linux driver to support Cisco/Aironet PCMCIA
+	  802.11 wireless cards.  This driver is the same as the Aironet
+	  driver part of the Linux Pcmcia package.
+	  It supports the new 802.11b cards from Cisco (Cisco 34X, Cisco 35X
+	  - with or without encryption) as well as card before the Cisco
+	  acquisition (Aironet 4500, Aironet 4800, Aironet 4800B). It also
+	  supports OEM of Cisco such as the DELL TrueMobile 4800 and Xircom
+	  802.11b cards.
+
+	  This driver support both the standard Linux Wireless Extensions
+	  and Cisco proprietary API, so both the Linux Wireless Tools and the
+	  Cisco Linux utilities can be used to configure the card.
+
 menuconfig ATMEL_80211
 	bool "Atmel Wireless Cards"
 	depends on WLAN_80211
@@ -265,26 +285,6 @@ config AT76C50X_USB
 
 endif # ATMEL_80211
 
-config AIRO_CS
-	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
-	depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
-	select WIRELESS_EXT
-	select CRYPTO
-	select CRYPTO_AES
-	---help---
-	  This is the standard Linux driver to support Cisco/Aironet PCMCIA
-	  802.11 wireless cards.  This driver is the same as the Aironet
-	  driver part of the Linux Pcmcia package.
-	  It supports the new 802.11b cards from Cisco (Cisco 34X, Cisco 35X
-	  - with or without encryption) as well as card before the Cisco
-	  acquisition (Aironet 4500, Aironet 4800, Aironet 4800B). It also
-	  supports OEM of Cisco such as the DELL TrueMobile 4800 and Xircom
-	  802.11b cards.
-
-	  This driver support both the standard Linux Wireless Extensions
-	  and Cisco proprietary API, so both the Linux Wireless Tools and the
-	  Cisco Linux utilities can be used to configure the card.
-
 config PCMCIA_WL3501
       tristate "Planet WL3501 PCMCIA cards"
       depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-- 
1.6.2.5

