Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62897 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab1FBVrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 17:47:19 -0400
Received: by mail-gx0-f174.google.com with SMTP id 21so527686gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 14:47:19 -0700 (PDT)
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
Subject: [PATCH 2/6] NFC: add nfc generic netlink interface
Date: Thu,  2 Jun 2011 18:46:06 -0300
Message-Id: <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org> (sfid-20110602_234730_485890_D6D54ECB)
In-Reply-To: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NFC generic netlink interface exports the NFC control operations
to the user space.

Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h |  122 ++++++++++++++
 include/net/nfc.h   |   18 ++
 net/nfc/Makefile    |    2 +-
 net/nfc/core.c      |   63 +++++++-
 net/nfc/netlink.c   |  446 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h       |   14 ++
 6 files changed, 662 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/nfc.h
 create mode 100644 net/nfc/netlink.c

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
new file mode 100644
index 0000000..be8fc88
--- /dev/null
+++ b/include/linux/nfc.h
@@ -0,0 +1,122 @@
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
+#ifndef __LINUX_NFC_H
+#define __LINUX_NFC_H
+
+#define NFC_GENL_NAME "nfc"
+#define NFC_GENL_VERSION 1
+
+#define NFC_GENL_MCAST_EVENT_NAME "events"
+
+/**
+ * enum nfc_commands - supported nfc commands
+ *
+ * @NFC_CMD_UNSPEC: unspecified command
+ *
+ * @NFC_CMD_GET_DEVICE: request information about a device (requires
+ *	%NFC_ATTR_DEVICE_INDEX) or dump request to get a list of all nfc devices
+ * @NFC_CMD_START_POLL: start polling for targets using the given protocols
+ *	(requires %NFC_ATTR_DEVICE_INDEX and %NFC_ATTR_PROTOCOLS)
+ * @NFC_CMD_STOP_POLL: stop polling for targets (requires
+ *	%NFC_ATTR_DEVICE_INDEX)
+ * @NFC_EVENT_TARGETS_FOUND: event emitted when a new target is found
+ *	(it sends %NFC_ATTR_DEVICE_INDEX and %NFC_ATTR_TARGETS)
+ * @NFC_EVENT_DEVICE_ADDED: event emitted when a new device is registred
+ * @NFC_EVENT_DEVICE_REMOVED: event emitted when a device is removed
+ */
+enum nfc_commands {
+	NFC_CMD_UNSPEC,
+	NFC_CMD_GET_DEVICE,
+	NFC_CMD_START_POLL,
+	NFC_CMD_STOP_POLL,
+	NFC_EVENT_TARGETS_FOUND,
+	NFC_EVENT_DEVICE_ADDED,
+	NFC_EVENT_DEVICE_REMOVED,
+/* private: internal use only */
+	__NFC_CMD_AFTER_LAST
+};
+#define NFC_CMD_MAX (__NFC_CMD_AFTER_LAST - 1)
+
+/**
+ * enum nfc_attrs - supported nfc attributes
+ *
+ * @NFC_ATTR_UNSPEC: unspecified attribute
+ *
+ * @NFC_ATTR_DEVICE_INDEX: index of nfc device
+ * @NFC_ATTR_DEVICE_NAME: device name, max 8 chars
+ * @NFC_ATTR_PROTOCOLS: nfc protocols - bitwise or-ed combination from
+ *	NFC_PROTO_*_MASK constants
+ * @NFC_ATTR_TARGETS: array of targets (see enum nfc_target_attr)
+ */
+enum nfc_attrs {
+	NFC_ATTR_UNSPEC,
+	NFC_ATTR_DEVICE_INDEX,
+	NFC_ATTR_DEVICE_NAME,
+	NFC_ATTR_PROTOCOLS,
+	NFC_ATTR_TARGETS,
+/* private: internal use only */
+	__NFC_ATTR_AFTER_LAST
+};
+#define NFC_ATTR_MAX (__NFC_ATTR_AFTER_LAST - 1)
+
+#define NFC_DEVICE_NAME_MAXSIZE 8
+
+/* NFC protocols */
+#define NFC_PROTO_JEWEL		0
+#define NFC_PROTO_MIFARE	1
+#define NFC_PROTO_FELICA	2
+#define NFC_PROTO_ISO14443	3
+#define NFC_PROTO_NFC_DEP	4
+
+#define NFC_PROTO_MAX		5
+
+/* NFC protocols masks used in bitsets */
+#define NFC_PROTO_JEWEL_MASK	(1 << NFC_PROTO_JEWEL)
+#define NFC_PROTO_MIFARE_MASK	(1 << NFC_PROTO_MIFARE)
+#define NFC_PROTO_FELICA_MASK	(1 << NFC_PROTO_FELICA)
+#define NFC_PROTO_ISO14443_MASK	(1 << NFC_PROTO_ISO14443)
+#define NFC_PROTO_NFC_DEP_MASK	(1 << NFC_PROTO_NFC_DEP)
+
+/**
+ * enum nfc_target_attr - attributes for nfc targets
+ *
+ * @NFC_TARGET_ATTR_UNSPEC: unspecified attribute
+ * @NFC_TARGET_ATTR_TARGET_INDEX: target index
+ * @NFC_TARGET_ATTR_SUPPORTED_PROTOCOLS: protocols supported by the target
+ *	(bitwise or-ed combination from NFC_PROTO_* constants)
+ * @NFC_TARGET_ATTR_SENS_RES: extra information for NFC-A targets
+ * @NFC_TARGET_ATTR_SEL_RES: extra information for NFC-A targets
+ */
+enum nfc_target_attr {
+	NFC_TARGET_ATTR_UNSPEC,
+	NFC_TARGET_ATTR_TARGET_INDEX,
+	NFC_TARGET_ATTR_SUPPORTED_PROTOCOLS,
+	NFC_TARGET_ATTR_SENS_RES,
+	NFC_TARGET_ATTR_SEL_RES,
+/* private: internal use only */
+	__NFC_TARGET_ATTR_AFTER_LAST
+};
+#define NFC_TARGET_ATTR_MAX (__NFC_TARGET_ATTR_AFTER_LAST - 1)
+
+#endif /*__LINUX_NFC_H */
diff --git a/include/net/nfc.h b/include/net/nfc.h
index 11d63dc..72cc54d 100644
--- a/include/net/nfc.h
+++ b/include/net/nfc.h
@@ -54,16 +54,31 @@ struct nfc_ops {
 							void *cb_context);
 };
 
