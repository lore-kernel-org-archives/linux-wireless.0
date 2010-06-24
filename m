Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:55886 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0FXXJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 19:09:52 -0400
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Kalle Valo <kvalo@adurom.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1277249607.2233.270.camel@gnutoo-laptop>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	 <1275693948-3189-2-git-send-email-notasas@gmail.com>
	 <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
	 <1277124410.28895.23.camel@gnutoo-laptop>
	 <AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
	 <1277145901.28895.29.camel@gnutoo-laptop>
	 <AANLkTildbagKqzTQbcZ8cT53s4L2OWpJ5fkBUTcejj0h@mail.gmail.com>
	 <1277249607.2233.270.camel@gnutoo-laptop>
Content-Type: multipart/mixed; boundary="=-L3JgMbisHPdyvBGm1B+J"
Date: Fri, 25 Jun 2010 01:09:00 +0200
Message-ID: <1277420940.28625.30.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L3JgMbisHPdyvBGm1B+J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2010-06-23 at 01:33 +0200, Denis 'GNUtoo' Carikli wrote:
> On Tue, 2010-06-22 at 01:48 +0300, Grazvydas Ignotas wrote:
> > >> Probably not relevant to power saving, but:
> > >>
> > >> Are you using the dedicated irq line or sdio interrupt?
> > >> It makes a big difference in overall throughput to use
> > >> the former.
> > > I don't know. what should I grep for?
> > 
> > It might actually be related.. Try adding this to your board file to
> > enable GPIO irq:
> > 
> > static void wl1251_set_power(bool enable)
> > {
> > }
> > 
> > static struct wl12xx_platform_data wl1251_pdata = {
> >         .set_power      = wl1251_set_power,
> > };
> > 
> > static struct platform_device wl1251_data = {
> >         .name           = "wl1251_data",
> >         .id             = -1,
> >         .dev            = {
> >                 .platform_data  = &wl1251_pdata,
> >         },
> > };
> > 
> > .. then from some init function:
> > 
> > // WIFI_IRQ_GPIO is the GPIO number connected to wl1251 irq line
> > wl1251_pdata.irq = gpio_to_irq(WIFI_IRQ_GPIO);
> > platform_device_register(&wl1251_pdata);
> Thanks a lot for the infos,they were really helpfull.
> 
> I've applied that patch(as it was not for submitting,just for reading I
> didn't bother sending with git-send-email): 
> Index: sources/arch/arm/mach-msm/board-trout.c
> ===================================================================
> --- sources.orig/arch/arm/mach-msm/board-trout.c	2010-06-23
> 00:41:54.601288614 +0200
> +++ sources/arch/arm/mach-msm/board-trout.c	2010-06-23
> 00:43:59.893158944 +0200
> @@ -52,6 +52,7 @@
>  #include <asm/mach/mmc.h>
>  #include <linux/mmc/sdio_ids.h>
>  #include <linux/msm_audio.h>
> +#include <linux/spi/wl12xx.h>
>  
>  #include "board-trout.h"
>  
> @@ -363,6 +364,17 @@
>  	},
>  };
>  
> +struct wl12xx_platform_data wl12xx_data = {
> +};
> +
> +static struct platform_device  wl12xx = {
> +	.name		= "wl1251_data",
> +	.id		= -1,
> +	.dev		= {
> +		.platform_data = &wl12xx_data,
> +	},
> +};
> +
>  #ifdef CONFIG_HTC_HEADSET
>  static void h2w_config_cpld(int route)
>  {
> @@ -650,6 +662,7 @@
>  	&trout_pwr_sink,
>  #endif
>  	&trout_snd,
> +	&wl12xx,
>  };
>  
>  extern struct sys_timer msm_timer;
> @@ -745,6 +758,7 @@
>  
>  static void __init config_gpios(void)
>  {
> +	wl12xx_data.irq = gpio_to_irq(29);
>  	config_gpio_table(gpio_table, ARRAY_SIZE(gpio_table));
>  	config_camera_off_gpios();
>  }
> Index: sources/include/linux/spi/wl12xx.h
> ===================================================================
> --- sources.orig/include/linux/spi/wl12xx.h	2010-06-23
> 00:42:03.641283312 +0200
> +++ sources/include/linux/spi/wl12xx.h	2010-06-23 00:42:48.103178185
> +0200
> @@ -26,6 +26,7 @@
>  
>  struct wl12xx_platform_data {
>  	void (*set_power)(bool enable);
> +	int irq;
>  };
>  
>  #endif
> 
> The patch was made from someone in irc and modified by me later.
> 
> Then I load the wifi as usual:
> modprobe wl1251_sdio #it doesn't crash
> modprobe msm_wifi
> the modprobe msm_wifi gives the following result:
> [ 1366.500427] wifi probe start
> [ 1366.500457] trout_wifi_power: 1
> [ 1366.927185] trout_wifi_reset: 0
> [ 1367.030944] trout_wifi_set_carddetect: 1
> [ 1367.030975] mmc0: card_present 1
> [ 1367.030975] mmc0: Slot status change detected (0 -> 1)
> [ 1367.031036] wifi probe done
> And then I've an invisible crash/kernel panic which result in the
> machine lockup and then reboot(so it should be a kernel panic).
> Note that I've no serial yet(I think I should really get a serial cable
> for this machine)
> 
> msm_wifi comes from here:
> http://bobcopeland.com/srcs/android/msm_wifi.patch
> 
> I had already some wifi structures which may have conflicted:
> 
> struct wifi_platform_data trout_wifi_control = {
> 	.set_power		= trout_wifi_power,
> 	.set_reset		= trout_wifi_reset,
> 	.set_carddetect		= trout_wifi_set_carddetect,
> #ifdef CONFIG_WIFI_MEM_PREALLOC
> 	.mem_prealloc		= trout_wifi_mem_prealloc,
> #else
> 	.mem_prealloc		= NULL,
> #endif	
> };
I've changed that struct to wl12xx_platform_Data and added the irq
int,and I've still the following errors:
[  541.676849] wl1251: ERROR sdio_writeb failed (-84)
[  542.006378] mmc0: Command timeout
[  542.011444] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  543.016357] mmc0: Command CRC error
[  543.016418] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  544.026367] mmc0: Command timeout
[  544.031433] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  545.036376] mmc0: Command CRC error
[  545.036437] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  546.066345] mmc0: Command timeout
[  546.071411] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  547.076354] mmc0: Command CRC error
[  547.076416] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  548.106384] mmc0: Command timeout
[  548.111450] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  548.706665] mmc0: Command CRC error
[  548.706726] wl1251: ERROR sdio_writeb failed (-84)
[  549.136383] mmc0: Command timeout
[  549.141479] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  549.676635] mmc0: Command CRC error
[  549.676696] wl1251: ERROR sdio_writeb failed (-84)
[  550.166381] mmc0: Command timeout
[  550.171447] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  550.676269] wlan0: no IPv6 routers present
[  551.176361] mmc0: Command CRC error
[  551.176422] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  552.186340] mmc0: Command timeout

