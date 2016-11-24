Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36624 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935508AbcKXB1Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 20:27:16 -0500
Received: by mail-pg0-f68.google.com with SMTP id x23so2204281pgx.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 17:27:16 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 17:27:10 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 7/7] mwifiex: Remove unused 'bcd_usb' variable
Message-ID: <966b21f38a4a9f4c5538ff614cb733f88221184e.1479950323.git.kirtika@google.com> (sfid-20161124_022719_800889_1DB4C444)
References: <cover.1479950323.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479950323.git.kirtika@google.com>
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
index c3f696a..c563160 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -379,7 +379,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *epd;
 	int ret, i;
 	struct usb_card_rec *card;
-	u16 id_vendor, id_product, bcd_device, bcd_usb;
+	u16 id_vendor, id_product, bcd_device;
 
 	card = devm_kzalloc(&intf->dev, sizeof(*card), GFP_KERNEL);
 	if (!card)
@@ -390,7 +390,6 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	id_vendor = le16_to_cpu(udev->descriptor.idVendor);
 	id_product = le16_to_cpu(udev->descriptor.idProduct);
 	bcd_device = le16_to_cpu(udev->descriptor.bcdDevice);
-	bcd_usb = le16_to_cpu(udev->descriptor.bcdUSB);
 	pr_debug("info: VID/PID = %X/%X, Boot2 version = %X\n",
 		 id_vendor, id_product, bcd_device);
 
-- 
2.8.0.rc3.226.g39d4020
