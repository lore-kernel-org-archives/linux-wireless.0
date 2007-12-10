Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32805 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXLJQu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:50:27 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 17/48] libertas: Fix endianness in boot2_version handling.
Message-Id: <E1J1kpL-0006lU-Ud@shinybook.infradead.org> (sfid-20071210_165031_076906_E89751B9)
Date: Mon, 10 Dec 2007 10:45:51 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 7 Dec 2007 12:56:45 +0000

We read it from the card. We byte-swap it. We write it back to the card.
D'oh.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 4d89fd0..d5fc7d7 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -227,7 +227,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->hw_host_to_card = if_usb_host_to_card;
 	priv->hw_get_int_status = if_usb_get_int_status;
 	priv->hw_read_event_cause = if_usb_read_event_cause;
-	priv->boot2_version = udev->descriptor.bcdDevice;
+	priv->boot2_version = le16_to_cpu(udev->descriptor.bcdDevice);
 
 	/* Delay 200 ms to waiting for the FW ready */
 	if_usb_submit_rx_urb(cardp);
-- 
1.5.3.4

