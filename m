Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64168 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1FTRv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 13:51:59 -0400
Received: by yia27 with SMTP id 27so2181176yia.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 10:51:58 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
Date: Mon, 20 Jun 2011 14:50:08 -0300
Message-Id: <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110620_195203_413637_0569B181)
In-Reply-To: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>

The NFC generic netlink interface exports the NFC control operations
to the user space.

Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h |  111 +++++++++++
 include/net/nfc.h   |   21 ++
 net/nfc/Makefile    |    2 +-
 net/nfc/core.c      |   83 ++++++++-
 net/nfc/netlink.c   |  537 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nfc.h       |   11 +
 6 files changed, 762 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/nfc.h
 create mode 100644 net/nfc/netlink.c

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
new file mode 100644
index 0000000..59b3c79
--- /dev/null
+++ b/include/linux/nfc.h
@@ -0,0 +1,111 @@
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
+ * @NFC_CMD_GET_TARGET: dump all targets found by the previous poll (requires
+ *	%NFC_ATTR_DEVICE_INDEX)
+ * @NFC_EVENT_TARGETS_FOUND: event emitted when a new target is found
+ *	(it sends %NFC_ATTR_DEVICE_INDEX)
+ * @NFC_EVENT_DEVICE_ADDED: event emitted when a new device is registred
+ *	(it sends %NFC_ATTR_DEVICE_NAME, %NFC_ATTR_DEVICE_INDEX and
+ *	%NFC_ATTR_PROTOCOLS)
+ * @NFC_EVENT_DEVICE_REMOVED: event emitted when a device is removed
+ *	(it sends %NFC_ATTR_DEVICE_INDEX)
+ */
+enum nfc_commands {
+	NFC_CMD_UNSPEC,
+	NFC_CMD_GET_DEVICE,
+	NFC_CMD_START_POLL,
+	NFC_CMD_STOP_POLL,
+	NFC_CMD_GET_TARGET,
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
+ * @NFC_ATTR_TARGET_INDEX: index of the nfc target
+ * @NFC_ATTR_TARGET_SENS_RES: extra information for NFC-A targets
+ * @NFC_ATTR_TARGET_SEL_RES: extra information for NFC-A targets
+ */
+enum nfc_attrs {
+	NFC_ATTR_UNSPEC,
+	NFC_ATTR_DEVICE_INDEX,
+	NFC_ATTR_DEVICE_NAME,
+	NFC_ATTR_PROTOCOLS,
+	NFC_ATTR_TARGET_INDEX,
+	NFC_ATTR_TARGET_SENS_RES,
+	NFC_ATTR_TARGET_SEL_RES,
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
+#endif /*__LINUX_NFC_H */
diff --git a/include/net/nfc.h b/include/net/nfc.h
index 11d63dc..01a30b3 100644
--- a/include/net/nfc.h
+++ b/include/net/nfc.h
@@ -54,10 +54,28 @@ struct nfc_ops {
 							void *cb_context);
 };
 
+struct nfc_target {
+	u32 idx;
+	u32 supported_protocols;
+	u16 sens_res;
+	u8 sel_res;
+};
+
+struct nfc_genl_data {
+	u32 poll_req_pid;
+	struct mutex genl_data_mutex;
+};
+
 struct nfc_dev {
 	unsigned idx;
+	unsigned target_idx;
+	struct nfc_target *targets;
+	int n_targets;
+	int targets_generation;
+	spinlock_t targets_lock;
 	struct device dev;
 	bool polling;
+	struct nfc_genl_data genl_data;
 	u32 supported_protocols;
 
 	struct nfc_ops *ops;
@@ -128,4 +146,7 @@ static inline const char *nfc_device_name(struct nfc_dev *dev)
 
 struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp);
 
+int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
+							int ntargets);
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
index f4710fe..5e09d50 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -213,12 +213,61 @@ struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp)
 }
 EXPORT_SYMBOL(nfc_alloc_skb);
 
