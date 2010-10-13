Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:31961 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab0JMTcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 15:32:33 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: dcbw@redhat.com
Cc: pgf@laptop.org
Cc: steve@cozybit.com
Subject: [PATCH] libertas: Communicate USB transfer errors
Message-Id: <20101013191456.BA0A99D401B@zog.reactivated.net>
Date: Wed, 13 Oct 2010 20:14:56 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Paul Fox <pgf@laptop.org>

The return code was being overwritten with -1.
Useful for debugging.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 3ff6106..16e2575 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -472,11 +472,12 @@ static int if_usb_reset_device(struct if_usb_card *cardp)
  */
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb)
 {
-	int ret = -1;
+	int ret;
 
 	/* check if device is removed */
 	if (cardp->surprise_removed) {
 		lbs_deb_usbd(&cardp->udev->dev, "Device removed\n");
+		ret = -ENODEV;
 		goto tx_ret;
 	}
 
@@ -489,7 +490,6 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb
 
 	if ((ret = usb_submit_urb(cardp->tx_urb, GFP_ATOMIC))) {
 		lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
-		ret = -1;
 	} else {
 		lbs_deb_usb2(&cardp->udev->dev, "usb_submit_urb success\n");
 		ret = 0;
-- 
1.7.2.3

