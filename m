Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56714 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab1F1SVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:21:43 -0400
Received: by gxk21 with SMTP id 21so181684gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 11:21:43 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	padovan@profusion.mobi, rdunlap@xenotime.net,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH v4 1/6] NFC: add nfc subsystem core
Date: Tue, 28 Jun 2011 15:20:41 -0300
Message-Id: <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110628_203941_669173_C6E49B20)
In-Reply-To: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>

The NFC subsystem core is responsible for providing the device driver
interface. It is also responsible for providing an interface to the control
operations and data exchange.

Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/Kconfig      |    2 -
 drivers/Makefile     |    1 +
 drivers/nfc/Kconfig  |   16 +--
 drivers/nfc/Makefile |    2 +
 include/net/nfc.h    |  131 +++++++++++++++++++
 net/Kconfig          |    1 +
 net/Makefile         |    1 +
 net/nfc/Kconfig      |   16 +++
 net/nfc/Makefile     |    7 +
 net/nfc/core.c       |  344 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h        |   75 +++++++++++
 11 files changed, 581 insertions(+), 15 deletions(-)
 create mode 100644 include/net/nfc.h
 create mode 100644 net/nfc/Kconfig
 create mode 100644 net/nfc/Makefile
 create mode 100644 net/nfc/core.c
 create mode 100644 net/nfc/nfc.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 61631ed..a56b0b8 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -92,8 +92,6 @@ source "drivers/memstick/Kconfig"
 
 source "drivers/leds/Kconfig"
 
-source "drivers/nfc/Kconfig"
-
 source "drivers/accessibility/Kconfig"
 
 source "drivers/infiniband/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index a29527f..843cd31 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -120,3 +120,4 @@ obj-y				+= ieee802154/
 obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
+obj-$(CONFIG_NFC)		+= nfc/
diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index ea15800..7809289 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -2,17 +2,8 @@
 # Near Field Communication (NFC) devices
 #
 
-menuconfig NFC_DEVICES
-	bool "Near Field Communication (NFC) devices"
-	default n
-	---help---
-	  You'll have to say Y if your computer contains an NFC device that
-	  you want to use under Linux.
-
-	  You can say N here if you don't have any Near Field Communication
-	  devices connected to your computer.
-
-if NFC_DEVICES
+menu "Near Field Communication (NFC) devices"
+	depends on NFC
 
 config PN544_NFC
 	tristate "PN544 NFC driver"
@@ -26,5 +17,4 @@ config PN544_NFC
 	  To compile this driver as a module, choose m here. The module will
 	  be called pn544.
 
