Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36282 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbcGOTIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 15:08:22 -0400
Received: by mail-oi0-f65.google.com with SMTP id u68so9992582oie.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 12:08:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [RFC] rfkill: Add new ACPI device for Realtek serial BT
Date: Fri, 15 Jul 2016 14:08:16 -0500
Message-Id: <1468609696-8828-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160715_210832_697016_54F9CDCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Realtek RTL8723BS chips, which are connected via SDIO, also contain
a serial Bluetooth device. In order for BT to work, the device must be
added to the acpi_device_id table.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

I have no idea if this device should be added here, or if the device could
be added to some structure supplied at device startup. If anyone has any
suggestions, please let me know.

Thanks,

Larry
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
2.6.6