+/**
+ * nfc_targets_found - inform that targets were found
+ *
+ * @dev: The nfc device that found the targets
+ * @targets: array of nfc targets found
+ * @ntargets: targets array size
+ *
+ * The device driver must call this function when one or many nfc targets
+ * are found. After calling this function, the device driver must stop
+ * polling for targets.
+ */
+int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
+							int n_targets)
+{
+	int i;
+
+	pr_debug("%s: dev_name:%s", __func__, dev_name(&dev->dev));
+
+	dev->polling = false;
+
+	for (i = 0; i < n_targets; i++)
+		targets[i].idx = dev->target_idx++;
+
+	spin_lock_bh(&dev->targets_lock);
+
+	dev->targets_generation++;
+
+	kfree(dev->targets);
+	dev->targets = kzalloc(n_targets * sizeof(struct nfc_target),
+							GFP_ATOMIC);
+	if (!dev->targets) {
+		dev->n_targets = 0;
+		spin_unlock_bh(&dev->targets_lock);
+		return -ENOMEM;
+	}
+
+	memcpy(dev->targets, targets, n_targets * sizeof(struct nfc_target));
+	dev->n_targets = n_targets;
+
+	spin_unlock_bh(&dev->targets_lock);
+
+	nfc_genl_targets_found(dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_targets_found);
+
 static void nfc_release(struct device *d)
 {
 	struct nfc_dev *dev = to_nfc_dev(d);
 
 	pr_debug("%s: dev_name:%s", __func__, dev_name(&dev->dev));
 
+	nfc_genl_data_exit(&dev->genl_data);
+	kfree(dev->targets);
 	kfree(dev);
 }
 
@@ -278,6 +327,12 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	dev->ops = ops;
 	dev->supported_protocols = supported_protocols;
 
+	spin_lock_init(&dev->targets_lock);
+	nfc_genl_data_init(&dev->genl_data);
+
+	/* first generation must not be 0 */
+	dev->targets_generation = 1;
+
 	return dev;
 }
 EXPORT_SYMBOL(nfc_allocate_device);
@@ -298,7 +353,10 @@ int nfc_register_device(struct nfc_dev *dev)
 	rc = device_add(&dev->dev);
 	mutex_unlock(&nfc_devlist_mutex);
 
-	return rc;
+	if (rc < 0)
+		return rc;
+
+	return nfc_genl_device_added(dev);
 }
 EXPORT_SYMBOL(nfc_register_device);
 
@@ -321,18 +379,39 @@ void nfc_unregister_device(struct nfc_dev *dev)
 	device_unlock(&dev->dev);
 
 	mutex_unlock(&nfc_devlist_mutex);
