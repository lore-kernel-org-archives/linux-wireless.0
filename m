Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYJ3KNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:13:53 -0400
Subject: [PATCH for 2.6.28] libertas_tf: fix skb tail pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 23:24:14 +0100
Message-Id: <1225319054.5439.39.camel@johannes.berg> (sfid-20081030_111408_801294_56AE0E9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb->tail can't be meant here because it's not the same across 32/64 bit
compilations. This means there's no way the current driver can work on
64-bit architectures.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.27]
---
 drivers/net/wireless/libertas_tf/if_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/libertas_tf/if_usb.c	2008-10-29 23:03:29.890775463 +0100
+++ wireless-testing/drivers/net/wireless/libertas_tf/if_usb.c	2008-10-29 23:03:40.587777840 +0100
@@ -331,7 +331,7 @@ static int __if_usb_submit_rx_urb(struct
 	/* Fill the receive configuration URB and initialise the Rx call back */
 	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
 			  usb_rcvbulkpipe(cardp->udev, cardp->ep_in),
-			  (void *) (skb->tail),
+			  skb_tail_pointer(skb),
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn, cardp);
 
 	cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;


