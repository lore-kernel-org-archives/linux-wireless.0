Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33158 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab2BTXiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 18:38:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: zajec5@gmail.com, Larry.Finger@lwfinger.net
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	m@bues.ch, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC] b43: fix memory leak on bcm5354
Date: Tue, 21 Feb 2012 00:38:19 +0100
Message-Id: <1329781099-17342-1-git-send-email-hauke@hauke-m.de> (sfid-20120221_003858_680351_754EAE1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the bcm5354 with a recent firmware >= 478.104 it runs into a
memory very shortly after doing an active scan or any thing else where
packages are send. This was cased by a gpio misconfiguration, the
firmware triggered the GPIO pins used for buttons on some devices and
that caused an other driver (OpenWrt diag) listening for these buttons
to send many user space messages.
This patch fixes the bug for my devices (Asus WL-520GU) and makes it
work with firmware 666.2, but I do not know if this patch is correct.
The spec for this part is out of date:
http://bcm-specs.sipsolutions.net/GPIO

GPIO pin layout:
pin#	name	type
0	power	led
1	wlan	led
2	reset	button
3	ses	buttom

related nvram configuration:
wl0gpio2=11
wl0gpio3=11
wl0gpio0=11
wl0gpio1=0x02
reset_gpio=2

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 23ffb1b..f782723 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2720,6 +2720,8 @@ static int b43_gpio_init(struct b43_wldev *dev)
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

