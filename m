Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49249 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870AbXLPW6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:20 -0500
Subject: [PATCH 98/48] libertas: stop attempting to reset devices on unload
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rk-00037h-E7@shinybook.infradead.org> (sfid-20071216_225826_811125_A9FB2797)
Date: Sun, 16 Dec 2007 17:58:56 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 13 Dec 2007 21:53:16 -0500

It wasn't working anyway -- by the time we get into if_usb_disconnect()
the USB core has already stopped us talking to the thing; even if it's
just on unload and the device still exists.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 8191416..25925bd 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -278,16 +278,11 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	cardp->surprise_removed = 1;
 
 	if (priv) {
-
 		priv->surpriseremoved = 1;
 		lbs_stop_card(priv);
 		lbs_remove_card(priv);
 	}
 
-	/* this is (apparently?) necessary for future usage of the device */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RESET, CMD_ACT_HALT,
-			0, 0, NULL);
-
 	/* Unlink and free urb */
 	if_usb_free(cardp);
 
-- 
1.5.3.4

