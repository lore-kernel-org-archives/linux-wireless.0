Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56563 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624AbcHKVNh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 17:13:37 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] net: wireless: marvell: libertas_tf: if_usb: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:13:06 +0200
Message-Id: <1470949988-25705-2-git-send-email-wsa-dev@sang-engineering.com> (sfid-20160811_231454_616013_85A69452)
In-Reply-To: <1470949988-25705-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
 <1470949988-25705-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index 799a2efe579372..e0ade40d9497d7 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -198,22 +198,16 @@ static int if_usb_probe(struct usb_interface *intf,
 	}
 
 	cardp->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cardp->rx_urb) {
-		lbtf_deb_usbd(&udev->dev, "Rx URB allocation failed\n");
+	if (!cardp->rx_urb)
 		goto dealloc;
-	}
 
 	cardp->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cardp->tx_urb) {
-		lbtf_deb_usbd(&udev->dev, "Tx URB allocation failed\n");
+	if (!cardp->tx_urb)
 		goto dealloc;
-	}
 
 	cardp->cmd_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cardp->cmd_urb) {
-		lbtf_deb_usbd(&udev->dev, "Cmd URB allocation failed\n");
+	if (!cardp->cmd_urb)
 		goto dealloc;
-	}
 
 	cardp->ep_out_buf = kmalloc(MRVDRV_ETH_TX_PACKET_BUFFER_SIZE,
 				    GFP_KERNEL);
-- 
2.8.1

