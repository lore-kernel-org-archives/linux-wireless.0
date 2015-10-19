Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57741 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbbJSJkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:40:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] staging/wilc: fix Kconfig dependencies, second try
Date: Mon, 19 Oct 2015 11:39:31 +0200
Message-ID: <4253270.hGxaSY0VLA@wuerfel> (sfid-20151019_114024_219876_27731E3B)
In-Reply-To: <5624A1AF.8080607@atmel.com>
References: <5446980.8Rmykv9Tt3@wuerfel> <5624A1AF.8080607@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 October 2015 16:54:23 Tony Cho wrote:
> Hi Arnd Bergmann,
> 
> When I apply this patch, I cannot make WILC1000 module (wilc1000.ko) because CONFIG_WILC1000 is y and also I can see some link errors for the cfg80211 APIs.
> 
> Can you consider this patch?

Ah, you are right. I see the same thing now and don't know what caused me
to send the patch in an incomplete state.

I hope this snippet is the last missing piece:

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index ee51b4278088..e3f109655be4 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -1,6 +1,7 @@
 config WILC1000_DRIVER
-	bool "WILC1000 support (WiFi only)"
+	tristate "WILC1000 support (WiFi only)"
 	depends on CFG80211 && WEXT_CORE && INET
+	depends on MMC || SPI
 	---help---
 	  This module only support IEEE 802.11n WiFi.
 
@@ -35,7 +36,7 @@ choice
 
 config WILC1000_SDIO
 	bool "SDIO support"
-	depends on MMC
+	depends on MMC=y || (MMC=m && WILC1000_DRIVER=m)
 	select WILC1000
 	---help---
 	  This module adds support for the SDIO interface of adapters using

I'll do a few hundred more randconfig builds with this on top and submit
it once it succeeds.

	Arnd
