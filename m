Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014AbXLPW6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:24 -0500
Subject: [PATCH 99/48] libertas: clean up if_usb driver
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rm-00037m-Hd@shinybook.infradead.org> (sfid-20071216_225830_852281_05133BED)
Date: Sun, 16 Dec 2007 17:58:58 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 14 Dec 2007 00:47:05 -0500

It was just getting on my tits, really.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |  428 ++++++++++++++------------------
 drivers/net/wireless/libertas/if_usb.h |   95 ++++----
 2 files changed, 225 insertions(+), 298 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 25925bd..9cb9e03 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -16,6 +16,9 @@
 #include "cmd.h"
 #include "if_usb.h"
 
+#define INSANEDEBUG	0
+#define lbs_deb_usb2(...) do { if (INSANEDEBUG) lbs_deb_usbd(__VA_ARGS__); } while (0)
+
 #define MESSAGE_HEADER_LEN	4
 
 static char *lbs_fw_name = "usb8388.bin";
@@ -32,17 +35,16 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
 
 static void if_usb_receive(struct urb *urb);
 static void if_usb_receive_fwload(struct urb *urb);
-static int if_usb_prog_firmware(struct usb_card_rec *cardp);
-static int if_usb_host_to_card(struct lbs_private *priv,
-	u8 type,
-	u8 *payload,
-	u16 nb);
-static int if_usb_get_int_status(struct lbs_private *priv, u8 *);
+static int if_usb_prog_firmware(struct if_usb_card *cardp);
+static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
+			       uint8_t *payload, uint16_t nb);
+static int if_usb_get_int_status(struct lbs_private *priv, uint8_t *);
 static int if_usb_read_event_cause(struct lbs_private *);
