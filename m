Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41002 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab1HPRgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 13:36:10 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 16 Aug 2011 19:35:56 +0200
Subject: [PATCH 1/4] NFC: Add NFC dev_up and dev_down control operations
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com> (sfid-20110816_193613_865312_A3F7CC29)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following 2 NFC control operations (via generic netlink) were added:
	- Dev_up, which turn on the NFC controller (this operation may take a 	few seconds, as it can download new FW to the NFC controller)
	- Dev_down, which turn off the NFC controller

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/pn533.c |    2 +
 include/linux/nfc.h |    6 ++++
 include/net/nfc.h   |    3 ++
 net/nfc/core.c      |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/netlink.c   |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h       |    4 +++
 6 files changed, 148 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index c77e054..d931e9c 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1445,6 +1445,8 @@ static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 }
 
 struct nfc_ops pn533_nfc_ops = {
+	.dev_up = NULL,
+	.dev_down = NULL,
 	.start_poll = pn533_start_poll,
 	.stop_poll = pn533_stop_poll,
 	.activate_target = pn533_activate_target,
diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 330a4c5..2056969 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -39,6 +39,10 @@
  *
  * @NFC_CMD_GET_DEVICE: request information about a device (requires
  *	%NFC_ATTR_DEVICE_INDEX) or dump request to get a list of all nfc devices
+ * @NFC_CMD_DEV_UP: turn on the nfc device
+ *	(requires %NFC_ATTR_DEVICE_INDEX)
+ * @NFC_CMD_DEV_DOWN: turn off the nfc device
+ *	(requires %NFC_ATTR_DEVICE_INDEX)
  * @NFC_CMD_START_POLL: start polling for targets using the given protocols
  *	(requires %NFC_ATTR_DEVICE_INDEX and %NFC_ATTR_PROTOCOLS)
  * @NFC_CMD_STOP_POLL: stop polling for targets (requires
@@ -56,6 +60,8 @@
 enum nfc_commands {
 	NFC_CMD_UNSPEC,
 	NFC_CMD_GET_DEVICE,
+	NFC_CMD_DEV_UP,
+	NFC_CMD_DEV_DOWN,
 	NFC_CMD_START_POLL,
 	NFC_CMD_STOP_POLL,
 	NFC_CMD_GET_TARGET,
diff --git a/include/net/nfc.h b/include/net/nfc.h
index cc01303..5ee60de 100644
--- a/include/net/nfc.h
+++ b/include/net/nfc.h
@@ -48,6 +48,8 @@ typedef void (*data_exchange_cb_t)(void *context, struct sk_buff *skb,
 								int err);
 
 struct nfc_ops {
+	int (*dev_up)(struct nfc_dev *dev);
+	int (*dev_down)(struct nfc_dev *dev);
 	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
 	void (*stop_poll)(struct nfc_dev *dev);
 	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
@@ -78,6 +80,7 @@ struct nfc_dev {
 	int targets_generation;
 	spinlock_t targets_lock;
 	struct device dev;
+	bool dev_up;
 	bool polling;
 	struct nfc_genl_data genl_data;
 	u32 supported_protocols;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index b6fd4e1..b9cc7b9 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -53,6 +53,75 @@ int nfc_printk(const char *level, const char *format, ...)
 EXPORT_SYMBOL(nfc_printk);
 
 /**
+ * nfc_dev_up - turn on the NFC device
+ *
+ * @dev: The nfc device to be turned on
+ *
+ * The device remains up until the nfc_dev_down function is called.
+ */
+int nfc_dev_up(struct nfc_dev *dev)
+{
+	int rc = 0;
+
+	nfc_dbg("dev_name=%s", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (dev->dev_up) {
+		rc = -EALREADY;
+		goto error;
+	}
+
+	if (dev->ops->dev_up)
+		rc = dev->ops->dev_up(dev);
+
+	if (!rc)
+		dev->dev_up = true;
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
+ * nfc_dev_down - turn off the NFC device
+ *
+ * @dev: The nfc device to be turned off
+ */
+int nfc_dev_down(struct nfc_dev *dev)
+{
+	int rc = 0;
+
+	nfc_dbg("dev_name=%s", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (!dev->dev_up) {
+		rc = -EINVAL;
+		goto error;
+	}
+
+	if (dev->ops->dev_down)
+		dev->ops->dev_down(dev);
+
+	dev->dev_up = false;
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
  * nfc_start_poll - start polling for nfc targets
  *
  * @dev: The nfc device that must start polling
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index ccdff79..4e572b4 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -367,6 +367,60 @@ out_putdev:
 	return rc;
 }
 
+static int nfc_genl_dev_up(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	int rc;
+	u32 idx;
+
+	nfc_dbg("entry");
+
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+		return -EINVAL;
+
+	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
+
+	dev = nfc_get_device(idx);
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->genl_data.genl_data_mutex);
+
+	rc = nfc_dev_up(dev);
+
+	mutex_unlock(&dev->genl_data.genl_data_mutex);
+
+	nfc_put_device(dev);
+	return rc;
+}
+
+static int nfc_genl_dev_down(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	int rc;
+	u32 idx;
+
+	nfc_dbg("entry");
+
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+		return -EINVAL;
+
+	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
+
+	dev = nfc_get_device(idx);
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->genl_data.genl_data_mutex);
+
+	rc = nfc_dev_down(dev);
+
+	mutex_unlock(&dev->genl_data.genl_data_mutex);
+
+	nfc_put_device(dev);
+	return rc;
+}
+
 static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nfc_dev *dev;
@@ -441,6 +495,16 @@ static struct genl_ops nfc_genl_ops[] = {
 		.policy = nfc_genl_policy,
 	},
 	{
+		.cmd = NFC_CMD_DEV_UP,
+		.doit = nfc_genl_dev_up,
+		.policy = nfc_genl_policy,
+	},
+	{
+		.cmd = NFC_CMD_DEV_DOWN,
+		.doit = nfc_genl_dev_down,
+		.policy = nfc_genl_policy,
+	},
+	{
 		.cmd = NFC_CMD_START_POLL,
 		.doit = nfc_genl_start_poll,
 		.policy = nfc_genl_policy,
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index aaf9832..1a877de 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -101,6 +101,10 @@ static inline void nfc_device_iter_exit(struct class_dev_iter *iter)
 	class_dev_iter_exit(iter);
 }
 
+int nfc_dev_up(struct nfc_dev *dev);
+
+int nfc_dev_down(struct nfc_dev *dev);
+
 int nfc_start_poll(struct nfc_dev *dev, u32 protocols);
 
 int nfc_stop_poll(struct nfc_dev *dev);
-- 
1.7.0.4
