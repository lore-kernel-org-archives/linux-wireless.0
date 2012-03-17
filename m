Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64516 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2CQRgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 13:36:18 -0400
Received: by wgbdr13 with SMTP id dr13so416323wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2012 10:36:15 -0700 (PDT)
Subject: [PATCH] p54usb: Load firmware asynchronously
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 17 Mar 2012 18:36:11 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201203171836.11413.chunkeey@googlemail.com> (sfid-20120317_183649_389074_DEBB7B0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

Drivers that load firmware from their probe routine have problems with
the latest versions of udev as they get timeouts while waiting for user
space to start. The problem is fixed by using request_firmware_nowait()
and delaying the start of mac80211 until the firmware is loaded.

To prevent the possibility of the driver being unloaded while the
firmware loading callback is still active, a completion queue entry
is used.

Also, to simplify the firmware loading procedure, this patch removes
the old, unofficial and confusing fallback firmware names. However,
they are still supported! So any user - who is still using them -
is hereby advised to link/rename their old firmware filenames:
	isl3890usb to isl3886usb
	isl3887usb_bare to isl3887usb

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Larry,

I've tested the patch and did some changes:

	1. Removed isl3890usb & isl3887usb_bare firmware names
	   [as mentioned in the commit message]

	2. If the firmware loading failed [either because the firmware
	   could not be found, or p54u_start_ops returns an error] the
	   driver gets unbound from the device. This is necessary to
	   match the old behavior, when .probe failed due to similar
	   errors. [Without this, a user would have to manually
	   unload the module in order to release the allocated
	   usb_dev & priv ressources]

	3. Renamed fw_loaded to fw_wait_load
	   (Actually, Johannes is partially responsible for that :D)

	4. Due to the changes in 2) this patch depends on
	   [PATCH] p54: only unregister i3e_hw when it...
	   (which I sent today!)

	5. Because the p54u_load_firmware_cb is called from an outside
	   thread [a special kthread] we have to be careful with the
	   usage of the usb_dev. Therefore I updated the usb_get_dev
	   and usb_put_dev refcounting to reflect the changes.

	6. reordered p54u_stop & p54u_start so we don't need any
	   additional forward declarations for both.

I hope you still agree with all the extra code I added. If not, then
please drop me a few lines and express your concerns.

Regards,
	Christian
---
 drivers/net/wireless/p54/p54usb.c |  191 ++++++++++++++++++++++++-------------
 drivers/net/wireless/p54/p54usb.h |    3 +
 2 files changed, 128 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index f4d28c3..8b2e8b3 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -117,21 +117,18 @@ static const struct {
 	u32 intf;
 	enum p54u_hw_type type;
 	const char *fw;
-	const char *fw_legacy;
 	char hw[20];
 } p54u_fwlist[__NUM_P54U_HWTYPES] = {
 	{
 		.type = P54U_NET2280,
 		.intf = FW_LM86,
 		.fw = "isl3886usb",
-		.fw_legacy = "isl3890usb",
 		.hw = "ISL3886 + net2280",
 	},
 	{
 		.type = P54U_3887,
 		.intf = FW_LM87,
 		.fw = "isl3887usb",
-		.fw_legacy = "isl3887usb_bare",
 		.hw = "ISL3887",
 	},
 };
@@ -208,6 +205,16 @@ static void p54u_free_urbs(struct ieee80211_hw *dev)
 	usb_kill_anchored_urbs(&priv->submitted);
 }
 
+static void p54u_stop(struct ieee80211_hw *dev)
+{
+	/*
+	 * TODO: figure out how to reliably stop the 3887 and net2280 so
+	 * the hardware is still usable next time we want to start it.
+	 * until then, we just stop listening to the hardware..
+	 */
+	p54u_free_urbs(dev);
+}
+
 static int p54u_init_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -257,6 +264,16 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
 	return ret;
 }
 
+static int p54u_open(struct ieee80211_hw *dev)
+{
+	/*
+	 * TODO: Because we don't know how to reliably stop the 3887 and
+	 * the isl3886+net2280, other than brutally cut off all
+	 * communications. We have to reinitialize the urbs on every start.
+	 */
+	return p54u_init_urbs(dev);
+}
+
 static __le32 p54u_lm87_chksum(const __le32 *data, size_t length)
 {
 	u32 chk = 0;
@@ -836,70 +853,137 @@ fail:
 	return err;
 }
 
-static int p54u_load_firmware(struct ieee80211_hw *dev)
+static int p54_find_type(struct p54u_priv *priv)
 {
-	struct p54u_priv *priv = dev->priv;
-	int err, i;
-
-	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
+	int i;
 
 	for (i = 0; i < __NUM_P54U_HWTYPES; i++)
 		if (p54u_fwlist[i].type == priv->hw_type)
 			break;
-
 	if (i == __NUM_P54U_HWTYPES)
 		return -EOPNOTSUPP;
 
-	err = request_firmware(&priv->fw, p54u_fwlist[i].fw, &priv->udev->dev);
-	if (err) {
-		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
-					  "(%d)!\n", p54u_fwlist[i].fw, err);
+	return i;
+}
 
