Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:34107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3KSKgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 05:36:47 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Borislav Petkov <bp@suse.de>,
	Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
Date: Tue, 19 Nov 2013 11:36:42 +0100
Message-Id: <1384857402-4138-1-git-send-email-bp@alien8.de> (sfid-20131119_113707_862133_FFBB4B5B)
In-Reply-To: <528B2B2A.2030504@broadcom.com>
References: <528B2B2A.2030504@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Borislav Petkov <bp@suse.de>

When building randconfigs with CONFIG_BCMA_DRIVER_GPIO=y, I get

drivers/built-in.o: In function `brcms_led_unregister':
(.text+0x351aca): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `brcms_led_register':
(.text+0x351c65): undefined reference to `led_classdev_register'

during final linking stage because brcmsmac/led.c needs LEDS_CLASS for
registering/deregistering the led device. Select the required symbols.

Cc: Arend van Spriel <arend@broadcom.com>
Cc: "Rafał Miłecki" <zajec5@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/net/wireless/brcm80211/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b00a7e92225f..54e36fcb3954 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -5,6 +5,8 @@ config BRCMSMAC
 	tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
 	depends on MAC80211
 	depends on BCMA
+	select NEW_LEDS if BCMA_DRIVER_GPIO
+	select LEDS_CLASS if BCMA_DRIVER_GPIO
 	select BRCMUTIL
 	select FW_LOADER
 	select CRC_CCITT
-- 
1.8.4

