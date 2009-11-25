Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17997 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbZKYMJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 07:09:05 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 1/5] libertas: rename mesh.c into persistcfg.c
Date: Wed, 25 Nov 2009 13:08:55 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911251308.55837.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mesh.c will be the file where we concentrate all mesh-related
code. This allows us to either add a KConfig entry for mesh and
makes matters easier for the cfg80211 transition.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>
---

This is the equivalent of "git mv persistcfg.c mesh.c" and fixing up the Makefile

 drivers/net/wireless/libertas/Makefile     |    2 +-
 drivers/net/wireless/libertas/mesh.c       |  453 ++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/persistcfg.c |  453 ----------------------------
 3 files changed, 454 insertions(+), 454 deletions(-)
 create mode 100644 drivers/net/wireless/libertas/mesh.c
 delete mode 100644 drivers/net/wireless/libertas/persistcfg.c

diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index fa37039..b188cd9 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -5,7 +5,7 @@ libertas-y += cmdresp.o
 libertas-y += debugfs.o
 libertas-y += ethtool.o
 libertas-y += main.o
-libertas-y += persistcfg.o
+libertas-y += mesh.o
 libertas-y += rx.o
 libertas-y += scan.o
 libertas-y += tx.o
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
new file mode 100644
index 0000000..871f914
--- /dev/null
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -0,0 +1,453 @@
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
+
+static int mesh_get_default_parameters(struct device *dev,
+				       struct mrvl_mesh_defaults *defs)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_config cmd;
+	int ret;
+
+	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
+				   CMD_TYPE_MESH_GET_DEFAULTS);
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
+			    struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 12, "%d\n", le32_to_cpu(defs.bootflag));
+}
+
+/**
+ * @brief Set function for sysfs attribute bootflag
+ */
+static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_config cmd;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%d", &datum);
+	if ((ret != 1) || (datum > 1))
+		return -EINVAL;
+
+	*((__le32 *)&cmd.data[0]) = cpu_to_le32(!!datum);
+	cmd.length = cpu_to_le16(sizeof(uint32_t));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_BOOTFLAG);
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
+			    struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 12, "%d\n", defs.boottime);
+}
+
+/**
+ * @brief Set function for sysfs attribute boottime
+ */
+static ssize_t boottime_set(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_config cmd;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%d", &datum);
+	if ((ret != 1) || (datum > 255))
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
+	cmd.data[0] = datum;
+	cmd.length = cpu_to_le16(sizeof(uint8_t));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_BOOTTIME);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute channel
+ */
+static ssize_t channel_get(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct mrvl_mesh_defaults defs;
+	int ret;
+
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	if (ret)
+		return ret;
+
+	return snprintf(buf, 12, "%d\n", le16_to_cpu(defs.channel));
+}
+
+/**
+ * @brief Set function for sysfs attribute channel
+ */
+static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	struct cmd_ds_mesh_config cmd;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%d", &datum);
+	if (ret != 1 || datum < 1 || datum > 11)
+		return -EINVAL;
+
+	*((__le16 *)&cmd.data[0]) = cpu_to_le16(datum);
+	cmd.length = cpu_to_le16(sizeof(uint16_t));
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_DEF_CHANNEL);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+/**
+ * @brief Get function for sysfs attribute mesh_id
+ */
+static ssize_t mesh_id_get(struct device *dev, struct device_attribute *attr,
+			   char *buf)
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
+	if (defs.meshie.val.mesh_id_len > IEEE80211_MAX_SSID_LEN) {
+		lbs_pr_err("inconsistent mesh ID length");
+		defs.meshie.val.mesh_id_len = IEEE80211_MAX_SSID_LEN;
+	}
+
+	/* SSID not null terminated: reserve room for \0 + \n */
+	maxlen = defs.meshie.val.mesh_id_len + 2;
+	maxlen = (PAGE_SIZE > maxlen) ? maxlen : PAGE_SIZE;
+
+	defs.meshie.val.mesh_id[defs.meshie.val.mesh_id_len] = '\0';
+
+	return snprintf(buf, maxlen, "%s\n", defs.meshie.val.mesh_id);
+}
+
+/**
+ * @brief Set function for sysfs attribute mesh_id
+ */
+static ssize_t mesh_id_set(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	int len;
+	int ret;
+
+	if (count < 2 || count > IEEE80211_MAX_SSID_LEN + 1)
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
+	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
+
+	len = count - 1;
+	memcpy(ie->val.mesh_id, buf, len);
+	/* SSID len */
+	ie->val.mesh_id_len = len;
+	/* IE len */
+	ie->len = sizeof(struct mrvl_meshie_val) - IEEE80211_MAX_SSID_LEN + len;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_MESH_IE);
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
+			       struct device_attribute *attr, char *buf)
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
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%d", &datum);
+	if ((ret != 1) || (datum > 255))
+		return -EINVAL;
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
+	/* update protocol id */
+	ie->val.active_protocol_id = datum;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_MESH_IE);
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
+static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%d", &datum);
+	if ((ret != 1) || (datum > 255))
+		return -EINVAL;
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
+	/* update metric id */
+	ie->val.active_metric_id = datum;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_MESH_IE);
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
+static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_mesh_defaults defs;
+	struct mrvl_meshie *ie;
+	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
+	uint32_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%d", &datum);
+	if ((ret != 1) || (datum > 255))
+		return -EINVAL;
+
+	/* fetch all other Information Element parameters */
+	ret = mesh_get_default_parameters(dev, &defs);
+
+	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
+
+	/* transfer IE elements */
+	ie = (struct mrvl_meshie *) &cmd.data[0];
+	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
+	/* update value */
+	ie->val.mesh_capability = datum;
+
+	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
+				   CMD_TYPE_MESH_SET_MESH_IE);
+	if (ret)
+		return ret;
+
+	return strlen(buf);
+}
+
+
+static DEVICE_ATTR(bootflag, 0644, bootflag_get, bootflag_set);
+static DEVICE_ATTR(boottime, 0644, boottime_get, boottime_set);
+static DEVICE_ATTR(channel, 0644, channel_get, channel_set);
+static DEVICE_ATTR(mesh_id, 0644, mesh_id_get, mesh_id_set);
+static DEVICE_ATTR(protocol_id, 0644, protocol_id_get, protocol_id_set);
+static DEVICE_ATTR(metric_id, 0644, metric_id_get, metric_id_set);
+static DEVICE_ATTR(capability, 0644, capability_get, capability_set);
+
+static struct attribute *boot_opts_attrs[] = {
+	&dev_attr_bootflag.attr,
+	&dev_attr_boottime.attr,
+	&dev_attr_channel.attr,
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
diff --git a/drivers/net/wireless/libertas/persistcfg.c b/drivers/net/wireless/libertas/persistcfg.c
deleted file mode 100644
index 871f914..0000000
--- a/drivers/net/wireless/libertas/persistcfg.c
+++ /dev/null
@@ -1,453 +0,0 @@
-#include <linux/moduleparam.h>
-#include <linux/delay.h>
-#include <linux/etherdevice.h>
-#include <linux/netdevice.h>
-#include <linux/if_arp.h>
-#include <linux/kthread.h>
-#include <linux/kfifo.h>
-
-#include "host.h"
-#include "decl.h"
-#include "dev.h"
-#include "wext.h"
-#include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
-#include "cmd.h"
-
-static int mesh_get_default_parameters(struct device *dev,
-				       struct mrvl_mesh_defaults *defs)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	int ret;
-
-	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
-				   CMD_TYPE_MESH_GET_DEFAULTS);
-
-	if (ret)
-		return -EOPNOTSUPP;
-
-	memcpy(defs, &cmd.data[0], sizeof(struct mrvl_mesh_defaults));
-
-	return 0;
-}
-
-/**
- * @brief Get function for sysfs attribute bootflag
- */
-static ssize_t bootflag_get(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 12, "%d\n", le32_to_cpu(defs.bootflag));
-}
-
-/**
- * @brief Set function for sysfs attribute bootflag
- */
-static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 1))
-		return -EINVAL;
-
-	*((__le32 *)&cmd.data[0]) = cpu_to_le32(!!datum);
-	cmd.length = cpu_to_le16(sizeof(uint32_t));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_BOOTFLAG);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute boottime
- */
-static ssize_t boottime_get(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 12, "%d\n", defs.boottime);
-}
-
-/**
- * @brief Set function for sysfs attribute boottime
- */
-static ssize_t boottime_set(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 255))
-		return -EINVAL;
-
-	/* A too small boot time will result in the device booting into
-	 * standalone (no-host) mode before the host can take control of it,
-	 * so the change will be hard to revert.  This may be a desired
-	 * feature (e.g to configure a very fast boot time for devices that
-	 * will not be attached to a host), but dangerous.  So I'm enforcing a
-	 * lower limit of 20 seconds:  remove and recompile the driver if this
-	 * does not work for you.
-	 */
-	datum = (datum < 20) ? 20 : datum;
-	cmd.data[0] = datum;
-	cmd.length = cpu_to_le16(sizeof(uint8_t));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_BOOTTIME);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute channel
- */
-static ssize_t channel_get(struct device *dev,
-			   struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 12, "%d\n", le16_to_cpu(defs.channel));
-}
-
-/**
- * @brief Set function for sysfs attribute channel
- */
-static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if (ret != 1 || datum < 1 || datum > 11)
-		return -EINVAL;
-
-	*((__le16 *)&cmd.data[0]) = cpu_to_le16(datum);
-	cmd.length = cpu_to_le16(sizeof(uint16_t));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_DEF_CHANNEL);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute mesh_id
- */
-static ssize_t mesh_id_get(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int maxlen;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	if (defs.meshie.val.mesh_id_len > IEEE80211_MAX_SSID_LEN) {
-		lbs_pr_err("inconsistent mesh ID length");
-		defs.meshie.val.mesh_id_len = IEEE80211_MAX_SSID_LEN;
-	}
-
-	/* SSID not null terminated: reserve room for \0 + \n */
-	maxlen = defs.meshie.val.mesh_id_len + 2;
-	maxlen = (PAGE_SIZE > maxlen) ? maxlen : PAGE_SIZE;
-
-	defs.meshie.val.mesh_id[defs.meshie.val.mesh_id_len] = '\0';
-
-	return snprintf(buf, maxlen, "%s\n", defs.meshie.val.mesh_id);
-}
-
-/**
- * @brief Set function for sysfs attribute mesh_id
- */
-static ssize_t mesh_id_set(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	int len;
-	int ret;
-
-	if (count < 2 || count > IEEE80211_MAX_SSID_LEN + 1)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-
-	len = count - 1;
-	memcpy(ie->val.mesh_id, buf, len);
-	/* SSID len */
-	ie->val.mesh_id_len = len;
-	/* IE len */
-	ie->len = sizeof(struct mrvl_meshie_val) - IEEE80211_MAX_SSID_LEN + len;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute protocol_id
- */
-static ssize_t protocol_id_get(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 5, "%d\n", defs.meshie.val.active_protocol_id);
-}
-
-/**
- * @brief Set function for sysfs attribute protocol_id
- */
-static ssize_t protocol_id_set(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 255))
-		return -EINVAL;
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-	/* update protocol id */
-	ie->val.active_protocol_id = datum;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute metric_id
- */
-static ssize_t metric_id_get(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 5, "%d\n", defs.meshie.val.active_metric_id);
-}
-
-/**
- * @brief Set function for sysfs attribute metric_id
- */
-static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 255))
-		return -EINVAL;
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-	/* update metric id */
-	ie->val.active_metric_id = datum;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * @brief Get function for sysfs attribute capability
- */
-static ssize_t capability_get(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return snprintf(buf, 5, "%d\n", defs.meshie.val.mesh_capability);
-}
-
-/**
- * @brief Set function for sysfs attribute capability
- */
-static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 255))
-		return -EINVAL;
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-	/* update value */
-	ie->val.mesh_capability = datum;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-
-static DEVICE_ATTR(bootflag, 0644, bootflag_get, bootflag_set);
-static DEVICE_ATTR(boottime, 0644, boottime_get, boottime_set);
-static DEVICE_ATTR(channel, 0644, channel_get, channel_set);
-static DEVICE_ATTR(mesh_id, 0644, mesh_id_get, mesh_id_set);
-static DEVICE_ATTR(protocol_id, 0644, protocol_id_get, protocol_id_set);
-static DEVICE_ATTR(metric_id, 0644, metric_id_get, metric_id_set);
-static DEVICE_ATTR(capability, 0644, capability_get, capability_set);
-
-static struct attribute *boot_opts_attrs[] = {
-	&dev_attr_bootflag.attr,
-	&dev_attr_boottime.attr,
-	&dev_attr_channel.attr,
-	NULL
-};
-
-static struct attribute_group boot_opts_group = {
-	.name = "boot_options",
-	.attrs = boot_opts_attrs,
-};
-
-static struct attribute *mesh_ie_attrs[] = {
-	&dev_attr_mesh_id.attr,
-	&dev_attr_protocol_id.attr,
-	&dev_attr_metric_id.attr,
-	&dev_attr_capability.attr,
-	NULL
-};
-
-static struct attribute_group mesh_ie_group = {
-	.name = "mesh_ie",
-	.attrs = mesh_ie_attrs,
-};
-
-void lbs_persist_config_init(struct net_device *dev)
-{
-	int ret;
-	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
-	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
-}
-
-void lbs_persist_config_remove(struct net_device *dev)
-{
-	sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
-	sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
-}
-- 
1.6.5.3


-- 
http://www.holgerschurig.de
