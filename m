Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55221 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3CHVmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 16:42:08 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so3079238wgb.12
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 13:42:07 -0800 (PST)
Date: Fri, 8 Mar 2013 22:42:03 +0100
From: =?UTF-8?B?TWljaGHFgg==?= Pecio <michal.pecio@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco_usb: don't release nonexistent firmware
Message-ID: <20130308224203.5fd4ff92@gmail.com> (sfid-20130308_224213_402827_0C7DCF6C)
In-Reply-To: <20130308210220.GD402@tuxdriver.com>
References: <20130307233341.6738c6e6@gmail.com>
	<20130308210220.GD402@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Pecio <michal.pecio@gmail.com>

Initialize fw_entry to NULL to prevent cleanup code from passing
bogus pointer to release_firmware() when priv allocation fails.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 01624dc..2e998ac 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1578,7 +1578,7 @@ static int ezusb_probe(struct usb_interface *interface,
 	struct ezusb_priv *upriv = NULL;
 	struct usb_interface_descriptor *iface_desc;
 	struct usb_endpoint_descriptor *ep;
-	const struct firmware *fw_entry;
+	const struct firmware *fw_entry = NULL;
 	int retval = 0;
 	int i;
 
-- 
1.8.1.5

