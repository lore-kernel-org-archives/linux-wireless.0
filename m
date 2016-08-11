Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56559 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366AbcHKVNf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 17:13:35 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] net: wireless: intersil: orinoco: orinoco_usb: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:13:05 +0200
Message-Id: <1470949988-25705-1-git-send-email-wsa-dev@sang-engineering.com> (sfid-20160811_231439_337122_CBC29A50)
In-Reply-To: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 56f109bc83945d..bca6935a94db9a 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1613,10 +1613,8 @@ static int ezusb_probe(struct usb_interface *interface,
 			}
 
 			upriv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!upriv->read_urb) {
-				err("No free urbs available");
+			if (!upriv->read_urb)
 				goto error;
-			}
 			if (le16_to_cpu(ep->wMaxPacketSize) != 64)
 				pr_warn("bulk in: wMaxPacketSize!= 64\n");
 			if (ep->bEndpointAddress != (2 | USB_DIR_IN))
-- 
2.8.1

