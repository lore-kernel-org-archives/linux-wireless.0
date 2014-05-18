Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46170 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaERLlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2014 07:41:45 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so2748854eek.36
        for <linux-wireless@vger.kernel.org>; Sun, 18 May 2014 04:41:44 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Fengguang Wu <fengguang.wu@intel.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: make B43_PCMCIA and B43_SDIO depend on B43_SSB
Date: Sun, 18 May 2014 13:41:33 +0200
Message-Id: <1400413293-25973-1-git-send-email-zajec5@gmail.com> (sfid-20140518_134332_718591_5DADE127)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are extra configs specific to the SSB. Lack of this dependency and
CONFIG_B43=y
CONFIG_B43_BUSES_BCMA=y
CONFIG_SSB=m
would result in:
> drivers/built-in.o: In function `b43_sdio_remove':
> sdio.c:(.text+0x14657f): undefined reference to `ssb_bus_unregister'
> drivers/built-in.o: In function `b43_sdio_probe':
> sdio.c:(.text+0x14672f): undefined reference to `ssb_bus_sdiobus_register'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 1c7d27b..e3f67b8 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -73,7 +73,7 @@ config B43_PCICORE_AUTOSELECT
 
 config B43_PCMCIA
 	bool "Broadcom 43xx PCMCIA device support"
-	depends on B43 && SSB_PCMCIAHOST_POSSIBLE
+	depends on B43 && B43_SSB && SSB_PCMCIAHOST_POSSIBLE
 	select SSB_PCMCIAHOST
 	---help---
 	  Broadcom 43xx PCMCIA device support.
@@ -93,7 +93,7 @@ config B43_PCMCIA
 
 config B43_SDIO
 	bool "Broadcom 43xx SDIO device support"
-	depends on B43 && SSB_SDIOHOST_POSSIBLE
+	depends on B43 && B43_SSB && SSB_SDIOHOST_POSSIBLE
 	select SSB_SDIOHOST
 	---help---
 	  Broadcom 43xx device support for Soft-MAC SDIO devices.
-- 
1.8.4.5

