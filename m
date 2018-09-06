Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeIGDFw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 23:05:52 -0400
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net: wireless: mediatek: fix mt76 LEDS build error
Message-ID: <563c7f90-1d9f-440c-4670-8fbebc9f76b0@infradead.org> (sfid-20180907_002819_635083_3649053E)
Date: Thu, 6 Sep 2018 15:28:12 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

All of the mt76 driver options use its mac80211.o component,
which uses led interfaces, so each of them should depend on
LEDS_CLASS.

Fixes this build error:

drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_led_init':
drivers/net/wireless/mediatek/mt76/mac80211.c:119: undefined reference to `devm_of_led_classdev_register'

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/mediatek/mt76/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20180906.orig/drivers/net/wireless/mediatek/mt76/Kconfig
+++ linux-next-20180906/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -18,6 +18,7 @@ config MT76x0U
 	tristate "MediaTek MT76x0U (USB) support"
 	select MT76_CORE
 	depends on MAC80211
+	depends on LEDS_CLASS
 	depends on USB
 	select MT76x02_LIB
 	help
@@ -28,6 +29,7 @@ config MT76x2E
 	select MT76_CORE
 	select MT76x2_COMMON
 	depends on MAC80211
+	depends on LEDS_CLASS
 	depends on PCI
 	---help---
 	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
@@ -38,6 +40,7 @@ config MT76x2U
 	select MT76_USB
 	select MT76x2_COMMON
 	depends on MAC80211
+	depends on LEDS_CLASS
 	depends on USB
 	help
 	  This adds support for MT7612U-based wireless USB dongles.
