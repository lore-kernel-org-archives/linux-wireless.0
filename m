Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iron100.routit.net ([89.146.30.22]:46505 "EHLO
	iron100.routit.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaHGKDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 06:03:55 -0400
From: Ronald Wahl <ronald.wahl@raritan.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Ronald Wahl <ronald.wahl@raritan.com>
Subject: [PATCH v2] carl9170: fix sending URBs with wrong type when using full-speed
Date: Thu,  7 Aug 2014 12:03:19 +0200
Message-Id: <1407405799-5746-1-git-send-email-ronald.wahl@raritan.com> (sfid-20140807_120401_152994_0BBFACD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver assumes that endpoint 4 is always an interrupt endpoint.
Unfortunately the type differs between high-speed and full-speed
configurations while in the former case it is indeed an interrupt
endpoint this is not true for the latter case - here it is a bulk
endpoint. When sending URBs with the wrong type the kernel will
generate a warning message including backtrace.

To fix this we are now sending URBs to endpoint 4 using the type
found in the endpoint descriptor.

A side note: The carl9170 firmware currently specifies endpoint 4 as
interrupt endpoint even in the full-speed configuration but this has
no relevance because before this firmware is loaded the endpoint type
is as described above and after the firmware is running the stick is not
reenumerated and so the old descriptor is used.
---
 drivers/net/wireless/ath/carl9170/carl9170.h |  1 +
 drivers/net/wireless/ath/carl9170/usb.c      | 29 ++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 8596aba..237d0cd 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -256,6 +256,7 @@ struct ar9170 {
 	atomic_t rx_work_urbs;
 	atomic_t rx_pool_urbs;
 	kernel_ulong_t features;
+	bool usb_ep_cmd_is_bulk;
 
 	/* firmware settings */
 	struct completion fw_load_wait;
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index f35c7f3..e344d84 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -621,9 +621,14 @@ int __carl9170_exec_cmd(struct ar9170 *ar, struct carl9170_cmd *cmd,
 		goto err_free;
 	}
 
-	usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
-		AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
-		carl9170_usb_cmd_complete, ar, 1);
+	if (ar->usb_ep_cmd_is_bulk)
+		usb_fill_bulk_urb(urb, ar->udev, usb_sndbulkpipe(ar->udev,
+			AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
+			carl9170_usb_cmd_complete, ar);
+	else
+		usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
+			AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
+			carl9170_usb_cmd_complete, ar, 1);
 
 	if (free_buf)
 		urb->transfer_flags |= URB_FREE_BUFFER;
@@ -1032,9 +1037,10 @@ static void carl9170_usb_firmware_step2(const struct firmware *fw,
 static int carl9170_usb_probe(struct usb_interface *intf,
 			      const struct usb_device_id *id)
 {
+	struct usb_endpoint_descriptor *ep;
 	struct ar9170 *ar;
 	struct usb_device *udev;
-	int err;
+	int i, err;
 
 	err = usb_reset_device(interface_to_usbdev(intf));
 	if (err)
@@ -1050,6 +1056,21 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 	ar->intf = intf;
 	ar->features = id->driver_info;
 
+	/* We need to remember the type of endpoint 4 because it differs
+	 * between high- and full-speed configuration. The high-speed
+	 * configuration specifies it as interrupt and the full-speed
+	 * configuration as bulk endpoint. This information is required
+	 * later when sending urbs to that endpoint.
+	 */
+	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
+		ep = &intf->cur_altsetting->endpoint[i].desc;
+
+		if (usb_endpoint_dir_out(ep) &&
+		    usb_endpoint_num(ep) == AR9170_USB_EP_CMD)
+			ar->usb_ep_cmd_is_bulk =
+				usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK;
+	}
+
 	usb_set_intfdata(intf, ar);
 	SET_IEEE80211_DEV(ar->hw, &intf->dev);
 
-- 
1.9.3

