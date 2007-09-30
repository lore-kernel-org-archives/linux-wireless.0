Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64294 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXI3SlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:41:07 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 23/26] at76_usb: Be more verbose on startup
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:41:06 -0400
Message-ID: <20070930184106.23921.39307.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Promote some debug messages from at76_dbg() to unconditional KERN_DEBUG.
Use dev_printk() before the device is registered, as "wlan%d" doesn't
identify the device uniquely.

Print firmware name and version when it's loaded from file.  Print
firmware version reported by the card.  Print USB address and network
device name on the same line to help identifying the device.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 1849b94..1e3363e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5101,9 +5101,11 @@ static struct fwentry *at76_load_firmware(struct usb_device *udev,
 
 	fwe->loaded = 1;
 
-	at76_dbg(DBG_DEVSTART, "firmware board %u version %u.%u.%u-%u "
-		 "(int %d:%d, ext %d:%d)", board_type,
-		 fwh->major, fwh->minor, fwh->patch, fwh->build,
+	dev_printk(KERN_DEBUG, &udev->dev,
+		   "using firmware %s (version %d.%d.%d-%d)\n",
+		   fwe->fwname, fwh->major, fwh->minor, fwh->patch, fwh->build);
+
+	at76_dbg(DBG_DEVSTART, "board %u, int %d:%d, ext %d:%d", board_type,
 		 le32_to_cpu(fwh->int_fw_offset), le32_to_cpu(fwh->int_fw_len),
 		 le32_to_cpu(fwh->ext_fw_offset), le32_to_cpu(fwh->ext_fw_len));
 	at76_dbg(DBG_DEVSTART, "firmware id %s", str);
@@ -5256,8 +5258,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 	/* MAC address */
 	ret = at76_get_hw_config(priv);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: cannot get MAC address\n",
-		       priv->netdev->name);
+		dev_printk(KERN_ERR, &interface->dev,
+			   "cannot get MAC address\n");
 		goto exit;
 	}
 
@@ -5299,15 +5301,14 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	ret = register_netdev(priv->netdev);
 	if (ret) {
-		printk(KERN_ERR "cannot register netdevice %s (status %d)!\n",
-		       priv->netdev->name, ret);
+		dev_printk(KERN_ERR, &interface->dev,
+			   "cannot register netdevice (status %d)!\n", ret);
 		goto exit;
 	}
 	priv->netdev_registered = 1;
 
-	printk(KERN_INFO "%s: MAC address %s\n", netdev->name,
-	       mac2str(priv->mac_addr));
-	printk(KERN_INFO "%s: firmware version %d.%d.%d-%d\n", netdev->name,
+	printk(KERN_INFO "%s: USB %s, MAC %s, firmware %d.%d.%d-%d\n",
+	       netdev->name, interface->dev.bus_id, mac2str(priv->mac_addr),
 	       priv->fw_version.major, priv->fw_version.minor,
 	       priv->fw_version.patch, priv->fw_version.build);
 	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n", netdev->name,
@@ -5412,7 +5413,8 @@ static int at76_probe(struct usb_interface *interface,
 	if (op_mode != OPMODE_NORMAL_NIC_WITH_FLASH
 	    && op_mode != OPMODE_NORMAL_NIC_WITHOUT_FLASH) {
 		/* download internal firmware part */
-		at76_dbg(DBG_DEVSTART, "downloading internal firmware");
+		dev_printk(KERN_DEBUG, &interface->dev,
+			   "downloading internal firmware\n");
 		ret = at76_load_internal_fw(udev, fwe);
 		if (ret < 0) {
 			dev_printk(KERN_ERR, &interface->dev,
@@ -5442,7 +5444,8 @@ static int at76_probe(struct usb_interface *interface,
 		need_ext_fw = 1;
 
 	if (need_ext_fw) {
-		at76_dbg(DBG_DEVSTART, "downloading external firmware");
+		dev_printk(KERN_DEBUG, &interface->dev,
+			   "downloading external firmware\n");
 
 		ret = at76_load_external_fw(udev, fwe);
 		if (ret)
