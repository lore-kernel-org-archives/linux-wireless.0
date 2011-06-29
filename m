Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2020 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab1F2Xs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:57 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 073/119] staging: brcm80211: remove custom gpio support
 code
Date: Wed, 29 Jun 2011 16:47:37 -0700
Message-ID: <1309391303-22741-74-git-send-email-frankyl@broadcom.com> (sfid-20110630_015722_901229_434DF537)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The custom gpio code is intended for hardware platform for specific
customers and require supporting functionality not included in the
fullmac driver. The fullmac driver does not need this so it has been
removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile        |    1 -
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |  156 --------------------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    8 +-
 3 files changed, 1 insertions(+), 164 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index f097246..c38fa55 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -30,7 +30,6 @@ DHDOFILES = \
 	wl_cfg80211.o \
 	dhd_cdc.o \
 	dhd_common.o \
-	dhd_custom_gpio.o \
 	dhd_sdio.o	\
 	dhd_linux.o \
 	bcmsdh.o \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
deleted file mode 100644
index 6fd1072..0000000
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ /dev/null
@@ -1,156 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/netdevice.h>
-#include <linux/sched.h>
-#include <brcmu_utils.h>
-#include <defs.h>
-#include <brcmu_wifi.h>
-
-#include "dngl_stats.h"
-#include "dhd.h"
-
-#define WL_ERROR(fmt, args...) printk(fmt, ##args)
-#define WL_TRACE(fmt, args...) no_printk(fmt, ##args)
-
-#ifdef CUSTOMER_HW
-extern void bcm_wlan_power_off(int);
-extern void bcm_wlan_power_on(int);
-#endif				/* CUSTOMER_HW */
-#ifdef CUSTOMER_HW2
-int wifi_set_carddetect(int on);
-int wifi_set_power(int on, unsigned long msec);
-int wifi_get_irq_number(unsigned long *irq_flags_ptr);
-#endif
-
-#if defined(OOB_INTR_ONLY)
-
-extern int sdioh_mmc_irq(int irq);
-
-#ifdef CUSTOMER_HW3
-#include <mach/gpio.h>
-#endif
-
-/* Customer specific Host GPIO definition  */
-static int dhd_oob_gpio_num = -1;	/* GG 19 */
-
-module_param(dhd_oob_gpio_num, int, 0644);
-MODULE_PARM_DESC(dhd_oob_gpio_num, "DHD oob gpio number");
-
-int brcmf_customer_oob_irq_map(unsigned long *irq_flags_ptr)
-{
-	int host_oob_irq = 0;
-
-#ifdef CUSTOMER_HW2
-	host_oob_irq = wifi_get_irq_number(irq_flags_ptr);
-
-#else				/* for NOT  CUSTOMER_HW2 */
-#if defined(CUSTOM_OOB_GPIO_NUM)
-	if (dhd_oob_gpio_num < 0)
-		dhd_oob_gpio_num = CUSTOM_OOB_GPIO_NUM;
-#endif
-
-	if (dhd_oob_gpio_num < 0) {
-		WL_ERROR("%s: ERROR customer specific Host GPIO is NOT defined\n",
-			 __func__);
-		return dhd_oob_gpio_num;
-	}
-
-	WL_ERROR("%s: customer specific Host GPIO number is (%d)\n",
-		 __func__, dhd_oob_gpio_num);
-
-#if defined CUSTOMER_HW
-	host_oob_irq = MSM_GPIO_TO_INT(dhd_oob_gpio_num);
-#elif defined CUSTOMER_HW3
-	gpio_request(dhd_oob_gpio_num, "oob irq");
-	host_oob_irq = gpio_to_irq(dhd_oob_gpio_num);
-	gpio_direction_input(dhd_oob_gpio_num);
-#endif				/* CUSTOMER_HW */
-#endif				/* CUSTOMER_HW2 */
-
-	return host_oob_irq;
-}
-#endif				/* defined(OOB_INTR_ONLY) */
-
-/* Customer function to control hw specific wlan gpios */
-void brcmf_customer_gpio_wlan_ctrl(int onoff)
-{
-	switch (onoff) {
-	case WLAN_RESET_OFF:
-		WL_TRACE("%s: call customer specific GPIO to insert WLAN RESET\n",
-			 __func__);
-#ifdef CUSTOMER_HW
-		bcm_wlan_power_off(2);
-#endif				/* CUSTOMER_HW */
-#ifdef CUSTOMER_HW2
-		wifi_set_power(0, 0);
-#endif
-		WL_ERROR("=========== WLAN placed in RESET ========\n");
-		break;
-
-	case WLAN_RESET_ON:
-		WL_TRACE("%s: callc customer specific GPIO to remove WLAN RESET\n",
-			 __func__);
-#ifdef CUSTOMER_HW
-		bcm_wlan_power_on(2);
-#endif				/* CUSTOMER_HW */
-#ifdef CUSTOMER_HW2
-		wifi_set_power(1, 0);
-#endif
-		WL_ERROR("=========== WLAN going back to live  ========\n");
-		break;
-
-	case WLAN_POWER_OFF:
-		WL_TRACE("%s: call customer specific GPIO to turn off WL_REG_ON\n",
-			 __func__);
-#ifdef CUSTOMER_HW
-		bcm_wlan_power_off(1);
-#endif				/* CUSTOMER_HW */
-		break;
-
-	case WLAN_POWER_ON:
-		WL_TRACE("%s: call customer specific GPIO to turn on WL_REG_ON\n",
-			 __func__);
-#ifdef CUSTOMER_HW
-		bcm_wlan_power_on(1);
-#endif				/* CUSTOMER_HW */
-		/* Lets customer power to get stable */
-		udelay(200);
-		break;
-	}
-}
-
-#ifdef GET_CUSTOM_MAC_ENABLE
-/* Function to get custom MAC address */
-int brcmf_custom_get_mac_address(unsigned char *buf)
-{
-	WL_TRACE("%s Enter\n", __func__);
-	if (!buf)
-		return -EINVAL;
-
-	/* Customer access to MAC address stored outside of DHD driver */
-
-#ifdef EXAMPLE_GET_MAC
-	/* EXAMPLE code */
-	{
-		u8 ea_example[ETH_ALEN] = {0x00, 0x11, 0x22, 0x33, 0x44, 0xFF};
-		memcpy(buf, ea_example, ETH_ALEN);
-	}
-#endif				/* EXAMPLE_GET_MAC */
-
-	return 0;
-}
-#endif				/* GET_CUSTOM_MAC_ENABLE */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 6507891..5a0bcb2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2192,8 +2192,6 @@ static void __exit brcmf_module_cleanup(void)
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
 	wifi_del_dev();
 #endif
-	/* Call customer gpio to turn off power with WL_REG_ON signal */
-	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
 }
 
 static int __init brcmf_module_init(void)
@@ -2216,8 +2214,6 @@ static int __init brcmf_module_init(void)
 		DHD_ERROR(("Invalid module parameters.\n"));
 		return -EINVAL;
 	} while (0);
-	/* Call customer gpio to turn on power with WL_REG_ON signal */
-	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_ON);
 
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
 	sema_init(&wifi_control_sem, 0);
@@ -2245,11 +2241,9 @@ static int __init brcmf_module_init(void)
 		DHD_ERROR(("%s: dhd_bus_register failed\n", __func__));
 		goto failed;
 	}
-	return error;
+	return 0;
 
 failed:
-	/* turn off power and exit */
-	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
 	return -EINVAL;
 }
 
-- 
1.7.1


