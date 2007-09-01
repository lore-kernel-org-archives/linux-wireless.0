Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56199 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbXIAEe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:26 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 7E50A618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:26 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 02/35] Use existing macros to find bulk in and bulk out  endpoints
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:26 -0400
Message-ID: <20070901043425.2498.87794.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index f2a74d4..be9ef6e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -2045,10 +2045,7 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 			 __func__,
 			 i, endpoint->bEndpointAddress, endpoint->bmAttributes);
 
-		if ((endpoint->bEndpointAddress & 0x80) &&
-		    ((endpoint->bmAttributes & 3) == 0x02)) {
-			/* we found a bulk in endpoint */
-
+		if (usb_endpoint_is_bulk_in(endpoint)) {
 			priv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (!priv->read_urb) {
 				err("No free urbs available");
@@ -2058,9 +2055,7 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 			    usb_rcvbulkpipe(udev, endpoint->bEndpointAddress);
 		}
 
-		if (((endpoint->bEndpointAddress & 0x80) == 0x00) &&
-		    ((endpoint->bmAttributes & 3) == 0x02)) {
-			/* we found a bulk out endpoint */
+		if (usb_endpoint_is_bulk_out(endpoint)) {
 			priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (!priv->write_urb) {
 				err("no free urbs available");
