Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34570 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2DNVBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 17:01:05 -0400
Received: by wgbdr13 with SMTP id dr13so4039035wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2012 14:01:03 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com,
	linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: [PATCH] wireless: rt2x00: rt{2500,73}usb.c put back duplicate id
Date: Sat, 14 Apr 2012 23:00:01 +0200
Message-Id: <1334437201-12737-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120414_230140_649525_72C751B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:

K7SF5D7050A ver 2xxx is rt2500
K7SF5D7050B ver 3xxx is rt73

<http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1de9c75..c88fd3e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1912,7 +1912,7 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1706) },
 	{ USB_DEVICE(0x0b05, 0x1707) },
 	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050) },
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050A ver. 2.x */
 	{ USB_DEVICE(0x050d, 0x7051) },
 	/* Cisco Systems */
 	{ USB_DEVICE(0x13b1, 0x000d) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e477a96..1551366 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2412,6 +2412,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1723) },
 	{ USB_DEVICE(0x0b05, 0x1724) },
 	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050B ver. 3.x */
 	{ USB_DEVICE(0x050d, 0x705a) },
 	{ USB_DEVICE(0x050d, 0x905b) },
 	{ USB_DEVICE(0x050d, 0x905c) },
-- 
1.7.6.5

