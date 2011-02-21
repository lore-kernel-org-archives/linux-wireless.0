Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51037 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1BUCSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:18:07 -0500
Received: by yib18 with SMTP id 18so2360152yib.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:18:06 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52048.322098.184826@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:47:52 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 01/23] ath9k_htc: Handle storage devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Some AR7010 based devices are recognized as storage media.
Sending a CD-EJECT command to the device will 'convert' it into
a WLAN device. Do this within the driver itself, removing the
dependancy on an external program (usb_modeswitch).

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   74 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/reg.h     |    1 +
 2 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 5ab3084..fde5444 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -52,6 +52,9 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x083A, 0xA704),
 	  .driver_info = AR9280_USB },  /* SMC Networks */
 
+	{ USB_DEVICE(0x0cf3, 0x20ff),
+	  .driver_info = STORAGE_DEVICE },
+
 	{ },
 };
 
@@ -934,6 +937,61 @@ static void ath9k_hif_usb_dev_deinit(struct hif_device_usb *hif_dev)
 		release_firmware(hif_dev->firmware);
 }
 
+/*
+ * An exact copy of the function from zd1211rw.
+ */
+static int send_eject_command(struct usb_interface *interface)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_host_interface *iface_desc = &interface->altsetting[0];
+	struct usb_endpoint_descriptor *endpoint;
+	unsigned char *cmd;
+	u8 bulk_out_ep;
+	int r;
+
+	/* Find bulk out endpoint */
+	for (r = 1; r >= 0; r--) {
+		endpoint = &iface_desc->endpoint[r].desc;
+		if (usb_endpoint_dir_out(endpoint) &&
+		    usb_endpoint_xfer_bulk(endpoint)) {
+			bulk_out_ep = endpoint->bEndpointAddress;
+			break;
+		}
+	}
+	if (r == -1) {
+		dev_err(&udev->dev,
+			"ath9k_htc: Could not find bulk out endpoint\n");
+		return -ENODEV;
+	}
+
+	cmd = kzalloc(31, GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENODEV;
+
+	/* USB bulk command block */
+	cmd[0] = 0x55;	/* bulk command signature */
+	cmd[1] = 0x53;	/* bulk command signature */
+	cmd[2] = 0x42;	/* bulk command signature */
+	cmd[3] = 0x43;	/* bulk command signature */
+	cmd[14] = 6;	/* command length */
+
+	cmd[15] = 0x1b;	/* SCSI command: START STOP UNIT */
+	cmd[19] = 0x2;	/* eject disc */
+
+	dev_info(&udev->dev, "Ejecting storage device...\n");
+	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, bulk_out_ep),
+		cmd, 31, NULL, 2000);
+	kfree(cmd);
+	if (r)
+		return r;
+
+	/* At this point, the device disconnects and reconnects with the real
+	 * ID numbers. */
+
+	usb_set_intfdata(interface, NULL);
+	return 0;
+}
+
 static int ath9k_hif_usb_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
@@ -941,6 +999,9 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	struct hif_device_usb *hif_dev;
 	int ret = 0;
 
+	if (id->driver_info == STORAGE_DEVICE)
+		return send_eject_command(interface);
+
 	hif_dev = kzalloc(sizeof(struct hif_device_usb), GFP_KERNEL);
 	if (!hif_dev) {
 		ret = -ENOMEM;
@@ -1027,12 +1088,13 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 	struct hif_device_usb *hif_dev = usb_get_intfdata(interface);
 	bool unplugged = (udev->state == USB_STATE_NOTATTACHED) ? true : false;
 
-	if (hif_dev) {
-		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
-		ath9k_htc_hw_free(hif_dev->htc_handle);
-		ath9k_hif_usb_dev_deinit(hif_dev);
-		usb_set_intfdata(interface, NULL);
-	}
+	if (!hif_dev)
+		return;
+
+	ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
+	ath9k_htc_hw_free(hif_dev->htc_handle);
+	ath9k_hif_usb_dev_deinit(hif_dev);
+	usb_set_intfdata(interface, NULL);
 
 	if (!unplugged && (hif_dev->flags & HIF_USB_START))
 		ath9k_hif_usb_reboot(udev);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 64b226a..8fa8acf 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -878,6 +878,7 @@
 enum ath_usb_dev {
 	AR9280_USB = 1, /* AR7010 + AR9280, UB94 */
 	AR9287_USB = 2, /* AR7010 + AR9287, UB95 */
+	STORAGE_DEVICE = 3,
 };
 
 #define AR_DEVID_7010(_ah) \
-- 
1.7.4.1

