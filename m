Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:49851 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0FVXeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 19:34:23 -0400
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Kalle Valo <kvalo@adurom.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTildbagKqzTQbcZ8cT53s4L2OWpJ5fkBUTcejj0h@mail.gmail.com>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	 <1275693948-3189-2-git-send-email-notasas@gmail.com>
	 <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
	 <1277124410.28895.23.camel@gnutoo-laptop>
	 <AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
	 <1277145901.28895.29.camel@gnutoo-laptop>
	 <AANLkTildbagKqzTQbcZ8cT53s4L2OWpJ5fkBUTcejj0h@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 01:33:27 +0200
Message-ID: <1277249607.2233.270.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-22 at 01:48 +0300, Grazvydas Ignotas wrote:
> >> Probably not relevant to power saving, but:
> >>
> >> Are you using the dedicated irq line or sdio interrupt?
> >> It makes a big difference in overall throughput to use
> >> the former.
> > I don't know. what should I grep for?
> 
> It might actually be related.. Try adding this to your board file to
> enable GPIO irq:
> 
> static void wl1251_set_power(bool enable)
> {
> }
> 
> static struct wl12xx_platform_data wl1251_pdata = {
>         .set_power      = wl1251_set_power,
> };
> 
> static struct platform_device wl1251_data = {
>         .name           = "wl1251_data",
>         .id             = -1,
>         .dev            = {
>                 .platform_data  = &wl1251_pdata,
>         },
> };
> 
> .. then from some init function:
> 
> // WIFI_IRQ_GPIO is the GPIO number connected to wl1251 irq line
> wl1251_pdata.irq = gpio_to_irq(WIFI_IRQ_GPIO);
> platform_device_register(&wl1251_pdata);
Thanks a lot for the infos,they were really helpfull.

I've applied that patch(as it was not for submitting,just for reading I
didn't bother sending with git-send-email): 
Index: sources/arch/arm/mach-msm/board-trout.c
===================================================================
--- sources.orig/arch/arm/mach-msm/board-trout.c	2010-06-23
00:41:54.601288614 +0200
+++ sources/arch/arm/mach-msm/board-trout.c	2010-06-23
00:43:59.893158944 +0200
@@ -52,6 +52,7 @@
 #include <asm/mach/mmc.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/msm_audio.h>
+#include <linux/spi/wl12xx.h>
 
 #include "board-trout.h"
 
@@ -363,6 +364,17 @@
 	},
 };
 
+struct wl12xx_platform_data wl12xx_data = {
+};
+
+static struct platform_device  wl12xx = {
+	.name		= "wl1251_data",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &wl12xx_data,
+	},
+};
+
 #ifdef CONFIG_HTC_HEADSET
 static void h2w_config_cpld(int route)
 {
@@ -650,6 +662,7 @@
 	&trout_pwr_sink,
 #endif
 	&trout_snd,
+	&wl12xx,
 };
 
 extern struct sys_timer msm_timer;
@@ -745,6 +758,7 @@
 
 static void __init config_gpios(void)
 {
+	wl12xx_data.irq = gpio_to_irq(29);
 	config_gpio_table(gpio_table, ARRAY_SIZE(gpio_table));
 	config_camera_off_gpios();
 }
Index: sources/include/linux/spi/wl12xx.h
===================================================================
--- sources.orig/include/linux/spi/wl12xx.h	2010-06-23
00:42:03.641283312 +0200
+++ sources/include/linux/spi/wl12xx.h	2010-06-23 00:42:48.103178185
+0200
@@ -26,6 +26,7 @@
 
 struct wl12xx_platform_data {
 	void (*set_power)(bool enable);
+	int irq;
 };
 
 #endif

The patch was made from someone in irc and modified by me later.

Then I load the wifi as usual:
modprobe wl1251_sdio #it doesn't crash
modprobe msm_wifi
the modprobe msm_wifi gives the following result:
[ 1366.500427] wifi probe start
[ 1366.500457] trout_wifi_power: 1
[ 1366.927185] trout_wifi_reset: 0
[ 1367.030944] trout_wifi_set_carddetect: 1
[ 1367.030975] mmc0: card_present 1
[ 1367.030975] mmc0: Slot status change detected (0 -> 1)
[ 1367.031036] wifi probe done
And then I've an invisible crash/kernel panic which result in the
machine lockup and then reboot(so it should be a kernel panic).
Note that I've no serial yet(I think I should really get a serial cable
for this machine)

msm_wifi comes from here:
http://bobcopeland.com/srcs/android/msm_wifi.patch

I had already some wifi structures which may have conflicted:

struct wifi_platform_data trout_wifi_control = {
	.set_power		= trout_wifi_power,
	.set_reset		= trout_wifi_reset,
	.set_carddetect		= trout_wifi_set_carddetect,
#ifdef CONFIG_WIFI_MEM_PREALLOC
	.mem_prealloc		= trout_wifi_mem_prealloc,
#else
	.mem_prealloc		= NULL,
#endif	
};

static struct platform_device trout_wifi = {
	.name		= "msm_wifi",
	.id		= 1,
	.num_resources	= 0,
	.resource	= NULL,
	.dev		= {
		.platform_data = &trout_wifi_control,
	},
};

Thanks a lot for the help so far.
Denis