-static int usb_tx_block(struct usb_card_rec *cardp, u8 *payload, u16 nb);
-static void if_usb_free(struct usb_card_rec *cardp);
-static int if_usb_submit_rx_urb(struct usb_card_rec *cardp);
-static int if_usb_reset_device(struct usb_card_rec *cardp);
+static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
+			uint16_t nb);
+static void if_usb_free(struct if_usb_card *cardp);
+static int if_usb_submit_rx_urb(struct if_usb_card *cardp);
+static int if_usb_reset_device(struct if_usb_card *cardp);
 
 /**
  *  @brief  call back function to handle the status of the URB
@@ -51,18 +53,16 @@ static int if_usb_reset_device(struct usb_card_rec *cardp);
  */
 static void if_usb_write_bulk_callback(struct urb *urb)
 {
-	struct usb_card_rec *cardp = (struct usb_card_rec *) urb->context;
+	struct if_usb_card *cardp = (struct if_usb_card *) urb->context;
 
 	/* handle the transmission complete validations */
 
 	if (urb->status == 0) {
 		struct lbs_private *priv = cardp->priv;
 
-		/*
-		lbs_deb_usbd(&urb->dev->dev, "URB status is successfull\n");
-		lbs_deb_usbd(&urb->dev->dev, "Actual length transmitted %d\n",
-		       urb->actual_length);
-		*/
+		lbs_deb_usb2(&urb->dev->dev, "URB status is successful\n");
+		lbs_deb_usb2(&urb->dev->dev, "Actual length transmitted %d\n",
+			     urb->actual_length);
 
 		/* Used for both firmware TX and regular TX.  priv isn't
 		 * valid at firmware load time.
@@ -79,10 +79,10 @@ static void if_usb_write_bulk_callback(struct urb *urb)
 
 /**
  *  @brief  free tx/rx urb, skb and rx buffer
- *  @param cardp	pointer usb_card_rec
+ *  @param cardp	pointer if_usb_card
  *  @return 	   	N/A
  */
-static void if_usb_free(struct usb_card_rec *cardp)
+static void if_usb_free(struct if_usb_card *cardp)
 {
 	lbs_deb_enter(LBS_DEB_USB);
 
@@ -96,8 +96,8 @@ static void if_usb_free(struct usb_card_rec *cardp)
 	usb_free_urb(cardp->rx_urb);
 	cardp->rx_urb = NULL;
 
-	kfree(cardp->bulk_out_buffer);
-	cardp->bulk_out_buffer = NULL;
+	kfree(cardp->ep_out_buf);
+	cardp->ep_out_buf = NULL;
 
 	lbs_deb_leave(LBS_DEB_USB);
 }
@@ -115,7 +115,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 
 static void if_usb_fw_timeo(unsigned long priv)
 {
-	struct usb_card_rec *cardp = (void *)priv;
+	struct if_usb_card *cardp = (void *)priv;
 
 	if (cardp->fwdnldover) {
 		lbs_deb_usb("Download complete, no event. Assuming success\n");
@@ -125,6 +125,7 @@ static void if_usb_fw_timeo(unsigned long priv)
 	}
 	wake_up(&cardp->fw_wq);
 }
+
 /**
  *  @brief sets the configuration values
  *  @param ifnum	interface number
@@ -138,12 +139,12 @@ static int if_usb_probe(struct usb_interface *intf,
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
 	struct lbs_private *priv;
-	struct usb_card_rec *cardp;
+	struct if_usb_card *cardp;
 	int i;
 
 	udev = interface_to_usbdev(intf);
 
-	cardp = kzalloc(sizeof(struct usb_card_rec), GFP_KERNEL);
+	cardp = kzalloc(sizeof(struct if_usb_card), GFP_KERNEL);
 	if (!cardp) {
 		lbs_pr_err("Out of memory allocating private data.\n");
 		goto error;
@@ -156,7 +157,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	iface_desc = intf->cur_altsetting;
 
 	lbs_deb_usbd(&udev->dev, "bcdUSB = 0x%X bDeviceClass = 0x%X"
-	       " bDeviceSubClass = 0x%X, bDeviceProtocol = 0x%X\n",
+		     " bDeviceSubClass = 0x%X, bDeviceProtocol = 0x%X\n",
 		     le16_to_cpu(udev->descriptor.bcdUSB),
 		     udev->descriptor.bDeviceClass,
 		     udev->descriptor.bDeviceSubClass,
@@ -164,61 +165,40 @@ static int if_usb_probe(struct usb_interface *intf,
 
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
-		if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-			USB_ENDPOINT_XFER_BULK)) {
-			/* we found a bulk in endpoint */
-			lbs_deb_usbd(&udev->dev, "Bulk in size is %d\n",
-				     le16_to_cpu(endpoint->wMaxPacketSize));
-			if (!(cardp->rx_urb = usb_alloc_urb(0, GFP_KERNEL))) {
-				lbs_deb_usbd(&udev->dev,
-				       "Rx URB allocation failed\n");
-				goto dealloc;
-			}
-			cardp->bulk_in_size =
-				le16_to_cpu(endpoint->wMaxPacketSize);
-			cardp->bulk_in_endpointAddr =
-			    (endpoint->
-			     bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
-			lbs_deb_usbd(&udev->dev, "in_endpoint = %d\n",
-			       endpoint->bEndpointAddress);
-		}
+		if (usb_endpoint_is_bulk_in(endpoint)) {
+			cardp->ep_in_size = le16_to_cpu(endpoint->wMaxPacketSize);
+			cardp->ep_in = usb_endpoint_num(endpoint);
 
-		if (((endpoint->
-		      bEndpointAddress & USB_ENDPOINT_DIR_MASK) ==
-		     USB_DIR_OUT)
-		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-			USB_ENDPOINT_XFER_BULK)) {
-			/* We found bulk out endpoint */
-			if (!(cardp->tx_urb = usb_alloc_urb(0, GFP_KERNEL))) {
-				lbs_deb_usbd(&udev->dev,
-				       "Tx URB allocation failed\n");
-				goto dealloc;
-			}
+			lbs_deb_usbd(&udev->dev, "in_endpoint = %d\n", cardp->ep_in);
+			lbs_deb_usbd(&udev->dev, "Bulk in size is %d\n", cardp->ep_in_size);
 
-			cardp->bulk_out_size =
-				le16_to_cpu(endpoint->wMaxPacketSize);
-			lbs_deb_usbd(&udev->dev,
-				     "Bulk out size is %d\n",
-				     le16_to_cpu(endpoint->wMaxPacketSize));
-			cardp->bulk_out_endpointAddr =
-			    endpoint->bEndpointAddress;
-			lbs_deb_usbd(&udev->dev, "out_endpoint = %d\n",
-				    endpoint->bEndpointAddress);
-			cardp->bulk_out_buffer =
-			    kmalloc(MRVDRV_ETH_TX_PACKET_BUFFER_SIZE,
-				    GFP_KERNEL);
-
-			if (!cardp->bulk_out_buffer) {
-				lbs_deb_usbd(&udev->dev,
-				       "Could not allocate buffer\n");
-				goto dealloc;
-			}
+		} else if (usb_endpoint_is_bulk_out(endpoint)) {
+			cardp->ep_out_size = le16_to_cpu(endpoint->wMaxPacketSize);
+			cardp->ep_out = usb_endpoint_num(endpoint);
+
+			lbs_deb_usbd(&udev->dev, "out_endpoint = %d\n", cardp->ep_out);
+			lbs_deb_usbd(&udev->dev, "Bulk out size is %d\n", cardp->ep_out_size);
 		}
 	}
+	if (!cardp->ep_out_size || !cardp->ep_in_size) {
+		lbs_deb_usbd(&udev->dev, "Endpoints not found\n");
+		goto dealloc;
+	}
+	if (!(cardp->rx_urb = usb_alloc_urb(0, GFP_KERNEL))) {
+		lbs_deb_usbd(&udev->dev, "Rx URB allocation failed\n");
+		goto dealloc;
+	}
+	if (!(cardp->tx_urb = usb_alloc_urb(0, GFP_KERNEL))) {
+		lbs_deb_usbd(&udev->dev, "Tx URB allocation failed\n");
+		goto dealloc;
+	}
+	cardp->ep_out_buf = kmalloc(MRVDRV_ETH_TX_PACKET_BUFFER_SIZE, GFP_KERNEL);
+	if (!cardp->ep_out_buf) {
+		lbs_deb_usbd(&udev->dev, "Could not allocate buffer\n");
+		goto dealloc;
+	}
 
 	/* Upload firmware */
-	cardp->rinfo.cardp = cardp;
 	if (if_usb_prog_firmware(cardp)) {
 		lbs_deb_usbd(&udev->dev, "FW upload failed\n");
 		goto err_prog_firmware;
@@ -269,12 +249,11 @@ error:
  */
 static void if_usb_disconnect(struct usb_interface *intf)
 {
-	struct usb_card_rec *cardp = usb_get_intfdata(intf);
+	struct if_usb_card *cardp = usb_get_intfdata(intf);
 	struct lbs_private *priv = (struct lbs_private *) cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	/* Update Surprise removed to TRUE */
 	cardp->surprise_removed = 1;
 
 	if (priv) {
@@ -297,98 +276,75 @@ static void if_usb_disconnect(struct usb_interface *intf)
  *  @param priv		pointer to struct lbs_private
  *  @return 	   	0
  */
-static int if_usb_send_fw_pkt(struct usb_card_rec *cardp)
+static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 {
-	struct FWData *fwdata;
-	struct fwheader *fwheader;
-	u8 *firmware = cardp->fw->data;
-
-	fwdata = kmalloc(sizeof(struct FWData), GFP_ATOMIC);
-
-	if (!fwdata)
-		return -1;
-
-	fwheader = &fwdata->fwheader;
+	struct fwdata *fwdata = cardp->ep_out_buf;
+	uint8_t *firmware = cardp->fw->data;
 
+	/* If we got a CRC failure on the last block, back
+	   up and retry it */
 	if (!cardp->CRC_OK) {
 		cardp->totalbytes = cardp->fwlastblksent;
-		cardp->fwseqnum = cardp->lastseqnum - 1;
+		cardp->fwseqnum--;
 	}
 
-	/*
-	lbs_deb_usbd(&cardp->udev->dev, "totalbytes = %d\n",
-		    cardp->totalbytes);
-	*/
+	lbs_deb_usb2(&cardp->udev->dev, "totalbytes = %d\n",
+		     cardp->totalbytes);
 
-	memcpy(fwheader, &firmware[cardp->totalbytes],
+	/* struct fwdata (which we sent to the card) has an
+	   extra __le32 field in between the header and the data,
+	   which is not in the struct fwheader in the actual
+	   firmware binary. Insert the seqnum in the middle... */
+	memcpy(&fwdata->hdr, &firmware[cardp->totalbytes],
 	       sizeof(struct fwheader));
 
 	cardp->fwlastblksent = cardp->totalbytes;
 	cardp->totalbytes += sizeof(struct fwheader);
 
-	/* lbs_deb_usbd(&cardp->udev->dev,"Copy Data\n"); */
 	memcpy(fwdata->data, &firmware[cardp->totalbytes],
-	       le32_to_cpu(fwdata->fwheader.datalength));
+	       le32_to_cpu(fwdata->hdr.datalength));
 
-	/*
-	lbs_deb_usbd(&cardp->udev->dev,
-		    "Data length = %d\n", le32_to_cpu(fwdata->fwheader.datalength));
-	*/
+	lbs_deb_usb2(&cardp->udev->dev, "Data length = %d\n",
+		     le32_to_cpu(fwdata->hdr.datalength));
 
-	cardp->fwseqnum = cardp->fwseqnum + 1;
+	fwdata->seqnum = cpu_to_le32(++cardp->fwseqnum);
+	cardp->totalbytes += le32_to_cpu(fwdata->hdr.datalength);
 
-	fwdata->seqnum = cpu_to_le32(cardp->fwseqnum);
-	cardp->lastseqnum = cardp->fwseqnum;
-	cardp->totalbytes += le32_to_cpu(fwdata->fwheader.datalength);
+	usb_tx_block(cardp, cardp->ep_out_buf, sizeof(struct fwdata) +
+		     le32_to_cpu(fwdata->hdr.datalength));
+
+	if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_DATA_TO_RECV)) {
+		lbs_deb_usb2(&cardp->udev->dev, "There are data to follow\n");
+		lbs_deb_usb2(&cardp->udev->dev, "seqnum = %d totalbytes = %d\n",
+			     cardp->fwseqnum, cardp->totalbytes);
+	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
+		lbs_deb_usb2(&cardp->udev->dev, "Host has finished FW downloading\n");
+		lbs_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
 
-	if (fwheader->dnldcmd == cpu_to_le32(FW_HAS_DATA_TO_RECV)) {
-		/*
-		lbs_deb_usbd(&cardp->udev->dev, "There are data to follow\n");
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "seqnum = %d totalbytes = %d\n", cardp->fwseqnum,
-			    cardp->totalbytes);
-		*/
-		memcpy(cardp->bulk_out_buffer, fwheader, FW_DATA_XMIT_SIZE);
-		usb_tx_block(cardp, cardp->bulk_out_buffer, FW_DATA_XMIT_SIZE);
-
-	} else if (fwdata->fwheader.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
-		/*
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "Host has finished FW downloading\n");
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "Donwloading FW JUMP BLOCK\n");
-		*/
-		memcpy(cardp->bulk_out_buffer, fwheader, FW_DATA_XMIT_SIZE);
-		usb_tx_block(cardp, cardp->bulk_out_buffer, FW_DATA_XMIT_SIZE);
 		cardp->fwfinalblk = 1;
 	}
 
-	/*
-	lbs_deb_usbd(&cardp->udev->dev,
-		    "The firmware download is done size is %d\n",
-		    cardp->totalbytes);
-	*/
-
-	kfree(fwdata);
+	lbs_deb_usb2(&cardp->udev->dev, "Firmware download done; size %d\n",
+		     cardp->totalbytes);
 
 	return 0;
 }
 
-static int if_usb_reset_device(struct usb_card_rec *cardp)
+static int if_usb_reset_device(struct if_usb_card *cardp)
 {
-	struct cmd_ds_command *cmd = (void *)&cardp->bulk_out_buffer[4];
+	struct cmd_ds_command *cmd = cardp->ep_out_buf + 4;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	*(__le32 *)cardp->bulk_out_buffer = cpu_to_le32(CMD_TYPE_REQUEST);
+	*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
 
 	cmd->command = cpu_to_le16(CMD_802_11_RESET);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_reset) + S_DS_GEN);
 	cmd->result = cpu_to_le16(0);
 	cmd->seqnum = cpu_to_le16(0x5a5a);
 	cmd->params.reset.action = cpu_to_le16(CMD_ACT_HALT);
-	usb_tx_block(cardp, cardp->bulk_out_buffer, 4 + S_DS_GEN + sizeof(struct cmd_ds_802_11_reset));
+	usb_tx_block(cardp, cardp->ep_out_buf, 4 + S_DS_GEN + sizeof(struct cmd_ds_802_11_reset));
 
 	msleep(100);
 	ret = usb_reset_device(cardp->udev);
@@ -406,7 +362,7 @@ static int if_usb_reset_device(struct usb_card_rec *cardp)
  *  @param nb		data length
  *  @return 	   	0 or -1
  */
-static int usb_tx_block(struct usb_card_rec *cardp, u8 * payload, u16 nb)
+static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb)
 {
 	int ret = -1;
 
@@ -418,17 +374,16 @@ static int usb_tx_block(struct usb_card_rec *cardp, u8 * payload, u16 nb)
 
 	usb_fill_bulk_urb(cardp->tx_urb, cardp->udev,
 			  usb_sndbulkpipe(cardp->udev,
-					  cardp->bulk_out_endpointAddr),
+					  cardp->ep_out),
 			  payload, nb, if_usb_write_bulk_callback, cardp);
 
 	cardp->tx_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	if ((ret = usb_submit_urb(cardp->tx_urb, GFP_ATOMIC))) {
-		/*  transfer failed */
 		lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
 		ret = -1;
 	} else {
-		/* lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb success\n"); */
+		lbs_deb_usb2(&cardp->udev->dev, "usb_submit_urb success\n");
 		ret = 0;
 	}
 
@@ -436,11 +391,10 @@ tx_ret:
 	return ret;
 }
 