-
-endif # NFC_DEVICES
+endmenu
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index a4efb16..25296f0 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-$(CONFIG_PN544_NFC)		+= pn544.o
+
+ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/include/net/nfc.h b/include/net/nfc.h
new file mode 100644
index 0000000..11d63dc
--- /dev/null
+++ b/include/net/nfc.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2011 Instituto Nokia de Tecnologia
+ *
+ * Authors:
+ *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
+ *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __NET_NFC_H
+#define __NET_NFC_H
+
+#include <linux/device.h>
+#include <linux/skbuff.h>
+
+struct nfc_dev;
+
+/**
+ * data_exchange_cb_t - Definition of nfc_data_exchange callback
+ *
+ * @context: nfc_data_exchange cb_context parameter
+ * @skb: response data
+ * @err: If an error has occurred during data exchange, it is the
+ *	error number. Zero means no error.
+ *
+ * When a rx or tx package is lost or corrupted or the target gets out
+ * of the operating field, err is -EIO.
+ */
+typedef void (*data_exchange_cb_t)(void *context, struct sk_buff *skb,
+								int err);
+
+struct nfc_ops {
+	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
+	void (*stop_poll)(struct nfc_dev *dev);
+	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
+							u32 protocol);
+	void (*deactivate_target)(struct nfc_dev *dev, u32 target_idx);
+	int (*data_exchange)(struct nfc_dev *dev, u32 target_idx,
+				struct sk_buff *skb, data_exchange_cb_t cb,
+							void *cb_context);
+};
+
+struct nfc_dev {
+	unsigned idx;
+	struct device dev;
+	bool polling;
+	u32 supported_protocols;
+
+	struct nfc_ops *ops;
+};
+#define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
+
+extern struct class nfc_class;
+
+struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
+					u32 supported_protocols);
+
+/**
+ * nfc_free_device - free nfc device
+ *
+ * @dev: The nfc device to free
+ */
+static inline void nfc_free_device(struct nfc_dev *dev)
+{
+	put_device(&dev->dev);
+}
+
+int nfc_register_device(struct nfc_dev *dev);
+
+void nfc_unregister_device(struct nfc_dev *dev);
+
+/**
+ * nfc_set_parent_dev - set the parent device
+ *
+ * @nfc_dev: The nfc device whose parent is being set
+ * @dev: The parent device
+ */
+static inline void nfc_set_parent_dev(struct nfc_dev *nfc_dev,
+					struct device *dev)
+{
+	nfc_dev->dev.parent = dev;
+}
+
+/**
+ * nfc_set_drvdata - set driver specifc data
+ *
+ * @dev: The nfc device
+ * @data: Pointer to driver specifc data
+ */
+static inline void nfc_set_drvdata(struct nfc_dev *dev, void *data)
+{
+	dev_set_drvdata(&dev->dev, data);
+}
+
+/**
+ * nfc_get_drvdata - get driver specifc data
+ *
+ * @dev: The nfc device
+ */
+static inline void *nfc_get_drvdata(struct nfc_dev *dev)
+{
+	return dev_get_drvdata(&dev->dev);
+}
+
+/**
+ * nfc_device_name - get the nfc device name
+ *
+ * @dev: The nfc device whose name to return
+ */
+static inline const char *nfc_device_name(struct nfc_dev *dev)
+{
+	return dev_name(&dev->dev);
+}
+
+struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp);
+
+#endif /* __NET_NFC_H */
diff --git a/net/Kconfig b/net/Kconfig
index 878151c..a073148 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -322,6 +322,7 @@ source "net/rfkill/Kconfig"
 source "net/9p/Kconfig"
 source "net/caif/Kconfig"
 source "net/ceph/Kconfig"
+source "net/nfc/Kconfig"
 
 
 endif   # if NET
diff --git a/net/Makefile b/net/Makefile
index a51d946..acdde49 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -68,3 +68,4 @@ obj-$(CONFIG_WIMAX)		+= wimax/
 obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
 obj-$(CONFIG_CEPH_LIB)		+= ceph/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
