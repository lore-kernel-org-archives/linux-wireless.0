Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:45127 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYIBTJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 15:09:02 -0400
Message-ID: <48BD8F0C.5010209@oracle.com> (sfid-20080902_210908_190142_614215B8)
Date: Tue, 02 Sep 2008 12:07:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	akpm <akpm@linux-foundation.org>
CC: lrodriguez@atheros.com, jmalinen@atheros.com
Subject: [PATCH -next] ath9k: uses/needs led_classdev_[un]register
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

ath9k uses LED classdev functions, so it needs to either select or depend
on them.  This patch uses the same selects that ath5k uses...

drivers/built-in.o: In function `ath_unregister_led':
main.c:(.text+0x138c1d): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `ath_register_led':
main.c:(.text+0x139c16): undefined reference to `led_classdev_register'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Luis R. Rodriguez <lrodriguez@atheros.com>
cc: Jouni Malinen <jmalinen@atheros.com>
---
 drivers/net/wireless/ath9k/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20080902.orig/drivers/net/wireless/ath9k/Kconfig
+++ linux-next-20080902/drivers/net/wireless/ath9k/Kconfig
@@ -1,6 +1,9 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008 and AR9001 family of chipsets.
