Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35147 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdLAHth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 02:49:37 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v3 2/8] rsi: add bluetooth rx endpoint
Date: Fri,  1 Dec 2017 13:11:19 +0530
Message-Id: <1512114085-2615-3-git-send-email-amitkarwar@gmail.com> (sfid-20171201_084951_880483_D9F984B0)
In-Reply-To: <1512114085-2615-1-git-send-email-amitkarwar@gmail.com>
References: <1512114085-2615-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

USB endpoint 1 is used for WLAN which is presently in use.
USB endpoint 2 is introduced for BT Rx traffic. Enumeration
of Rx BT endpoint and submitting Rx BT URB are added.

>From /sys/kernel/debug/usb/devices,
Ad=81(I) is for WLAN EP IN and Ad=01(O) is for Wlan EP OUT.
Ad=82(I) is for BT EP IN and Ad=02(O) is for BT EP OUT.

T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=03 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1618 ProdID=9113 Rev= 0.02
S:  Manufacturer=Redpine Signals, Inc.
S:  Product=Wireless USB Network Module
S:  SerialNumber=000000000001
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 6 Cls=00(>ifc ) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v3: Same as v2
v2: Included '/sys/kernel/debug/usb/devices' info in patch description(Marcel)
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 37 ++++++++++++++++++++--------------
 drivers/net/wireless/rsi/rsi_usb.h     |  6 +++---
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 147fcee2..b212a15 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -103,41 +103,42 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
 	__le16 buffer_size;
-	int ii, bep_found = 0;
+	int ii, bin_found = 0, bout_found = 0;
 
 	iface_desc = &(interface->altsetting[0]);
 
 	for (ii = 0; ii < iface_desc->desc.bNumEndpoints; ++ii) {
 		endpoint = &(iface_desc->endpoint[ii].desc);
 
-		if ((!(dev->bulkin_endpoint_addr)) &&
+		if (!dev->bulkin_endpoint_addr[bin_found] &&
 		    (endpoint->bEndpointAddress & USB_DIR_IN) &&
-		    ((endpoint->bmAttributes &
-		    USB_ENDPOINT_XFERTYPE_MASK) ==
+		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 		    USB_ENDPOINT_XFER_BULK)) {
 			buffer_size = endpoint->wMaxPacketSize;
-			dev->bulkin_size = buffer_size;
-			dev->bulkin_endpoint_addr =
+			dev->bulkin_size[bin_found] = buffer_size;
+			dev->bulkin_endpoint_addr[bin_found] =
 				endpoint->bEndpointAddress;
+			bin_found++;
 		}
 
-		if (!dev->bulkout_endpoint_addr[bep_found] &&
+		if (!dev->bulkout_endpoint_addr[bout_found] &&
 		    !(endpoint->bEndpointAddress & USB_DIR_IN) &&
 		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-		      USB_ENDPOINT_XFER_BULK)) {
-			dev->bulkout_endpoint_addr[bep_found] =
+		    USB_ENDPOINT_XFER_BULK)) {
+			buffer_size = endpoint->wMaxPacketSize;
+			dev->bulkout_endpoint_addr[bout_found] =
 				endpoint->bEndpointAddress;
 			buffer_size = endpoint->wMaxPacketSize;
-			dev->bulkout_size[bep_found] = buffer_size;
-			bep_found++;
+			dev->bulkout_size[bout_found] = buffer_size;
+			bout_found++;
 		}
 
-		if (bep_found >= MAX_BULK_EP)
+		if (bin_found >= MAX_BULK_EP || bout_found >= MAX_BULK_EP)
 			break;
 	}
 
-	if (!(dev->bulkin_endpoint_addr) &&
-	    (dev->bulkout_endpoint_addr[0]))
+	if (!(dev->bulkin_endpoint_addr[0]) &&
+	    dev->bulkout_endpoint_addr[0])
 		return -EINVAL;
 
 	return 0;
@@ -273,7 +274,7 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num)
 	usb_fill_bulk_urb(urb,
 			  dev->usbdev,
 			  usb_rcvbulkpipe(dev->usbdev,
-				dev->bulkin_endpoint_addr),
+			  dev->bulkin_endpoint_addr[ep_num - 1]),
 			  urb->transfer_buffer,
 			  3000,
 			  rsi_rx_done_handler,
@@ -745,6 +746,12 @@ static int rsi_probe(struct usb_interface *pfunction,
 	if (status)
 		goto err1;
 
+	if (adapter->priv->coex_mode > 1) {
+		status = rsi_rx_urb_submit(adapter, BT_EP);
+		if (status)
+			goto err1;
+	}
+
 	return 0;
 err1:
 	rsi_deinit_usb_interface(adapter);
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 7e781d5..0fda14c 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -31,7 +31,7 @@
 #define USB_VENDOR_REGISTER_WRITE    0x16
 #define RSI_USB_TX_HEAD_ROOM         128
 
-#define MAX_RX_URBS                  1
+#define MAX_RX_URBS                  2
 #define MAX_BULK_EP                  8
 #define WLAN_EP                      1
 #define BT_EP                        2
@@ -54,8 +54,8 @@ struct rsi_91x_usbdev {
 	struct usb_interface *pfunction;
 	struct rx_usb_ctrl_block rx_cb[MAX_RX_URBS];
 	u8 *tx_buffer;
-	__le16 bulkin_size;
-	u8 bulkin_endpoint_addr;
+	__le16 bulkin_size[MAX_BULK_EP];
+	u8 bulkin_endpoint_addr[MAX_BULK_EP];
 	__le16 bulkout_size[MAX_BULK_EP];
 	u8 bulkout_endpoint_addr[MAX_BULK_EP];
 	u32 tx_blk_size;
-- 
2.7.4