+struct nfc_genl_data {
+	u32 poll_req_pid;
+	struct mutex genl_data_mutex;
+};
+
 struct nfc_dev {
 	unsigned idx;
+	unsigned target_idx;
+	int n_targets;
 	struct device dev;
 	bool polling;
+	struct nfc_genl_data genl_data;
 	u32 supported_protocols;
 
 	struct nfc_ops *ops;
 };
 #define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
 
+struct nfc_target {
+	u32 idx;
+	u32 supported_protocols;
+	u16 sens_res;
+	u8 sel_res;
+};
+
 extern struct class nfc_class;
 
 struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
@@ -128,4 +143,7 @@ static inline const char *nfc_device_name(struct nfc_dev *dev)
 
 struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp);
 
+int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
+						int ntargets, gfp_t gfp);
+
 #endif /* __NET_NFC_H */
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index d837743..8aeaddc 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -4,6 +4,6 @@
 
 obj-$(CONFIG_NFC) += nfc.o
 
-nfc-objs := core.o
+nfc-objs := core.o netlink.o
 
 ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/net/nfc/core.c b/net/nfc/core.c
index a6b8c95..b73c917 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -210,6 +210,38 @@ struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp)
 }
 EXPORT_SYMBOL(nfc_alloc_skb);
 
