Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:45021 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3HZHcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:32:03 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so947526bkb.21
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 00:32:01 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 15:32:01 +0800
Message-ID: <CAPgLHd8dEFz6W7W-HLDgqK_up0zpmmAj2+D1fU0WkgA_KwPTsw@mail.gmail.com> (sfid-20130826_093208_600976_2DDA14FE)
Subject: [PATCH] zd1201: fix error return code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the memory alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/zd1201.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 4941f20..73aa738 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -75,8 +75,10 @@ static int zd1201_fw_upload(struct usb_device *dev, int apfw)
         len = fw_entry->size;
 
 	buf = kmalloc(1024, GFP_ATOMIC);
-	if (!buf)
+	if (!buf) {
+		err = -ENOMEM;
 		goto exit;
+	}
 	
 	while (len > 0) {
 		int translen = (len > 1024) ? 1024 : len;
@@ -1762,8 +1764,10 @@ static int zd1201_probe(struct usb_interface *interface,
 	zd->endp_out2 = 2;
 	zd->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	zd->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!zd->rx_urb || !zd->tx_urb)
+	if (!zd->rx_urb || !zd->tx_urb) {
+		err = -ENOMEM;
 		goto err_zd;
+	}
 
 	mdelay(100);
 	err = zd1201_drvr_start(zd);

