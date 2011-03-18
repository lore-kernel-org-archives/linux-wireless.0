Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:47566 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756690Ab1CROUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:07 -0400
Received: by mail-wy0-f177.google.com with SMTP id 28so4067513wyb.8
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:00 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 01/14] wl12xx: add new board_tcxo_clock element to the platform data
Date: Fri, 18 Mar 2011 16:19:16 +0200
Message-Id: <1300457969-19601-2-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new value is a new type of clock setting that is used by wl128x
chipsets.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/wl12xx.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index bebb8ef..9820ae5 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -24,7 +24,7 @@
 #ifndef _LINUX_WL12XX_H
 #define _LINUX_WL12XX_H
 
-/* The board reference clock values */
+/* Reference clock values */
 enum {
 	WL12XX_REFCLOCK_19 = 0,	/* 19.2 MHz */
 	WL12XX_REFCLOCK_26 = 1,	/* 26 MHz */
@@ -32,12 +32,25 @@ enum {
 	WL12XX_REFCLOCK_54 = 3,	/* 54 MHz */
 };
 
+/* TCXO clock values */
+enum {
+        WL12XX_TCXOCLOCK_19_2	= 0, /* 19.2MHz */
+        WL12XX_TCXOCLOCK_26	= 1, /* 26 MHz */
+        WL12XX_TCXOCLOCK_38_4	= 2, /* 38.4MHz */
+        WL12XX_TCXOCLOCK_52	= 3, /* 52 MHz */
+        WL12XX_TCXOCLOCK_16_368	= 4, /* 16.368 MHz */
+        WL12XX_TCXOCLOCK_32_736	= 5, /* 32.736 MHz */
+	WL12XX_TCXOCLOCK_16_8	= 6, /* 16.8 MHz */
+	WL12XX_TCXOCLOCK_33_6	= 7, /* 33.6 MHz */
+};
+
 struct wl12xx_platform_data {
 	void (*set_power)(bool enable);
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
 	int irq;
 	bool use_eeprom;
 	int board_ref_clock;
+	int board_tcxo_clock;
 };
 
 #ifdef CONFIG_WL12XX_PLATFORM_DATA
-- 
1.7.1

