Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56967 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762795AbXLMG7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:33 -0500
Subject: [PATCH 75/48] libertas: add lbs_mesh sysfs attribute for enabling mesh
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2x-0005t3-Oc@shinybook.infradead.org> (sfid-20071213_070108_024130_3D8CADFB)
Date: Thu, 13 Dec 2007 01:59:51 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 18:56:42 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   17 +++++++
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/decl.h    |    2 -
 drivers/net/wireless/libertas/dev.h     |    2 +
 drivers/net/wireless/libertas/host.h    |    1 +
 drivers/net/wireless/libertas/hostcmd.h |   12 +++++
 drivers/net/wireless/libertas/if_usb.c  |    6 ---
 drivers/net/wireless/libertas/main.c    |   74 +++++++++++++++++++++++++++----
 8 files changed, 99 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 2228fec..01d2349 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1093,6 +1093,23 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 }
 EXPORT_SYMBOL_GPL(lbs_mesh_access);
 
+int lbs_mesh_config(struct lbs_private *priv, int enable)
+{
+	struct cmd_ds_mesh_config cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.action = cpu_to_le16(enable);
+	cmd.channel = cpu_to_le16(priv->curbssparams.channel);
+	cmd.type = cpu_to_le16(0x100 + 37);
+	
+	if (enable) {
+		cmd.length = cpu_to_le16(priv->mesh_ssid_len);
+		memcpy(cmd.data, priv->mesh_ssid, priv->mesh_ssid_len);
+	}
+
+	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, cmd);
+}
+
 static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
 				struct cmd_ds_command *cmd,
 				u16 cmd_action)
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 5b02d73..80714b5 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -33,4 +33,6 @@ int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 int lbs_get_channel(struct lbs_private *priv);
 int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
+int lbs_mesh_config(struct lbs_private *priv, int enable);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 33c8305..9b0ef16 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -74,8 +74,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
 int lbs_remove_card(struct lbs_private *priv);
 int lbs_start_card(struct lbs_private *priv);
 int lbs_stop_card(struct lbs_private *priv);
