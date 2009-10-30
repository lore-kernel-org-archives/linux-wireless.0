Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747AbZJ3RpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 13:45:20 -0400
Subject: [PATCH] libertas if_usb: Fix crash on 64-bit machines
From: David Woodhouse <dwmw2@infradead.org>
To: linville@tuxdriver.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, stern@rowland.harvard.edu, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 17:45:14 +0000
Message-Id: <1256924714.4030.44.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a 64-bit kernel, skb->tail is an offset, not a pointer. The libertas
usb driver passes it to usb_fill_bulk_urb() anyway, causing interesting
crashes. Fix that by using skb->data instead.

This highlights a problem with usb_fill_bulk_urb(). It doesn't notice
when dma_map_single() fails and return the error to its caller as it
should. In fact it _can't_ currently return the error, since it returns
void.

So this problem was showing up only at unmap time, after we'd already
suffered memory corruption by doing DMA to a bogus address.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: stable@kernel.org
---
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 92bc8c5..3fac4ef 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -508,7 +508,7 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 	/* Fill the receive configuration URB and initialise the Rx call back */
 	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
 			  usb_rcvbulkpipe(cardp->udev, cardp->ep_in),
-			  (void *) (skb->tail + (size_t) IPFIELD_ALIGN_OFFSET),
+			  skb->data + IPFIELD_ALIGN_OFFSET,
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
 			  cardp);
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

