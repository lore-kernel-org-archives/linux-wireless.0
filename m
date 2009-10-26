Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:8610 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZJZPmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 11:42:10 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH, v2] libertas: initial move of mesh related functions into persistcfg.c
Date: Mon, 26 Oct 2009 16:41:35 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>
References: <200910261622.22140.hs4233@mail.mn-solutions.de>
In-Reply-To: <200910261622.22140.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910261641.35319.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves mesh initialization, start/stop and rx/tx handling from
the respective *.c files into persistcfg.c.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
v2: don't modify Makefile

--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -94,107 +94,9 @@
 	return 0;
 }
 
-/**
- * Attributes exported through sysfs
- */
-
-/**
- * @brief Get function for sysfs attribute anycast_mask
- */
-static ssize_t lbs_anycast_get(struct device *dev,
-		struct device_attribute *attr, char * buf)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_access mesh_access;
-	int ret;
-
-	memset(&mesh_access, 0, sizeof(mesh_access));
-
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_ANYCAST, &mesh_access);
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 12, "0x%X\n", le32_to_cpu(mesh_access.data[0]));
-}
-
-/**
- * @brief Set function for sysfs attribute anycast_mask
- */
-static ssize_t lbs_anycast_set(struct device *dev,
-		struct device_attribute *attr, const char * buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_access mesh_access;
-	uint32_t datum;
-	int ret;
-
-	memset(&mesh_access, 0, sizeof(mesh_access));
-	sscanf(buf, "%x", &datum);
-	mesh_access.data[0] = cpu_to_le32(datum);
-
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_ANYCAST, &mesh_access);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute prb_rsp_limit
- */
-static ssize_t lbs_prb_rsp_limit_get(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_access mesh_access;
-	int ret;
-	u32 retry_limit;
-
-	memset(&mesh_access, 0, sizeof(mesh_access));
-	mesh_access.data[0] = cpu_to_le32(CMD_ACT_GET);
-
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_GET_PRB_RSP_LIMIT,
-			&mesh_access);
-	if (ret)
-		return ret;
-
-	retry_limit = le32_to_cpu(mesh_access.data[1]);
-	return snprintf(buf, 10, "%d\n", retry_limit);
-}
-
-/**
- * @brief Set function for sysfs attribute prb_rsp_limit
- */
-static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_access mesh_access;
-	int ret;
-	unsigned long retry_limit;
-
-	memset(&mesh_access, 0, sizeof(mesh_access));
-	mesh_access.data[0] = cpu_to_le32(CMD_ACT_SET);
-
-	if (!strict_strtoul(buf, 10, &retry_limit))
-		return -ENOTSUPP;
-	if (retry_limit > 15)
-		return -ENOTSUPP;
-
-	mesh_access.data[1] = cpu_to_le32(retry_limit);
-
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_GET_PRB_RSP_LIMIT,
-			&mesh_access);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
 
 static int lbs_add_rtap(struct lbs_private *priv);
 static void lbs_remove_rtap(struct lbs_private *priv);