-static int __if_usb_submit_rx_urb(struct usb_card_rec *cardp,
+static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 				  void (*callbackfn)(struct urb *urb))
 {
 	struct sk_buff *skb;
-	struct read_cb_info *rinfo = &cardp->rinfo;
 	int ret = -1;
 
 	if (!(skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE))) {
@@ -448,27 +402,25 @@ static int __if_usb_submit_rx_urb(struct usb_card_rec *cardp,
 		goto rx_ret;
 	}
 
-	rinfo->skb = skb;
+	cardp->rx_skb = skb;
 
 	/* Fill the receive configuration URB and initialise the Rx call back */
 	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
-			  usb_rcvbulkpipe(cardp->udev,
-					  cardp->bulk_in_endpointAddr),
+			  usb_rcvbulkpipe(cardp->udev, cardp->ep_in),
 			  (void *) (skb->tail + (size_t) IPFIELD_ALIGN_OFFSET),
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
-			  rinfo);
+			  cardp);
 
 	cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;
 
-	/* lbs_deb_usbd(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb); */
+	lbs_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb);
 	if ((ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
-		/* handle failure conditions */
 		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
 		kfree_skb(skb);
-		rinfo->skb = NULL;
+		cardp->rx_skb = NULL;
 		ret = -1;
 	} else {
-		/* lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB success\n"); */
+		lbs_deb_usb2(&cardp->udev->dev, "Submit Rx URB success\n");
 		ret = 0;
 	}
 
@@ -476,27 +428,26 @@ rx_ret:
 	return ret;
 }
 
