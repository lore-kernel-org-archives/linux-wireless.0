Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:38415 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2EANmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 09:42:54 -0400
Message-ID: <4F9FE85C.5050902@mlbassoc.com> (sfid-20120501_154258_776524_AEC7C22E)
Date: Tue, 01 May 2012 07:42:52 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: Re: wl1271 woes continue
References: <4F9E8F49.3080700@mlbassoc.com>
In-Reply-To: <4F9E8F49.3080700@mlbassoc.com>
Content-Type: multipart/mixed;
 boundary="------------040102080401080407090101"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040102080401080407090101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2012-04-30 07:10, Gary Thomas wrote:
> Luciano,
>
> I'm still having troubles with the WL1271. I now have a
> brand new platform - same basic design as before but with
> a DM3730 instead of the DM8148. I've tried a couple of
> off-the-shelf kernels (3.0.0 and 3.3.0) with it, with mixed
> results.
>
> With 3.3.0 I could not get the device to associate with the AP.
> It would get started and then the wl1271 stopped talking and
> the process failed.
>
> With 3.0.0, I can get it to work reasonably well. However, I
> still have to go through the manual steps to get it to associate.
> Anything other than the process below causes the wl1271 to reset
> and die... I also cannot shut the device down and restart it.
> Attempts at a restart cause the wl1271 to lock up and I have to
> reboot to recover.
>
> Only these steps work for the initial association:
> # ifconfig wlan0 hw ether 0:1:2:3:4:5
> # ifconfig wlan0 up
> # iw wlan0 scan
> # ifup wlan0
> Note: my AP is using WPA2 so I'm also running wpa_supplicant
>
> I'm going to try using the latest compat-wireless, using the
> 3.0.0 kernel as overall it is more stable on this platform.
> I also plan to experiment a bit with the Panda (OMAP4) as it
> has the same peripherals (and I assume that it works?)
>
> What can I do to make this work better?
> What data need I provide to help diagnose the failures?
>
> Thanks for your time
>

My problems seem to stem from how the WiFi interface is taken
up/down.  Looking at the driver, it's expecting the MMC/SDIO
hardware to be able to power the device on/off.  Sadly, on my
board, this is not possible.  However, we do have a way to
control the WLAN_EN signal to the module.

I extended the driver to make use of the set_power function
within the platform data.  With this in place, the WiFi can
now be taken up/down with much success (that means it's not
perfect, but at least it doesn't stop talking irrecoverably)
Note that is is how it also works when SPI is used instead
of SDIO.

The attached patch is what I used.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------040102080401080407090101
Content-Type: text/x-patch;
 name="0001-Use-platform-specific-power-function-if-provided-whe.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Use-platform-specific-power-function-if-provided-whe.pa";
 filename*1="tch"

>From 58eb478ced706dda18af23452c26568ea25aac77 Mon Sep 17 00:00:00 2001
From: Gary Thomas <gary@mlbassoc.com>
Date: Tue, 1 May 2012 06:02:11 -0600
Subject: [PATCH 1/3] Use platform specific power function if provided when
 taking interface up/down

Signed-off-by: Gary Thomas <gary@mlbassoc.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 536e506..a242b67 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -170,6 +170,11 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	struct sdio_func *func = wl_to_func(wl);
 	int ret;
 
+        /* Use platform function to enable power if provided */
+        if (wl->set_power) {
+                (wl->set_power)(true);
+        }
+
 	/* Make sure the card will not be powered off by runtime PM */
 	ret = pm_runtime_get_sync(&func->dev);
 	if (ret < 0)
@@ -200,6 +205,11 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+        /* Use platform function to disable power if provided */
+        if (wl->set_power) {
+                (wl->set_power)(false);
+        }
+
 	/* Let runtime PM know the card is powered off */
 	return pm_runtime_put_sync(&func->dev);
 }
@@ -264,6 +274,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	wl->ref_clock = wlan_data->board_ref_clock;
 	wl->tcxo_clock = wlan_data->board_tcxo_clock;
 	wl->platform_quirks = wlan_data->platform_quirks;
+	wl->set_power = wlan_data->set_power;
 
 	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
 		irqflags = IRQF_TRIGGER_RISING;
-- 
1.7.7.6


--------------040102080401080407090101--