-		err = request_firmware(&priv->fw, p54u_fwlist[i].fw_legacy,
-				       &priv->udev->dev);
-		if (err)
-			return err;
-	}
+static int p54_start_ops(struct p54u_priv *priv)
+{
+	struct ieee80211_hw *dev = priv->common.hw;
+	int ret;
 
-	err = p54_parse_firmware(dev, priv->fw);
+	ret = p54_parse_firmware(dev, priv->fw);
 	if (err)
-		goto out;
+		goto err_out;
 
-	if (priv->common.fw_interface != p54u_fwlist[i].intf) {
+	ret = p54_find_type(priv);
+	if (ret < 0)
+		goto err_out;
+
+	if (priv->common.fw_interface != p54u_fwlist[ret].intf) {
 		dev_err(&priv->udev->dev, "wrong firmware, please get "
 			"a firmware for \"%s\" and try again.\n",
-			p54u_fwlist[i].hw);
-		err = -EINVAL;
+			p54u_fwlist[ret].hw);
+		ret = -ENODEV;
+		goto err_out;
 	}
 
-out:
+	ret = priv->upload_fw(dev);
 	if (err)
-		release_firmware(priv->fw);
+		goto err_out;
 
-	return err;
+	ret = p54u_open(dev);
+	if (err)
+		goto err_out;
+
+	ret = p54_read_eeprom(dev);
+	if (err)
+		goto err_stop;
+
+	p54u_stop(dev);
+
+	ret = p54_register_common(dev, &priv->udev->dev);
+	if (ret)
+		goto err_stop;
+
+	return 0;
+
+err_stop:
+	p54u_stop(dev);
+
+err_out:
+	/*
+	 * p54u_disconnect will do the rest of the
+	 * cleanup
+	 */
+	return ret;
 }
 
-static int p54u_open(struct ieee80211_hw *dev)
+static void p54u_load_firmware_cb(const struct firmware *firmware,
+				  void *context)
 {
-	struct p54u_priv *priv = dev->priv;
+	struct p54u_priv *priv = context;
+	struct usb_device *udev = priv->udev;
 	int err;
 
-	err = p54u_init_urbs(dev);
-	if (err) {
-		return err;
+	complete(&priv->fw_wait_load);
+	if (firmware) {
+		priv->fw = firmware;
+		err = p54_start_ops(priv);
+	} else {
+		err = -ENOENT;
+		dev_err(&udev->dev, "Firmware not found.\n");
 	}
 
-	priv->common.open = p54u_init_urbs;
+	if (err) {
+		struct device *parent = priv->udev->dev.parent;
 
-	return 0;
+		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
+
+		if (parent)
+			device_lock(parent);
+
+		device_release_driver(&udev->dev);
+		/*
+		 * At this point p54u_disconnect has already freed
+		 * the "priv" context. Do not use it anymore!
+		 */
+		priv = NULL;
+
+		if (parent)
+			device_unlock(parent);
+	}
+
+	usb_put_dev(udev);
 }
 
-static void p54u_stop(struct ieee80211_hw *dev)
+static int p54u_load_firmware(struct ieee80211_hw *dev,
+			      struct usb_interface *intf)
 {
-	/* TODO: figure out how to reliably stop the 3887 and net2280 so
-	   the hardware is still usable next time we want to start it.
-	   until then, we just stop listening to the hardware.. */
-	p54u_free_urbs(dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct p54u_priv *priv = dev->priv;
+	struct device *device = &udev->dev;
+	int err, i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
+
+	init_completion(&priv->fw_wait_load);
+	i = p54_find_type(priv);
+	if (i < 0)
+		return i;
+
+	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
+	       p54u_fwlist[i].fw);
+
+	usb_get_dev(udev);
+	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
+				      device, GFP_KERNEL, priv,
+				      p54u_load_firmware_cb);
+	if (err) {
+		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
+					  "(%d)!\n", p54u_fwlist[i].fw, err);
+	}
+
+	return err;
 }
 
 static int __devinit p54u_probe(struct usb_interface *intf,
@@ -969,33 +1053,7 @@ static int __devinit p54u_probe(struct usb_interface *intf,
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
-	return 0;
-
-err_free_fw:
-	release_firmware(priv->fw);
-
-err_free_dev:
-	p54_free_common(dev);
-	usb_set_intfdata(intf, NULL);
-	usb_put_dev(udev);
+	err = p54u_load_firmware(dev, intf);
 	return err;
 }
 
@@ -1007,9 +1065,10 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
+	priv = dev->priv;
+	wait_for_completion(&priv->fw_wait_load);
 	p54_unregister_common(dev);
 
-	priv = dev->priv;
 	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
index ed4034a..d273be7 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -143,6 +143,9 @@ struct p54u_priv {
 	struct sk_buff_head rx_queue;
 	struct usb_anchor submitted;
 	const struct firmware *fw;
+
+	/* asynchronous firmware callback */
+	struct completion fw_wait_load;
 };
 
 #endif /* P54USB_H */
-- 
1.7.9.1

