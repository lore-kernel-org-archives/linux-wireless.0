Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52249 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab1LUTwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 14:52:44 -0500
Received: by lahl5 with SMTP id l5so5697852lah.27
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 11:52:40 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: enable sparse endianess check by default
Date: Wed, 21 Dec 2011 21:52:31 +0200
Message-Id: <1324497151-21295-1-git-send-email-coelho@ti.com> (sfid-20111221_205247_943414_DF9980A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following the good example of the Intel (and more recently Atheros)
drivers, enable endianess check by default when running sparse.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index fe67262..98f289c 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
 
 # small builtin driver bit
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
+
+ccflags-y += -D__CHECK_ENDIAN__
-- 
1.7.4.1

