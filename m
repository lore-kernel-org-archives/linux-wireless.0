Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48505 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbZAELvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 06:51:52 -0500
Date: Mon, 5 Jan 2009 13:51:24 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Enforce module build if rfkill is a module
Message-ID: <20090105115124.GA2235@jm.kir.nu> (sfid-20090105_125156_359105_6FC16FEB)
References: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com> <20090102180730.GA10072@elte.hu> <3f9a31f40901021040l2afb5e19sc37e61d3f9728531@mail.gmail.com> <495E6C96.3040102@kernel.org> <20090102195802.GA28494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090102195802.GA28494@elte.hu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_ATH9K=y results in build issues if CONFIG_RFKILL=m since ath9k
does not depend on rfkill in kconfig (i.e., CONFIG_RFKILL is used to
select whether to enable rfkill in ath9k), but uses its functions if
rfkill is enabled. Enforce ath9k to be build as a module if
CONFIG_RFKILL=m to avoid this invalid configuration.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/Kconfig	2009-01-05 13:27:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/Kconfig	2009-01-05 13:36:27.000000000 +0200
@@ -1,6 +1,7 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
+	depends on RFKILL || RFKILL=n
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS

-- 
Jouni Malinen                                            PGP id EFC895FA
