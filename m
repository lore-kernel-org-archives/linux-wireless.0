Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:32897 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbcAXPhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 10:37:50 -0500
Received: by mail-lb0-f178.google.com with SMTP id x4so63218509lbm.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 07:37:49 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add support for BCM47094
Date: Sun, 24 Jan 2016 16:37:33 +0100
Message-Id: <1453649853-11412-1-git-send-email-zajec5@gmail.com> (sfid-20160124_163824_032909_CD0CFF0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's another SoC with 32 GPIOs and simplified watchdog handling. It was
tested on D-Link DIR-885L.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon.c | 1 +
 drivers/bcma/driver_gpio.c       | 1 +
 include/linux/bcma/bcma.h        | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index bdb73d9..b0f44a2 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -197,6 +197,7 @@ u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 		struct bcma_bus *bus = cc->core->bus;
 
 		if (bus->chipinfo.id != BCMA_CHIP_ID_BCM4707 &&
+		    bus->chipinfo.id != BCMA_CHIP_ID_BCM47094 &&
 		    bus->chipinfo.id != BCMA_CHIP_ID_BCM53018)
 			bcma_core_set_clockmode(cc->core,
 						ticks ? BCMA_CLKMODE_FAST : BCMA_CLKMODE_DYNAMIC);
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 504899a7..77b0738f 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -197,6 +197,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM4707:
 	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM47094:
 		chip->ngpio	= 32;
 		break;
 	default:
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 991ebb4..0367c63 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -201,6 +201,7 @@ struct bcma_host_ops {
 #define  BCMA_PKG_ID_BCM4707	1
 #define  BCMA_PKG_ID_BCM4708	2
 #define  BCMA_PKG_ID_BCM4709	0
+#define BCMA_CHIP_ID_BCM47094	53030
 #define BCMA_CHIP_ID_BCM53018	53018
 
 /* Board types (on PCI usually equals to the subsystem dev id) */
-- 
1.8.4.5

