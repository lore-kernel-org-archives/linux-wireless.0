Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:52724 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZKDWNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:13:01 -0500
Received: by ewy28 with SMTP id 28so7673728ewy.18
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 14:13:05 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas if_usb: tiny usb-rx overhaul
Date: Wed, 4 Nov 2009 23:12:59 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org
References: <1256924714.4030.44.camel@macbook.infradead.org> <1257364903.14545.51.camel@localhost.localdomain> <20091104211600.GE10786@tuxdriver.com>
In-Reply-To: <20091104211600.GE10786@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911042313.00089.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reorganizes libertas' if_usb rx routines.

 - URB_ZERO_PACKET flag has no use for urbs for 
   incoming endpoints.
    
 - skb_tail_pointer(skb) should be used to get
   the right rx_buf pointer.

 - most + IPFIELD_ALIGN_OFFSET can be prevented by
   moving skb_reserve up right after allocation.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
any Tested-by: ?
---
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index a8262de..f220db9 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -506,17 +506,16 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 		goto rx_ret;
 	}
 
+	skb_reserve(skb, IPFIELD_ALIGN_OFFSET);
 	cardp->rx_skb = skb;
 
 	/* Fill the receive configuration URB and initialise the Rx call back */
 	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
 			  usb_rcvbulkpipe(cardp->udev, cardp->ep_in),
-			  skb->data + IPFIELD_ALIGN_OFFSET,
+			  skb_tail_pointer(skb),
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
 			  cardp);
 
-	cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;
-
 	lbs_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb);
 	if ((ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
 		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
@@ -557,7 +556,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 	}
 
 	if (cardp->fwdnldover) {
-		__le32 *tmp = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
+		__le32 *tmp = (__le32 *)skb->data;
 
 		if (tmp[0] == cpu_to_le32(CMD_TYPE_INDICATION) &&
 		    tmp[1] == cpu_to_le32(MACREG_INT_CODE_FIRMWARE_READY)) {
@@ -572,8 +571,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 		return;
 	}
 	if (cardp->bootcmdresp <= 0) {
-		memcpy (&bootcmdresp, skb->data + IPFIELD_ALIGN_OFFSET,
-			sizeof(bootcmdresp));
+		memcpy(&bootcmdresp, skb->data, sizeof(bootcmdresp));
 
 		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
 			kfree_skb(skb);
@@ -619,8 +617,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 		return;
 	}
 
-	memcpy(syncfwheader, skb->data + IPFIELD_ALIGN_OFFSET,
-	       sizeof(struct fwsyncheader));
+	memcpy(syncfwheader, skb->data, sizeof(struct fwsyncheader));
 
 	if (!syncfwheader->cmd) {
 		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
@@ -665,7 +662,6 @@ static inline void process_cmdtypedata(int recvlength, struct sk_buff *skb,
 		return;
 	}
 
-	skb_reserve(skb, IPFIELD_ALIGN_OFFSET);
 	skb_put(skb, recvlength);
 	skb_pull(skb, MESSAGE_HEADER_LEN);
 
@@ -719,7 +715,7 @@ static void if_usb_receive(struct urb *urb)
 	int recvlength = urb->actual_length;
 	uint8_t *recvbuff = NULL;
 	uint32_t recvtype = 0;
-	__le32 *pkt = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
+	__le32 *pkt = (__le32 *)skb->data;
 	uint32_t event;
 
 	lbs_deb_enter(LBS_DEB_USB);
@@ -732,7 +728,7 @@ static void if_usb_receive(struct urb *urb)
 			goto setup_for_next;
 		}
 
-		recvbuff = skb->data + IPFIELD_ALIGN_OFFSET;
+		recvbuff = skb->data;
 		recvtype = le32_to_cpu(pkt[0]);
 		lbs_deb_usbd(&cardp->udev->dev,
 			    "Recv length = 0x%x, Recv type = 0x%X\n",
