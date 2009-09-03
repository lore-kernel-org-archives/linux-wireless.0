Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52279 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZICLmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 07:42:22 -0400
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org,
	Amit Kucheria <amit.kucheria@canonical.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
Date: Thu,  3 Sep 2009 14:42:20 +0300
Message-Id: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
defined. Remove it from rt2500usb.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index ce75426..2e9fac7 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -2020,7 +2020,6 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
-	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Sagem */
 	{ USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
-- 
1.6.3.3

