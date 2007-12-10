Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55240 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXLJPpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:33 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 01/48] libertas: Fix memory leak of RX skbs
Message-Id: <E1J1kp5-0006kC-4J@shinybook.infradead.org> (sfid-20071210_154539_009743_B623E83F)
Date: Mon, 10 Dec 2007 10:45:35 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 28 Nov 2007 16:20:51 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 4fce0ba..c27ffcf 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -460,6 +460,8 @@ static int __if_usb_submit_rx_urb(struct usb_card_rec *cardp,
 	if ((ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
 		/* handle failure conditions */
 		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed\n");
+		kfree_skb(skb);
+		rinfo->skb = NULL;
 		ret = -1;
 	} else {
 		/* lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB success\n"); */
@@ -667,8 +669,10 @@ static void if_usb_receive(struct urb *urb)
 		lbs_deb_usbd(&cardp->udev->dev,
 			    "Recv length = 0x%x, Recv type = 0x%X\n",
 			    recvlength, recvtype);
-	} else if (urb->status)
+	} else if (urb->status) {
+		kfree_skb(skb);
 		goto rx_exit;
+	}
 
 	switch (recvtype) {
 	case CMD_TYPE_DATA:
-- 
1.5.3.4