-static int lbs_add_mesh(struct lbs_private *priv);
-static void lbs_remove_mesh(struct lbs_private *priv);
 
 
 /**
@@ -260,74 +162,7 @@
 static DEVICE_ATTR(lbs_rtap, 0644, lbs_rtap_get, lbs_rtap_set );
 
 /**
- * Get function for sysfs attribute mesh
- */
-static ssize_t lbs_mesh_get(struct device *dev,
-		struct device_attribute *attr, char * buf)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	return snprintf(buf, 5, "0x%X\n", !!priv->mesh_dev);
-}
-
-/**
- *  Set function for sysfs attribute mesh
- */
-static ssize_t lbs_mesh_set(struct device *dev,
-		struct device_attribute *attr, const char * buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	int enable;
-	int ret, action = CMD_ACT_MESH_CONFIG_STOP;
-
-	sscanf(buf, "%x", &enable);
-	enable = !!enable;
-	if (enable == !!priv->mesh_dev)
-		return count;
-	if (enable)
-		action = CMD_ACT_MESH_CONFIG_START;
-	ret = lbs_mesh_config(priv, action, priv->channel);
-	if (ret)
-		return ret;
-
-	if (enable)
-		lbs_add_mesh(priv);
-	else
-		lbs_remove_mesh(priv);
-
-	return count;
-}
-
-/**
- * lbs_mesh attribute to be exported per ethX interface
- * through sysfs (/sys/class/net/ethX/lbs_mesh)
- */
-static DEVICE_ATTR(lbs_mesh, 0644, lbs_mesh_get, lbs_mesh_set);
-
-/**
- * anycast_mask attribute to be exported per mshX interface
- * through sysfs (/sys/class/net/mshX/anycast_mask)
- */
-static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
-
-/**
- * prb_rsp_limit attribute to be exported per mshX interface
- * through sysfs (/sys/class/net/mshX/prb_rsp_limit)
- */
-static DEVICE_ATTR(prb_rsp_limit, 0644, lbs_prb_rsp_limit_get,
-		lbs_prb_rsp_limit_set);
-
-static struct attribute *lbs_mesh_sysfs_entries[] = {
-	&dev_attr_anycast_mask.attr,
-	&dev_attr_prb_rsp_limit.attr,
-	NULL,
-};
-
-static struct attribute_group lbs_mesh_attr_group = {
-	.attrs = lbs_mesh_sysfs_entries,
-};
-
-/**
- *  @brief This function opens the ethX or mshX interface
+ *  @brief This function opens the ethX interface
  *
  *  @param dev     A pointer to net_device structure
  *  @return 	   0 or -EBUSY if monitor mode active
@@ -346,18 +181,12 @@
 		goto out;
 	}
 
-	if (dev == priv->mesh_dev) {
-		priv->mesh_open = 1;
-		priv->mesh_connect_status = LBS_CONNECTED;
-		netif_carrier_on(dev);
-	} else {
-		priv->infra_open = 1;
+	priv->infra_open = 1;
 
-		if (priv->connect_status == LBS_CONNECTED)
-			netif_carrier_on(dev);
-		else
-			netif_carrier_off(dev);
-	}
+	if (priv->connect_status == LBS_CONNECTED)
+		netif_carrier_on(dev);
+	else
+		netif_carrier_off(dev);
 
 	if (!priv->tx_pending_len)
 		netif_wake_queue(dev);
@@ -369,33 +198,6 @@
 }
 
 /**
- *  @brief This function closes the mshX interface
- *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0
- */
-static int lbs_mesh_stop(struct net_device *dev)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_MESH);
-	spin_lock_irq(&priv->driver_lock);
-
-	priv->mesh_open = 0;
-	priv->mesh_connect_status = LBS_DISCONNECTED;
-
-	netif_stop_queue(dev);
-	netif_carrier_off(dev);
-
-	spin_unlock_irq(&priv->driver_lock);
-
-	schedule_work(&priv->mcast_work);
-
-	lbs_deb_leave(LBS_DEB_MESH);
-	return 0;
-}
-
-/**
  *  @brief This function closes the ethX interface
  *
  *  @param dev     A pointer to net_device structure
@@ -466,7 +268,7 @@
 }
 EXPORT_SYMBOL_GPL(lbs_host_to_card_done);
 
-static int lbs_set_mac_address(struct net_device *dev, void *addr)
+int lbs_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->ml_priv;
@@ -600,7 +402,7 @@
 	lbs_deb_leave(LBS_DEB_NET);
 }
 
-static void lbs_set_multicast_list(struct net_device *dev)
+void lbs_set_multicast_list(struct net_device *dev)
 {
 	struct lbs_private *priv = dev->ml_priv;
 
@@ -1177,7 +980,6 @@
 
 
 	priv->card = card;
-	priv->mesh_open = 0;
 	priv->infra_open = 0;
 
 
@@ -1198,6 +1000,7 @@
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
+	priv->mesh_open = 0;
 	sprintf(priv->mesh_ssid, "mesh");
 	priv->mesh_ssid_len = 4;
 
@@ -1292,50 +1095,12 @@
 
 	lbs_update_channel(priv);
 
-	/* Check mesh FW version and appropriately send the mesh start
-	 * command
+	/*
+	 * While rtap isn't related to mesh, only mesh-enabled
+	 * firmware implements the rtap functionality via
+	 * CMD_802_11_MONITOR_MODE.
 	 */
