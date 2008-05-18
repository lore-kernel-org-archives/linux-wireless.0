Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:61955 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbYETDOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 23:14:53 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1828807wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2008 20:14:52 -0700 (PDT)
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Cc: dwmw2@infradead.org, carrano@laptop.org, dilinger@queued.net
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 17 May 2008 21:01:24 -0700
Subject: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Message-ID: <4832422a.20018e0a.6b37.3217@mx.google.com> (sfid-20080520_051456_175552_614327E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will create the following sysfs directories:
/sys/class/net/ethX
		...
		|-- boot_options
		|   |-- bootflag
		|   `-- boottime
		...
		|-- mesh_ie
		|   |-- capability
		|   |-- mesh_id
		|   |-- metric_id
		|   `-- protocol_id

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/Makefile     |    1 +
 drivers/net/wireless/libertas/defs.h       |    4 +-
 drivers/net/wireless/libertas/main.c       |    3 +
 drivers/net/wireless/libertas/persistcfg.c |  422 ++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/persistcfg.h |    5 +
 5 files changed, 434 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/libertas/persistcfg.c
 create mode 100644 drivers/net/wireless/libertas/persistcfg.h

diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index f0724e3..09b6353 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -3,6 +3,7 @@ libertas-objs := main.o wext.o \
 		cmdresp.o scan.o	  \
 		11d.o 		  \
 		debugfs.o	  \
+		persistcfg.o	\
 		ethtool.o assoc.o
 
 usb8xxx-objs += if_usb.o
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 0120d6c..4a7f936 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -40,6 +40,7 @@
 #define LBS_DEB_THREAD	0x00100000
 #define LBS_DEB_HEX	0x00200000
 #define LBS_DEB_SDIO	0x00400000
+#define LBS_DEB_SYSFS	0x00800000
 
 extern unsigned int lbs_debug;
 
@@ -81,7 +82,8 @@ do { if ((lbs_debug & (grp)) == (grp)) \
 #define lbs_deb_usbd(dev, fmt, args...) LBS_DEB_LL(LBS_DEB_USB, " usbd", "%s:" fmt, (dev)->bus_id, ##args)
 #define lbs_deb_cs(fmt, args...)        LBS_DEB_LL(LBS_DEB_CS, " cs", fmt, ##args)
 #define lbs_deb_thread(fmt, args...)    LBS_DEB_LL(LBS_DEB_THREAD, " thread", fmt, ##args)
-#define lbs_deb_sdio(fmt, args...)      LBS_DEB_LL(LBS_DEB_SDIO, " thread", fmt, ##args)
+#define lbs_deb_sdio(fmt, args...)      LBS_DEB_LL(LBS_DEB_SDIO, " sdio", fmt, ##args)
+#define lbs_deb_sysfs(fmt, args...)     LBS_DEB_LL(LBS_DEB_SYSFS, " sysfs", fmt, ##args)
 
 #define lbs_pr_info(format, args...) \
 	printk(KERN_INFO DRV_NAME": " format, ## args)
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 5001888..27769cb 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -23,6 +23,7 @@
 #include "scan.h"
 #include "assoc.h"
 #include "cmd.h"
+#include "persistcfg.h"
 
 #define DRIVER_RELEASE_VERSION "323.p0"
 const char lbs_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
@@ -1218,6 +1219,7 @@ int lbs_start_card(struct lbs_private *priv)
 	if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 		lbs_pr_err("cannot register lbs_rtap attribute\n");
 
+	lbs_persist_config_init(dev);
 	lbs_update_channel(priv);
 
 	/* 5.0.16p0 is known to NOT support any mesh */
@@ -1278,6 +1280,7 @@ int lbs_stop_card(struct lbs_private *priv)
 
 	lbs_debugfs_remove_one(priv);
 	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
+	lbs_persist_config_remove(dev);
 	if (priv->mesh_tlv)
 		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
 
diff --git a/drivers/net/wireless/libertas/persistcfg.c b/drivers/net/wireless/libertas/persistcfg.c
new file mode 100644
index 0000000..bd7a47a
--- /dev/null
+++ b/drivers/net/wireless/libertas/persistcfg.c
@@ -0,0 +1,422 @@
+#include <linux/moduleparam.h>
+#include <linux/delay.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
+#include <linux/if_arp.h>
+#include <linux/kthread.h>
+#include <linux/kfifo.h>
+
+#include "host.h"
+#include "decl.h"
+#include "dev.h"
+#include "wext.h"
+#include "debugfs.h"
+#include "scan.h"
+#include "assoc.h"
+#include "cmd.h"
+#include "persistcfg.h"
+
+static int mesh_get_default_parameters(struct device *dev,
+		struct mrvl_mesh_defaults *defs)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	struct cmd_ds_mesh_config cmd;
+	int ret;
+
+	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
+			CMD_TYPE_MESH_GET_DEFAULTS);
+
+	if (ret)
+		return -EOPNOTSUPP;
+
+	memcpy(defs, &cmd.data[0], sizeof(struct mrvl_mesh_defaults));
+
+	return 0;
+}
+
+/**
+ * @brief Get function for sysfs attribute bootflag
+ */
+static ssize_t bootflag_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 12, "0x%X\n",
+		le32_to_cpu(cpu_to_le32(defs.bootflag)));
+}
+
+/**
+ * @brief Set function for sysfs attribute bootflag
+ */
+static ssize_t bootflag_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	struct cmd_ds_mesh_config cmd;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%x", &datum);
+	if (ret != 1)
+		return -EINVAL;
+
+	*((uint32_t *)&cmd.data[0]) = cpu_to_le32(!!datum);
+	cmd.length = cpu_to_le16(sizeof(uint32_t));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+					CMD_TYPE_MESH_SET_BOOTFLAG);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute boottime
+ */
+static ssize_t boottime_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults *defs;
+	int ret;
+
+	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
+			CMD_TYPE_MESH_GET_DEFAULTS);
+
+	if (ret)
+		return -EOPNOTSUPP;
+
+	defs = (struct mrvl_mesh_defaults *)&cmd.data[0];
+
+	return snprintf(buf, 12, "0x%X\n", le32_to_cpu(defs->boottime));
+}
+
+/**
+ * @brief Set function for sysfs attribute boottime
+ */
+static ssize_t boottime_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	struct cmd_ds_mesh_config cmd;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%x", &datum);
+	if (ret != 1)
+		return -EINVAL;
+
+	/* A too small boot time will result in the device booting into
+	 * standalone (no-host) mode before the host can take control of it,
+	 * so the change will be hard to revert.  This may be a desired
+	 * feature (e.g to configure a very fast boot time for devices that
+	 * will not be attached to a host), but dangerous.  So I'm enforcing a
+	 * lower limit of 20 seconds:  remove and recompile the driver if this
+	 * does not work for you.
+	 */
+	datum = (datum < 20) ? 20 : datum;
+	cmd.data[0] = (uint8_t) datum;
+	cmd.length = cpu_to_le16(sizeof(uint8_t));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+					CMD_TYPE_MESH_SET_BOOTTIME);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute mesh_id
+ */
+static ssize_t mesh_id_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int maxlen;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	if (defs.meshie.val.mesh_id_len > IW_ESSID_MAX_SIZE) {
+		printk(KERN_ERR "Inconsistent mesh ID length");
+		defs.meshie.val.mesh_id_len = IW_ESSID_MAX_SIZE;
+	}
+
+	/* SSID not null terminated: reserve room for \0 + \n */
+	maxlen = defs.meshie.val.mesh_id_len + 2;
+	maxlen = (PAGE_SIZE > maxlen) ? maxlen : PAGE_SIZE;
+
+	defs.meshie.val.mesh_id[defs.meshie.val.mesh_id_len] = '\0';
+
+
+	return snprintf(buf, maxlen, "%s\n", defs.meshie.val.mesh_id);
+}
+
+/**
+ * @brief Set function for sysfs attribute mesh_id
+ */
+static ssize_t mesh_id_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	int len;
+	int ret;
+
+	if (count < 2 || count > IW_ESSID_MAX_SIZE + 1)
+		return -EINVAL;
+
+	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	memcpy((uint8_t *) ie, (uint8_t *) &defs.meshie,
+						sizeof(struct mrvl_meshie));
+
+	len = count - 1;
+	memcpy(ie->val.mesh_id, buf, len);
+	/* SSID len */
+	ie->val.mesh_id_len = len;
+	/* IE len */
+	ie->hdr.len = sizeof(struct mrvl_meshie_val) - IW_ESSID_MAX_SIZE +
+		len;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+					CMD_TYPE_MESH_SET_MESH_IE);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute protocol_id
+ */
+static ssize_t protocol_id_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 5, "%d\n", defs.meshie.val.active_protocol_id);
+}
+
+/**
+ * @brief Set function for sysfs attribute protocol_id
+ */
+static ssize_t protocol_id_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%x", &datum);
+	if (ret != 1)
+		return -EINVAL;
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+	memcpy((uint8_t *) ie, (uint8_t *) &defs.meshie,
+						sizeof(struct mrvl_meshie));
+	/* update protocol id */
+	ie->val.active_protocol_id = (uint8_t) datum;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+					CMD_TYPE_MESH_SET_MESH_IE);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute metric_id
+ */
+static ssize_t metric_id_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 5, "%d\n", defs.meshie.val.active_metric_id);
+}
+
+/**
+ * @brief Set function for sysfs attribute metric_id
+ */
+static ssize_t metric_id_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%x", &datum);
+	if (ret != 1)
+		return -EINVAL;
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+	memcpy((uint8_t *) ie, (uint8_t *) &defs.meshie,
+						sizeof(struct mrvl_meshie));
+	/* update protocol id */
+	ie->val.active_metric_id = (uint8_t) datum;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+					CMD_TYPE_MESH_SET_MESH_IE);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute capability
+ */
+static ssize_t capability_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 5, "%d\n", defs.meshie.val.mesh_capability);
+}
+
+/**
+ * @brief Set function for sysfs attribute capability
+ */
+static ssize_t capability_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%x", &datum);
+	if (ret != 1)
+		return -EINVAL;
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+	memcpy((uint8_t *) ie, (uint8_t *) &defs.meshie,
+						sizeof(struct mrvl_meshie));
+	/* update value */
+	ie->val.mesh_capability = (uint8_t) datum;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+					CMD_TYPE_MESH_SET_MESH_IE);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+
+static DEVICE_ATTR(bootflag, 0644, bootflag_get, bootflag_set);
+static DEVICE_ATTR(boottime, 0644, boottime_get, boottime_set);
+static DEVICE_ATTR(mesh_id, 0644, mesh_id_get, mesh_id_set);
+static DEVICE_ATTR(protocol_id, 0644, protocol_id_get, protocol_id_set);
+static DEVICE_ATTR(metric_id, 0644, metric_id_get, metric_id_set);
+static DEVICE_ATTR(capability, 0644, capability_get, capability_set);
+
+static struct attribute *boot_opts_attrs[] = {
+	&dev_attr_bootflag.attr,
+	&dev_attr_boottime.attr,
+	NULL
+};
+
+static struct attribute_group boot_opts_group = {
+	.name = "boot_options",
+	.attrs = boot_opts_attrs,
+};
+
+static struct attribute *mesh_ie_attrs[] = {
+	&dev_attr_mesh_id.attr,
+	&dev_attr_protocol_id.attr,
+	&dev_attr_metric_id.attr,
+	&dev_attr_capability.attr,
+	NULL
+};
+
+static struct attribute_group mesh_ie_group = {
+	.name = "mesh_ie",
+	.attrs = mesh_ie_attrs,
+};
+
+void lbs_persist_config_init(struct net_device *dev)
+{
+	int ret;
+	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
+	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
+}
+
+void lbs_persist_config_remove(struct net_device *dev)
+{
+	sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
+	sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
+}
diff --git a/drivers/net/wireless/libertas/persistcfg.h b/drivers/net/wireless/libertas/persistcfg.h
new file mode 100644
index 0000000..6ab9ff6
--- /dev/null
+++ b/drivers/net/wireless/libertas/persistcfg.h
@@ -0,0 +1,5 @@
+#ifndef _LBS_PERSISTCFG_H_
+#define _LBS_PERSISTCFG_H_
+void lbs_persist_config_init(struct net_device *net);
+void lbs_persist_config_remove(struct net_device *net);
+#endif
-- 
1.5.2.4