-static int if_usb_submit_rx_urb_fwload(struct usb_card_rec *cardp)
+static int if_usb_submit_rx_urb_fwload(struct if_usb_card *cardp)
 {
 	return __if_usb_submit_rx_urb(cardp, &if_usb_receive_fwload);
 }
 
-static int if_usb_submit_rx_urb(struct usb_card_rec *cardp)
+static int if_usb_submit_rx_urb(struct if_usb_card *cardp)
 {
 	return __if_usb_submit_rx_urb(cardp, &if_usb_receive);
 }
 
 static void if_usb_receive_fwload(struct urb *urb)
 {
-	struct read_cb_info *rinfo = (struct read_cb_info *)urb->context;
-	struct sk_buff *skb = rinfo->skb;
-	struct usb_card_rec *cardp = (struct usb_card_rec *)rinfo->cardp;
+	struct if_usb_card *cardp = urb->context;
+	struct sk_buff *skb = cardp->rx_skb;
 	struct fwsyncheader *syncfwheader;
-	struct bootcmdrespStr bootcmdresp;
+	struct bootcmdresp bootcmdresp;
 
 	if (urb->status) {
 		lbs_deb_usbd(&cardp->udev->dev,
-			    "URB status is failed during fw load\n");
+			     "URB status is failed during fw load\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -509,8 +460,8 @@ static void if_usb_receive_fwload(struct urb *urb)
 			lbs_pr_info("Firmware ready event received\n");
 			wake_up(&cardp->fw_wq);
 		} else {
-			lbs_deb_usb("Waiting for confirmation; got %x %x\n", le32_to_cpu(tmp[0]),
-				    le32_to_cpu(tmp[1]));
+			lbs_deb_usb("Waiting for confirmation; got %x %x\n",
+				    le32_to_cpu(tmp[0]), le32_to_cpu(tmp[1]));
 			if_usb_submit_rx_urb_fwload(cardp);
 		}
 		kfree_skb(skb);
@@ -519,37 +470,36 @@ static void if_usb_receive_fwload(struct urb *urb)
 	if (cardp->bootcmdresp <= 0) {
 		memcpy (&bootcmdresp, skb->data + IPFIELD_ALIGN_OFFSET,
 			sizeof(bootcmdresp));
+
 		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
 			kfree_skb(skb);
 			if_usb_submit_rx_urb_fwload(cardp);
 			cardp->bootcmdresp = 1;
 			lbs_deb_usbd(&cardp->udev->dev,
-				    "Received valid boot command response\n");
+				     "Received valid boot command response\n");
 			return;
 		}
