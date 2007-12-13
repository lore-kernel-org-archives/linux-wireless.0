Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770AbXLMG7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:42 -0500
Subject: [PATCH 77/48] libertas: kill rx_urb_recall and eth_dev members of struct usb_card_rec
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i30-0005tD-19@shinybook.infradead.org> (sfid-20071213_070014_731168_0EC9304C)
Date: Thu, 13 Dec 2007 01:59:54 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 18:36:35 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   12 ++----------
 drivers/net/wireless/libertas/if_usb.h |    3 ---
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index b19a6c9..02192e8 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -175,8 +175,6 @@ static int if_usb_probe(struct usb_interface *intf,
 				       "Rx URB allocation failed\n");
 				goto dealloc;
 			}
-			cardp->rx_urb_recall = 0;
-
 			cardp->bulk_in_size =
 				le16_to_cpu(endpoint->wMaxPacketSize);
 			cardp->bulk_in_endpointAddr =
@@ -232,8 +230,6 @@ static int if_usb_probe(struct usb_interface *intf,
 	cardp->priv = priv;
 	cardp->priv->fw_ready = 1;
 
-	cardp->eth_dev = priv->dev;
-
 	priv->hw_host_to_card = if_usb_host_to_card;
 	priv->hw_get_int_status = if_usb_get_int_status;
 	priv->hw_read_event_cause = if_usb_read_event_cause;
@@ -978,15 +974,13 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
-	netif_device_detach(cardp->eth_dev);
+	netif_device_detach(priv->dev);
 	netif_device_detach(priv->mesh_dev);
 
 	/* Unlink tx & rx urb */
 	usb_kill_urb(cardp->tx_urb);
 	usb_kill_urb(cardp->rx_urb);
 
-	cardp->rx_urb_recall = 1;
-
 	lbs_deb_leave(LBS_DEB_USB);
 	return 0;
 }
@@ -998,11 +992,9 @@ static int if_usb_resume(struct usb_interface *intf)
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	cardp->rx_urb_recall = 0;
-
 	if_usb_submit_rx_urb(cardp);
 
-	netif_device_attach(cardp->eth_dev);
+	netif_device_attach(priv->dev);
 	netif_device_attach(priv->mesh_dev);
 
 	lbs_deb_leave(LBS_DEB_USB);
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index f028df1..668410f 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -47,7 +47,6 @@ struct read_cb_info {
 
 /** USB card description structure*/
 struct usb_card_rec {
-	struct net_device *eth_dev;
 	struct usb_device *udev;
 	struct urb *rx_urb, *tx_urb;
 	struct lbs_private *priv;
@@ -75,8 +74,6 @@ struct usb_card_rec {
 	u32 usb_event_cause;
 	u8 usb_int_cause;
 
-	u8 rx_urb_recall;
-
 	s8 bootcmdresp;
 };
 
-- 
1.5.3.4