-	if (priv->mesh_fw_ver == MESH_FW_OLD) {
-		/* Enable mesh, if supported, and work out which TLV it uses.
-		   0x100 + 291 is an unofficial value used in 5.110.20.pXX
-		   0x100 + 37 is the official value used in 5.110.21.pXX
-		   but we check them in that order because 20.pXX doesn't
-		   give an error -- it just silently fails. */
-
-		/* 5.110.20.pXX firmware will fail the command if the channel
-		   doesn't match the existing channel. But only if the TLV
-		   is correct. If the channel is wrong, _BOTH_ versions will
-		   give an error to 0x100+291, and allow 0x100+37 to succeed.
-		   It's just that 5.110.20.pXX will not have done anything
-		   useful */
-
-		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
-		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->channel)) {
-			priv->mesh_tlv = TLV_TYPE_MESH_ID;
-			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-					    priv->channel))
-				priv->mesh_tlv = 0;
-		}
-	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
-		/* 10.0.0.pXX new firmwares should succeed with TLV
-		 * 0x100+37; Do not invoke command with old TLV.
-		 */
-		priv->mesh_tlv = TLV_TYPE_MESH_ID;
-		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->channel))
-			priv->mesh_tlv = 0;
-	}
-	if (priv->mesh_tlv) {
-		lbs_add_mesh(priv);
-
-		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
-			lbs_pr_err("cannot register lbs_mesh attribute\n");
-
-		/* While rtap isn't related to mesh, only mesh-enabled
-		 * firmware implements the rtap functionality via
-		 * CMD_802_11_MONITOR_MODE.
-		 */
+	if (lbs_init_mesh(priv)) {
 		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 			lbs_pr_err("cannot register lbs_rtap attribute\n");
 	}
@@ -1369,10 +1134,8 @@
 	netif_carrier_off(dev);
 
 	lbs_debugfs_remove_one(priv);
-	if (priv->mesh_tlv) {
-		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
+	if (lbs_deinit_mesh(priv))
 		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
-	}
 
 	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
@@ -1405,95 +1168,6 @@
 EXPORT_SYMBOL_GPL(lbs_stop_card);
 
 
-static const struct net_device_ops mesh_netdev_ops = {
-	.ndo_open		= lbs_dev_open,
-	.ndo_stop 		= lbs_mesh_stop,
-	.ndo_start_xmit		= lbs_hard_start_xmit,
-	.ndo_set_mac_address	= lbs_set_mac_address,
-	.ndo_set_multicast_list = lbs_set_multicast_list,
-};
-
-/**
- * @brief This function adds mshX interface
- *
- *  @param priv    A pointer to the struct lbs_private structure
- *  @return 	   0 if successful, -X otherwise
- */
-static int lbs_add_mesh(struct lbs_private *priv)
-{
-	struct net_device *mesh_dev = NULL;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_MESH);
-
-	/* Allocate a virtual mesh device */
-	if (!(mesh_dev = alloc_netdev(0, "msh%d", ether_setup))) {
-		lbs_deb_mesh("init mshX device failed\n");
-		ret = -ENOMEM;
-		goto done;
-	}
-	mesh_dev->ml_priv = priv;
-	priv->mesh_dev = mesh_dev;
-
-	mesh_dev->netdev_ops = &mesh_netdev_ops;
-	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
-	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
-			sizeof(priv->dev->dev_addr));
-
-	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
-
-#ifdef	WIRELESS_EXT
-	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
-#endif
-	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
-	/* Register virtual mesh interface */
-	ret = register_netdev(mesh_dev);
-	if (ret) {
-		lbs_pr_err("cannot register mshX virtual interface\n");
-		goto err_free;
-	}
-
-	ret = sysfs_create_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
-	if (ret)
-		goto err_unregister;
-
-	lbs_persist_config_init(mesh_dev);
-
-	/* Everything successful */
-	ret = 0;
-	goto done;
-
-err_unregister:
-	unregister_netdev(mesh_dev);
-
-err_free:
-	free_netdev(mesh_dev);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
-	return ret;
-}
-
-static void lbs_remove_mesh(struct lbs_private *priv)
-{
-	struct net_device *mesh_dev;
-
-
-	mesh_dev = priv->mesh_dev;
-	if (!mesh_dev)
-		return;
-
-	lbs_deb_enter(LBS_DEB_MESH);
-	netif_stop_queue(mesh_dev);
-	netif_carrier_off(mesh_dev);
-	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
-	lbs_persist_config_remove(mesh_dev);
-	unregister_netdev(mesh_dev);
-	priv->mesh_dev = NULL;
-	free_netdev(mesh_dev);
-	lbs_deb_leave(LBS_DEB_MESH);
-}
-
 void lbs_queue_event(struct lbs_private *priv, u32 event)
 {
 	unsigned long flags;
--- linux-wl.orig/drivers/net/wireless/libertas/persistcfg.c
+++ linux-wl/drivers/net/wireless/libertas/persistcfg.c
@@ -6,15 +6,444 @@
 #include <linux/kthread.h>
 #include <linux/kfifo.h>
 
-#include "host.h"
+#include "mesh.h"
 #include "decl.h"
-#include "dev.h"
-#include "wext.h"
-#include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
 #include "cmd.h"
 
+
+/***************************************************************************
+ * Mesh sysfs support
+ */
+
+/**
+ * Attributes exported through sysfs
+ */
+
+/**
+ * @brief Get function for sysfs attribute anycast_mask
+ */
+static ssize_t lbs_anycast_get(struct device *dev,
+		struct device_attribute *attr, char * buf)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_access mesh_access;
+	int ret;
+
+	memset(&mesh_access, 0, sizeof(mesh_access));
+
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_ANYCAST, &mesh_access);
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 12, "0x%X\n", le32_to_cpu(mesh_access.data[0]));
+}
+
+/**
+ * @brief Set function for sysfs attribute anycast_mask
+ */
+static ssize_t lbs_anycast_set(struct device *dev,
+		struct device_attribute *attr, const char * buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_access mesh_access;
+	uint32_t datum;
+	int ret;
+
+	memset(&mesh_access, 0, sizeof(mesh_access));
+	sscanf(buf, "%x", &datum);
+	mesh_access.data[0] = cpu_to_le32(datum);
+
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_ANYCAST, &mesh_access);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute prb_rsp_limit
+ */
+static ssize_t lbs_prb_rsp_limit_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_access mesh_access;
+	int ret;
+	u32 retry_limit;
+
+	memset(&mesh_access, 0, sizeof(mesh_access));
+	mesh_access.data[0] = cpu_to_le32(CMD_ACT_GET);
+
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_GET_PRB_RSP_LIMIT,
+			&mesh_access);
+	if (ret)
+		return ret;
+
+	retry_limit = le32_to_cpu(mesh_access.data[1]);
+	return snprintf(buf, 10, "%d\n", retry_limit);
+}
+
+/**
+ * @brief Set function for sysfs attribute prb_rsp_limit
+ */
+static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_access mesh_access;
+	int ret;
+	unsigned long retry_limit;
+
+	memset(&mesh_access, 0, sizeof(mesh_access));
+	mesh_access.data[0] = cpu_to_le32(CMD_ACT_SET);
+
+	if (!strict_strtoul(buf, 10, &retry_limit))
+		return -ENOTSUPP;
+	if (retry_limit > 15)
+		return -ENOTSUPP;
+
+	mesh_access.data[1] = cpu_to_le32(retry_limit);
+
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_GET_PRB_RSP_LIMIT,
+			&mesh_access);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * Get function for sysfs attribute mesh
+ */
+static ssize_t lbs_mesh_get(struct device *dev,
+		struct device_attribute *attr, char * buf)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	return snprintf(buf, 5, "0x%X\n", !!priv->mesh_dev);
+}
+
+/**
+ *  Set function for sysfs attribute mesh
+ */
+static ssize_t lbs_mesh_set(struct device *dev,
+		struct device_attribute *attr, const char * buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	int enable;
+	int ret, action = CMD_ACT_MESH_CONFIG_STOP;
+
+	sscanf(buf, "%x", &enable);
+	enable = !!enable;
+	if (enable == !!priv->mesh_dev)
+		return count;
+	if (enable)
+		action = CMD_ACT_MESH_CONFIG_START;
+	ret = lbs_mesh_config(priv, action, priv->channel);
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
+
+/**
+ * anycast_mask attribute to be exported per mshX interface
+ * through sysfs (/sys/class/net/mshX/anycast_mask)
+ */
+static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
+
+/**
+ * prb_rsp_limit attribute to be exported per mshX interface
+ * through sysfs (/sys/class/net/mshX/prb_rsp_limit)
+ */
+static DEVICE_ATTR(prb_rsp_limit, 0644, lbs_prb_rsp_limit_get,
+		lbs_prb_rsp_limit_set);
+
+static struct attribute *lbs_mesh_sysfs_entries[] = {
+	&dev_attr_anycast_mask.attr,
+	&dev_attr_prb_rsp_limit.attr,
+	NULL,
+};
+
+static struct attribute_group lbs_mesh_attr_group = {
+	.attrs = lbs_mesh_sysfs_entries,
+};
+
+
+
+/***************************************************************************
+ * Initializing and starting, stopping mesh
+ */
+
+/*
+ * Check mesh FW version and appropriately send the mesh start
+ * command
+ */
+int lbs_init_mesh(struct lbs_private *priv)
+{
+	struct net_device *dev = priv->dev;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+
+	if (priv->mesh_fw_ver == MESH_FW_OLD) {
+		/* Enable mesh, if supported, and work out which TLV it uses.
+		   0x100 + 291 is an unofficial value used in 5.110.20.pXX
+		   0x100 + 37 is the official value used in 5.110.21.pXX
+		   but we check them in that order because 20.pXX doesn't
+		   give an error -- it just silently fails. */
+
+		/* 5.110.20.pXX firmware will fail the command if the channel
+		   doesn't match the existing channel. But only if the TLV
+		   is correct. If the channel is wrong, _BOTH_ versions will
+		   give an error to 0x100+291, and allow 0x100+37 to succeed.
+		   It's just that 5.110.20.pXX will not have done anything
+		   useful */
+
+		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+				    priv->channel)) {
+			priv->mesh_tlv = TLV_TYPE_MESH_ID;
+			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+					    priv->channel))
+				priv->mesh_tlv = 0;
+		}
+	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+		/* 10.0.0.pXX new firmwares should succeed with TLV
+		 * 0x100+37; Do not invoke command with old TLV.
+		 */
+		priv->mesh_tlv = TLV_TYPE_MESH_ID;
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+				    priv->channel))
+			priv->mesh_tlv = 0;
+	}
+	if (priv->mesh_tlv) {
+		lbs_add_mesh(priv);
+
+		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
+			lbs_pr_err("cannot register lbs_mesh attribute\n");
+
+		ret = 1;
+	}
+
+	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
+	return ret;
+}
+
+
+int lbs_deinit_mesh(struct lbs_private *priv)
+{
+	struct net_device *dev = priv->dev;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+
+	if (priv->mesh_tlv) {
+		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
+		ret = 1;
+	}
+
+	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
+	return ret;
+}
+
+
+/**
+ *  @brief This function closes the mshX interface
+ *
+ *  @param dev     A pointer to net_device structure
+ *  @return 	   0
+ */
+static int lbs_mesh_stop(struct net_device *dev)
+{
+	struct lbs_private *priv = dev->ml_priv;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+	spin_lock_irq(&priv->driver_lock);
+
+	priv->mesh_open = 0;
+	priv->mesh_connect_status = LBS_DISCONNECTED;
+
+	netif_stop_queue(dev);
+	netif_carrier_off(dev);
+
+	spin_unlock_irq(&priv->driver_lock);
+
+	schedule_work(&priv->mcast_work);
+
+	lbs_deb_leave(LBS_DEB_MESH);
+	return 0;
+}
+
+/**
+ *  @brief This function opens the mshX interface
+ *
+ *  @param dev     A pointer to net_device structure
+ *  @return 	   0 or -EBUSY if monitor mode active
+ */
+static int lbs_mesh_dev_open(struct net_device *dev)
+{
+	struct lbs_private *priv = dev->ml_priv;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_NET);
+
+	spin_lock_irq(&priv->driver_lock);
+
+	if (priv->monitormode) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	priv->mesh_open = 1;
+	priv->mesh_connect_status = LBS_CONNECTED;
+	netif_carrier_on(dev);
+
+	if (!priv->tx_pending_len)
+		netif_wake_queue(dev);
+ out:
+
+	spin_unlock_irq(&priv->driver_lock);
+	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
+	return ret;
+}
+
+static const struct net_device_ops mesh_netdev_ops = {
+	.ndo_open		= lbs_mesh_dev_open,
+	.ndo_stop 		= lbs_mesh_stop,
+	.ndo_start_xmit		= lbs_hard_start_xmit,
+	.ndo_set_mac_address	= lbs_set_mac_address,
+	.ndo_set_multicast_list = lbs_set_multicast_list,
+};
+
+/**
+ * @brief This function adds mshX interface
+ *
+ *  @param priv    A pointer to the struct lbs_private structure
+ *  @return 	   0 if successful, -X otherwise
+ */
+int lbs_add_mesh(struct lbs_private *priv)
+{
+	struct net_device *mesh_dev = NULL;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+
+	/* Allocate a virtual mesh device */
+	mesh_dev = alloc_netdev(0, "msh%d", ether_setup);
+	if (!mesh_dev) {
+		lbs_deb_mesh("init mshX device failed\n");
+		ret = -ENOMEM;
+		goto done;
+	}
+	mesh_dev->ml_priv = priv;
+	priv->mesh_dev = mesh_dev;
+
+	mesh_dev->netdev_ops = &mesh_netdev_ops;
+	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
+	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
+			sizeof(priv->dev->dev_addr));
+
+	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
+
+#ifdef	WIRELESS_EXT
+	mesh_dev->wireless_handlers = &mesh_handler_def;
+#endif
+	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	/* Register virtual mesh interface */
+	ret = register_netdev(mesh_dev);
+	if (ret) {
+		lbs_pr_err("cannot register mshX virtual interface\n");
+		goto err_free;
+	}
+
+	ret = sysfs_create_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
+	if (ret)
+		goto err_unregister;
+
+	lbs_persist_config_init(mesh_dev);
+
+	/* Everything successful */
+	ret = 0;
+	goto done;
+
+err_unregister:
+	unregister_netdev(mesh_dev);
+
+err_free:
+	free_netdev(mesh_dev);
+
+done:
+	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
+	return ret;
+}
+
+void lbs_remove_mesh(struct lbs_private *priv)
+{
+	struct net_device *mesh_dev;
+
+	mesh_dev = priv->mesh_dev;
+	if (!mesh_dev)
+		return;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+	netif_stop_queue(mesh_dev);
+	netif_carrier_off(mesh_dev);
+	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
+	lbs_persist_config_remove(mesh_dev);
+	unregister_netdev(mesh_dev);
+	priv->mesh_dev = NULL;
+	free_netdev(mesh_dev);
+	lbs_deb_leave(LBS_DEB_MESH);
+}
+
+
+
+/***************************************************************************
+ * Sending and receiving
+ */
+struct net_device *lbs_mesh_set_dev(struct lbs_private *priv,
+	struct net_device *dev, struct rxpd *rxpd)
+{
+	if (priv->mesh_dev) {
+		if (priv->mesh_fw_ver == MESH_FW_OLD) {
+			if (rxpd->rx_control & RxPD_MESH_FRAME)
+				dev = priv->mesh_dev;
+		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+			if (rxpd->u.bss.bss_num == MESH_IFACE_ID)
+				dev = priv->mesh_dev;
+		}
+	}
+	return dev;
+}
+
+
+void lbs_mesh_set_txpd(struct lbs_private *priv,
+	struct net_device *dev, struct txpd *txpd)
+{
+	if (dev == priv->mesh_dev) {
+		if (priv->mesh_fw_ver == MESH_FW_OLD)
+			txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
+		else if (priv->mesh_fw_ver == MESH_FW_NEW)
+			txpd->u.bss.bss_num = MESH_IFACE_ID;
+	}
+}
+
+
+/***************************************************************************
+ * Persistent configuration support
+ */
+
 static int mesh_get_default_parameters(struct device *dev,
 				       struct mrvl_mesh_defaults *defs)
 {
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -22,10 +22,34 @@
 
 
 struct net_device;
+struct lbs_private;
+
+int lbs_init_mesh(struct lbs_private *priv);
+int lbs_deinit_mesh(struct lbs_private *priv);
+
+int lbs_add_mesh(struct lbs_private *priv);
+void lbs_remove_mesh(struct lbs_private *priv);
+
+
+/* Sending / Receiving */
+
+struct rxpd;
+struct txpd;
+
+struct net_device *lbs_mesh_set_dev(struct lbs_private *priv,
+	struct net_device *dev, struct rxpd *rxpd);
+void lbs_mesh_set_txpd(struct lbs_private *priv,
+	struct net_device *dev, struct txpd *txpd);
+
+
+/* Persistent configuration */
 
 void lbs_persist_config_init(struct net_device *net);
 void lbs_persist_config_remove(struct net_device *net);
 
+
+/* WEXT handler */
+
 extern struct iw_handler_def mesh_handler_def;
 
 
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -34,6 +34,9 @@
 void lbs_stop_card(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
+int lbs_set_mac_address(struct net_device *dev, void *addr);
+void lbs_set_multicast_list(struct net_device *dev);
+
 int lbs_suspend(struct lbs_private *priv);
 void lbs_resume(struct lbs_private *priv);
 
--- linux-wl.orig/drivers/net/wireless/libertas/rx.c
+++ linux-wl/drivers/net/wireless/libertas/rx.c
@@ -160,15 +160,8 @@
 	p_rx_pd = (struct rxpd *) skb->data;
 	p_rx_pkt = (struct rxpackethdr *) ((u8 *)p_rx_pd +
 		le32_to_cpu(p_rx_pd->pkt_ptr));
-	if (priv->mesh_dev) {
-		if (priv->mesh_fw_ver == MESH_FW_OLD) {
-			if (p_rx_pd->rx_control & RxPD_MESH_FRAME)
-				dev = priv->mesh_dev;
-		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
-			if (p_rx_pd->u.bss.bss_num == MESH_IFACE_ID)
-				dev = priv->mesh_dev;
-		}
-	}
+
+	dev = lbs_mesh_set_dev(priv, dev, p_rx_pd);
 
 	lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data,
 		 min_t(unsigned int, skb->len, 100));
--- linux-wl.orig/drivers/net/wireless/libertas/tx.c
+++ linux-wl/drivers/net/wireless/libertas/tx.c
@@ -131,12 +131,7 @@
 	txpd->tx_packet_length = cpu_to_le16(pkt_len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
 
-	if (dev == priv->mesh_dev) {
-		if (priv->mesh_fw_ver == MESH_FW_OLD)
-			txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
-		else if (priv->mesh_fw_ver == MESH_FW_NEW)
-			txpd->u.bss.bss_num = MESH_IFACE_ID;
-	}
+	lbs_mesh_set_txpd(priv, dev, txpd);
 
 	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) &txpd, sizeof(struct txpd));
 
