Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbYIVWDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 18:03:13 -0400
Message-Id: <200809222201.m8MM1pBH032706@imap1.linux-foundation.org> (sfid-20080923_000317_208841_37D70CCA)
Subject: [patch 1/1] wireless: zd1211rw: add device ID fix wifi dongle "trust nw-3100"
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	born.into.silence@gmail.com, dsd@gentoo.org,
	johannes@sipsolutions.net, kune@deine-taler.de
From: akpm@linux-foundation.org
Date: Mon, 22 Sep 2008 15:01:51 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: <born.into.silence@gmail.com>

akpm: taken from http://bugzilla.kernel.org/show_bug.cgi?id=11587

I bought the wifi dongle trust nw-3100 wich is in fact a zd1211rw.  Its
hardware id was missing in the sources, adding it made it work flawlessly.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/zd1211rw/zd_usb.c~wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100 drivers/net/wireless/zd1211rw/zd_usb.c
--- a/drivers/net/wireless/zd1211rw/zd_usb.c~wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100
+++ a/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -58,6 +58,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
_