-int lbs_add_mesh(struct lbs_private *priv, struct device *dev);
-void lbs_remove_mesh(struct lbs_private *priv);
 int lbs_reset_device(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 9921d0c..86b45a4 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -201,6 +201,8 @@ struct lbs_private {
 
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
+	u8 mesh_ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 mesh_ssid_len;
 
 	/* IW_MODE_* */
 	u8 mode;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index cc5f9bf..fcd2238 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -113,6 +113,7 @@
 #define CMD_802_11_MONITOR_MODE       0x0098
 
 #define CMD_MESH_ACCESS               0x009b
+#define CMD_MESH_CONFIG				0x00a3
 
 #define CMD_SET_BOOT2_VER                 0x00a5
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 7acb651..aab5d64 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -626,6 +626,18 @@ struct cmd_ds_fwt_access {
 	u8 prec[ETH_ALEN];
 } __attribute__ ((packed));
 
+
+struct cmd_ds_mesh_config {
+	struct cmd_header hdr;
+
+        __le16 action;
+        __le16 channel;
+        __le16 type;
+        __le16 length;
+        u8 data[128];   /* last position reserved */
+} __attribute__ ((packed));
+
+
 struct cmd_ds_mesh_access {
 	struct cmd_header hdr;
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 7c57ff4..351c7ea 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -232,9 +232,6 @@ static int if_usb_probe(struct usb_interface *intf,
 	cardp->priv = priv;
 	cardp->priv->fw_ready = 1;
 
-	if (lbs_add_mesh(priv, &udev->dev))
-		goto err_add_mesh;
-
 	cardp->eth_dev = priv->dev;
 
 	priv->hw_host_to_card = if_usb_host_to_card;
@@ -255,8 +252,6 @@ static int if_usb_probe(struct usb_interface *intf,
 	return 0;
 
 err_start_card:
-	lbs_remove_mesh(priv);
-err_add_mesh:
 	lbs_remove_card(priv);
 err_prog_firmware:
 	if_usb_reset_device(cardp);
@@ -286,7 +281,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 		priv->surpriseremoved = 1;
 		lbs_stop_card(priv);
-		lbs_remove_mesh(priv);
 		lbs_remove_card(priv);
 	}
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index c51d3af..fd76c46 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -254,6 +254,9 @@ static ssize_t lbs_anycast_set(struct device *dev,
 
 static int lbs_add_rtap(struct lbs_private *priv);
 static void lbs_remove_rtap(struct lbs_private *priv);
+static int lbs_add_mesh(struct lbs_private *priv);
+static void lbs_remove_mesh(struct lbs_private *priv);
+  
 
 /**
  * Get function for sysfs attribute rtap
@@ -312,11 +315,53 @@ static ssize_t lbs_rtap_set(struct device *dev,
 }
 
 /**
- * lbs_rtap attribute to be exported per mshX interface
- * through sysfs (/sys/class/net/mshX/libertas-rtap)
+ * lbs_rtap attribute to be exported per ethX interface
+ * through sysfs (/sys/class/net/ethX/lbs_rtap)
  */
-static DEVICE_ATTR(lbs_rtap, 0644, lbs_rtap_get,
-		lbs_rtap_set );
+static DEVICE_ATTR(lbs_rtap, 0644, lbs_rtap_get, lbs_rtap_set );
+
+/**
+ * Get function for sysfs attribute mesh
+ */
+static ssize_t lbs_mesh_get(struct device *dev,
+		struct device_attribute *attr, char * buf)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	return snprintf(buf, 5, "0x%X\n", !!priv->mesh_dev);
+}
+
+/**
+ *  Set function for sysfs attribute mesh
+ */
+static ssize_t lbs_mesh_set(struct device *dev,
+		struct device_attribute *attr, const char * buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	int enable;
+	int ret;
+
+	sscanf(buf, "%x", &enable);
+	enable = !!enable;
+	if (enable == !!priv->mesh_dev)
+		return count;
+
+	ret = lbs_mesh_config(priv, enable);
+	if (ret)
+		return ret;
+		
+	if (enable)
+		lbs_add_mesh(priv);
+	else
+		lbs_remove_mesh(priv);
+
+	return count;
+}
+
+/**
+ * lbs_mesh attribute to be exported per ethX interface
+ * through sysfs (/sys/class/net/ethX/lbs_mesh)
+ */
+static DEVICE_ATTR(lbs_mesh, 0644, lbs_mesh_get, lbs_mesh_set);
 
 /**
  * anycast_mask attribute to be exported per mshX interface
@@ -867,7 +912,9 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 		ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
 				      &mesh_access);
 		if (ret) {
-			ret = -1;
+			printk("Mesh autostart set failed\n");
+			ret = 0;
+			//ret = -1;
 			goto done;
 		}
 		priv->mesh_autostart_enabled = 0;
@@ -1059,6 +1106,9 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel);
 
+	sprintf(priv->mesh_ssid, "mesh");
+	priv->mesh_ssid_len = 4;
+
 	goto done;
 
 err_init_adapter:
@@ -1080,6 +1130,7 @@ int lbs_remove_card(struct lbs_private *priv)
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
+	lbs_remove_mesh(priv);
 	lbs_remove_rtap(priv);
 
 	dev = priv->dev;
@@ -1133,6 +1184,8 @@ int lbs_start_card(struct lbs_private *priv)
 	}
 	if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 		lbs_pr_err("cannot register lbs_rtap attribute\n");
+	if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
+		lbs_pr_err("cannot register lbs_mesh attribute\n");
 
 	lbs_debugfs_init_one(priv, dev);
 
@@ -1161,6 +1214,7 @@ int lbs_stop_card(struct lbs_private *priv)
 
 	lbs_debugfs_remove_one(priv);
 	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
+	device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
 
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
@@ -1184,7 +1238,7 @@ EXPORT_SYMBOL_GPL(lbs_stop_card);
  *  @param priv    A pointer to the struct lbs_private structure
  *  @return 	   0 if successful, -X otherwise
  */
-int lbs_add_mesh(struct lbs_private *priv, struct device *dev)
+static int lbs_add_mesh(struct lbs_private *priv)
 {
 	struct net_device *mesh_dev = NULL;
 	int ret = 0;
@@ -1209,7 +1263,7 @@ int lbs_add_mesh(struct lbs_private *priv, struct device *dev)
 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
 			sizeof(priv->dev->dev_addr));
 
-	SET_NETDEV_DEV(priv->mesh_dev, dev);
+	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
 #ifdef	WIRELESS_EXT
 	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
@@ -1242,7 +1296,7 @@ done:
 EXPORT_SYMBOL_GPL(lbs_add_mesh);
 
 
-void lbs_remove_mesh(struct lbs_private *priv)
+static void lbs_remove_mesh(struct lbs_private *priv)
 {
 	struct net_device *mesh_dev;
 
@@ -1252,6 +1306,8 @@ void lbs_remove_mesh(struct lbs_private *priv)
 		goto out;
 
 	mesh_dev = priv->mesh_dev;
+	if (!mesh_dev)
+		goto out;
 
 	netif_stop_queue(mesh_dev);
 	netif_carrier_off(priv->mesh_dev);
@@ -1259,7 +1315,7 @@ void lbs_remove_mesh(struct lbs_private *priv)
 	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
 	unregister_netdev(mesh_dev);
 
-	priv->mesh_dev = NULL ;
+	priv->mesh_dev = NULL;
 	free_netdev(mesh_dev);
 
 out:
-- 
1.5.3.4

