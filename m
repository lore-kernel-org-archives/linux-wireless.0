Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdDHVFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 17:05:23 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: rfkill: gpio: Add OBDA8723 ACPI HID
Date: Sat,  8 Apr 2017 23:05:20 +0200
Message-Id: <20170408210520.2799-1-hdegoede@redhat.com> (sfid-20170408_230532_566466_3E322F15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The OBDA8723 ACPI HID is used on quite a few Bay Trail based tablets
for bluetooth rfkill functionality.

Tested-by: russianneuromancer@ya.ru <russianneuromancer@ya.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 76c01cb..50ca65e 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -163,6 +163,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
+	{ "OBDA8723", RFKILL_TYPE_BLUETOOTH },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, rfkill_acpi_match);
-- 
2.9.3
