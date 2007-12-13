Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762666AbXLMHAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:09 -0500
Subject: [PATCH 91/48] libertas: implement suspend/resume for USB devices
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3I-0005uS-Bc@shinybook.infradead.org> (sfid-20071213_070631_982477_E3F7B2BF)
Date: Thu, 13 Dec 2007 02:00:12 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 17:40:56 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 74fec9d..15715a6 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -242,6 +242,10 @@ static int if_usb_probe(struct usb_interface *intf,
 
 	if_usb_set_boot2_ver(priv);
 
+	/* Set suspend/resume configuration:
+	   wake via GPIO2 after a 20ms delay */
+	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA, 2, 20);
+
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
 
@@ -969,21 +973,24 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usb_card_rec *cardp = usb_get_intfdata(intf);
 	struct lbs_private *priv = cardp->priv;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
 	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
-	netif_device_detach(priv->dev);
-	netif_device_detach(priv->mesh_dev);
+	ret = lbs_suspend(priv);
+	if (ret)
+		goto out;
 
 	/* Unlink tx & rx urb */
 	usb_kill_urb(cardp->tx_urb);
 	usb_kill_urb(cardp->rx_urb);
 
+ out:
 	lbs_deb_leave(LBS_DEB_USB);
-	return 0;
+	return ret;
 }
 
 static int if_usb_resume(struct usb_interface *intf)
@@ -995,8 +1002,7 @@ static int if_usb_resume(struct usb_interface *intf)
 
 	if_usb_submit_rx_urb(cardp);
 
-	netif_device_attach(priv->dev);
-	netif_device_attach(priv->mesh_dev);
+	lbs_resume(priv);
 
 	lbs_deb_leave(LBS_DEB_USB);
 	return 0;
-- 
1.5.3.4

