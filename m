Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52974 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab0KYOsx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:48:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] compat-wireless: rename config symbols to CONFIG_WL12XX
Date: Thu, 25 Nov 2010 15:48:35 +0100
Message-Id: <1290696517-20437-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
References: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename config Symbols from CONFIG_WL1271 to CONFIG_WL12XX. This was
missing in 3bd28daf2ad78adf652c3e6b74645b7fa0cf3fc2.
Add CONFIG_WL12XX_HT and remove double definition of CONFIG_WL12XX

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/config.mk b/config.mk
index 0f58320..ad597cb 100644
--- a/config.mk
+++ b/config.mk
@@ -468,7 +468,7 @@ ifndef CONFIG_COMPAT_KERNEL_25
 
 ifdef CONFIG_CRC7
 CONFIG_WL1251_SPI=m
-CONFIG_WL1271_SPI=m
+CONFIG_WL12XX_SPI=m
 endif #CONFIG_CRC7
 CONFIG_P54_SPI=m
 
@@ -495,7 +495,7 @@ endif #CONFIG_WL12XX_PLATFORM_DATA
 
 ifndef CONFIG_COMPAT_KERNEL_32
 ifdef CONFIG_WL12XX_PLATFORM_DATA
-CONFIG_WL1271_SDIO=m
+CONFIG_WL12XX_SDIO=m
 endif #CONFIG_WL12XX_PLATFORM_DATA
 endif #CONFIG_COMPAT_KERNEL_32
 
@@ -564,10 +564,10 @@ CONFIG_P54_LEDS=y
 CONFIG_ATH_COMMON=m
 # CONFIG_ATH_DEBUG=y
 
-CONFIG_WL12XX=y
 ifdef CONFIG_CRC7
 CONFIG_WL1251=m
-CONFIG_WL1271=m
+CONFIG_WL12XX=m
+CONFIG_WL12XX_HT=y
 endif #CONFIG_CRC7
 
 ifdef CONFIG_COMPAT_KERNEL_27
-- 
1.7.1