-		if (bootcmdresp.u32magicnumber != cpu_to_le32(BOOT_CMD_MAGIC_NUMBER)) {
-			if (bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_REQUEST) ||
-			    bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_DATA) ||
-			    bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_INDICATION)) {
+		if (bootcmdresp.magic != cpu_to_le32(BOOT_CMD_MAGIC_NUMBER)) {
+			if (bootcmdresp.magic == cpu_to_le32(CMD_TYPE_REQUEST) ||
+			    bootcmdresp.magic == cpu_to_le32(CMD_TYPE_DATA) ||
+			    bootcmdresp.magic == cpu_to_le32(CMD_TYPE_INDICATION)) {
 				if (!cardp->bootcmdresp)
 					lbs_pr_info("Firmware already seems alive; resetting\n");
 				cardp->bootcmdresp = -1;
 			} else {
 				lbs_pr_info("boot cmd response wrong magic number (0x%x)\n",
-					    le32_to_cpu(bootcmdresp.u32magicnumber));
+					    le32_to_cpu(bootcmdresp.magic));
 			}
-		} else if (bootcmdresp.u8cmd_tag != BOOT_CMD_FW_BY_USB) {
-			lbs_pr_info(
-				"boot cmd response cmd_tag error (%d)\n",
-				bootcmdresp.u8cmd_tag);
-		} else if (bootcmdresp.u8result != BOOT_CMD_RESP_OK) {
-			lbs_pr_info(
-				"boot cmd response result error (%d)\n",
-				bootcmdresp.u8result);
+		} else if (bootcmdresp.cmd != BOOT_CMD_FW_BY_USB) {
+			lbs_pr_info("boot cmd response cmd_tag error (%d)\n",
+				    bootcmdresp.cmd);
+		} else if (bootcmdresp.result != BOOT_CMD_RESP_OK) {
+			lbs_pr_info("boot cmd response result error (%d)\n",
+				    bootcmdresp.result);
 		} else {
 			cardp->bootcmdresp = 1;
 			lbs_deb_usbd(&cardp->udev->dev,
-				    "Received valid boot command response\n");
+				     "Received valid boot command response\n");
 		}
 		kfree_skb(skb);
 		if_usb_submit_rx_urb_fwload(cardp);
@@ -564,20 +514,15 @@ static void if_usb_receive_fwload(struct urb *urb)
 	}
 
 	memcpy(syncfwheader, skb->data + IPFIELD_ALIGN_OFFSET,
-			sizeof(struct fwsyncheader));
+	       sizeof(struct fwsyncheader));
 
 	if (!syncfwheader->cmd) {
-		/*
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "FW received Blk with correct CRC\n");
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "FW received Blk seqnum = %d\n",
-		       syncfwheader->seqnum);
-		*/
+		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
+		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk seqnum = %d\n",
+			     le32_to_cpu(syncfwheader->seqnum));
 		cardp->CRC_OK = 1;
 	} else {
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "FW received Blk with CRC error\n");
+		lbs_deb_usbd(&cardp->udev->dev, "FW received Blk with CRC error\n");
 		cardp->CRC_OK = 0;
 	}
 
