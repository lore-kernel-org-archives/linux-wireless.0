Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762767AbXLMG7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:18 -0500
Subject: [PATCH 56/48] libertas: improve reliability of firmware reloading on USB
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2X-0005rM-Q1@shinybook.infradead.org> (sfid-20071213_070639_991018_4D364ABE)
Date: Thu, 13 Dec 2007 01:59:25 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 18:53:34 -0500

Increase the delay between issuing the RESET command and the usb reset,
and be prepared to discard more than one 'normal' packet from it before
it resets.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 8ff57a6..0a37950 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -389,9 +389,9 @@ static int if_usb_reset_device(struct usb_card_rec *cardp)
 	cmd->params.reset.action = cpu_to_le16(CMD_ACT_HALT);
 	usb_tx_block(cardp, cardp->bulk_out_buffer, 4 + S_DS_GEN + sizeof(struct cmd_ds_802_11_reset));
 
-	msleep(10);
+	msleep(100);
 	ret = usb_reset_device(cardp->udev);
-	msleep(10);
+	msleep(100);
 
 	lbs_deb_leave_args(LBS_DEB_USB, "ret %d", ret);
 
@@ -500,7 +500,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 		return;
 	}
 
-	if (cardp->bootcmdresp == 0) {
+	if (cardp->bootcmdresp <= 0) {
 		memcpy (&bootcmdresp, skb->data + IPFIELD_ALIGN_OFFSET,
 			sizeof(bootcmdresp));
 		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
-- 
1.5.3.4

