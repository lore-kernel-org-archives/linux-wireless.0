Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48906 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1IRIWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 04:22:19 -0400
Received: by gyg10 with SMTP id 10so3574299gyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:22:18 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v2 1/4 RESEND] NFC: Add dev_up and dev_down control operations
Date: Sun, 18 Sep 2011 11:19:33 +0300
Message-Id: <1316333976-30388-2-git-send-email-ilane@ti.com> (sfid-20110918_102223_358292_390A2019)
In-Reply-To: <1316333976-30388-1-git-send-email-ilane@ti.com>
References: <1316333976-30388-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Add 2 new nfc control operations:
dev_up to turn on the nfc device
dev_down to turn off the nfc device

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/pn533.c |    2 +
 include/linux/nfc.h |    6 ++++
 include/net/nfc.h   |    4 ++
 net/nfc/core.c      |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/netlink.c   |   56 +++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h       |    4 ++
 6 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index f81a93e..c78eb6a 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1432,6 +1432,8 @@ static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 }
 
 struct nfc_ops pn533_nfc_ops = {
+	.dev_up = NULL,
+	.dev_down = NULL,
 	.start_poll = pn533_start_poll,
 	.stop_poll = pn533_stop_poll,
 	.activate_target = pn533_activate_target,
diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index c525e0b..36cb955 100644
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
index 87b51fe..6a7f602 100644
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
@@ -78,7 +80,9 @@ struct nfc_dev {
 	int targets_generation;
 	spinlock_t targets_lock;
 	struct device dev;
+	bool dev_up;
 	bool polling;
+	bool remote_activated;
 	struct nfc_genl_data genl_data;
 	u32 supported_protocols;
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 284e2f6..47e02c1 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -53,6 +53,80 @@ int nfc_printk(const char *level, const char *format, ...)
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
+		rc = -EALREADY;
+		goto error;
+	}
+
+	if (dev->polling || dev->remote_activated) {
+		rc = -EBUSY;
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
@@ -144,6 +218,8 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 	}
 
 	rc = dev->ops->activate_target(dev, target_idx, protocol);
+	if (!rc)
+		dev->remote_activated = true;
 
 error:
 	device_unlock(&dev->dev);
@@ -170,6 +246,7 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx)
 	}
 
 	dev->ops->deactivate_target(dev, target_idx);
+	dev->remote_activated = false;
 
 error:
 	device_unlock(&dev->dev);
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index ccdff79..03f8818 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -367,6 +367,52 @@ out_putdev:
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
+	rc = nfc_dev_up(dev);
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
+	rc = nfc_dev_down(dev);
+
+	nfc_put_device(dev);
+	return rc;
+}
+
 static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nfc_dev *dev;
@@ -441,6 +487,16 @@ static struct genl_ops nfc_genl_ops[] = {
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