The patch is attached.

Denis.


--=-L3JgMbisHPdyvBGm1B+J
Content-Disposition: attachment; filename="cleaner_wifi_patch_quilt.patch"
Content-Type: text/x-patch; name="cleaner_wifi_patch_quilt.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Index: sources/arch/arm/mach-msm/board-trout-wifi.c
===================================================================
--- sources.orig/arch/arm/mach-msm/board-trout-wifi.c	2010-06-24 23:58:13.194099802 +0200
+++ sources/arch/arm/mach-msm/board-trout-wifi.c	2010-06-24 23:58:21.385931197 +0200
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/vmalloc.h>
 #include <linux/err.h>
-#include <linux/wifi_tiwlan.h>
+#include <linux/spi/wl12xx.h>
 
 extern int trout_wifi_set_carddetect(int val);
 extern int trout_wifi_power(int on);
@@ -60,7 +60,7 @@
 }
 #endif
 
-struct wifi_platform_data trout_wifi_control = {
+struct wl12xx_platform_data trout_wifi_control = {
 	.set_power		= trout_wifi_power,
 	.set_reset		= trout_wifi_reset,
 	.set_carddetect		= trout_wifi_set_carddetect,
Index: sources/arch/arm/mach-msm/board-trout.c
===================================================================
--- sources.orig/arch/arm/mach-msm/board-trout.c	2010-06-24 23:58:13.234055563 +0200
+++ sources/arch/arm/mach-msm/board-trout.c	2010-06-25 00:40:37.324053664 +0200
@@ -66,7 +66,7 @@
 #include <mach/htc_headset.h>
 #endif
 #ifdef CONFIG_WIFI_CONTROL_FUNC
-#include <linux/wifi_tiwlan.h>
+#include <linux/spi/wl12xx.h>
 #endif
 
 #include "proc_comm.h"
@@ -80,7 +80,7 @@
 #ifdef CONFIG_WIFI_MEM_PREALLOC
 extern int trout_init_wifi_mem(void);
 #endif
-extern struct wifi_platform_data trout_wifi_control;
+extern struct wl12xx_platform_data trout_wifi_control;
 #endif
 
 struct trout_axis_info {
@@ -545,6 +545,28 @@
 	.ram_console_size = MSM_RAM_CONSOLE_SIZE,
 };
 
+
+static void trout_wl1251_init(void)
+{
+	int ret;
+
+	ret = gpio_request(TROUT_WIFI_IRQ_GPIO, "wl1251 irq");
+	if (ret < 0)
+		goto fail_irq;
+
+	ret = gpio_direction_input(TROUT_WIFI_IRQ_GPIO);
+	if (ret < 0)
+		goto fail_irq;
+
+	trout_wifi_control.irq = gpio_to_irq(TROUT_WIFI_IRQ_GPIO);
+	if (trout_wifi_control.irq < 0)
+		goto fail_irq;
+
+	return;
+
+fail_irq:
+	gpio_free(TROUT_WIFI_IRQ_GPIO);
+}
 #ifdef CONFIG_WIFI_CONTROL_FUNC
 static struct platform_device trout_wifi = {
 	.name		= "msm_wifi",
@@ -823,6 +845,7 @@
 
 	/* SD card door should wake the device */
 	set_irq_wake(TROUT_GPIO_TO_INT(TROUT_GPIO_SD_DOOR_N), 1);
+	trout_wl1251_init();
 }
 
 static struct map_desc trout_io_desc[] __initdata = {
Index: sources/arch/arm/mach-msm/board-trout.h
===================================================================
--- sources.orig/arch/arm/mach-msm/board-trout.h	2010-06-24 23:58:13.294049700 +0200
+++ sources/arch/arm/mach-msm/board-trout.h	2010-06-24 23:58:21.385931197 +0200
@@ -74,6 +74,7 @@
 
 #define TROUT_GPIO_HAPTIC_PWM               (28)
 #define TROUT_GPIO_PS_HOLD                  (25)
+#define TROUT_WIFI_IRQ_GPIO	            (29)
 
 #define TROUT_GPIO_MISC2_BASE               (TROUT_GPIO_START + 0x00)
 #define TROUT_GPIO_MISC3_BASE               (TROUT_GPIO_START + 0x08)
Index: sources/arch/arm/mach-msm/msm_wifi.c
===================================================================
--- sources.orig/arch/arm/mach-msm/msm_wifi.c	2010-06-24 23:58:13.344052459 +0200
+++ sources/arch/arm/mach-msm/msm_wifi.c	2010-06-24 23:58:21.385931197 +0200
@@ -18,12 +18,12 @@
  * Copyright (C) 2008 Google Inc
  */
 #include <linux/platform_device.h>
-#include <linux/wifi_tiwlan.h>
+#include <linux/spi/wl12xx.h>
 
 static int wifi_probe(struct platform_device *pdev)
 {
-	struct wifi_platform_data *wifi_ctrl =
-		(struct wifi_platform_data *)(pdev->dev.platform_data);
+	struct wl12xx_platform_data *wifi_ctrl =
+		(struct wl12xx_platform_data *)(pdev->dev.platform_data);
 
 	printk(KERN_DEBUG "wifi probe start\n");
 
@@ -43,8 +43,8 @@
 
 static int wifi_remove(struct platform_device *pdev)
 {
-	struct wifi_platform_data *wifi_ctrl =
-		(struct wifi_platform_data *)(pdev->dev.platform_data);
+	struct wl12xx_platform_data *wifi_ctrl =
+		(struct w12xx_platform_data *)(pdev->dev.platform_data);
 
 	printk(KERN_DEBUG "wifi remove start\n");
 	if (!wifi_ctrl)
Index: sources/include/linux/spi/wl12xx.h
===================================================================
--- sources.orig/include/linux/spi/wl12xx.h	2010-06-24 23:58:13.404053597 +0200
+++ sources/include/linux/spi/wl12xx.h	2010-06-24 23:58:21.385931197 +0200
@@ -24,8 +24,19 @@
 #ifndef _LINUX_SPI_WL12XX_H
 #define _LINUX_SPI_WL12XX_H
 
+#define WMPA_NUMBER_OF_SECTIONS	3
+#define WMPA_NUMBER_OF_BUFFERS	160
+#define WMPA_SECTION_HEADER	24
+#define WMPA_SECTION_SIZE_0	(WMPA_NUMBER_OF_BUFFERS * 64)
+#define WMPA_SECTION_SIZE_1	(WMPA_NUMBER_OF_BUFFERS * 256)
+#define WMPA_SECTION_SIZE_2	(WMPA_NUMBER_OF_BUFFERS * 2048)
+
 struct wl12xx_platform_data {
-	void (*set_power)(bool enable);
+        int (*set_power)(bool enable);
+        int (*set_reset)(bool enable);
+        int (*set_carddetect)(bool enable);
+	void *(*mem_prealloc)(int section, unsigned long size);
+	int irq;
 };
 
 #endif

--=-L3JgMbisHPdyvBGm1B+J--

