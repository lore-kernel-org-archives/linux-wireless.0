Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:38436 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab3BEVL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 16:11:28 -0500
Received: from moh2-ve1.go2.pl (moh2-ve1.go2.pl [193.17.41.186])
	by tur.go2.pl (Postfix) with ESMTP id 45FD215A1433
	for <linux-wireless@vger.kernel.org>; Tue,  5 Feb 2013 22:11:21 +0100 (CET)
Received: from moh2-ve1.go2.pl (unknown [10.0.0.186])
	by moh2-ve1.go2.pl (Postfix) with ESMTP id 0CE1D44DA66
	for <linux-wireless@vger.kernel.org>; Tue,  5 Feb 2013 22:10:36 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh2-ve1.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Tue,  5 Feb 2013 22:10:35 +0100 (CET)
Date: Tue, 5 Feb 2013 22:10:31 +0100
From: Tomasz Guszkowski <tsg@o2.pl>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: corrected USB ID for T-Com Sinus 154 data II
Message-Id: <20130205221031.05608bc50352b172003ec69e@o2.pl> (sfid-20130205_221134_194572_6B6F8440)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Corrected USB ID for T-Com Sinus 154 data II. ISL3887-based. The device was tested in managed mode with no security, WEP 128 bit and WPA-PSK (TKIP) with firmware 2.13.1.0.lm87.arm (md5sum: 7d676323ac60d6e1a3b6d61e8c528248). It works.

Signed-off-by: Tomasz Guszkowski <tsg@o2.pl>
---
Hi!

I have submitted a patch for this device on Dec 22-nd 2012. A couple of days ago I fetched a new kernel, with the December-submitted patch inside, compiled it and noticed to my surprise the device didn't work. A short investigation shown wrong USB ID. I must have done an error while manually modifying p54usb.c in git tree.

My mistake.

lsusb confirms this time the ID is correct:
root@tsg-desktop:/usr/src/git# lsusb -s1:4
Bus 001 Device 004: ID 083a:4531 Accton Technology Corp.

Let's correct this bug.

Tomek

 drivers/net/wireless/p54/p54usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 800a165..1f78585 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -84,8 +84,8 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
-	{USB_DEVICE(0x083a, 0x4503)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
+	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
 	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */
-- 
1.7.5.4

