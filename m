Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57485 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab2CIE3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 23:29:08 -0500
Received: by iagz16 with SMTP id z16so1695187iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 20:29:07 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, chunkeey@web.de
Subject: [PATCH 3/5 V2] p54usb: Load firmware from work queue and not from probe routine
Date: Thu,  8 Mar 2012 22:28:57 -0600
Message-Id: <1331267337-19605-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120309_052912_681096_EB28DF68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that load firmware from their probe routine have problems with the
latest versions of udev as they get timeouts while waiting for user
space to start. The problem is fixed by loading the firmware and starting
mac80211 from a work queue. By using this method, most of the
original code is preserved.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - Convert from delayed to ordinary work queue

John,

Again material for 3.5

Larry
---

 drivers/net/wireless/p54/p54usb.c |  120 +++++++++++++++++-------------------
 drivers/net/wireless/p54/p54usb.h |    1 +
 2 files changed, 58 insertions(+), 63 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/p54/p54usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54usb.c
+++ wireless-testing-new/drivers/net/wireless/p54/p54usb.c
@@ -836,9 +836,33 @@ fail:
 	return err;
 }
 
-static int p54u_load_firmware(struct ieee80211_hw *dev)
+static int p54u_open(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
+	int err;
+
+	err = p54u_init_urbs(dev);
+	if (err)
+		return err;
+
+	priv->common.open = p54u_init_urbs;
+
+	return 0;
+}
+
+static void p54u_stop(struct ieee80211_hw *dev)
+{
+	/* TODO: figure out how to reliably stop the 3887 and net2280 so
+	   the hardware is still usable next time we want to start it.
+	   until then, we just stop listening to the hardware.. */
+	p54u_free_urbs(dev);
+}
+
+static void p54u_load_firmware(struct work_struct *work)
+{
+	struct p54u_priv *priv = container_of(work,
+				 struct p54u_priv, firmware_load);
+	struct ieee80211_hw *dev = usb_get_intfdata(priv->intf);
 	int err, i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
@@ -847,59 +871,53 @@ static int p54u_load_firmware(struct iee
 		if (p54u_fwlist[i].type == priv->hw_type)
 			break;
 
-	if (i == __NUM_P54U_HWTYPES)
-		return -EOPNOTSUPP;
+	if (i == __NUM_P54U_HWTYPES) {
+		dev_err(&priv->udev->dev, "Device not supported\n");
+		return;
+	}
 
 	err = request_firmware(&priv->fw, p54u_fwlist[i].fw, &priv->udev->dev);
 	if (err) {
-		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
-					  "(%d)!\n", p54u_fwlist[i].fw, err);
-
 		err = request_firmware(&priv->fw, p54u_fwlist[i].fw_legacy,
 				       &priv->udev->dev);
-		if (err)
-			return err;
+
+		if (err) {
+			dev_err(&priv->udev->dev,
+				"(p54usb) cannot load firmware %s or %s(%d)!\n",
+				p54u_fwlist[i].fw, p54u_fwlist[i].fw_legacy,
+				err);
+			return;
+		}
 	}
 
 	err = p54_parse_firmware(dev, priv->fw);
-	if (err)
-		goto out;
+	if (err) {
+		dev_err(&priv->udev->dev, "Error parsing firmware\n");
+		return;
+	}
 
 	if (priv->common.fw_interface != p54u_fwlist[i].intf) {
 		dev_err(&priv->udev->dev, "wrong firmware, please get "
 			"a firmware for \"%s\" and try again.\n",
 			p54u_fwlist[i].hw);
-		err = -EINVAL;
+		return;
 	}
-
-out:
-	if (err)
-		release_firmware(priv->fw);
-
-	return err;
-}
-
-static int p54u_open(struct ieee80211_hw *dev)
-{
-	struct p54u_priv *priv = dev->priv;
-	int err;
-
-	err = p54u_init_urbs(dev);
+	err = priv->upload_fw(dev);
 	if (err) {
-		return err;
+		dev_err(&priv->udev->dev, "Error uploading firmware\n");
+		return;
 	}
 
-	priv->common.open = p54u_init_urbs;
-
-	return 0;
-}
+	p54u_open(dev);
+	err = p54_read_eeprom(dev);
+	if (err)
+		dev_err(&priv->udev->dev, "Error reading eeprom\n");
+	p54u_stop(dev);
+	if (err)
+		return;
 
-static void p54u_stop(struct ieee80211_hw *dev)
-{
-	/* TODO: figure out how to reliably stop the 3887 and net2280 so
-	   the hardware is still usable next time we want to start it.
-	   until then, we just stop listening to the hardware.. */
-	p54u_free_urbs(dev);
+	/* firmware available - start operations */
+	err = p54_register_common(dev, &priv->udev->dev);
 }
 
 static int __devinit p54u_probe(struct usb_interface *intf,
@@ -969,34 +987,10 @@ static int __devinit p54u_probe(struct u
 		priv->common.tx = p54u_tx_net2280;
 		priv->upload_fw = p54u_upload_firmware_net2280;
 	}
-	err = p54u_load_firmware(dev);
-	if (err)
-		goto err_free_dev;
-
-	err = priv->upload_fw(dev);
-	if (err)
-		goto err_free_fw;
-
-	p54u_open(dev);
-	err = p54_read_eeprom(dev);
-	p54u_stop(dev);
-	if (err)
-		goto err_free_fw;
-
-	err = p54_register_common(dev, &udev->dev);
-	if (err)
-		goto err_free_fw;
-
+	/* setup and start work to load firmware */
+	INIT_WORK(&priv->firmware_load, p54u_load_firmware);
+	schedule_work(&priv->firmware_load);
 	return 0;
-
-err_free_fw:
-	release_firmware(priv->fw);
-
-err_free_dev:
-	p54_free_common(dev);
-	usb_set_intfdata(intf, NULL);
-	usb_put_dev(udev);
-	return err;
 }
 
 static void __devexit p54u_disconnect(struct usb_interface *intf)
@@ -1007,9 +1001,10 @@ static void __devexit p54u_disconnect(st
 	if (!dev)
 		return;
 
+	priv = dev->priv;
+	cancel_work_sync(&priv->firmware_load);
 	p54_unregister_common(dev);
 
-	priv = dev->priv;
 	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
Index: wireless-testing-new/drivers/net/wireless/p54/p54usb.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54usb.h
+++ wireless-testing-new/drivers/net/wireless/p54/p54usb.h
@@ -143,6 +143,7 @@ struct p54u_priv {
 	struct sk_buff_head rx_queue;
 	struct usb_anchor submitted;
 	const struct firmware *fw;
+	struct work_struct firmware_load;
 };
 
 #endif /* P54USB_H */
