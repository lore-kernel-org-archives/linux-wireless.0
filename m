Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:40107 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYLIXbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 18:31:03 -0500
Received: by qyk4 with SMTP id 4so396424qyk.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 15:30:58 -0800 (PST)
Message-ID: <493effb1.0610c00a.3f59.7990@mx.google.com> (sfid-20081210_003106_447798_714E22AE)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
From: Anna Neal <anna@cozybit.com>
Date: Tue, 9 Dec 2008 13:23:45 -0800
Subject: [PATCH] libertas: Create sysfs entry for changing the mesh probe response limit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to change the number of probe response retries sent
by the mesh interface.

In dense networks it is recommended to change this value to zero to reduce
traffic congestion.

Signed-off-by: Anna Neal <anna@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/host.h |    1 +
 drivers/net/wireless/libertas/main.c |   60 ++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index a17b778..277ff19 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -245,6 +245,7 @@ enum cmd_mesh_access_opts {
 	CMD_ACT_MESH_GET_ROUTE_EXP,
 	CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
 	CMD_ACT_MESH_GET_AUTOSTART_ENABLED,
+	CMD_ACT_MESH_SET_GET_PRB_RSP_LIMIT = 17,
 };
 
 /* Define actions and types for CMD_MESH_CONFIG */
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index c320264..f7caef9 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -257,6 +257,58 @@ static ssize_t lbs_anycast_set(struct device *dev,
 	return strlen(buf);
 }
 
+/**
+ * @brief Get function for sysfs attribute prb_rsp_limit
+ */
+static ssize_t lbs_prb_rsp_limit_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lbs_private *priv = to_net_dev(dev)->priv;
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
+	struct lbs_private *priv = to_net_dev(dev)->priv;
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
 static int lbs_add_rtap(struct lbs_private *priv);
 static void lbs_remove_rtap(struct lbs_private *priv);
 static int lbs_add_mesh(struct lbs_private *priv);
@@ -375,8 +427,16 @@ static DEVICE_ATTR(lbs_mesh, 0644, lbs_mesh_get, lbs_mesh_set);
  */
 static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
 
+/**
+ * prb_rsp_limit attribute to be exported per mshX interface
+ * through sysfs (/sys/class/net/mshX/prb_rsp_limit)
+ */
+static DEVICE_ATTR(prb_rsp_limit, 0644, lbs_prb_rsp_limit_get,
+		lbs_prb_rsp_limit_set);
+
 static struct attribute *lbs_mesh_sysfs_entries[] = {
 	&dev_attr_anycast_mask.attr,
+	&dev_attr_prb_rsp_limit.attr,
 	NULL,
 };
 
-- 
1.5.6.3



