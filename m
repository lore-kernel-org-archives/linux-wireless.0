Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753088AbeFGNyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Jun 2018 09:54:51 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2] NFC: pn533: Fix wrong GFP flag usage
Date: Thu,  7 Jun 2018 15:54:48 +0200
Message-Id: <20180607135448.20657-1-hdegoede@redhat.com> (sfid-20180607_155454_724360_BC21047B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pn533_recv_response() is an urb completion handler, so it must use
GFP_ATOMIC. pn533_usb_send_frame() OTOH runs from a regular sleeping
context, so the pn533_submit_urb_for_response() there (and only there)
can use the regular GFP_KERNEL flags.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1514134
Fixes: 9815c7cf22da ("NFC: pn533: Separate physical layer from ...")
Cc: Michael Thalmeier <michael.thalmeier@hale.at>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Rebase on top of current usb/usb-next
---
 drivers/nfc/pn533/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index d5553c47014f..5d823e965883 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -74,7 +74,7 @@ static void pn533_recv_response(struct urb *urb)
 	struct sk_buff *skb = NULL;
 
 	if (!urb->status) {
-		skb = alloc_skb(urb->actual_length, GFP_KERNEL);
+		skb = alloc_skb(urb->actual_length, GFP_ATOMIC);
 		if (!skb) {
 			nfc_err(&phy->udev->dev, "failed to alloc memory\n");
 		} else {
@@ -186,7 +186,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 
 	if (dev->protocol_type == PN533_PROTO_REQ_RESP) {
 		/* request for response for sent packet directly */
-		rc = pn533_submit_urb_for_response(phy, GFP_ATOMIC);
+		rc = pn533_submit_urb_for_response(phy, GFP_KERNEL);
 		if (rc)
 			goto error;
 	} else if (dev->protocol_type == PN533_PROTO_REQ_ACK_RESP) {
-- 
2.17.1
