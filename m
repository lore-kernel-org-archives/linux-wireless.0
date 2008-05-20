Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYETXnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 19:43:09 -0400
Subject: [PATCH] libertas: sysfs interface for accessing default mesh
	channel
From: David Woodhouse <dwmw2@infradead.org>
To: linville@tuxdriver.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	javier@cozybit.com
Content-Type: text/plain
Date: Wed, 21 May 2008 00:43:11 +0100
Message-Id: <1211326991.2561.24.camel@shinybook.infradead.org> (sfid-20080521_014325_321624_4386B769)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This will create the following entry:
/sys/class/net/mshX
            -- boot_options
            |   |-- ...
            |   `-- channel
            ...

... which I overlooked on my previous patch.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

---
Added to git://git.infradead.org/~dwmw2/libertas-2.6.git
(from which I dropped the OLPC reset patch which Andres is going to improve on)

diff --git a/drivers/net/wireless/libertas/persistcfg.c b/drivers/net/wireless/libertas/persistcfg.c
index baa6627..6cf5e39 100644
--- a/drivers/net/wireless/libertas/persistcfg.c
+++ b/drivers/net/wireless/libertas/persistcfg.c
@@ -130,6 +130,49 @@ static ssize_t boottime_set(struct device *dev,
 }
 
 /**
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
+	return snprintf(buf, 12, "0x%x\n", le16_to_cpu(defs.channel));
+}
+
+/**
+ * @brief Set function for sysfs attribute channel
+ */
+static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
+	struct cmd_ds_mesh_config cmd;
+	uint16_t datum;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ret = sscanf(buf, "%hx", &datum);
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
  * @brief Get function for sysfs attribute mesh_id
  */
 static ssize_t mesh_id_get(struct device *dev, struct device_attribute *attr,
@@ -365,6 +408,7 @@ static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(bootflag, 0644, bootflag_get, bootflag_set);
 static DEVICE_ATTR(boottime, 0644, boottime_get, boottime_set);
+static DEVICE_ATTR(channel, 0644, channel_get, channel_set);
 static DEVICE_ATTR(mesh_id, 0644, mesh_id_get, mesh_id_set);
 static DEVICE_ATTR(protocol_id, 0644, protocol_id_get, protocol_id_set);
 static DEVICE_ATTR(metric_id, 0644, metric_id_get, metric_id_set);
@@ -373,6 +417,7 @@ static DEVICE_ATTR(capability, 0644, capability_get, capability_set);
 static struct attribute *boot_opts_attrs[] = {
 	&dev_attr_bootflag.attr,
 	&dev_attr_boottime.attr,
+	&dev_attr_channel.attr,
 	NULL
 };
 

-- 
dwmw2