+/**
+ * nfc_targets_found - inform that targets were found
+ *
+ * @dev: The nfc device that found the targets
+ * @targets: array of nfc targets found
+ * @ntargets: targets array size
+ * @gfp: gfp flags
+ *
+ * The device driver must call this function when one or many nfc targets
+ * are found. After calling this function, the device driver must stop
+ * polling for targets.
+ */
+int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
+						int ntargets, gfp_t gfp)
+{
+	int i;
+
+	pr_debug("%s: dev_name:%s", __func__, dev_name(&dev->dev));
+
+	dev->polling = false;
+
+	for (i = 0; i < ntargets; i++)
+		targets[i].idx = dev->target_idx++;
+
+	dev->n_targets = ntargets;
+
+	nfc_genl_targets_found(dev, targets, ntargets);
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_targets_found);
+
 static void nfc_release(struct device *d)
 {
 	struct nfc_dev *dev = to_nfc_dev(d);
@@ -286,9 +318,17 @@ EXPORT_SYMBOL(nfc_allocate_device);
  */
 int nfc_register_device(struct nfc_dev *dev)
 {
+	int rc;
+
 	pr_debug("%s: dev_name:%s", __func__, dev_name(&dev->dev));
 
-	return device_add(&dev->dev);
+	nfc_genl_data_init(&dev->genl_data);
+
+	rc = device_add(&dev->dev);
+	if (rc < 0)
+		return rc;
+
+	return nfc_genl_device_added(dev);
 }
 EXPORT_SYMBOL(nfc_register_device);
 
@@ -301,9 +341,12 @@ void nfc_unregister_device(struct nfc_dev *dev)
 {
 	pr_debug("%s: dev_name:%s", __func__, dev_name(&dev->dev));
 
+	nfc_genl_data_exit(&dev->genl_data);
+
 	/* lock to avoid unregistering a device while an operation
 	   is in progress */
 	device_lock(&dev->dev);
+	nfc_genl_device_removed(dev);
 	device_del(&dev->dev);
 	device_unlock(&dev->dev);
 }
@@ -311,13 +354,29 @@ EXPORT_SYMBOL(nfc_unregister_device);
 
 static int __init nfc_init(void)
 {
+	int rc;
+
 	printk(KERN_INFO "NFC Core ver %s\n", VERSION);
 
-	return class_register(&nfc_class);
+	rc = class_register(&nfc_class);
+	if (rc)
+		goto err;
+
+	rc = nfc_genl_init();
+	if (rc)
+		goto err_genl;
+
+	return 0;
+
+err_genl:
+	class_unregister(&nfc_class);
+err:
+	return rc;
 }
 
 static void __exit nfc_exit(void)
 {
+	nfc_genl_exit();
 	class_unregister(&nfc_class);
 }
 
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
new file mode 100644
index 0000000..76ec1ff
--- /dev/null
+++ b/net/nfc/netlink.c
@@ -0,0 +1,446 @@
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
+#include <net/genetlink.h>
+#include <linux/nfc.h>
+#include <linux/slab.h>
+
+#include "nfc.h"
+
+static struct genl_multicast_group nfc_genl_event_mcgrp = {
+	.name = NFC_GENL_MCAST_EVENT_NAME,
+};
+
+struct genl_family nfc_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = NFC_GENL_NAME,
+	.version = NFC_GENL_VERSION,
+	.maxattr = NFC_ATTR_MAX,
+};
+
+static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
+	[NFC_ATTR_DEVICE_INDEX] = { .type = NLA_U32 },
+	[NFC_ATTR_DEVICE_NAME] = { .type = NLA_STRING,
+				.len = NFC_DEVICE_NAME_MAXSIZE },
+	[NFC_ATTR_PROTOCOLS] = { .type = NLA_U32 },
+	[NFC_ATTR_TARGETS] = { .type = NLA_NESTED },
+};
+
+static int nfc_genl_msg_put_target(struct sk_buff *msg,
+				struct nfc_target *target)
+{
+	NLA_PUT_U32(msg, NFC_TARGET_ATTR_TARGET_INDEX, target->idx);
+	NLA_PUT_U32(msg, NFC_TARGET_ATTR_SUPPORTED_PROTOCOLS,
+				target->supported_protocols);
+	NLA_PUT_U8(msg, NFC_TARGET_ATTR_SENS_RES, target->sens_res);
+	NLA_PUT_U8(msg, NFC_TARGET_ATTR_SEL_RES, target->sel_res);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+int nfc_genl_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
+								int ntargets)
+{
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *targets_attr;
+	int i;
+
+	pr_debug("%s\n", __func__);
+
+	dev->genl_data.poll_req_pid = 0;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+				NFC_EVENT_TARGETS_FOUND);
+	if (!hdr)
+		goto free_msg;
+
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
+
+	targets_attr = nla_nest_start(msg, NFC_ATTR_TARGETS);
+
+	for (i = 0; i < ntargets; i++) {
+		struct nlattr *target = nla_nest_start(msg, i);
+
+		if (nfc_genl_msg_put_target(msg, &targets[i]))
+			goto nla_put_failure;
+
+		nla_nest_end(msg, target);
+	}
+
+	nla_nest_end(msg, targets_attr);
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_ATOMIC);
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+int nfc_genl_device_added(struct nfc_dev *dev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	pr_debug("%s\n", __func__);
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+				NFC_EVENT_DEVICE_ADDED);
+	if (!hdr)
+		goto free_msg;
+
+	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
+	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_KERNEL);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+int nfc_genl_device_removed(struct nfc_dev *dev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	pr_debug("%s\n", __func__);
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+				NFC_EVENT_DEVICE_REMOVED);
+	if (!hdr)
+		goto free_msg;
+
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_KERNEL);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+static int nfc_genl_send_device(struct sk_buff *msg, u32 pid, u32 seq,
+					int flags, struct nfc_dev *dev)
+{
+	void *hdr;
+
+	pr_debug("%s\n", __func__);
+
+	hdr = genlmsg_put(msg, pid, seq, &nfc_genl_family, flags,
+						NFC_CMD_GET_DEVICE);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
+	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols);
+
+	return genlmsg_end(msg, hdr);
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int nfc_genl_dump_devices(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
+	struct nfc_dev *dev = (struct nfc_dev *) cb->args[1];
+	u32 pid = NETLINK_CB(cb->skb).pid;
+	u32 seq = cb->nlh->nlmsg_seq;
+
+	pr_debug("%s\n", __func__);
+
+	if (!iter) {
+		iter = kmalloc(sizeof(struct class_dev_iter), GFP_KERNEL);
+		if (!iter)
+			return -ENOMEM;
+
+		nfc_device_iter_init(iter);
+		cb->args[0] = (long) iter;
+
+		dev = nfc_device_iter_next(iter);
+	}
+
+	while (dev) {
+		int rc;
+
+		rc = nfc_genl_send_device(skb, pid, seq, NLM_F_MULTI, dev);
+		if (rc < 0)
+			break;
+
+		dev = nfc_device_iter_next(iter);
+	}
+
+	cb->args[1] = (long) dev;
+
+	return skb->len;
+}
+
+static int nfc_genl_dump_devices_done(struct netlink_callback *cb)
+{
+	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
+
+	pr_debug("%s\n", __func__);
+
+	nfc_device_iter_exit(iter);
+	kfree(iter);
+
+	return 0;
+}
+
+static int nfc_genl_get_device(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	struct nfc_dev *dev;
+	u32 idx;
+	int rc = -ENOBUFS;
+
+	pr_debug("%s\n", __func__);
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
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg) {
+		rc = -ENOMEM;
+		goto out_putdev;
+	}
+
+	rc = nfc_genl_send_device(msg, info->snd_pid, info->snd_seq, 0, dev);
+	if (rc < 0)
+		goto out_free;
+
+	nfc_put_device(dev);
+
+	return genlmsg_reply(msg, info);
+
+out_free:
+	nlmsg_free(msg);
+out_putdev:
+	nfc_put_device(dev);
+	return rc;
+}
+
+static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	int rc;
+	u32 idx;
+	u32 protocols;
+
+	pr_debug("%s\n", __func__);
+
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+		!info->attrs[NFC_ATTR_PROTOCOLS])
+		return -EINVAL;
+
+	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
+	protocols = nla_get_u32(info->attrs[NFC_ATTR_PROTOCOLS]);
+
+	dev = nfc_get_device(idx);
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->genl_data.genl_data_mutex);
+
+	rc = nfc_start_poll(dev, protocols);
+	if (!rc)
+		dev->genl_data.poll_req_pid = info->snd_pid;
+
+	mutex_unlock(&dev->genl_data.genl_data_mutex);
+
+	nfc_put_device(dev);
+	return rc;
+}
+
+static int nfc_genl_stop_poll(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	int rc;
+	u32 idx;
+
+	pr_debug("%s\n", __func__);
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
+	if (dev->genl_data.poll_req_pid != info->snd_pid) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	rc = nfc_stop_poll(dev);
+	dev->genl_data.poll_req_pid = 0;
+
+out:
+	mutex_unlock(&dev->genl_data.genl_data_mutex);
+	nfc_put_device(dev);
+	return rc;
+}
+
+static struct genl_ops nfc_genl_ops[] = {
+	{
+		.cmd = NFC_CMD_GET_DEVICE,
+		.doit = nfc_genl_get_device,
+		.dumpit = nfc_genl_dump_devices,
+		.done = nfc_genl_dump_devices_done,
+		.policy = nfc_genl_policy,
+	},
+	{
+		.cmd = NFC_CMD_START_POLL,
+		.doit = nfc_genl_start_poll,
+		.policy = nfc_genl_policy,
+	},
+	{
+		.cmd = NFC_CMD_STOP_POLL,
+		.doit = nfc_genl_stop_poll,
+		.policy = nfc_genl_policy,
+	},
+};
+
+static int nfc_genl_rcv_nl_event(struct notifier_block *this,
+						unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+	struct class_dev_iter iter;
+	struct nfc_dev *dev;
+
+	if (event != NETLINK_URELEASE || n->protocol != NETLINK_GENERIC)
+		goto out;
+
+	pr_debug("%s: NETLINK_URELEASE event from id %d\n", __func__, n->pid);
+
+	nfc_device_iter_init(&iter);
+	dev = nfc_device_iter_next(&iter);
+
+	while (dev) {
+		mutex_lock(&dev->genl_data.genl_data_mutex);
+		if (dev->genl_data.poll_req_pid == n->pid) {
+			nfc_stop_poll(dev);
+			dev->genl_data.poll_req_pid = 0;
+		}
+		mutex_unlock(&dev->genl_data.genl_data_mutex);
+		dev = nfc_device_iter_next(&iter);
+	}
+
+	nfc_device_iter_exit(&iter);
+
+out:
+	return NOTIFY_DONE;
+}
+
+void nfc_genl_data_init(struct nfc_genl_data *genl_data)
+{
+	genl_data->poll_req_pid = 0;
+	mutex_init(&genl_data->genl_data_mutex);
+}
+
+void nfc_genl_data_exit(struct nfc_genl_data *genl_data)
+{
+	mutex_destroy(&genl_data->genl_data_mutex);
+}
+
+static struct notifier_block nl_notifier = {
+	.notifier_call  = nfc_genl_rcv_nl_event,
+};
+
+/**
+ * nfc_genl_init() - Initialize netlink interface
+ *
+ * This initialization function registers the nfc netlink family.
+ */
+int __init nfc_genl_init(void)
+{
+	int rc;
+
+	rc = genl_register_family_with_ops(&nfc_genl_family, nfc_genl_ops,
+					ARRAY_SIZE(nfc_genl_ops));
+	if (rc)
+		return rc;
+
+	rc = genl_register_mc_group(&nfc_genl_family, &nfc_genl_event_mcgrp);
+
+	netlink_register_notifier(&nl_notifier);
+
+	return rc;
+}
+
+/**
+ * nfc_genl_exit() - Deinitialize netlink interface
+ *
+ * This exit function unregisters the nfc netlink family.
+ */
+void nfc_genl_exit(void)
+{
+	netlink_unregister_notifier(&nl_notifier);
+	genl_unregister_family(&nfc_genl_family);
+}
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 8a50fd1..33d19eb 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -26,6 +26,20 @@
 
 #include <net/nfc.h>
 
+int __init nfc_genl_init(void);
+
+void nfc_genl_exit(void);
+
+void nfc_genl_data_init(struct nfc_genl_data *genl_data);
+
+void nfc_genl_data_exit(struct nfc_genl_data *genl_data);
+
+int nfc_genl_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
+								int ntargets);
+
+int nfc_genl_device_added(struct nfc_dev *dev);
+int nfc_genl_device_removed(struct nfc_dev *dev);
+
 struct nfc_dev *nfc_get_device(unsigned idx);
 
 static inline void nfc_put_device(struct nfc_dev *dev)
-- 
1.7.1

