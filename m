Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:46499 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0GaOQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 10:16:22 -0400
From: Thomas Klute <thomas2.klute@uni-dortmund.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com,
	libertas-dev@lists.infradead.org,
	Thomas Klute <thomas2.klute@uni-dortmund.de>
Subject: [PATCH 2/2] libertas_tf: if_usb.c: Some more formatting fixes
Date: Sat, 31 Jul 2010 12:01:45 +0200
Message-Id: <1280570505-6791-2-git-send-email-thomas2.klute@uni-dortmund.de>
In-Reply-To: <1280570505-6791-1-git-send-email-thomas2.klute@uni-dortmund.de>
References: <1280570505-6791-1-git-send-email-thomas2.klute@uni-dortmund.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split some long lines to make checkpatch.pl happy. ;-)

Signed-off-by: Thomas Klute <thomas2.klute@uni-dortmund.de>
---
 drivers/net/wireless/libertas_tf/if_usb.c |   49 ++++++++++++++++++----------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index f93260b..1cf01ac 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -178,14 +178,17 @@ static int if_usb_probe(struct usb_interface *intf,
 				le16_to_cpu(endpoint->wMaxPacketSize);
 			cardp->ep_in = usb_endpoint_num(endpoint);
 
-			lbtf_deb_usbd(&udev->dev, "in_endpoint = %d\n", cardp->ep_in);
-			lbtf_deb_usbd(&udev->dev, "Bulk in size is %d\n", cardp->ep_in_size);
+			lbtf_deb_usbd(&udev->dev, "in_endpoint = %d\n",
+				cardp->ep_in);
+			lbtf_deb_usbd(&udev->dev, "Bulk in size is %d\n",
+				cardp->ep_in_size);
 		} else if (usb_endpoint_is_bulk_out(endpoint)) {
 			cardp->ep_out_size =
 				le16_to_cpu(endpoint->wMaxPacketSize);
 			cardp->ep_out = usb_endpoint_num(endpoint);
 
-			lbtf_deb_usbd(&udev->dev, "out_endpoint = %d\n", cardp->ep_out);
+			lbtf_deb_usbd(&udev->dev, "out_endpoint = %d\n",
+				cardp->ep_out);
 			lbtf_deb_usbd(&udev->dev, "Bulk out size is %d\n",
 				cardp->ep_out_size);
 		}
@@ -318,10 +321,12 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 
 	if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_DATA_TO_RECV)) {
 		lbtf_deb_usb2(&cardp->udev->dev, "There are data to follow\n");
-		lbtf_deb_usb2(&cardp->udev->dev, "seqnum = %d totalbytes = %d\n",
-			     cardp->fwseqnum, cardp->totalbytes);
+		lbtf_deb_usb2(&cardp->udev->dev,
+			"seqnum = %d totalbytes = %d\n",
+			cardp->fwseqnum, cardp->totalbytes);
 	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
-		lbtf_deb_usb2(&cardp->udev->dev, "Host has finished FW downloading\n");
+		lbtf_deb_usb2(&cardp->udev->dev,
+			"Host has finished FW downloading\n");
 		lbtf_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
 
 		/* Host has finished FW downloading
@@ -400,7 +405,8 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 	urb->transfer_flags |= URB_ZERO_PACKET;
 
 	if (usb_submit_urb(urb, GFP_ATOMIC)) {
-		lbtf_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
+		lbtf_deb_usbd(&cardp->udev->dev,
+			"usb_submit_urb failed: %d\n", ret);
 		goto tx_ret;
 	}
 
@@ -438,10 +444,12 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 
 	cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;
 
-	lbtf_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb);
+	lbtf_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n",
+		cardp->rx_urb);
 	ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC);
 	if (ret) {
-		lbtf_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
+		lbtf_deb_usbd(&cardp->udev->dev,
+			"Submit Rx URB failed: %d\n", ret);
 		kfree_skb(skb);
 		cardp->rx_skb = NULL;
 		lbtf_deb_leave(LBTF_DEB_USB);
@@ -522,14 +530,14 @@ static void if_usb_receive_fwload(struct urb *urb)
 			}
 		} else if (bcmdresp.cmd != BOOT_CMD_FW_BY_USB) {
 			pr_info("boot cmd response cmd_tag error (%d)\n",
-				    bcmdresp.cmd);
+				bcmdresp.cmd);
 		} else if (bcmdresp.result != BOOT_CMD_RESP_OK) {
 			pr_info("boot cmd response result error (%d)\n",
-				    bcmdresp.result);
+				bcmdresp.result);
 		} else {
 			cardp->bootcmdresp = 1;
 			lbtf_deb_usbd(&cardp->udev->dev,
-				     "Received valid boot command response\n");
+				"Received valid boot command response\n");
 		}
 
 		kfree_skb(skb);
@@ -541,19 +549,23 @@ static void if_usb_receive_fwload(struct urb *urb)
 	syncfwheader = kmemdup(skb->data, sizeof(struct fwsyncheader),
 			       GFP_ATOMIC);
 	if (!syncfwheader) {
-		lbtf_deb_usbd(&cardp->udev->dev, "Failure to allocate syncfwheader\n");
+		lbtf_deb_usbd(&cardp->udev->dev,
+			"Failure to allocate syncfwheader\n");
 		kfree_skb(skb);
 		lbtf_deb_leave(LBTF_DEB_USB);
 		return;
 	}
 
 	if (!syncfwheader->cmd) {
-		lbtf_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
-		lbtf_deb_usb2(&cardp->udev->dev, "FW received Blk seqnum = %d\n",
-			     le32_to_cpu(syncfwheader->seqnum));
+		lbtf_deb_usb2(&cardp->udev->dev,
+			"FW received Blk with correct CRC\n");
+		lbtf_deb_usb2(&cardp->udev->dev,
+			"FW received Blk seqnum = %d\n",
+			le32_to_cpu(syncfwheader->seqnum));
 		cardp->CRC_OK = 1;
 	} else {
-		lbtf_deb_usbd(&cardp->udev->dev, "FW received Blk with CRC error\n");
+		lbtf_deb_usbd(&cardp->udev->dev,
+			"FW received Blk with CRC error\n");
 		cardp->CRC_OK = 0;
 	}
 
@@ -666,7 +678,8 @@ static void if_usb_receive(struct urb *urb)
 	{
 		/* Event cause handling */
 		u32 event_cause = le32_to_cpu(pkt[1]);
-		lbtf_deb_usbd(&cardp->udev->dev, "**EVENT** 0x%X\n", event_cause);
+		lbtf_deb_usbd(&cardp->udev->dev, "**EVENT** 0x%X\n",
+			event_cause);
 
 		/* Icky undocumented magic special case */
 		if (event_cause & 0xffff0000) {
-- 
1.7.1