+obj-$(CONFIG_NFC)		+= nfc/
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
new file mode 100644
index 0000000..33e095b
--- /dev/null
+++ b/net/nfc/Kconfig
@@ -0,0 +1,16 @@
+#
+# NFC sybsystem configuration
+#
+
+menuconfig NFC
+	depends on NET && EXPERIMENTAL
+	tristate "NFC subsystem support (EXPERIMENTAL)"
+	default n
+	help
+	  Say Y here if you want to build support for NFC (Near field
+	  communication) devices.
+
+	  To compile this support as a module, choose M here: the module will
+	  be called nfc.
+
+source "drivers/nfc/Kconfig"
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
new file mode 100644
index 0000000..28bee59
--- /dev/null
+++ b/net/nfc/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux NFC subsystem.
+#
+
+obj-$(CONFIG_NFC) += nfc.o
+
+nfc-objs := core.o
diff --git a/net/nfc/core.c b/net/nfc/core.c
new file mode 100644
index 0000000..992bbc5
--- /dev/null
+++ b/net/nfc/core.c
@@ -0,0 +1,344 @@
+/*
+ * Copyright (C) 2011 Instituto Nokia de Tecnologia
+ *
+ * Authors:
+ *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
+ *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "nfc.h"
+
+#define VERSION "0.1"
+
+int nfc_devlist_generation;
+DEFINE_MUTEX(nfc_devlist_mutex);
+
+/**
+ * nfc_start_poll - start polling for nfc targets
+ *
+ * @dev: The nfc device that must start polling
+ * @protocols: bitset of nfc protocols that must be used for polling
+ *
+ * The device remains polling for targets until a target is found or
+ * the nfc_stop_poll function is called.
+ */
+int nfc_start_poll(struct nfc_dev *dev, u32 protocols)
+{
+	int rc;
+
+	NFC_DBG("dev_name:%s protocols=0x%x", dev_name(&dev->dev), protocols);
+
+	if (!protocols)
+		return -EINVAL;
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (dev->polling) {
+		rc = -EBUSY;
+		goto error;
+	}
+
+	rc = dev->ops->start_poll(dev, protocols);
+	if (!rc)
+		dev->polling = true;
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
+ * nfc_stop_poll - stop polling for nfc targets
+ *
+ * @dev: The nfc device that must stop polling
+ */
+int nfc_stop_poll(struct nfc_dev *dev)
+{
+	int rc = 0;
+
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (!dev->polling) {
+		rc = -EINVAL;
+		goto error;
+	}
+
+	dev->ops->stop_poll(dev);
+	dev->polling = false;
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
+ * nfc_activate_target - prepare the target for data exchange
+ *
+ * @dev: The nfc device that found the target
+ * @target_idx: index of the target that must be activated
+ * @protocol: nfc protocol that will be used for data exchange
+ */
+int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
+{
+	int rc;
+
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	rc = dev->ops->activate_target(dev, target_idx, protocol);
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
+ * nfc_deactivate_target - deactivate a nfc target
+ *
+ * @dev: The nfc device that found the target
+ * @target_idx: index of the target that must be deactivated
+ */
+int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx)
+{
+	int rc = 0;
+
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	dev->ops->deactivate_target(dev, target_idx);
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
+ * nfc_data_exchange - transceive data
+ *
+ * @dev: The nfc device that found the target
+ * @target_idx: index of the target
+ * @skb: data to be sent
+ * @cb: callback called when the response is received
+ * @cb_context: parameter for the callback function
+ *
+ * The user must wait for the callback before calling this function again.
+ */
+int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx,
+					struct sk_buff *skb,
+					data_exchange_cb_t cb,
+					void *cb_context)
+{
+	int rc;
+
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
+
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
+		kfree_skb(skb);
+		goto error;
+	}
+
+	rc = dev->ops->data_exchange(dev, target_idx, skb, cb, cb_context);
+
+error:
+	device_unlock(&dev->dev);
+	return rc;
+}
+
+/**
+ * nfc_alloc_skb - allocate a skb for data exchange responses
+ *
+ * @size: size to allocate
+ * @gfp: gfp flags
+ */
+struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp)
+{
+	struct sk_buff *skb;
+	unsigned int total_size;
+
+	total_size = size + 1;
+	skb = alloc_skb(total_size, gfp);
+
+	if (skb)
+		skb_reserve(skb, 1);
+
+	return skb;
+}
+EXPORT_SYMBOL(nfc_alloc_skb);
+
+static void nfc_release(struct device *d)
+{
+	struct nfc_dev *dev = to_nfc_dev(d);
+
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	kfree(dev);
+}
+
+struct class nfc_class = {
+	.name = "nfc",
+	.dev_release = nfc_release,
+};
+EXPORT_SYMBOL(nfc_class);
+
+static int match_idx(struct device *d, void *data)
+{
+	struct nfc_dev *dev = to_nfc_dev(d);
+	unsigned *idx = data;
+
+	return dev->idx == *idx;
+}
+
+struct nfc_dev *nfc_get_device(unsigned idx)
+{
+	struct device *d;
+
+	d = class_find_device(&nfc_class, NULL, &idx, match_idx);
+	if (!d)
+		return NULL;
+
+	return to_nfc_dev(d);
+}
+
+/**
+ * nfc_allocate_device - allocate a new nfc device
+ *
+ * @ops: device operations
+ * @supported_protocols: NFC protocols supported by the device
+ */
+struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
+					u32 supported_protocols)
+{
+	static atomic_t dev_no = ATOMIC_INIT(0);
+	struct nfc_dev *dev;
+
+	if (!ops->start_poll || !ops->stop_poll || !ops->activate_target ||
+		!ops->deactivate_target || !ops->data_exchange)
+		return NULL;
+
+	if (!supported_protocols)
+		return NULL;
+
+	dev = kzalloc(sizeof(struct nfc_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->dev.class = &nfc_class;
+	dev->idx = atomic_inc_return(&dev_no) - 1;
+	dev_set_name(&dev->dev, "nfc%d", dev->idx);
+	device_initialize(&dev->dev);
+
+	dev->ops = ops;
+	dev->supported_protocols = supported_protocols;
+
+	return dev;
+}
+EXPORT_SYMBOL(nfc_allocate_device);
+
+/**
+ * nfc_register_device - register a nfc device in the nfc subsystem
+ *
+ * @dev: The nfc device to register
+ */
+int nfc_register_device(struct nfc_dev *dev)
+{
+	int rc;
+
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	mutex_lock(&nfc_devlist_mutex);
+	nfc_devlist_generation++;
+	rc = device_add(&dev->dev);
+	mutex_unlock(&nfc_devlist_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL(nfc_register_device);
+
+/**
+ * nfc_unregister_device - unregister a nfc device in the nfc subsystem
+ *
+ * @dev: The nfc device to unregister
+ */
+void nfc_unregister_device(struct nfc_dev *dev)
+{
+	NFC_DBG("dev_name:%s", dev_name(&dev->dev));
+
+	mutex_lock(&nfc_devlist_mutex);
+	nfc_devlist_generation++;
+
+	/* lock to avoid unregistering a device while an operation
+	   is in progress */
+	device_lock(&dev->dev);
+	device_del(&dev->dev);
+	device_unlock(&dev->dev);
+
+	mutex_unlock(&nfc_devlist_mutex);
+}
+EXPORT_SYMBOL(nfc_unregister_device);
+
+static int __init nfc_init(void)
+{
+	NFC_INFO("NFC Core ver %s", VERSION);
+
+	return class_register(&nfc_class);
+}
+
+static void __exit nfc_exit(void)
+{
+	class_unregister(&nfc_class);
+}
+
+subsys_initcall(nfc_init);
+module_exit(nfc_exit);
+
+MODULE_AUTHOR("Lauro Ramos Venancio <lauro.venancio@openbossa.org>");
+MODULE_DESCRIPTION("NFC Core ver " VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL");
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
new file mode 100644
index 0000000..b0ff15c
--- /dev/null
+++ b/net/nfc/nfc.h
@@ -0,0 +1,75 @@
+/*
+ * Copyright (C) 2011 Instituto Nokia de Tecnologia
+ *
+ * Authors:
+ *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
+ *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __LOCAL_NFC_H
+#define __LOCAL_NFC_H
+
+#include <net/nfc.h>
+
+#define NFC_INFO(fmt, arg...) printk(KERN_INFO "NFC: " fmt "\n", ## arg)
+#define NFC_ERR(fmt, arg...) printk(KERN_ERR "%s: " fmt "\n", __func__, ## arg)
+#define NFC_DBG(fmt, arg...) pr_debug("%s: " fmt "\n", __func__, ## arg)
+
+extern int nfc_devlist_generation;
+extern struct mutex nfc_devlist_mutex;
+
+struct nfc_dev *nfc_get_device(unsigned idx);
+
+static inline void nfc_put_device(struct nfc_dev *dev)
+{
+	put_device(&dev->dev);
+}
+
+static inline void nfc_device_iter_init(struct class_dev_iter *iter)
+{
+	class_dev_iter_init(iter, &nfc_class, NULL, NULL);
+}
+
+static inline struct nfc_dev *nfc_device_iter_next(struct class_dev_iter *iter)
+{
+	struct device *d = class_dev_iter_next(iter);
+	if (!d)
+		return NULL;
+
+	return to_nfc_dev(d);
+}
+
+static inline void nfc_device_iter_exit(struct class_dev_iter *iter)
+{
+	class_dev_iter_exit(iter);
+}
+
+int nfc_start_poll(struct nfc_dev *dev, u32 protocols);
+
+int nfc_stop_poll(struct nfc_dev *dev);
+
+int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol);
+
+int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx);
+
+int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx,
+					struct sk_buff *skb,
+					data_exchange_cb_t cb,
+					void *cb_context);
+
+#endif /* __LOCAL_NFC_H */
-- 
1.7.5.4

