Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54918 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030299Ab2B1Tph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 14:45:37 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: Larry.Finger@lwfinger.net, florian@openwrt.org, zajec5@gmail.com,
	m@bues.ch, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] b43: prevent firmware on bcm5354 from taking over wrong GPIO pins
Date: Tue, 28 Feb 2012 20:45:06 +0100
Message-Id: <1330458306-13169-1-git-send-email-hauke@hauke-m.de> (sfid-20120228_204556_277510_FB5E4286)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the bcm5354 (Soc with integrated LP-PHY Wifi) with a recent
firmware >= 478.104 it runs out of memory after a very short time in
OpenWrt after doing an active scan or any thing else where packages are
send. This was cased by a gpio misconfiguration, the firmware triggered
the GPIO pins used for buttons on some devices and that caused an other
driver (OpenWrt diag) listening for these buttons irqs to send many
messages to the user space.
This patch fixes the bug for my devices (Asus WL-520GU) and makes it
work with firmware 666.2. Now the firmware just uses LED GPIO pin
number 1 and not the button pins any more.

This is the GPIO Pin layout used on my device, see [0].
GPIO pin layout:
pin#    name    type
0       power   led
1       wlan    led
2       reset   button
3       ses     buttom

This is the nvram configuration output of "nvram show |grep gpio"

related nvram configuration:
wl0gpio2=11
wl0gpio3=11
wl0gpio0=11
wl0gpio1=0x02
reset_gpio=2

[0]: https://dev.openwrt.org/browser/trunk/package/broadcom-diag/src/diag.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5189cf3..1d633f3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2706,6 +2706,8 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
+	if (dev->dev->chip_id == 0x5354)
+		set &= 0xff02;
 	if (0 /* FIXME: conditional unknown */ ) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
-- 
1.7.5.4

