Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33802 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbcKRIqb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:46:31 -0500
Received: by mail-pg0-f65.google.com with SMTP id e9so19719164pgc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 00:46:31 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Fri, 18 Nov 2016 00:46:25 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH 7/7] mwifiex: Remove unused 'bcd_usb' variable
Message-ID: <eb22a169bcb478a8221d9c78f6335a11520fd336.1479458374.git.kirtika@google.com> (sfid-20161118_094635_094629_A1C80CCA)
References: <cover.1479458373.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479458373.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_usb_probe() defines and sets bcd_usb but does not use it,
Compiling with W=1 gives the following warning, fix it.
mwifiex/usb.c: In function ‘mwifiex_usb_probe’:
mwifiex/usb.c:383:41: warning: variable ‘bcd_usb’ set but not used [-Wunused-but-set-variable]

The unused variable seems to be present since 4daffe354366 which introduced
mwifiex_usb_probe().

Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 73eb084..67a15c1 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -380,7 +380,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *epd;
 	int ret, i;
 	struct usb_card_rec *card;
-	u16 id_vendor, id_product, bcd_device, bcd_usb;
+	u16 id_vendor, id_product, bcd_device;

 	card = kzalloc(sizeof(struct usb_card_rec), GFP_KERNEL);
 	if (!card)
@@ -389,7 +389,6 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	id_vendor = le16_to_cpu(udev->descriptor.idVendor);
 	id_product = le16_to_cpu(udev->descriptor.idProduct);
 	bcd_device = le16_to_cpu(udev->descriptor.bcdDevice);
-	bcd_usb = le16_to_cpu(udev->descriptor.bcdUSB);
 	pr_debug("info: VID/PID = %X/%X, Boot2 version = %X\n",
 		 id_vendor, id_product, bcd_device);

--
2.8.0.rc3.226.g39d4020