+
+	nfc_genl_device_removed(dev);
 }
 EXPORT_SYMBOL(nfc_unregister_device);
 
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
+	/* the first generation must not be 0 */
+	nfc_devlist_generation = 1;
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
index 0000000..5f2ddb2
--- /dev/null
+++ b/net/nfc/netlink.c
@@ -0,0 +1,537 @@
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
+};
+
+static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
+					struct netlink_callback *cb, int flags)
+{
+	void *hdr;
+
+	pr_debug("%s\n", __func__);
+
+	hdr = genlmsg_put(msg, NETLINK_CB(cb->skb).pid, cb->nlh->nlmsg_seq,
+				&nfc_genl_family, flags, NFC_CMD_GET_TARGET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	genl_dump_check_consistent(cb, hdr, &nfc_genl_family);
+
+	NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target->idx);
+	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS,
+				target->supported_protocols);
+	NLA_PUT_U16(msg, NFC_ATTR_TARGET_SENS_RES, target->sens_res);
+	NLA_PUT_U8(msg, NFC_ATTR_TARGET_SEL_RES, target->sel_res);
+
+	return genlmsg_end(msg, hdr);
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static struct nfc_dev *__get_device_from_cb(struct netlink_callback *cb)
+{
+	struct nfc_dev *dev;
+	int rc;
+	u32 idx;
+
+	rc = nlmsg_parse(cb->nlh, GENL_HDRLEN + nfc_genl_family.hdrsize,
+						nfc_genl_family.attrbuf,
+						nfc_genl_family.maxattr,
+						nfc_genl_policy);
+	if (rc < 0)
+		return ERR_PTR(rc);
+
+	if (!nfc_genl_family.attrbuf[NFC_ATTR_DEVICE_INDEX])
+		return ERR_PTR(-EINVAL);
+
+	idx = nla_get_u32(nfc_genl_family.attrbuf[NFC_ATTR_DEVICE_INDEX]);
+
+	dev = nfc_get_device(idx);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	return dev;
+}
+
+static int nfc_genl_dump_targets(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	int i = cb->args[0];
+	struct nfc_dev *dev = (struct nfc_dev *) cb->args[1];
+	int rc;
+
+	pr_debug("%s\n", __func__);
+
+	if (!dev) {
+		dev = __get_device_from_cb(cb);
+		if (IS_ERR(dev))
+			return PTR_ERR(dev);
+
+		cb->args[1] = (long) dev;
+	}
+
+	spin_lock_bh(&dev->targets_lock);
+
+	cb->seq = dev->targets_generation;
+
+	while (i < dev->n_targets) {
+		rc = nfc_genl_send_target(skb, &dev->targets[i], cb,
+								NLM_F_MULTI);
+		if (rc < 0)
+			break;
+
+		i++;
+	}
+
+	spin_unlock_bh(&dev->targets_lock);
+
+	cb->args[0] = i;
+
+	return skb->len;
+}
+
+static int nfc_genl_dump_targets_done(struct netlink_callback *cb)
+{
+	struct nfc_dev *dev = (struct nfc_dev *) cb->args[1];
+
+	pr_debug("%s\n", __func__);
+
+	if (dev)
+		nfc_put_device(dev);
+
+	return 0;
+}
+
+int nfc_genl_targets_found(struct nfc_dev *dev)
+{
+	struct sk_buff *msg;
+	void *hdr;
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
+static int nfc_genl_send_device(struct sk_buff *msg, struct nfc_dev *dev,
+						u32 pid, u32 seq,
+						struct netlink_callback *cb,
+						int flags)
+{
+	void *hdr;
+
+	pr_debug("%s\n", __func__);
+
+	hdr = genlmsg_put(msg, pid, seq, &nfc_genl_family, flags,
+							NFC_CMD_GET_DEVICE);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr, &nfc_genl_family);
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
+	bool first_call = false;
+
+	pr_debug("%s\n", __func__);
+
+	if (!iter) {
+		first_call = true;
+		iter = kmalloc(sizeof(struct class_dev_iter), GFP_KERNEL);
+		if (!iter)
+			return -ENOMEM;
+		cb->args[0] = (long) iter;
+	}
+
+	mutex_lock(&nfc_devlist_mutex);
+
+	cb->seq = nfc_devlist_generation;
+
+	if (first_call) {
+		nfc_device_iter_init(iter);
+		dev = nfc_device_iter_next(iter);
+	}
+
+	while (dev) {
+		int rc;
+
+		rc = nfc_genl_send_device(skb, dev, NETLINK_CB(cb->skb).pid,
+							cb->nlh->nlmsg_seq,
+							cb, NLM_F_MULTI);
+		if (rc < 0)
+			break;
+
+		dev = nfc_device_iter_next(iter);
+	}
+
+	mutex_unlock(&nfc_devlist_mutex);
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
+	rc = nfc_genl_send_device(msg, dev, info->snd_pid, info->snd_seq,
+								NULL, 0);
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
+	{
+		.cmd = NFC_CMD_GET_TARGET,
+		.dumpit = nfc_genl_dump_targets,
+		.done = nfc_genl_dump_targets_done,
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
index ad19e4a..878a333 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -29,6 +29,17 @@
 extern int nfc_devlist_generation;
 extern struct mutex nfc_devlist_mutex;
 
+int __init nfc_genl_init(void);
+void nfc_genl_exit(void);
+
+void nfc_genl_data_init(struct nfc_genl_data *genl_data);
+void nfc_genl_data_exit(struct nfc_genl_data *genl_data);
+
+int nfc_genl_targets_found(struct nfc_dev *dev);
+
+int nfc_genl_device_added(struct nfc_dev *dev);
+int nfc_genl_device_removed(struct nfc_dev *dev);
+
 struct nfc_dev *nfc_get_device(unsigned idx);
 
 static inline void nfc_put_device(struct nfc_dev *dev)
-- 
1.7.4.1

