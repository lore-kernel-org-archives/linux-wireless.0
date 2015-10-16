Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53320 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbbJPUGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 16:06:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] staging: wilc1000: restore wilc_spi_dev variable
Date: Fri, 16 Oct 2015 22:05:34 +0200
Message-ID: <4978401.AVrDN2jmbq@wuerfel> (sfid-20151016_220652_090852_EFADE802)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent change to wilc1000 accidentally deleted an important
variable, so we now get a build error when the SPI mode is
selected:

ERROR: "wilc_spi_dev" [drivers/staging/wilc1000/wilc1000.ko] undefined!

This partially reverts the broken commit to put the variable back.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 56293ff232b9 ("staging: wilc1000: linux_wlan_spi: include header")
---
Found on ARM randconfig builds.

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 760b72a9a6ff..039d06192d6b 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -41,6 +41,7 @@
 
 static u32 SPEED = MIN_SPEED;
 
+struct spi_device *wilc_spi_dev;
 void linux_spi_deinit(void *vp);
 
 static int __init wilc_bus_probe(struct spi_device *spi)

