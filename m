Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbXLJPpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:54 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 19/48] libertas: when usb_submit_usb fails, include the error code in the printk
Message-Id: <E1J1kpO-0006le-1j@shinybook.infradead.org> (sfid-20071210_154600_799786_208381EF)
Date: Mon, 10 Dec 2007 10:45:54 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 7 Dec 2007 15:12:26 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index d5fc7d7..e9190a6 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -424,7 +424,7 @@ static int usb_tx_block(struct usb_card_rec *cardp, u8 * payload, u16 nb)
 
 	if ((ret = usb_submit_urb(cardp->tx_urb, GFP_ATOMIC))) {
 		/*  transfer failed */
-		lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed\n");
+		lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
 		ret = -1;
 	} else {
 		/* lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb success\n"); */
@@ -462,7 +462,7 @@ static int __if_usb_submit_rx_urb(struct usb_card_rec *cardp,
 	/* lbs_deb_usbd(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb); */
 	if ((ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
 		/* handle failure conditions */
-		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed\n");
+		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
 		kfree_skb(skb);
 		rinfo->skb = NULL;
 		ret = -1;
-- 
1.5.3.4

