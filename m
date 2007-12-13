Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762742AbXLMG70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:26 -0500
Subject: [PATCH 62/48] libertas: switch USB cardp->priv to 'struct lbs_private *' and resulting fix
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2h-0005ry-PV@shinybook.infradead.org> (sfid-20071213_070638_995250_BB306713)
Date: Thu, 13 Dec 2007 01:59:35 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 12:53:43 -0500

Amazing what interesting things the compiler will tell you if you let it
know what types you expect to be passing around.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 drivers/net/wireless/libertas/if_usb.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index a086653..6cd6c96 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1003,7 +1003,7 @@ static int if_usb_resume(struct usb_interface *intf)
 
 	cardp->rx_urb_recall = 0;
 
-	if_usb_submit_rx_urb(cardp->priv);
+	if_usb_submit_rx_urb(cardp);
 
 	netif_device_attach(cardp->eth_dev);
 	netif_device_attach(priv->mesh_dev);
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 224c957..f028df1 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -4,6 +4,8 @@
 #include <linux/wait.h>
 #include <linux/timer.h>
 
+struct lbs_private;
+
 /**
   * This file contains definition for USB interface.
   */
@@ -48,7 +50,7 @@ struct usb_card_rec {
 	struct net_device *eth_dev;
 	struct usb_device *udev;
 	struct urb *rx_urb, *tx_urb;
-	void *priv;
+	struct lbs_private *priv;
 	struct read_cb_info rinfo;
 
 	int bulk_in_size;
-- 
1.5.3.4