@@ -604,13 +549,12 @@ static void if_usb_receive_fwload(struct urb *urb)
 #define MRVDRV_MIN_PKT_LEN	30
 
 static inline void process_cmdtypedata(int recvlength, struct sk_buff *skb,
-				       struct usb_card_rec *cardp,
+				       struct if_usb_card *cardp,
 				       struct lbs_private *priv)
 {
-	if (recvlength > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE +
-	    MESSAGE_HEADER_LEN || recvlength < MRVDRV_MIN_PKT_LEN) {
-		lbs_deb_usbd(&cardp->udev->dev,
-			    "Packet length is Invalid\n");
+	if (recvlength > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + MESSAGE_HEADER_LEN
+	    || recvlength < MRVDRV_MIN_PKT_LEN) {
+		lbs_deb_usbd(&cardp->udev->dev, "Packet length is Invalid\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -618,19 +562,21 @@ static inline void process_cmdtypedata(int recvlength, struct sk_buff *skb,
 	skb_reserve(skb, IPFIELD_ALIGN_OFFSET);
 	skb_put(skb, recvlength);
 	skb_pull(skb, MESSAGE_HEADER_LEN);
+
 	lbs_process_rxed_packet(priv, skb);
 	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
 }
 
-static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
+static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 				      struct sk_buff *skb,
-				      struct usb_card_rec *cardp,
+				      struct if_usb_card *cardp,
 				      struct lbs_private *priv)
 {
-	u8 *cmdbuf;
+	uint8_t *cmdbuf;
+
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_usbd(&cardp->udev->dev,
-			    "The receive buffer is too large\n");
+			     "The receive buffer is too large\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -642,16 +588,16 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 	/* take care of cur_cmd = NULL case by reading the
 	 * data to clear the interrupt */
 	if (!priv->cur_cmd) {
-		lbs_deb_hex(LBS_DEB_HOST, "Unsolicited CMD_RESP", (void *) recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
+		lbs_deb_hex(LBS_DEB_HOST, "Unsolicited CMD_RESP",
+			    (void *) recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
 		cmdbuf = priv->upld_buf;
 		priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
 	} else
-		cmdbuf = (u8 *) priv->cur_cmd->cmdbuf;
+		cmdbuf = (uint8_t *) priv->cur_cmd->cmdbuf;
 
 	cardp->usb_int_cause |= MRVDRV_CMD_UPLD_RDY;
 	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
-	memcpy(cmdbuf, recvbuff + MESSAGE_HEADER_LEN,
-	       priv->upld_len);
+	memcpy(cmdbuf, recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
 
 	kfree_skb(skb);
 	lbs_interrupt(priv);
@@ -659,8 +605,6 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 
 	lbs_deb_usbd(&cardp->udev->dev,
 		    "Wake up main thread to handle cmd response\n");
-
-	return;
 }
 
 /**
@@ -672,30 +616,26 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
  */
 static void if_usb_receive(struct urb *urb)
 {
-	struct read_cb_info *rinfo = (struct read_cb_info *)urb->context;
-	struct sk_buff *skb = rinfo->skb;
-	struct usb_card_rec *cardp = (struct usb_card_rec *) rinfo->cardp;
+	struct if_usb_card *cardp = urb->context;
+	struct sk_buff *skb = cardp->rx_skb;
 	struct lbs_private *priv = cardp->priv;
-
 	int recvlength = urb->actual_length;
-	u8 *recvbuff = NULL;
-	u32 recvtype = 0;
+	uint8_t *recvbuff = NULL;
+	uint32_t recvtype = 0;
+	__le32 *pkt = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
 
 	lbs_deb_enter(LBS_DEB_USB);
 
 	if (recvlength) {
-		__le32 tmp;
-
 		if (urb->status) {
-			lbs_deb_usbd(&cardp->udev->dev,
-				    "URB status is failed\n");
+			lbs_deb_usbd(&cardp->udev->dev, "RX URB failed: %d\n",
+				     urb->status);
 			kfree_skb(skb);
 			goto setup_for_next;
 		}
 
 		recvbuff = skb->data + IPFIELD_ALIGN_OFFSET;
-		memcpy(&tmp, recvbuff, sizeof(u32));
-		recvtype = le32_to_cpu(tmp);
+		recvtype = le32_to_cpu(pkt[0]);
 		lbs_deb_usbd(&cardp->udev->dev,
 			    "Recv length = 0x%x, Recv type = 0x%X\n",
 			    recvlength, recvtype);
@@ -716,9 +656,13 @@ static void if_usb_receive(struct urb *urb)
 	case CMD_TYPE_INDICATION:
 		/* Event cause handling */
 		spin_lock(&priv->driver_lock);
-		cardp->usb_event_cause = le32_to_cpu(*(__le32 *) (recvbuff + MESSAGE_HEADER_LEN));
+
+		cardp->usb_event_cause = le32_to_cpu(pkt[1]);
+
 		lbs_deb_usbd(&cardp->udev->dev,"**EVENT** 0x%X\n",
-			    cardp->usb_event_cause);
+			     cardp->usb_event_cause);
+
+		/* Icky undocumented magic special case */
 		if (cardp->usb_event_cause & 0xffff0000) {
 			lbs_send_tx_feedback(priv);
 			spin_unlock(&priv->driver_lock);
@@ -732,7 +676,7 @@ static void if_usb_receive(struct urb *urb)
 		goto rx_exit;
 	default:
 		lbs_deb_usbd(&cardp->udev->dev, "Unknown command type 0x%X\n",
-		             recvtype);
+			     recvtype);
 		kfree_skb(skb);
 		break;
 	}
@@ -751,55 +695,48 @@ rx_exit:
  *  @param len		number of bytes
  *  @return 	   	0 or -1
  */
-static int if_usb_host_to_card(struct lbs_private *priv,
-	u8 type,
-	u8 *payload,
-	u16 nb)
+static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
+			       uint8_t *payload, uint16_t nb)
 {
-	struct usb_card_rec *cardp = (struct usb_card_rec *)priv->card;
+	struct if_usb_card *cardp = priv->card;
 
 	lbs_deb_usbd(&cardp->udev->dev,"*** type = %u\n", type);
 	lbs_deb_usbd(&cardp->udev->dev,"size after = %d\n", nb);
 
 	if (type == MVMS_CMD) {
-		__le32 tmp = cpu_to_le32(CMD_TYPE_REQUEST);
+		*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
 		priv->dnld_sent = DNLD_CMD_SENT;
-		memcpy(cardp->bulk_out_buffer, (u8 *) & tmp,
-		       MESSAGE_HEADER_LEN);
-
 	} else {
-		__le32 tmp = cpu_to_le32(CMD_TYPE_DATA);
+		*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_DATA);
 		priv->dnld_sent = DNLD_DATA_SENT;
-		memcpy(cardp->bulk_out_buffer, (u8 *) & tmp,
-		       MESSAGE_HEADER_LEN);
 	}
 
-	memcpy((cardp->bulk_out_buffer + MESSAGE_HEADER_LEN), payload, nb);
+	memcpy((cardp->ep_out_buf + MESSAGE_HEADER_LEN), payload, nb);
 
-	return usb_tx_block(cardp, cardp->bulk_out_buffer,
-	                    nb + MESSAGE_HEADER_LEN);
+	return usb_tx_block(cardp, cardp->ep_out_buf, nb + MESSAGE_HEADER_LEN);
 }
 
 /* called with priv->driver_lock held */
-static int if_usb_get_int_status(struct lbs_private *priv, u8 *ireg)
+static int if_usb_get_int_status(struct lbs_private *priv, uint8_t *ireg)
 {
-	struct usb_card_rec *cardp = priv->card;
+	struct if_usb_card *cardp = priv->card;
 
 	*ireg = cardp->usb_int_cause;
 	cardp->usb_int_cause = 0;
 
-	lbs_deb_usbd(&cardp->udev->dev,"Int cause is 0x%X\n", *ireg);
+	lbs_deb_usbd(&cardp->udev->dev, "Int cause is 0x%X\n", *ireg);
 
 	return 0;
 }
 
 static int if_usb_read_event_cause(struct lbs_private *priv)
 {
-	struct usb_card_rec *cardp = priv->card;
+	struct if_usb_card *cardp = priv->card;
 
 	priv->eventcause = cardp->usb_event_cause;
 	/* Re-submit rx urb here to avoid event lost issue */
 	if_usb_submit_rx_urb(cardp);
+
 	return 0;
 }
 
@@ -809,20 +746,17 @@ static int if_usb_read_event_cause(struct lbs_private *priv)
  *                  2:Boot from FW in EEPROM
  *  @return 	   	0
  */
-static int if_usb_issue_boot_command(struct usb_card_rec *cardp, int ivalue)
+static int if_usb_issue_boot_command(struct if_usb_card *cardp, int ivalue)
 {
-	struct bootcmdstr sbootcmd;
-	int i;
+	struct bootcmd *bootcmd = cardp->ep_out_buf;
 
 	/* Prepare command */
-	sbootcmd.u32magicnumber = cpu_to_le32(BOOT_CMD_MAGIC_NUMBER);
-	sbootcmd.u8cmd_tag = ivalue;
-	for (i=0; i<11; i++)
-		sbootcmd.au8dumy[i]=0x00;
-	memcpy(cardp->bulk_out_buffer, &sbootcmd, sizeof(struct bootcmdstr));
+	bootcmd->magic = cpu_to_le32(BOOT_CMD_MAGIC_NUMBER);
+	bootcmd->cmd = ivalue;
+	memset(bootcmd->pad, 0, sizeof(bootcmd->pad));
 
 	/* Issue command */
-	usb_tx_block(cardp, cardp->bulk_out_buffer, sizeof(struct bootcmdstr));
+	usb_tx_block(cardp, cardp->ep_out_buf, sizeof(*bootcmd));
 
 	return 0;
 }
@@ -835,10 +769,10 @@ static int if_usb_issue_boot_command(struct usb_card_rec *cardp, int ivalue)
  *         len               image length
  *  @return     0 or -1
  */
-static int check_fwfile_format(u8 *data, u32 totlen)
+static int check_fwfile_format(uint8_t *data, uint32_t totlen)
 {
-	u32 bincmd, exit;
-	u32 blksize, offset, len;
+	uint32_t bincmd, exit;
+	uint32_t blksize, offset, len;
 	int ret;
 
 	ret = 1;
@@ -876,7 +810,7 @@ static int check_fwfile_format(u8 *data, u32 totlen)
 }
 
 
-static int if_usb_prog_firmware(struct usb_card_rec *cardp)
+static int if_usb_prog_firmware(struct if_usb_card *cardp)
 {
 	int i = 0;
 	static int reset_count = 10;
@@ -953,11 +887,11 @@ restart:
 		goto release_fw;
 	}
 
-release_fw:
+ release_fw:
 	release_firmware(cardp->fw);
 	cardp->fw = NULL;
 
-done:
+ done:
 	lbs_deb_leave_args(LBS_DEB_USB, "ret %d", ret);
 	return ret;
 }
@@ -966,7 +900,7 @@ done:
 #ifdef CONFIG_PM
 static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	struct usb_card_rec *cardp = usb_get_intfdata(intf);
+	struct if_usb_card *cardp = usb_get_intfdata(intf);
 	struct lbs_private *priv = cardp->priv;
 	int ret;
 
@@ -990,7 +924,7 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 
 static int if_usb_resume(struct usb_interface *intf)
 {
-	struct usb_card_rec *cardp = usb_get_intfdata(intf);
+	struct if_usb_card *cardp = usb_get_intfdata(intf);
 	struct lbs_private *priv = cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_USB);
@@ -1041,5 +975,5 @@ module_init(if_usb_init_module);
 module_exit(if_usb_exit_module);
 
 MODULE_DESCRIPTION("8388 USB WLAN Driver");
-MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_AUTHOR("Marvell International Ltd. and Red Hat, Inc.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 668410f..7706691 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -9,72 +9,67 @@ struct lbs_private;
 /**
   * This file contains definition for USB interface.
   */
-#define CMD_TYPE_REQUEST                0xF00DFACE
-#define CMD_TYPE_DATA                   0xBEADC0DE
-#define CMD_TYPE_INDICATION             0xBEEFFACE
+#define CMD_TYPE_REQUEST		0xF00DFACE
+#define CMD_TYPE_DATA			0xBEADC0DE
+#define CMD_TYPE_INDICATION		0xBEEFFACE
 
-#define IPFIELD_ALIGN_OFFSET	2
+#define IPFIELD_ALIGN_OFFSET		2
 
-#define BOOT_CMD_FW_BY_USB     0x01
-#define BOOT_CMD_FW_IN_EEPROM  0x02
-#define BOOT_CMD_UPDATE_BOOT2  0x03
-#define BOOT_CMD_UPDATE_FW     0x04
-#define BOOT_CMD_MAGIC_NUMBER  0x4C56524D   /* M=>0x4D,R=>0x52,V=>0x56,L=>0x4C */
+#define BOOT_CMD_FW_BY_USB		0x01
+#define BOOT_CMD_FW_IN_EEPROM		0x02
+#define BOOT_CMD_UPDATE_BOOT2		0x03
+#define BOOT_CMD_UPDATE_FW		0x04
+#define BOOT_CMD_MAGIC_NUMBER		0x4C56524D   /* LVRM */
 
-struct bootcmdstr
+struct bootcmd
 {
-	__le32 u32magicnumber;
-	u8  u8cmd_tag;
-	u8  au8dumy[11];
+	__le32	magic;
+	uint8_t	cmd;
+	uint8_t	pad[11];
 };
 
-#define BOOT_CMD_RESP_OK     0x0001
-#define BOOT_CMD_RESP_FAIL   0x0000
+#define BOOT_CMD_RESP_OK		0x0001
+#define BOOT_CMD_RESP_FAIL		0x0000
 
-struct bootcmdrespStr
+struct bootcmdresp
 {
-	__le32 u32magicnumber;
-	u8  u8cmd_tag;
-	u8  u8result;
-	u8  au8dumy[2];
-};
-
-/* read callback private data */
-struct read_cb_info {
-        struct usb_card_rec *cardp;
-        struct sk_buff *skb;
+	__le32	magic;
+	uint8_t	cmd;
+	uint8_t	result;
+	uint8_t	pad[2];
 };
 
 /** USB card description structure*/
-struct usb_card_rec {
+struct if_usb_card {
 	struct usb_device *udev;
 	struct urb *rx_urb, *tx_urb;
 	struct lbs_private *priv;
-	struct read_cb_info rinfo;
 
-	int bulk_in_size;
-	u8 bulk_in_endpointAddr;
+	struct sk_buff *rx_skb;
+	uint32_t usb_event_cause;
+	uint8_t usb_int_cause;
+
+	uint8_t ep_in;
+	uint8_t ep_out;
 
-	u8 *bulk_out_buffer;
-	int bulk_out_size;
-	u8 bulk_out_endpointAddr;
+	int8_t bootcmdresp;
+
+	int ep_in_size;
+
+	void *ep_out_buf;
+	int ep_out_size;
 
 	const struct firmware *fw;
 	struct timer_list fw_timeout;
 	wait_queue_head_t fw_wq;
-	u8 CRC_OK;
-	u32 fwseqnum;
-	u32 lastseqnum;
-	u32 totalbytes;
-	u32 fwlastblksent;
-	u8 fwdnldover;
-	u8 fwfinalblk;
-	u8 surprise_removed;
-
-	u32 usb_event_cause;
-	u8 usb_int_cause;
-
-	s8 bootcmdresp;
+	uint32_t fwseqnum;
+	uint32_t totalbytes;
+	uint32_t fwlastblksent;
+	uint8_t CRC_OK;
+	uint8_t fwdnldover;
+	uint8_t fwfinalblk;
+	uint8_t surprise_removed;
+
 };
 
 /** fwheader */
@@ -87,10 +82,10 @@ struct fwheader {
 
 #define FW_MAX_DATA_BLK_SIZE	600
 /** FWData */
-struct FWData {
-	struct fwheader fwheader;
+struct fwdata {
+	struct fwheader hdr;
 	__le32 seqnum;
-	u8 data[FW_MAX_DATA_BLK_SIZE];
+	uint8_t data[0];
 };
 
 /** fwsyncheader */
@@ -102,7 +97,5 @@ struct fwsyncheader {
 #define FW_HAS_DATA_TO_RECV		0x00000001
 #define FW_HAS_LAST_BLOCK		0x00000004
 
-#define FW_DATA_XMIT_SIZE \
-	sizeof(struct fwheader) + le32_to_cpu(fwdata->fwheader.datalength) + sizeof(u32)
 
 #endif
-- 
1.5.3.4

