Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40002 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3CGWe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 17:34:58 -0500
Received: by mail-wg0-f42.google.com with SMTP id 12so7589380wgh.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 14:34:57 -0800 (PST)
Date: Thu, 7 Mar 2013 23:33:41 +0100
From: =?UTF-8?B?TWljaGHFgg==?= Pecio <michal.pecio@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco_usb: don't release nonexistent firmware
Message-ID: <20130307233341.6738c6e6@gmail.com> (sfid-20130307_233502_954184_23E1CFF3)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Pecio <michal.pecio@gmail.com>

Initialize fw_entry to NULL to prevent cleanup code from passing
bogus pointer to release_firmware() when priv allocation fails.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
---

Applies against v3.8.2.

Issue found by a static checker. I don't own this hardware so the
patch hasn't been tested.

Should be valid, though.


 drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c
b/drivers/net/wireless/orinoco/orinoco_usb.c index 01624dc..2e998ac
100644 --- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1578,7 +1578,7 @@ static int ezusb_probe(struct usb_interface
*interface, struct ezusb_priv *upriv = NULL;
 	struct usb_interface_descriptor *iface_desc;
 	struct usb_endpoint_descriptor *ep;
-	const struct firmware *fw_entry;
+	const struct firmware *fw_entry = NULL;
 	int retval = 0;
 	int i;
 
-- 
