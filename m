Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:56822 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730027AbeHNBUH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:20:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johan Hovold <johan@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rfkill-gpio: include linux/mod_devicetable.h
Date: Tue, 14 Aug 2018 00:35:24 +0200
Message-Id: <20180813223528.991144-1-arnd@arndb.de> (sfid-20180814_003608_029480_EC0AF1F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One more driver is apparently broken by the recent change
to linux/platform_device.h:

net/rfkill/rfkill-gpio.c: In function 'rfkill_gpio_acpi_probe':
net/rfkill/rfkill-gpio.c:82:29: error: dereferencing pointer to incomplete type 'const struct acpi_device_id'

Include linux/mod_devicetable.h to get the definition of the
acpi_device_id structure.

Fixes: ac3167257b9f ("headers: separate linux/mod_devicetable.h from linux/platform_device.h")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 00192a996be0..0f8465852254 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/rfkill.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-- 
2.18.0
