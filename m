Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56200 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab1LUUgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 15:36:45 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id c1so4351415lah.22
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 12:36:44 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 3/3] wl1251: enable sparse endianess check by default
Date: Wed, 21 Dec 2011 22:36:29 +0200
Message-Id: <1324499789-13525-4-git-send-email-coelho@ti.com> (sfid-20111221_213649_240068_0548A1AE)
In-Reply-To: <1324499789-13525-1-git-send-email-coelho@ti.com>
References: <1324499789-13525-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following the good example of the Intel (and more recently Atheros)
drivers, enable endianess check by default when running sparse.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl1251/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl1251/Makefile b/drivers/net/wireless/wl1251/Makefile
index 58b4f93..a5c6328 100644
--- a/drivers/net/wireless/wl1251/Makefile
+++ b/drivers/net/wireless/wl1251/Makefile
@@ -6,3 +6,5 @@ wl1251_sdio-objs	+= sdio.o
 obj-$(CONFIG_WL1251)		+= wl1251.o
 obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
 obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
+
+ccflags-y += -D__CHECK_ENDIAN__
-- 
1.7.4.1

