Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54212 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYLTBV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 20:21:58 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] p54usb: fix random traffic stalls (LM87)
Date: Sat, 20 Dec 2008 02:21:56 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812200221.56534.chunkeey@web.de> (sfid-20081220_022200_806617_89C47468)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All LM87 firmwares need a explicit termination "packet",
in oder to finish the pending transfer properly.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Larry,

Does your test case still fail with this one?
---
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-20 00:26:35.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-20 01:09:45.000000000 +0100
@@ -284,6 +284,7 @@ static void p54u_tx_lm87(struct ieee8021
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  skb->data, skb->len, p54u_tx_cb, skb);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_anchor_urb(data_urb, &priv->submitted);
 	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {

