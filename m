Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:57667 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751068AbbDGHRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 03:17:04 -0400
Message-ID: <1428391020.20888.31.camel@perches.com> (sfid-20150407_091712_580410_8C77203A)
Subject: [resend PATCH] nfc: logging neatening
From: Joe Perches <joe@perches.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 07 Apr 2015 00:17:00 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing terminating newlines to nfc_info and nfc_err
to avoid possible interleaving from other messages.

Miscellanea:

o typo fix of "unknonwn" in message
o remove unnecessary OOM messages as there's a generic dump_stack()
o realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---

Adding Andrew Morton
Resending after a 8 weeks with no reply/review.

 drivers/nfc/microread/i2c.c |  2 +-
 drivers/nfc/nfcmrvl/main.c  |  4 ++--
 drivers/nfc/nfcmrvl/usb.c   | 18 +++++++++---------
 drivers/nfc/pn533.c         |  2 +-
 drivers/nfc/pn544/i2c.c     |  7 ++-----
 drivers/nfc/port100.c       | 36 ++++++++++++++++++------------------
 drivers/nfc/st21nfcb/i2c.c  |  5 +----
 drivers/nfc/st21nfcb/ndlc.c |  5 ++---
 8 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index df85cd3..661e2c8 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -286,7 +286,7 @@ static int microread_i2c_probe(struct i2c_client *client,
 	if (r < 0)
 		goto err_irq;
 
-	nfc_info(&client->dev, "Probed");
+	nfc_info(&client->dev, "Probed\n");
 
 	return 0;
 
diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 85e8bcf..ad4933c 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -111,7 +111,7 @@ struct nfcmrvl_private *nfcmrvl_nci_register_dev(void *drv_data,
 
 	priv->ndev = nci_allocate_device(&nfcmrvl_nci_ops, protocols, 0, 0);
 	if (!priv->ndev) {
-		nfc_err(dev, "nci_allocate_device failed");
+		nfc_err(dev, "nci_allocate_device failed\n");
 		rc = -ENOMEM;
 		goto error;
 	}
@@ -120,7 +120,7 @@ struct nfcmrvl_private *nfcmrvl_nci_register_dev(void *drv_data,
 
 	rc = nci_register_device(priv->ndev);
 	if (rc) {
-		nfc_err(dev, "nci_register_device failed %d", rc);
+		nfc_err(dev, "nci_register_device failed %d\n", rc);
 		nci_free_device(priv->ndev);
 		goto error;
 	}
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 3221ca3..6cf15c1 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -80,7 +80,7 @@ static void nfcmrvl_bulk_complete(struct urb *urb)
 	if (!urb->status) {
 		if (nfcmrvl_nci_recv_frame(drv_data->priv, urb->transfer_buffer,
 					   urb->actual_length) < 0)
-			nfc_err(&drv_data->udev->dev, "corrupted Rx packet");
+			nfc_err(&drv_data->udev->dev, "corrupted Rx packet\n");
 	}
 
 	if (!test_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->flags))
@@ -96,7 +96,7 @@ static void nfcmrvl_bulk_complete(struct urb *urb)
 		 */
 		if (err != -EPERM && err != -ENODEV)
 			nfc_err(&drv_data->udev->dev,
-				"urb %p failed to resubmit (%d)", urb, -err);
+				"urb %p failed to resubmit (%d)\n", urb, -err);
 		usb_unanchor_urb(urb);
 	}
 }
@@ -137,7 +137,7 @@ nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *drv_data, gfp_t mem_flags)
 	if (err) {
 		if (err != -EPERM && err != -ENODEV)
 			nfc_err(&drv_data->udev->dev,
-				"urb %p submission failed (%d)", urb, -err);
+				"urb %p submission failed (%d)\n", urb, -err);
 		usb_unanchor_urb(urb);
 	}
 
@@ -153,7 +153,7 @@ static void nfcmrvl_tx_complete(struct urb *urb)
 	struct nfcmrvl_private *priv = nci_get_drvdata(ndev);
 	struct nfcmrvl_usb_drv_data *drv_data = priv->drv_data;
 
-	nfc_info(priv->dev, "urb %p status %d count %d",
+	nfc_info(priv->dev, "urb %p status %d count %d\n",
 		 urb, urb->status, urb->actual_length);
 
 	spin_lock(&drv_data->txlock);
@@ -253,7 +253,7 @@ static int nfcmrvl_usb_nci_send(struct nfcmrvl_private *priv,
 	if (err) {
 		if (err != -EPERM && err != -ENODEV)
 			nfc_err(&drv_data->udev->dev,
-				"urb %p submission failed (%d)", urb, -err);
+				"urb %p submission failed (%d)\n", urb, -err);
 		kfree(urb->setup_packet);
 		usb_unanchor_urb(urb);
 	} else {
@@ -293,7 +293,7 @@ static int nfcmrvl_probe(struct usb_interface *intf,
 	int i;
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	nfc_info(&udev->dev, "intf %p id %p", intf, id);
+	nfc_info(&udev->dev, "intf %p id %p\n", intf, id);
 
 	drv_data = devm_kzalloc(&intf->dev, sizeof(*drv_data), GFP_KERNEL);
 	if (!drv_data)
@@ -348,7 +348,7 @@ static void nfcmrvl_disconnect(struct usb_interface *intf)
 	if (!drv_data)
 		return;
 
-	nfc_info(&drv_data->udev->dev, "intf %p", intf);
+	nfc_info(&drv_data->udev->dev, "intf %p\n", intf);
 
 	nfcmrvl_nci_unregister_dev(drv_data->priv);
 
@@ -360,7 +360,7 @@ static int nfcmrvl_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct nfcmrvl_usb_drv_data *drv_data = usb_get_intfdata(intf);
 
-	nfc_info(&drv_data->udev->dev, "intf %p", intf);
+	nfc_info(&drv_data->udev->dev, "intf %p\n", intf);
 
 	if (drv_data->suspend_count++)
 		return 0;
@@ -401,7 +401,7 @@ static int nfcmrvl_resume(struct usb_interface *intf)
 	struct nfcmrvl_usb_drv_data *drv_data = usb_get_intfdata(intf);
 	int err = 0;
 
-	nfc_info(&drv_data->udev->dev, "intf %p", intf);
+	nfc_info(&drv_data->udev->dev, "intf %p\n", intf);
 
 	if (--drv_data->suspend_count)
 		return 0;
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index d46a700a..35ffbf9 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1820,7 +1820,7 @@ static int pn533_rf_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp)) {
 		rc = PTR_ERR(resp);
 
-		nfc_err(&dev->interface->dev, "RF setting error %d", rc);
+		nfc_err(&dev->interface->dev, "RF setting error %d\n", rc);
 
 		return rc;
 	}
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index cdde745..6fd986f 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -953,7 +953,7 @@ static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 	}
 
 	nfc_info(dev, "GPIO resource, no:%d irq:%d\n",
-			desc_to_gpio(gpiod_irq), ret);
+		 desc_to_gpio(gpiod_irq), ret);
 	client->irq = ret;
 
 	return 0;
@@ -1062,11 +1062,8 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct pn544_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		nfc_err(&client->dev,
-			"Cannot allocate memory for pn544 i2c phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	INIT_WORK(&phy->fw_work, pn544_hci_i2c_fw_work);
 	phy->fw_work_state = FW_WORK_STATE_IDLE;
diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 4ac4d31..87d5099 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -604,11 +604,11 @@ static void port100_recv_response(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 		nfc_err(&dev->interface->dev,
-			"The urb has been canceled (status %d)", urb->status);
+			"The urb has been canceled (status %d)\n", urb->status);
 		goto sched_wq;
 	case -ESHUTDOWN:
 	default:
-		nfc_err(&dev->interface->dev, "Urb failure (status %d)",
+		nfc_err(&dev->interface->dev, "Urb failure (status %d)\n",
 			urb->status);
 		goto sched_wq;
 	}
@@ -616,7 +616,7 @@ static void port100_recv_response(struct urb *urb)
 	in_frame = dev->in_urb->transfer_buffer;
 
 	if (!port100_rx_frame_is_valid(in_frame)) {
-		nfc_err(&dev->interface->dev, "Received an invalid frame");
+		nfc_err(&dev->interface->dev, "Received an invalid frame\n");
 		cmd->status = -EIO;
 		goto sched_wq;
 	}
@@ -626,7 +626,7 @@ static void port100_recv_response(struct urb *urb)
 
 	if (!port100_rx_frame_is_cmd_response(dev, in_frame)) {
 		nfc_err(&dev->interface->dev,
-			"It's not the response to the last command");
+			"It's not the response to the last command\n");
 		cmd->status = -EIO;
 		goto sched_wq;
 	}
@@ -657,11 +657,11 @@ static void port100_recv_ack(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 		nfc_err(&dev->interface->dev,
-			"The urb has been stopped (status %d)", urb->status);
+			"The urb has been stopped (status %d)\n", urb->status);
 		goto sched_wq;
 	case -ESHUTDOWN:
 	default:
-		nfc_err(&dev->interface->dev, "Urb failure (status %d)",
+		nfc_err(&dev->interface->dev, "Urb failure (status %d)\n",
 			urb->status);
 		goto sched_wq;
 	}
@@ -669,7 +669,7 @@ static void port100_recv_ack(struct urb *urb)
 	in_frame = dev->in_urb->transfer_buffer;
 
 	if (!port100_rx_frame_is_ack(in_frame)) {
-		nfc_err(&dev->interface->dev, "Received an invalid ack");
+		nfc_err(&dev->interface->dev, "Received an invalid ack\n");
 		cmd->status = -EIO;
 		goto sched_wq;
 	}
@@ -677,7 +677,7 @@ static void port100_recv_ack(struct urb *urb)
 	rc = port100_submit_urb_for_response(dev, GFP_ATOMIC);
 	if (rc) {
 		nfc_err(&dev->interface->dev,
-			"usb_submit_urb failed with result %d", rc);
+			"usb_submit_urb failed with result %d\n", rc);
 		cmd->status = rc;
 		goto sched_wq;
 	}
@@ -873,11 +873,11 @@ static void port100_send_complete(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 		nfc_err(&dev->interface->dev,
-			"The urb has been stopped (status %d)", urb->status);
+			"The urb has been stopped (status %d)\n", urb->status);
 		break;
 	case -ESHUTDOWN:
 	default:
-		nfc_err(&dev->interface->dev, "Urb failure (status %d)",
+		nfc_err(&dev->interface->dev, "Urb failure (status %d)\n",
 			urb->status);
 	}
 }
@@ -1094,7 +1094,7 @@ static void port100_in_comm_rf_complete(struct port100 *dev, void *arg,
 
 	if (resp->len < 4) {
 		nfc_err(&dev->interface->dev,
-			"Invalid packet length received.\n");
+			"Invalid packet length received\n");
 		rc = -EIO;
 		goto error;
 	}
@@ -1250,7 +1250,7 @@ static bool port100_tg_target_activated(struct port100 *dev, u8 tgt_activated)
 		       PORT100_MDAA_TGT_WAS_ACTIVATED_MASK;
 		break;
 	default:
-		nfc_err(&dev->interface->dev, "Unknonwn command type.\n");
+		nfc_err(&dev->interface->dev, "Unknown command type\n");
 		return false;
 	}
 
@@ -1481,7 +1481,7 @@ static int port100_probe(struct usb_interface *interface,
 	cmd_type_mask = port100_get_command_type_mask(dev);
 	if (!cmd_type_mask) {
 		nfc_err(&interface->dev,
-			"Could not get supported command types.\n");
+			"Could not get supported command types\n");
 		rc = -ENODEV;
 		goto error;
 	}
@@ -1494,7 +1494,7 @@ static int port100_probe(struct usb_interface *interface,
 	rc = port100_set_command_type(dev, dev->cmd_type);
 	if (rc) {
 		nfc_err(&interface->dev,
-			"The device does not support command type %u.\n",
+			"The device does not support command type %u\n",
 			dev->cmd_type);
 		goto error;
 	}
@@ -1502,7 +1502,7 @@ static int port100_probe(struct usb_interface *interface,
 	fw_version = port100_get_firmware_version(dev);
 	if (!fw_version)
 		nfc_err(&interface->dev,
-			"Could not get device firmware version.\n");
+			"Could not get device firmware version\n");
 
 	nfc_info(&interface->dev,
 		 "Sony NFC Port-100 Series attached (firmware v%x.%02x)\n",
@@ -1515,7 +1515,7 @@ static int port100_probe(struct usb_interface *interface,
 							   dev->skb_tailroom);
 	if (!dev->nfc_digital_dev) {
 		nfc_err(&interface->dev,
-			"Could not allocate nfc_digital_dev.\n");
+			"Could not allocate nfc_digital_dev\n");
 		rc = -ENOMEM;
 		goto error;
 	}
@@ -1526,7 +1526,7 @@ static int port100_probe(struct usb_interface *interface,
 	rc = nfc_digital_register_device(dev->nfc_digital_dev);
 	if (rc) {
 		nfc_err(&interface->dev,
-			"Could not register digital device.\n");
+			"Could not register digital device\n");
 		goto free_nfc_dev;
 	}
 
@@ -1562,7 +1562,7 @@ static void port100_disconnect(struct usb_interface *interface)
 
 	kfree(dev->cmd);
 
-	nfc_info(&interface->dev, "Sony Port-100 NFC device disconnected");
+	nfc_info(&interface->dev, "Sony Port-100 NFC device disconnected\n");
 }
 
 static struct usb_driver port100_driver = {
diff --git a/drivers/nfc/st21nfcb/i2c.c b/drivers/nfc/st21nfcb/i2c.c
index eb88693..43f3918 100644
--- a/drivers/nfc/st21nfcb/i2c.c
+++ b/drivers/nfc/st21nfcb/i2c.c
@@ -313,11 +313,8 @@ static int st21nfcb_nci_i2c_probe(struct i2c_client *client,
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct st21nfcb_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		nfc_err(&client->dev,
-			"Cannot allocate memory for st21nfcb i2c phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	phy->i2c_dev = client;
 
diff --git a/drivers/nfc/st21nfcb/ndlc.c b/drivers/nfc/st21nfcb/ndlc.c
index 5fbf59d..6014b58 100644
--- a/drivers/nfc/st21nfcb/ndlc.c
+++ b/drivers/nfc/st21nfcb/ndlc.c
@@ -256,10 +256,9 @@ int ndlc_probe(void *phy_id, struct nfc_phy_ops *phy_ops, struct device *dev,
 	struct llt_ndlc *ndlc;
 
 	ndlc = devm_kzalloc(dev, sizeof(struct llt_ndlc), GFP_KERNEL);
-	if (!ndlc) {
-		nfc_err(dev, "Cannot allocate memory for ndlc.\n");
+	if (!ndlc)
 		return -ENOMEM;
-	}
+
 	ndlc->ops = phy_ops;
 	ndlc->phy_id = phy_id;
 	ndlc->dev = dev;


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


