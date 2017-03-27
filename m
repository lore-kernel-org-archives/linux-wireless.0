Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38741 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752176AbdC0NAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 09:00:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2RD00dY030119
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 06:00:00 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 29f247g8yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 06:00:00 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2] mwifiex: Support USB interrupt endpoint for command response/event
Date: Mon, 27 Mar 2017 18:27:44 +0530
Message-ID: <1490619464-14844-1-git-send-email-gbhat@marvell.com> (sfid-20170327_150018_939561_5D710F7B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB firmware added support for sending command response/event through
interrupt endpoint, to enhance RX throughput. Added corresponding changes
required to support this feature. This change takes care of backward
compatibility with older firmware.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: Fixed typo in commit message
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 45 +++++++++++++++++++++++-------
 drivers/net/wireless/marvell/mwifiex/usb.h |  4 +++
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 9cf3334..2f7705c 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -306,9 +306,17 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 		}
 	}
 
-	usb_fill_bulk_urb(ctx->urb, card->udev,
-			  usb_rcvbulkpipe(card->udev, ctx->ep), ctx->skb->data,
-			  size, mwifiex_usb_rx_complete, (void *)ctx);
+	if (card->rx_cmd_ep == ctx->ep &&
+	    card->rx_cmd_ep_type == USB_ENDPOINT_XFER_INT)
+		usb_fill_int_urb(ctx->urb, card->udev,
+				 usb_rcvintpipe(card->udev, ctx->ep),
+				 ctx->skb->data, size, mwifiex_usb_rx_complete,
+				 (void *)ctx, card->rx_cmd_interval);
+	else
+		usb_fill_bulk_urb(ctx->urb, card->udev,
+				  usb_rcvbulkpipe(card->udev, ctx->ep),
+				  ctx->skb->data, size, mwifiex_usb_rx_complete,
+				  (void *)ctx);
 
 	if (card->rx_cmd_ep == ctx->ep)
 		atomic_inc(&card->rx_cmd_urb_pending);
@@ -424,10 +432,13 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 		epd = &iface_desc->endpoint[i].desc;
 		if (usb_endpoint_dir_in(epd) &&
 		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_CMD_EVENT &&
-		    usb_endpoint_xfer_bulk(epd)) {
-			pr_debug("info: bulk IN: max pkt size: %d, addr: %d\n",
+		    (usb_endpoint_xfer_bulk(epd) ||
+		     usb_endpoint_xfer_int(epd))) {
+			card->rx_cmd_ep_type = usb_endpoint_type(epd);
+			card->rx_cmd_interval = epd->bInterval;
+			pr_debug("info: Rx CMD/EVT:: max pkt size: %d, addr: %d, ep_type: %d\n",
 				 le16_to_cpu(epd->wMaxPacketSize),
-				 epd->bEndpointAddress);
+				 epd->bEndpointAddress, card->rx_cmd_ep_type);
 			card->rx_cmd_ep = usb_endpoint_num(epd);
 			atomic_set(&card->rx_cmd_urb_pending, 0);
 		}
@@ -461,10 +472,16 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 		}
 		if (usb_endpoint_dir_out(epd) &&
 		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_CMD_EVENT &&
-		    usb_endpoint_xfer_bulk(epd)) {
+		    (usb_endpoint_xfer_bulk(epd) ||
+		     usb_endpoint_xfer_int(epd))) {
+			card->tx_cmd_ep_type = usb_endpoint_type(epd);
+			card->tx_cmd_interval = epd->bInterval;
 			pr_debug("info: bulk OUT: max pkt size: %d, addr: %d\n",
 				 le16_to_cpu(epd->wMaxPacketSize),
 				 epd->bEndpointAddress);
+			pr_debug("info: Tx CMD:: max pkt size: %d, addr: %d, ep_type: %d\n",
+				 le16_to_cpu(epd->wMaxPacketSize),
+				 epd->bEndpointAddress, card->tx_cmd_ep_type);
 			card->tx_cmd_ep = usb_endpoint_num(epd);
 			atomic_set(&card->tx_cmd_urb_pending, 0);
 			card->bulk_out_maxpktsize =
@@ -884,9 +901,17 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	context->skb = skb;
 	tx_urb = context->urb;
 
-	usb_fill_bulk_urb(tx_urb, card->udev, usb_sndbulkpipe(card->udev, ep),
-			  data, skb->len, mwifiex_usb_tx_complete,
-			  (void *)context);
+	if (ep == card->tx_cmd_ep &&
+	    card->tx_cmd_ep_type == USB_ENDPOINT_XFER_INT)
+		usb_fill_int_urb(tx_urb, card->udev,
+				 usb_sndintpipe(card->udev, ep), data,
+				 skb->len, mwifiex_usb_tx_complete,
+				 (void *)context, card->tx_cmd_interval);
+	else
+		usb_fill_bulk_urb(tx_urb, card->udev,
+				  usb_sndbulkpipe(card->udev, ep), data,
+				  skb->len, mwifiex_usb_tx_complete,
+				  (void *)context);
 
 	tx_urb->transfer_flags |= URB_ZERO_PACKET;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index 16017ae..e36bd63 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -90,6 +90,10 @@ struct usb_card_rec {
 	struct urb_context tx_cmd;
 	u8 mc_resync_flag;
 	struct usb_tx_data_port port[MWIFIEX_TX_DATA_PORT];
+	int rx_cmd_ep_type;
+	u8 rx_cmd_interval;
+	int tx_cmd_ep_type;
+	u8 tx_cmd_interval;
 };
 
 struct fw_header {
-- 
1.9.1
