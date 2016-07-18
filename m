Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33357 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbcGRKed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 06:34:33 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bcma: allow enabling serial flash support on non-MIPS SoCs
Date: Mon, 18 Jul 2016 12:34:14 +0200
Message-Id: <1468838054-17014-1-git-send-email-zajec5@gmail.com> (sfid-20160718_123506_877014_6BCDEA59)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far we had only MIPS devices with serial flash connected to the SoC's
ChipCommon. ARM devices got a separated SPI controller and weere using
standard SPI drivers.
This has changed with the wireless SoC BCM47189B0. It's ARM based but
has serial flash attached just like older devices. This allows using
existing driver with these devices.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index efdc2ae..b5c48a8 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -76,9 +76,16 @@ config BCMA_PFLASH
 	default y
 
 config BCMA_SFLASH
-	bool
-	depends on BCMA_DRIVER_MIPS
+	bool "ChipCommon-attached serial flash support"
+	depends on BCMA_HOST_SOC
 	default y
+	help
+	  Some cheap devices have serial flash connected to the ChipCommon
+	  instead of independent SPI controller. It requires using a separated
+	  driver that implements ChipCommon specific interface communication.
+
+	  Enabling this symbol will let bcma recognize serial flash and register
+	  it as platform device.
 
 config BCMA_NFLASH
 	bool
-- 
1.8.4.5

