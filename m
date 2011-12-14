Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24005 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627Ab1LNPiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:52 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 8/8] NFC: Initial LLCP support
Date: Wed, 14 Dec 2011 16:43:12 +0100
Message-Id: <1323877392-20567-9-git-send-email-sameo@linux.intel.com> (sfid-20111214_163855_401613_3D9E17E3)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is an initial implementation for the NFC Logical Link Control
protocol. It's also known as NFC peer to peer mode.
This is a basic implementation as it lacks SDP (services Discovery
Protocol), frames aggregation support, and frame rejecion parsing.
Follow up patches will implement those missing features.
This code has been tested against a Nexus S phone implementing LLCP 1.0.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h     |   15 +-
 net/nfc/Kconfig         |    1 +
 net/nfc/Makefile        |    1 +
 net/nfc/core.c          |   20 +-
 net/nfc/llcp/Kconfig    |    7 +
 net/nfc/llcp/commands.c |  399 +++++++++++++++++++
 net/nfc/llcp/llcp.c     |  973 +++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/llcp/llcp.h     |  193 ++++++++++
 net/nfc/llcp/sock.c     |  675 ++++++++++++++++++++++++++++++++
 net/nfc/nfc.h           |   54 +++
 10 files changed, 2335 insertions(+), 3 deletions(-)
 create mode 100644 net/nfc/llcp/Kconfig
 create mode 100644 net/nfc/llcp/commands.c
 create mode 100644 net/nfc/llcp/llcp.c
 create mode 100644 net/nfc/llcp/llcp.h
 create mode 100644 net/nfc/llcp/sock.c

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 34d8303..89fee4a 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -139,9 +139,22 @@ struct sockaddr_nfc {
 	__u32 nfc_protocol;
 };
 
+#define NFC_LLCP_MAX_SERVICE_NAME 63
+struct sockaddr_nfc_llcp {
+	sa_family_t sa_family;
+	__u32 dev_idx;
+	__u32 target_idx;
+	__u32 nfc_protocol;
+	__u8 dsap; /* Destination SAP, if known */
+	__u8 ssap; /* Source SAP to be bound to */
+	char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
+	size_t service_name_len;
+};
+
 /* NFC socket protocols */
 #define NFC_SOCKPROTO_RAW	0
-#define NFC_SOCKPROTO_MAX	1
+#define NFC_SOCKPROTO_LLCP	1
+#define NFC_SOCKPROTO_MAX	2
 
 #define NFC_HEADER_SIZE 1
 
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 58cddad..44c865b 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -14,5 +14,6 @@ menuconfig NFC
 	  be called nfc.
 
 source "net/nfc/nci/Kconfig"
+source "net/nfc/llcp/Kconfig"
 
 source "drivers/nfc/Kconfig"
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index fbb550f..7b4a6dc 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_NFC) += nfc.o
 obj-$(CONFIG_NFC_NCI) += nci/
 
 nfc-objs := core.o netlink.o af_nfc.o rawsock.o
+nfc-$(CONFIG_NFC_LLCP)	+= llcp/llcp.o llcp/commands.o llcp/sock.o
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 3a45f21..3ddf6e6 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -240,6 +240,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 	rc = dev->ops->dep_link_down(dev);
 	if (!rc) {
 		dev->dep_link_up = false;
+		nfc_llcp_mac_is_down(dev);
 		nfc_genl_dep_link_down_event(dev);
 	}
 
@@ -254,6 +255,8 @@ int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 	dev->dep_link_up = true;
 	dev->dep_rf_mode = rf_mode;
 
+	nfc_llcp_mac_is_up(dev, target_idx, comm_mode, rf_mode);
+
 	return nfc_genl_dep_link_up_event(dev, target_idx, comm_mode, rf_mode);
 }
 EXPORT_SYMBOL(nfc_dep_link_is_up);
@@ -360,13 +363,13 @@ int nfc_set_remote_general_bytes(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 	if (gb_len > NFC_MAX_GT_LEN)
 		return -EINVAL;
 
-	return 0;
+	return nfc_llcp_set_remote_gb(dev, gb, gb_len);
 }
 EXPORT_SYMBOL(nfc_set_remote_general_bytes);
 
 u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, u8 *gt_len)
 {
-	return NULL;
+	return nfc_llcp_general_bytes(dev, gt_len);
 }
 EXPORT_SYMBOL(nfc_get_local_general_bytes);
 
@@ -560,6 +563,10 @@ int nfc_register_device(struct nfc_dev *dev)
 	if (rc < 0)
 		return rc;
 
+	rc = nfc_llcp_register_device(dev);
+	if (rc)
+		pr_err("Could not register llcp device\n");
+
 	rc = nfc_genl_device_added(dev);
 	if (rc)
 		pr_debug("The userspace won't be notified that the device %s was added\n",
@@ -591,6 +598,8 @@ void nfc_unregister_device(struct nfc_dev *dev)
 
 	mutex_unlock(&nfc_devlist_mutex);
 
+	nfc_llcp_unregister_device(dev);
+
 	rc = nfc_genl_device_removed(dev);
 	if (rc)
 		pr_debug("The userspace won't be notified that the device %s was removed\n",
@@ -620,6 +629,10 @@ static int __init nfc_init(void)
 	if (rc)
 		goto err_rawsock;
 
+	rc = nfc_llcp_init();
+	if (rc)
+		goto err_llcp_sock;
+
 	rc = af_nfc_init();
 	if (rc)
 		goto err_af_nfc;
@@ -627,6 +640,8 @@ static int __init nfc_init(void)
 	return 0;
 
 err_af_nfc:
+	nfc_llcp_exit();
+err_llcp_sock:
 	rawsock_exit();
 err_rawsock:
 	nfc_genl_exit();
@@ -638,6 +653,7 @@ err_genl:
 static void __exit nfc_exit(void)
 {
 	af_nfc_exit();
+	nfc_llcp_exit();
 	rawsock_exit();
 	nfc_genl_exit();
 	class_unregister(&nfc_class);
diff --git a/net/nfc/llcp/Kconfig b/net/nfc/llcp/Kconfig
new file mode 100644
index 0000000..fbf5e81
--- /dev/null
+++ b/net/nfc/llcp/Kconfig
@@ -0,0 +1,7 @@
+config NFC_LLCP
+       depends on NFC && EXPERIMENTAL
+       bool "NFC LLCP support (EXPERIMENTAL)"
+       default n
+       help
+	 Say Y here if you want to build support for a kernel NFC LLCP
+	 implementation.
\ No newline at end of file
diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
new file mode 100644
index 0000000..151f2ef
--- /dev/null
+++ b/net/nfc/llcp/commands.c
@@ -0,0 +1,399 @@
+/*
+ * Copyright (C) 2011  Intel Corporation. All rights reserved.
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
+#define pr_fmt(fmt) "llcp: %s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nfc.h>
+
+#include <net/nfc/nfc.h>
+
+#include "../nfc.h"
+#include "llcp.h"
+
+static u8 llcp_tlv_length[LLCP_TLV_MAX] = {
+	0,
+	1, /* VERSION */
+	2, /* MIUX */
+	2, /* WKS */
+	1, /* LTO */
+	1, /* RW */
+	0, /* SN */
+	1, /* OPT */
+	0, /* SDREQ */
+	2, /* SDRES */
+
+};
+
+static u8 llcp_tlv8(u8 *tlv, u8 type)
+{
+	if (tlv[0] != type || tlv[1] != llcp_tlv_length[tlv[0]])
+		return 0;
+
+	return tlv[2];
+}
+
+static u8 llcp_tlv16(u8 *tlv, u8 type)
+{
+	if (tlv[0] != type || tlv[1] != llcp_tlv_length[tlv[0]])
+		return 0;
+
+	return be16_to_cpu(*((__be16 *)(tlv + 2)));
+}
+
+
+static u8 llcp_tlv_version(u8 *tlv)
+{
+	return llcp_tlv8(tlv, LLCP_TLV_VERSION);
+}
+
+static u16 llcp_tlv_miux(u8 *tlv)
+{
+	return llcp_tlv16(tlv, LLCP_TLV_MIUX) & 0x7f;
+}
+
+static u16 llcp_tlv_wks(u8 *tlv)
+{
+	return llcp_tlv16(tlv, LLCP_TLV_WKS);
+}
+
+static u16 llcp_tlv_lto(u8 *tlv)
+{
+	return llcp_tlv8(tlv, LLCP_TLV_LTO);
+}
+
+static u8 llcp_tlv_opt(u8 *tlv)
+{
+	return llcp_tlv8(tlv, LLCP_TLV_OPT);
+}
+
+static u8 llcp_tlv_rw(u8 *tlv)
+{
+	return llcp_tlv8(tlv, LLCP_TLV_RW) & 0xf;
+}
+
+u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length)
+{
+	u8 *tlv, length;
+
+	pr_debug("type %d\n", type);
+
+	if (type >= LLCP_TLV_MAX)
+		return NULL;
+
+	length = llcp_tlv_length[type];
+	if (length == 0 && value_length == 0)
+		return NULL;
+	else
+		length = value_length;
+
+	*tlv_length = 2 + length;
+	tlv = kzalloc(2 + length, GFP_KERNEL);
+	if (tlv == NULL)
+		return tlv;
+
+	tlv[0] = type;
+	tlv[1] = length;
+	memcpy(tlv + 2, value, length);
+
+	return tlv;
+}
+
+int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
+			u8 *tlv_array, u16 tlv_array_len)
+{
+	u8 *tlv = tlv_array, type, length, offset = 0;
+
+	pr_debug("TLV array length %d\n", tlv_array_len);
+
+	if (local == NULL)
+		return -ENODEV;
+
+	while (offset < tlv_array_len) {
+		type = tlv[0];
+		length = tlv[1];
+
+		pr_debug("type 0x%x length %d\n", type, length);
+
+		switch (type) {
+		case LLCP_TLV_VERSION:
+			local->remote_version = llcp_tlv_version(tlv);
+			break;
+		case LLCP_TLV_MIUX:
+			local->remote_miu = llcp_tlv_miux(tlv) + 128;
+			break;
+		case LLCP_TLV_WKS:
+			local->remote_wks = llcp_tlv_wks(tlv);
+			break;
+		case LLCP_TLV_LTO:
+			local->remote_lto = llcp_tlv_lto(tlv) * 10;
+			break;
+		case LLCP_TLV_OPT:
+			local->remote_opt = llcp_tlv_opt(tlv);
+			break;
+		case LLCP_TLV_RW:
+			local->remote_rw = llcp_tlv_rw(tlv);
+			break;
+		default:
+			pr_err("Invalid gt tlv value 0x%x\n", type);
+			break;
+		}
+
+		offset += length + 2;
+		tlv += length + 2;
+	}
+
+	pr_debug("version 0x%x miu %d lto %d opt 0x%x wks 0x%x rw %d\n",
+		local->remote_version, local->remote_miu,
+		local->remote_lto, local->remote_opt,
+		local->remote_wks, local->remote_rw);
+
+	return 0;
+}
+
+static struct sk_buff *llcp_add_header(struct sk_buff *pdu,
+					u8 dsap, u8 ssap, u8 ptype)
+{
+	u8 header[2];
+
+	pr_debug("ptype 0x%x dsap 0x%x ssap 0x%x\n", ptype, dsap, ssap);
+
+	header[0] = (u8)((dsap << 2) | (ptype >> 2));
+	header[1] = (u8)((ptype << 6) | ssap);
+
+	pr_debug("header 0x%x 0x%x\n", header[0], header[1]);
+
+	memcpy(skb_put(pdu, LLCP_HEADER_SIZE), header, LLCP_HEADER_SIZE);
+
+	return pdu;
+}
+
+static struct sk_buff *llcp_add_tlv(struct sk_buff *pdu, u8 *tlv, u8 tlv_length)
+{
+	/* XXX Add an skb length check */
+
+	if (tlv == NULL)
+		return NULL;
+
+	memcpy(skb_put(pdu, tlv_length), tlv, tlv_length);
+
+	return pdu;
+}
+
+static struct sk_buff *llcp_allocate_pdu(struct nfc_llcp_sock *sock,
+							u8 cmd, u16 size)
+{
+	struct sk_buff *skb;
+	int err;
+
+	if (sock->ssap == 0)
+		return NULL;
+
+	skb = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
+					size + LLCP_HEADER_SIZE, &err);
+	if (skb == NULL) {
+		pr_err("Could not allocate PDU\n");
+		return NULL;
+	}
+
+	skb = llcp_add_header(skb, sock->dsap, sock->ssap, cmd);
+
+	return skb;
+}
+
+int nfc_llcp_disconnect(struct nfc_llcp_sock *sock)
+{
+	struct sk_buff *skb;
+	struct nfc_dev *dev;
+	struct nfc_llcp_local *local;
+	u16 size = 0;
+
+	pr_debug("Sending DISC\n");
+
+	local = sock->local;
+	if (local == NULL)
+		return -ENODEV;
+
+	dev = sock->dev;
+	if (dev == NULL)
+		return -ENODEV;
+
+	size += LLCP_HEADER_SIZE;
+	size += dev->tx_headroom + dev->tx_tailroom + NFC_HEADER_SIZE;
+
+	skb = alloc_skb(size, GFP_ATOMIC);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
+
+	skb = llcp_add_header(skb, sock->ssap, sock->dsap, LLCP_PDU_DISC);
+
+	skb_queue_tail(&local->tx_queue, skb);
+
+	return 0;
+}
+
+int nfc_llcp_send_symm(struct nfc_dev *dev)
+{
+	struct sk_buff *skb;
+	struct nfc_llcp_local *local;
+	u16 size = 0;
+
+	pr_debug("Sending SYMM\n");
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL)
+		return -ENODEV;
+
+	size += LLCP_HEADER_SIZE;
+	size += dev->tx_headroom + dev->tx_tailroom + NFC_HEADER_SIZE;
+
+	skb = alloc_skb(size, GFP_KERNEL);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
+
+	skb = llcp_add_header(skb, 0, 0, LLCP_PDU_SYMM);
+
+	return nfc_data_exchange(dev, local->target_idx, skb,
+					nfc_llcp_recv, local);
+}
+
+int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
+{
+	struct nfc_llcp_local *local;
+	struct sk_buff *skb;
+	u8 *service_name_tlv = NULL, service_name_tlv_length;
+	int err;
+	u16 size = 0;
+
+	pr_debug("Sending CONNECT\n");
+
+	local = sock->local;
+	if (local == NULL)
+		return -ENODEV;
+
+	if (sock->service_name != NULL) {
+		service_name_tlv = nfc_llcp_build_tlv(LLCP_TLV_SN,
+					sock->service_name,
+					sock->service_name_len,
+					&service_name_tlv_length);
+		size += service_name_tlv_length;
+	}
+
+	pr_debug("SKB size %d SN length %zu\n", size, sock->service_name_len);
+
+	skb = llcp_allocate_pdu(sock, LLCP_PDU_CONNECT, size);
+	if (skb == NULL) {
+		err = -ENOMEM;
+		goto error_tlv;
+	}
+
+	if (service_name_tlv != NULL)
+		skb = llcp_add_tlv(skb, service_name_tlv,
+					service_name_tlv_length);
+
+	skb_queue_tail(&local->tx_queue, skb);
+
+	return 0;
+
+error_tlv:
+	pr_err("error %d\n", err);
+
+	kfree(service_name_tlv);
+
+	return err;
+}
+
+int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
+{
+	struct nfc_llcp_local *local;
+	struct sk_buff *skb;
+
+	pr_debug("Sending CC\n");
+
+	local = sock->local;
+	if (local == NULL)
+		return -ENODEV;
+
+	skb = llcp_allocate_pdu(sock, LLCP_PDU_CC, 0);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	skb_queue_tail(&local->tx_queue, skb);
+
+	return 0;
+}
+
+int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason)
+{
+	struct sk_buff *skb;
+	struct nfc_dev *dev;
+	u16 size = 1; /* Reason code */
+
+	pr_debug("Sending DM reason 0x%x\n", reason);
+
+	if (local == NULL)
+		return -ENODEV;
+
+	dev = local->dev;
+	if (dev == NULL)
+		return -ENODEV;
+
+	size += LLCP_HEADER_SIZE;
+	size += dev->tx_headroom + dev->tx_tailroom + NFC_HEADER_SIZE;
+
+	skb = alloc_skb(size, GFP_KERNEL);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
+
+	skb = llcp_add_header(skb, ssap, dsap, LLCP_PDU_DM);
+
+	memcpy(skb_put(skb, 1), &reason, 1);
+
+	skb_queue_head(&local->tx_queue, skb);
+
+	return 0;
+}
+
+int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock)
+{
+	struct sk_buff *skb;
+	struct nfc_llcp_local *local;
+
+	pr_debug("Send DISC\n");
+
+	local = sock->local;
+	if (local == NULL)
+		return -ENODEV;
+
+	skb = llcp_allocate_pdu(sock, LLCP_PDU_DISC, 0);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	skb_queue_head(&local->tx_queue, skb);
+
+	return 0;
+}
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
new file mode 100644
index 0000000..67756b2
--- /dev/null
+++ b/net/nfc/llcp/llcp.c
@@ -0,0 +1,973 @@
+/*
+ * Copyright (C) 2011  Intel Corporation. All rights reserved.
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
+#define pr_fmt(fmt) "llcp: %s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/nfc.h>
+
+#include "../nfc.h"
+#include "llcp.h"
+
+static u8 llcp_magic[3] = {0x46, 0x66, 0x6d};
+
+static struct list_head llcp_devices;
+
+static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
+{
+	struct nfc_llcp_sock *parent, *s, *n;
+	struct sock *sk, *parent_sk;
+	int i;
+
+
+	mutex_lock(&local->socket_lock);
+
+	for (i = 0; i < LLCP_MAX_SAP; i++) {
+		parent = local->sockets[i];
+		if (parent == NULL)
+			continue;
+
+		/* Release all child sockets */
+		list_for_each_entry_safe(s, n, &parent->list, list) {
+			list_del(&s->list);
+			sk = &s->sk;
+
+			lock_sock(sk);
+
+			if (sk->sk_state == LLCP_CONNECTED)
+				nfc_put_device(s->dev);
+
+			sk->sk_state = LLCP_CLOSED;
+			sock_set_flag(sk, SOCK_DEAD);
+
+			release_sock(sk);
+		}
+
+		parent_sk = &parent->sk;
+
+		lock_sock(parent_sk);
+
+		if (parent_sk->sk_state == LLCP_LISTEN) {
+			struct nfc_llcp_sock *lsk, *n;
+			struct sock *accept_sk;
+
+			list_for_each_entry_safe(lsk, n, &parent->accept_queue,
+								accept_queue) {
+				accept_sk = &lsk->sk;
+				lock_sock(accept_sk);
+
+				nfc_llcp_accept_unlink(accept_sk);
+
+				accept_sk->sk_state = LLCP_CLOSED;
+				sock_set_flag(accept_sk, SOCK_DEAD);
+
+				release_sock(accept_sk);
+
+				sock_orphan(accept_sk);
+			}
+		}
+
+		if (parent_sk->sk_state == LLCP_CONNECTED)
+			nfc_put_device(parent->dev);
+
+		parent_sk->sk_state = LLCP_CLOSED;
+		sock_set_flag(parent_sk, SOCK_DEAD);
+
+		release_sock(parent_sk);
+	}
+
+	mutex_unlock(&local->socket_lock);
+}
+
+static void nfc_llcp_timeout_work(struct work_struct *work)
+{
+	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
+							timeout_work);
+
+	nfc_dep_link_down(local->dev);
+}
+
+static void nfc_llcp_symm_timer(unsigned long data)
+{
+	struct nfc_llcp_local *local = (struct nfc_llcp_local *) data;
+
+	pr_err("SYMM timeout\n");
+
+	queue_work(local->timeout_wq, &local->timeout_work);
+}
+
+struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev)
+{
+	struct nfc_llcp_local *local, *n;
+
+	list_for_each_entry_safe(local, n, &llcp_devices, list)
+		if (local->dev == dev)
+			return local;
+
+	pr_debug("No device found\n");
+
+	return NULL;
+}
+
+static char *wks[] = {
+	NULL,
+	NULL, /* SDP */
+	"urn:nfc:sn:ip",
+	"urn:nfc:sn:obex",
+	"urn:nfc:sn:snep",
+};
+
+static int nfc_llcp_wks_sap(char *service_name, size_t service_name_len)
+{
+	int sap, num_wks;
+
+	pr_debug("%s\n", service_name);
+
+	if (service_name == NULL)
+		return -EINVAL;
+
+	num_wks = ARRAY_SIZE(wks);
+
+	for (sap = 0 ; sap < num_wks; sap++) {
+		if (wks[sap] == NULL)
+			continue;
+
+		if (strncmp(wks[sap], service_name, service_name_len) == 0)
+			return sap;
+	}
+
+	return -EINVAL;
+}
+
+u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
+				struct nfc_llcp_sock *sock)
+{
+	mutex_lock(&local->sdp_lock);
+
+	if (sock->service_name != NULL && sock->service_name_len > 0) {
+		int ssap = nfc_llcp_wks_sap(sock->service_name,
+						sock->service_name_len);
+
+		if (ssap > 0) {
+			pr_debug("WKS %d\n", ssap);
+
+			/* This is a WKS, let's check if it's free */
+			if (local->local_wks & BIT(ssap)) {
+				mutex_unlock(&local->sdp_lock);
+
+				return LLCP_SAP_MAX;
+			}
+
+			set_bit(BIT(ssap), &local->local_wks);
+			mutex_unlock(&local->sdp_lock);
+
+			return ssap;
+		}
+
+		/*
+		 * This is not a well known service,
+		 * we should try to find a local SDP free spot
+		 */
+		ssap = find_first_zero_bit(&local->local_sdp, LLCP_SDP_NUM_SAP);
+		if (ssap == LLCP_SDP_NUM_SAP) {
+			mutex_unlock(&local->sdp_lock);
+
+			return LLCP_SAP_MAX;
+		}
+
+		pr_debug("SDP ssap %d\n", LLCP_WKS_NUM_SAP + ssap);
+
+		set_bit(BIT(ssap), &local->local_sdp);
+		mutex_unlock(&local->sdp_lock);
+
+		return LLCP_WKS_NUM_SAP + ssap;
+
+	} else if (sock->ssap != 0) {
+		if (sock->ssap < LLCP_WKS_NUM_SAP) {
+			if (!(local->local_wks & BIT(sock->ssap))) {
+				set_bit(BIT(sock->ssap), &local->local_wks);
+				mutex_unlock(&local->sdp_lock);
+
+				return sock->ssap;
+			}
+
+		} else if (sock->ssap < LLCP_SDP_NUM_SAP) {
+			if (!(local->local_sdp &
+				BIT(sock->ssap - LLCP_WKS_NUM_SAP))) {
+				set_bit(BIT(sock->ssap - LLCP_WKS_NUM_SAP),
+							&local->local_sdp);
+				mutex_unlock(&local->sdp_lock);
+
+				return sock->ssap;
+			}
+		}
+	}
+
+	mutex_unlock(&local->sdp_lock);
+
+	return LLCP_SAP_MAX;
+}
+
+u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local)
+{
+	u8 local_ssap;
+
+	mutex_lock(&local->sdp_lock);
+
+	local_ssap = find_first_zero_bit(&local->local_sap, LLCP_LOCAL_NUM_SAP);
+	if (local_ssap == LLCP_LOCAL_NUM_SAP) {
+		mutex_unlock(&local->sdp_lock);
+		return LLCP_SAP_MAX;
+	}
+
+	set_bit(BIT(local_ssap), &local->local_sap);
+
+	mutex_unlock(&local->sdp_lock);
+
+	return local_ssap + LLCP_LOCAL_SAP_OFFSET;
+}
+
+void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap)
+{
+	u8 local_ssap;
+	unsigned long *sdp;
+
+	if (ssap < LLCP_WKS_NUM_SAP) {
+		local_ssap = ssap;
+		sdp = &local->local_wks;
+	} else if (ssap < LLCP_LOCAL_NUM_SAP) {
+		local_ssap = ssap - LLCP_WKS_NUM_SAP;
+		sdp = &local->local_sdp;
+	} else if (ssap < LLCP_MAX_SAP) {
+		local_ssap = ssap - LLCP_LOCAL_NUM_SAP;
+		sdp = &local->local_sap;
+	} else {
+		return;
+	}
+
+	mutex_lock(&local->sdp_lock);
+
+	clear_bit(1 << local_ssap, sdp);
+
+	mutex_unlock(&local->sdp_lock);
+}
+
+u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *general_bytes_len)
+{
+	struct nfc_llcp_local *local;
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL) {
+		*general_bytes_len = 0;
+		return NULL;
+	}
+
+	*general_bytes_len = local->gb_len;
+
+	return local->gb;
+}
+
+static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
+{
+	u8 *gb_cur, *version_tlv, version, version_length;
+	u8 *lto_tlv, lto, lto_length;
+	u8 *wks_tlv, wks_length;
+	u8 gb_len = 0;
+
+	version = LLCP_VERSION_11;
+	version_tlv = nfc_llcp_build_tlv(LLCP_TLV_VERSION, &version,
+							1, &version_length);
+	gb_len += version_length;
+
+	/* 1500 ms */
+	lto = 150;
+	lto_tlv = nfc_llcp_build_tlv(LLCP_TLV_VERSION, &lto, 1, &lto_length);
+	gb_len += lto_length;
+
+	pr_debug("Local wks 0x%lx\n", local->local_wks);
+	wks_tlv = nfc_llcp_build_tlv(LLCP_TLV_WKS, (u8 *)&local->local_wks, 2,
+								&wks_length);
+	gb_len += wks_length;
+
+	gb_len += ARRAY_SIZE(llcp_magic);
+
+	if (gb_len > NFC_MAX_GT_LEN) {
+		kfree(version_tlv);
+		return -EINVAL;
+	}
+
+	gb_cur = local->gb;
+
+	memcpy(gb_cur, llcp_magic, ARRAY_SIZE(llcp_magic));
+	gb_cur += ARRAY_SIZE(llcp_magic);
+
+	memcpy(gb_cur, version_tlv, version_length);
+	gb_cur += version_length;
+
+	memcpy(gb_cur, lto_tlv, lto_length);
+	gb_cur += lto_length;
+
+	memcpy(gb_cur, wks_tlv, wks_length);
+	gb_cur += wks_length;
+
+	kfree(version_tlv);
+	kfree(lto_tlv);
+
+	local->gb_len = gb_len;
+
+	return 0;
+}
+
+int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
+{
+	struct nfc_llcp_local *local = nfc_llcp_find_local(dev);
+
+	if (local == NULL) {
+		pr_err("No LLCP device\n");
+		return -ENODEV;
+	}
+
+	memset(local->remote_gb, 0, NFC_MAX_GT_LEN);
+	memcpy(local->remote_gb, gb, gb_len);
+	local->remote_gb_len = gb_len;
+
+	if (local->remote_gb == NULL ||
+			local->remote_gb_len == 0)
+		return -ENODEV;
+
+	if (memcmp(local->remote_gb, llcp_magic, 3)) {
+		pr_err("MAC does not support LLCP\n");
+		return -EINVAL;
+	}
+
+	return nfc_llcp_parse_tlv(local,
+			&local->remote_gb[3], local->remote_gb_len - 3);
+}
+
+static void nfc_llcp_tx_work(struct work_struct *work)
+{
+	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
+							tx_work);
+	struct sk_buff *skb;
+
+	skb = skb_dequeue(&local->tx_queue);
+	if (skb != NULL) {
+		pr_debug("Sending pending skb\n");
+		nfc_data_exchange(local->dev, local->target_idx,
+					skb, nfc_llcp_recv, local);
+	} else {
+		nfc_llcp_send_symm(local->dev);
+	}
+
+	mod_timer(&local->link_timer,
+			jiffies + msecs_to_jiffies(local->remote_lto));
+}
+
+static u8 nfc_llcp_dsap(struct sk_buff *pdu)
+{
+	return (pdu->data[0] & 0xfc) >> 2;
+}
+
+static u8 nfc_llcp_ptype(struct sk_buff *pdu)
+{
+	return ((pdu->data[0] & 0x03) << 2) | ((pdu->data[1] & 0xc0) >> 6);
+}
+
+static u8 nfc_llcp_ssap(struct sk_buff *pdu)
+{
+	return pdu->data[1] & 0x3f;
+}
+
+static u8 nfc_llcp_ns(struct sk_buff *pdu)
+{
+	return pdu->data[2] >> 4;
+}
+
+static u8 nfc_llcp_nr(struct sk_buff *pdu)
+{
+	return pdu->data[2] & 0xf;
+}
+
+static void nfc_llcp_set_nrns(struct nfc_llcp_sock *sock, struct sk_buff *pdu)
+{
+	pdu->data[2] = (sock->send_n << 4) | ((sock->recv_n - 1) % 16);
+	sock->send_n = (sock->send_n + 1) % 16;
+	sock->recv_ack_n = (sock->recv_n - 1) % 16;
+}
+
+static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
+						u8 ssap, u8 dsap)
+{
+	struct nfc_llcp_sock *sock, *llcp_sock, *n;
+
+	if (ssap == 0 && dsap == 0)
+		return NULL;
+
+	mutex_lock(&local->socket_lock);
+	sock = local->sockets[ssap];
+	if (sock == NULL) {
+		mutex_unlock(&local->socket_lock);
+		return NULL;
+	}
+
+	pr_debug("root dsap %d (%d)\n", sock->dsap, dsap);
+
+	if (sock->dsap == dsap) {
+		sock_hold(&sock->sk);
+		mutex_unlock(&local->socket_lock);
+		return sock;
+	}
+
+	list_for_each_entry_safe(llcp_sock, n, &sock->list, list) {
+		pr_debug("llcp_sock %p sk %p dsap %d\n", llcp_sock,
+				&llcp_sock->sk, llcp_sock->dsap);
+		if (llcp_sock->dsap == dsap) {
+			sock_hold(&llcp_sock->sk);
+			mutex_unlock(&local->socket_lock);
+			return llcp_sock;
+		}
+	}
+
+	pr_err("Could not find socket for %d %d\n", ssap, dsap);
+
+	mutex_unlock(&local->socket_lock);
+
+	return NULL;
+}
+
+static void nfc_llcp_sock_put(struct nfc_llcp_sock *sock)
+{
+	sock_put(&sock->sk);
+}
+
+static u8 *nfc_llcp_connect_sn(struct sk_buff *skb, size_t *sn_len)
+{
+	u8 *tlv = &skb->data[2], type, length;
+	size_t tlv_array_len = skb->len - LLCP_HEADER_SIZE, offset = 0;
+
+	while (offset < tlv_array_len) {
+		type = tlv[0];
+		length = tlv[1];
+
+		pr_debug("type 0x%x length %d\n", type, length);
+
+		if (type == LLCP_TLV_SN) {
+			*sn_len = length;
+			return &tlv[2];
+		}
+
+		offset += length + 2;
+		tlv += length + 2;
+	}
+
+	return NULL;
+}
+
+static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
+				struct sk_buff *skb)
+{
+	struct sock *new_sk, *parent;
+	struct nfc_llcp_sock *sock, *new_sock;
+	u8 dsap, ssap, bound_sap, reason;
+
+	dsap = nfc_llcp_dsap(skb);
+	ssap = nfc_llcp_ssap(skb);
+
+	pr_debug("%d %d\n", dsap, ssap);
+
+	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
+				skb->len - LLCP_HEADER_SIZE);
+
+	if (dsap != LLCP_SAP_SDP) {
+		bound_sap = dsap;
+
+		mutex_lock(&local->socket_lock);
+		sock = local->sockets[dsap];
+		if (sock == NULL) {
+			mutex_unlock(&local->socket_lock);
+			reason = LLCP_DM_NOBOUND;
+			goto fail;
+		}
+
+		sock_hold(&sock->sk);
+		mutex_unlock(&local->socket_lock);
+
+		lock_sock(&sock->sk);
+
+		if (sock->dsap == LLCP_SAP_SDP &&
+				sock->sk.sk_state == LLCP_LISTEN)
+			goto enqueue;
+	} else {
+		u8 *sn;
+		size_t sn_len;
+
+		sn = nfc_llcp_connect_sn(skb, &sn_len);
+		if (sn == NULL) {
+			reason = LLCP_DM_NOBOUND;
+			goto fail;
+		}
+
+		pr_debug("Service name length %zu\n", sn_len);
+
+		mutex_lock(&local->socket_lock);
+		for (bound_sap = 0; bound_sap < LLCP_LOCAL_SAP_OFFSET;
+								bound_sap++) {
+			sock = local->sockets[bound_sap];
+			if (sock == NULL)
+				continue;
+
+			if (sock->service_name == NULL ||
+				sock->service_name_len == 0)
+					continue;
+
+			if (sock->service_name_len != sn_len)
+				continue;
+
+			if (sock->dsap == LLCP_SAP_SDP &&
+					sock->sk.sk_state == LLCP_LISTEN &&
+					!memcmp(sn, sock->service_name, sn_len)) {
+				pr_debug("Found service name at SAP %d\n",
+								bound_sap);
+				sock_hold(&sock->sk);
+				mutex_unlock(&local->socket_lock);
+
+				lock_sock(&sock->sk);
+
+				goto enqueue;
+			}
+		}
+
+	}
+
+	mutex_unlock(&local->socket_lock);
+
+	reason = LLCP_DM_NOBOUND;
+	goto fail;
+
+enqueue:
+	parent = &sock->sk;
+
+	if (sk_acceptq_is_full(parent)) {
+		reason = LLCP_DM_REJ;
+		release_sock(&sock->sk);
+		sock_put(&sock->sk);
+		goto fail;
+	}
+
+	new_sk = nfc_llcp_sock_alloc(NULL, parent->sk_type,
+				     GFP_ATOMIC);
+	if (new_sk == NULL) {
+		reason = LLCP_DM_REJ;
+		release_sock(&sock->sk);
+		sock_put(&sock->sk);
+		goto fail;
+	}
+
+	new_sock = nfc_llcp_sock(new_sk);
+	new_sock->dev = local->dev;
+	new_sock->local = local;
+	new_sock->nfc_protocol = sock->nfc_protocol;
+	new_sock->ssap = bound_sap;
+	new_sock->dsap = ssap;
+	new_sock->parent = parent;
+
+	pr_debug("new sock %p sk %p\n", new_sock, &new_sock->sk);
+
+	list_add_tail(&new_sock->list, &sock->list);
+
+	nfc_llcp_accept_enqueue(&sock->sk, new_sk);
+
+	nfc_get_device(local->dev->idx);
+
+	new_sk->sk_state = LLCP_CONNECTED;
+
+	/* Wake the listening processes */
+	parent->sk_data_ready(parent, 0);
+
+	/* Send CC */
+	nfc_llcp_send_cc(new_sock);
+
+	release_sock(&sock->sk);
+	sock_put(&sock->sk);
+
+	return;
+
+fail:
+	/* Send DM */
+	nfc_llcp_send_dm(local, dsap, ssap, reason);
+
+	return;
+
+}
+
+static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
+				struct sk_buff *skb)
+{
+	struct nfc_llcp_sock *llcp_sock;
+	struct sock *sk;
+	u8 dsap, ssap, ptype, ns, nr;
+
+	ptype = nfc_llcp_ptype(skb);
+	dsap = nfc_llcp_dsap(skb);
+	ssap = nfc_llcp_ssap(skb);
+	ns = nfc_llcp_ns(skb);
+	nr = nfc_llcp_nr(skb);
+
+	pr_debug("%d %d R %d S %d\n", dsap, ssap, nr, ns);
+
+	llcp_sock = nfc_llcp_sock_get(local, dsap, ssap);
+	if (llcp_sock == NULL) {
+		nfc_llcp_send_dm(local, dsap, ssap, LLCP_DM_NOCONN);
+		return;
+	}
+
+	sk = &llcp_sock->sk;
+	lock_sock(sk);
+	if (sk->sk_state == LLCP_CLOSED) {
+		release_sock(sk);
+		nfc_llcp_sock_put(llcp_sock);
+	}
+
+	if (ns == llcp_sock->recv_n)
+		llcp_sock->recv_n = (llcp_sock->recv_n + 1) % 16;
+	else
+		pr_err("Received out of sequence I PDU\n");
+
+	/* Pass the payload upstream */
+	if (ptype == LLCP_PDU_I) {
+		pr_debug("I frame, queueing on %p\n", &llcp_sock->sk);
+
+		skb_pull(skb, LLCP_HEADER_SIZE + LLCP_SEQUENCE_SIZE);
+		if (sock_queue_rcv_skb(&llcp_sock->sk, skb)) {
+			pr_err("receive queue is full\n");
+			skb_queue_head(&llcp_sock->tx_backlog_queue, skb);
+		}
+	}
+
+	/* Remove skbs from the pending queue */
+	if (llcp_sock->send_ack_n != nr) {
+		struct sk_buff *s, *tmp;
+
+		llcp_sock->send_ack_n = nr;
+
+		skb_queue_walk_safe(&llcp_sock->tx_pending_queue, s, tmp)
+			if (nfc_llcp_ns(s) <= nr) {
+				skb_unlink(s, &llcp_sock->tx_pending_queue);
+				kfree_skb(s);
+			}
+	}
+
+	/* Queue some I frames for transmission */
+	while (llcp_sock->remote_ready &&
+		skb_queue_len(&llcp_sock->tx_pending_queue) <= local->remote_rw) {
+		struct sk_buff *pdu, *pending_pdu;
+
+		pdu = skb_dequeue(&llcp_sock->tx_queue);
+		if (pdu == NULL)
+			break;
+
+		/* Update N(S)/N(R) */
+		nfc_llcp_set_nrns(llcp_sock, pdu);
+
+		pending_pdu = skb_clone(pdu, GFP_KERNEL);
+
+		skb_queue_tail(&local->tx_queue, pdu);
+		skb_queue_tail(&llcp_sock->tx_pending_queue, pending_pdu);
+	}
+
+	release_sock(sk);
+	nfc_llcp_sock_put(llcp_sock);
+}
+
+static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
+				struct sk_buff *skb)
+{
+	struct nfc_llcp_sock *llcp_sock;
+	struct sock *sk;
+	u8 dsap, ssap;
+
+	dsap = nfc_llcp_dsap(skb);
+	ssap = nfc_llcp_ssap(skb);
+
+	llcp_sock = nfc_llcp_sock_get(local, dsap, ssap);
+	if (llcp_sock == NULL) {
+		nfc_llcp_send_dm(local, dsap, ssap, LLCP_DM_NOCONN);
+		return;
+	}
+
+	sk = &llcp_sock->sk;
+	lock_sock(sk);
+	if (sk->sk_state == LLCP_CLOSED) {
+		release_sock(sk);
+		nfc_llcp_sock_put(llcp_sock);
+	}
+
+
+	if (sk->sk_state == LLCP_CONNECTED) {
+		nfc_put_device(local->dev);
+		sk->sk_state = LLCP_CLOSED;
+		sk->sk_state_change(sk);
+	}
+
+	nfc_llcp_send_dm(local, dsap, ssap, LLCP_DM_DISC);
+
+	release_sock(sk);
+	nfc_llcp_sock_put(llcp_sock);
+}
+
+static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
+				struct sk_buff *skb)
+{
+	struct nfc_llcp_sock *llcp_sock;
+	u8 dsap, ssap;
+
+
+	dsap = nfc_llcp_dsap(skb);
+	ssap = nfc_llcp_ssap(skb);
+
+	llcp_sock = nfc_llcp_sock_get(local, dsap, ssap);
+
+	if (llcp_sock == NULL)
+		llcp_sock = nfc_llcp_sock_get(local, dsap, LLCP_SAP_SDP);
+
+	if (llcp_sock == NULL) {
+		pr_err("Invalid CC\n");
+		nfc_llcp_send_dm(local, dsap, ssap, LLCP_DM_NOCONN);
+
+		return;
+	}
+
+	llcp_sock->dsap = ssap;
+
+	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
+				skb->len - LLCP_HEADER_SIZE);
+
+	nfc_llcp_sock_put(llcp_sock);
+}
+
+static void nfc_llcp_rx_work(struct work_struct *work)
+{
+	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
+								rx_work);
+	u8 dsap, ssap, ptype;
+	struct sk_buff *skb;
+
+	skb = local->rx_pending;
+	if (skb == NULL) {
+		pr_debug("No pending SKB\n");
+		return;
+	}
+
+	ptype = nfc_llcp_ptype(skb);
+	dsap = nfc_llcp_dsap(skb);
+	ssap = nfc_llcp_ssap(skb);
+
+	pr_debug("ptype 0x%x dsap 0x%x ssap 0x%x\n", ptype, dsap, ssap);
+
+	switch (ptype) {
+	case LLCP_PDU_SYMM:
+		pr_debug("SYMM\n");
+		break;
+
+	case LLCP_PDU_CONNECT:
+		pr_debug("CONNECT\n");
+		nfc_llcp_recv_connect(local, skb);
+		break;
+
+	case LLCP_PDU_DISC:
+		pr_debug("DISC\n");
+		nfc_llcp_recv_disc(local, skb);
+		break;
+
+	case LLCP_PDU_CC:
+		pr_debug("CC\n");
+		nfc_llcp_recv_cc(local, skb);
+		break;
+
+	case LLCP_PDU_I:
+	case LLCP_PDU_RR:
+		pr_debug("I frame\n");
+		nfc_llcp_recv_hdlc(local, skb);
+		break;
+
+	}
+
+	queue_work(local->tx_wq, &local->tx_work);
+	kfree_skb(local->rx_pending);
+	local->rx_pending = NULL;
+
+	return;
+}
+
+void nfc_llcp_recv(void *data, struct sk_buff *skb, int err)
+{
+	struct nfc_llcp_local *local = (struct nfc_llcp_local *) data;
+
+	pr_debug("Received an LLCP PDU\n");
+	if (err < 0) {
+		pr_err("err %d", err);
+		return;
+	}
+
+	local->rx_pending = skb_get(skb);
+	del_timer(&local->link_timer);
+	queue_work(local->rx_wq, &local->rx_work);
+
+	return;
+}
+
+void nfc_llcp_mac_is_down(struct nfc_dev *dev)
+{
+	struct nfc_llcp_local *local;
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL)
+		return;
+
+	/* Close and purge all existing sockets */
+	nfc_llcp_socket_release(local);
+}
+
+void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
+			u8 comm_mode, u8 rf_mode)
+{
+	struct nfc_llcp_local *local;
+
+	pr_debug("rf mode %d\n", rf_mode);
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL)
+		return;
+
+	local->target_idx = target_idx;
+	local->comm_mode = comm_mode;
+	local->rf_mode = rf_mode;
+
+	if (rf_mode == NFC_RF_INITIATOR) {
+		pr_debug("Queueing Tx work\n");
+
+		queue_work(local->tx_wq, &local->tx_work);
+	} else {
+		mod_timer(&local->link_timer,
+			jiffies + msecs_to_jiffies(local->remote_lto));
+	}
+}
+
+int nfc_llcp_register_device(struct nfc_dev *ndev)
+{
+	struct device *dev = &ndev->dev;
+	struct nfc_llcp_local *local;
+	char name[32];
+	int err;
+
+	local = kzalloc(sizeof(struct nfc_llcp_local), GFP_KERNEL);
+	if (local == NULL)
+		return -ENOMEM;
+
+	local->dev = ndev;
+	INIT_LIST_HEAD(&local->list);
+	mutex_init(&local->sdp_lock);
+	mutex_init(&local->socket_lock);
+	init_timer(&local->link_timer);
+	local->link_timer.data = (unsigned long) local;
+	local->link_timer.function = nfc_llcp_symm_timer;
+
+	skb_queue_head_init(&local->tx_queue);
+	INIT_WORK(&local->tx_work, nfc_llcp_tx_work);
+	snprintf(name, sizeof(name), "%s_llcp_tx_wq", dev_name(dev));
+	local->tx_wq = alloc_workqueue(name,
+			WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	if (local->tx_wq == NULL) {
+		err = -ENOMEM;
+		goto err_local;
+	}
+
+	local->rx_pending = NULL;
+	INIT_WORK(&local->rx_work, nfc_llcp_rx_work);
+	snprintf(name, sizeof(name), "%s_llcp_rx_wq", dev_name(dev));
+	local->rx_wq = alloc_workqueue(name,
+			WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	if (local->rx_wq == NULL) {
+		err = -ENOMEM;
+		goto err_tx_wq;
+	}
+
+	INIT_WORK(&local->timeout_work, nfc_llcp_timeout_work);
+	snprintf(name, sizeof(name), "%s_llcp_timeout_wq", dev_name(dev));
+	local->timeout_wq = alloc_workqueue(name,
+			WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	if (local->timeout_wq == NULL) {
+		err = -ENOMEM;
+		goto err_rx_wq;
+	}
+
+	nfc_llcp_build_gb(local);
+
+	local->remote_miu = LLCP_DEFAULT_MIU;
+	local->remote_lto = LLCP_DEFAULT_LTO;
+	local->remote_rw = LLCP_DEFAULT_RW;
+
+	list_add(&llcp_devices, &local->list);
+
+	return 0;
+
+err_rx_wq:
+	destroy_workqueue(local->rx_wq);
+
+err_tx_wq:
+	destroy_workqueue(local->tx_wq);
+
+err_local:
+	kfree(local);
+
+	return 0;
+}
+
+void nfc_llcp_unregister_device(struct nfc_dev *dev)
+{
+	struct nfc_llcp_local *local = nfc_llcp_find_local(dev);
+
+	if (local == NULL) {
+		pr_debug("No such device\n");
+		return;
+	}
+
+	list_del(&local->list);
+	nfc_llcp_socket_release(local);
+	del_timer_sync(&local->link_timer);
+	skb_queue_purge(&local->tx_queue);
+	destroy_workqueue(local->tx_wq);
+	destroy_workqueue(local->rx_wq);
+	kfree(local->rx_pending);
+	kfree(local);
+}
+
+int __init nfc_llcp_init(void)
+{
+	INIT_LIST_HEAD(&llcp_devices);
+
+	return nfc_llcp_sock_init();
+}
+
+void nfc_llcp_exit(void)
+{
+	nfc_llcp_sock_exit();
+}
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
new file mode 100644
index 0000000..0ad2e33
--- /dev/null
+++ b/net/nfc/llcp/llcp.h
@@ -0,0 +1,193 @@
+/*
+ * Copyright (C) 2011  Intel Corporation. All rights reserved.
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
+enum llcp_state {
+	LLCP_CONNECTED = 1, /* wait_for_packet() wants that */
+	LLCP_CLOSED,
+	LLCP_BOUND,
+	LLCP_LISTEN,
+};
+
+#define LLCP_DEFAULT_LTO 100
+#define LLCP_DEFAULT_RW  1
+#define LLCP_DEFAULT_MIU 128
+
+#define LLCP_WKS_NUM_SAP   16
+#define LLCP_SDP_NUM_SAP   16
+#define LLCP_LOCAL_NUM_SAP 32
+#define LLCP_LOCAL_SAP_OFFSET (LLCP_WKS_NUM_SAP + LLCP_SDP_NUM_SAP)
+#define LLCP_MAX_SAP (LLCP_WKS_NUM_SAP + LLCP_SDP_NUM_SAP + LLCP_LOCAL_NUM_SAP)
+
+struct nfc_llcp_sock;
+
+struct nfc_llcp_local {
+	struct list_head list;
+	struct nfc_dev *dev;
+
+	struct mutex sdp_lock;
+	struct mutex socket_lock;
+
+	struct timer_list link_timer;
+	struct sk_buff_head tx_queue;
+	struct workqueue_struct	*tx_wq;
+	struct work_struct	 tx_work;
+	struct workqueue_struct	*rx_wq;
+	struct work_struct	 rx_work;
+	struct sk_buff *rx_pending;
+	struct workqueue_struct	*timeout_wq;
+	struct work_struct	 timeout_work;
+
+	u32 target_idx;
+	u8 rf_mode;
+	u8 comm_mode;
+	unsigned long local_wks;      /* Well known services */
+	unsigned long local_sdp;      /* Local services  */
+	unsigned long local_sap; /* Local SAPs, not available for discovery */
+
+	/* local */
+	u8 gb[NFC_MAX_GT_LEN];
+	u8 gb_len;
+
+	/* remote */
+	u8 remote_gb[NFC_MAX_GT_LEN];
+	u8 remote_gb_len;
+
+	u8  remote_version;
+	u16 remote_miu;
+	u16 remote_lto;
+	u8  remote_opt;
+	u16 remote_wks;
+	u8  remote_rw;
+
+	/* sockets array */
+	struct nfc_llcp_sock *sockets[LLCP_MAX_SAP];
+};
+
+struct nfc_llcp_sock {
+	struct sock sk;
+	struct list_head list;
+	struct nfc_dev *dev;
+	struct nfc_llcp_local *local;
+	u32 target_idx;
+	u32 nfc_protocol;
+
+	u8 ssap;
+	u8 dsap;
+	char *service_name;
+	size_t service_name_len;
+
+	/* Link variables */
+	u8 send_n;
+	u8 send_ack_n;
+	u8 recv_n;
+	u8 recv_ack_n;
+
+	/* Is the remote peer ready to receive */
+	u8 remote_ready;
+
+	struct sk_buff_head tx_queue;
+	struct sk_buff_head tx_pending_queue;
+	struct sk_buff_head tx_backlog_queue;
+
+	struct list_head accept_queue;
+	struct sock *parent;
+};
+
+#define nfc_llcp_sock(sk) ((struct nfc_llcp_sock *) (sk))
+#define nfc_llcp_dev(sk)  (nfc_llcp_sock((sk))->dev)
+
+#define LLCP_HEADER_SIZE   2
+#define LLCP_SEQUENCE_SIZE 1
+
+/* LLCP versions: 1.1 is 1.0 plus SDP */
+#define LLCP_VERSION_10 0x10
+#define LLCP_VERSION_11 0x11
+
+/* LLCP PDU types */
+#define LLCP_PDU_SYMM     0x0
+#define LLCP_PDU_PAX      0x1
+#define LLCP_PDU_AGF      0x2
+#define LLCP_PDU_UI       0x3
+#define LLCP_PDU_CONNECT  0x4
+#define LLCP_PDU_DISC     0x5
+#define LLCP_PDU_CC       0x6
+#define LLCP_PDU_DM       0x7
+#define LLCP_PDU_FRMR     0x8
+#define LLCP_PDU_SNL      0x9
+#define LLCP_PDU_I        0xc
+#define LLCP_PDU_RR       0xd
+#define LLCP_PDU_RNR      0xe
+
+/* Parameters TLV types */
+#define LLCP_TLV_VERSION 0x1
+#define LLCP_TLV_MIUX    0x2
+#define LLCP_TLV_WKS     0x3
+#define LLCP_TLV_LTO     0x4
+#define LLCP_TLV_RW      0x5
+#define LLCP_TLV_SN      0x6
+#define LLCP_TLV_OPT     0x7
+#define LLCP_TLV_SDREQ   0x8
+#define LLCP_TLV_SDRES   0x9
+#define LLCP_TLV_MAX     0xa
+
+/* Well known LLCP SAP */
+#define LLCP_SAP_SDP   0x1
+#define LLCP_SAP_IP    0x2
+#define LLCP_SAP_OBEX  0x3
+#define LLCP_SAP_SNEP  0x4
+#define LLCP_SAP_MAX   0xff
+
+/* Disconnection reason code */
+#define LLCP_DM_DISC    0x00
+#define LLCP_DM_NOCONN  0x01
+#define LLCP_DM_NOBOUND 0x02
+#define LLCP_DM_REJ     0x03
+
+
+struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev);
+u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
+				struct nfc_llcp_sock *sock);
+u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local);
+void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap);
+
+/* Sock API */
+struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp);
+void nfc_llcp_sock_free(struct nfc_llcp_sock *sock);
+void nfc_llcp_accept_unlink(struct sock *sk);
+void nfc_llcp_accept_enqueue(struct sock *parent, struct sock *sk);
+struct sock *nfc_llcp_accept_dequeue(struct sock *sk, struct socket *newsock);
+
+/* TLV API */
+int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
+			u8 *tlv_array, u16 tlv_array_len);
+
+/* Commands API */
+void nfc_llcp_recv(void *data, struct sk_buff *skb, int err);
+u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length);
+void nfc_llcp_recv(void *data, struct sk_buff *skb, int err);
+int nfc_llcp_disconnect(struct nfc_llcp_sock *sock);
+int nfc_llcp_send_symm(struct nfc_dev *dev);
+int nfc_llcp_send_connect(struct nfc_llcp_sock *sock);
+int nfc_llcp_send_cc(struct nfc_llcp_sock *sock);
+int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason);
+int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock);
+
+/* Socket API */
+int __init nfc_llcp_sock_init(void);
+void nfc_llcp_sock_exit(void);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
new file mode 100644
index 0000000..f738ccd
--- /dev/null
+++ b/net/nfc/llcp/sock.c
@@ -0,0 +1,675 @@
+/*
+ * Copyright (C) 2011  Intel Corporation. All rights reserved.
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
+#define pr_fmt(fmt) "llcp: %s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nfc.h>
+
+#include "../nfc.h"
+#include "llcp.h"
+
+static struct proto llcp_sock_proto = {
+	.name     = "NFC_LLCP",
+	.owner    = THIS_MODULE,
+	.obj_size = sizeof(struct nfc_llcp_sock),
+};
+
+static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
+{
+	struct sock *sk = sock->sk;
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+	struct nfc_llcp_local *local;
+	struct nfc_dev *dev;
+	struct sockaddr_nfc_llcp llcp_addr;
+	int len, ret = 0;
+
+	pr_debug("sk %p addr %p family %d\n", sk, addr, addr->sa_family);
+
+	if (!addr || addr->sa_family != AF_NFC)
+		return -EINVAL;
+
+	memset(&llcp_addr, 0, sizeof(llcp_addr));
+	len = min_t(unsigned int, sizeof(llcp_addr), alen);
+	memcpy(&llcp_addr, addr, len);
+
+	/* This is going to be a listening socket, dsap must be 0 */
+	if (llcp_addr.dsap != 0)
+		return -EINVAL;
+
+	lock_sock(sk);
+
+	if (sk->sk_state != LLCP_CLOSED) {
+		ret = -EBADFD;
+		goto error;
+	}
+
+	dev = nfc_get_device(llcp_addr.dev_idx);
+	if (dev == NULL) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL) {
+		ret = -ENODEV;
+		goto put_dev;
+	}
+
+	llcp_sock->dev = dev;
+	llcp_sock->local = local;
+	llcp_sock->nfc_protocol = llcp_addr.nfc_protocol;
+	llcp_sock->service_name_len = min_t(unsigned int,
+			llcp_addr.service_name_len, NFC_LLCP_MAX_SERVICE_NAME);
+	llcp_sock->service_name = kmemdup(llcp_addr.service_name,
+				llcp_sock->service_name_len, GFP_KERNEL);
+
+	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
+	if (llcp_sock->ssap == LLCP_MAX_SAP)
+		goto put_dev;
+
+	local->sockets[llcp_sock->ssap] = llcp_sock;
+
+	pr_debug("Socket bound to SAP %d\n", llcp_sock->ssap);
+
+	sk->sk_state = LLCP_BOUND;
+
+put_dev:
+	nfc_put_device(dev);
+
+error:
+	release_sock(sk);
+	return ret;
+}
+
+static int llcp_sock_listen(struct socket *sock, int backlog)
+{
+	struct sock *sk = sock->sk;
+	int ret = 0;
+
+	pr_debug("sk %p backlog %d\n", sk, backlog);
+
+	lock_sock(sk);
+
+	if ((sock->type != SOCK_SEQPACKET && sock->type != SOCK_STREAM)
+			|| sk->sk_state != LLCP_BOUND) {
+		ret = -EBADFD;
+		goto error;
+	}
+
+	sk->sk_max_ack_backlog = backlog;
+	sk->sk_ack_backlog = 0;
+
+	pr_debug("Socket listening\n");
+	sk->sk_state = LLCP_LISTEN;
+
+error:
+	release_sock(sk);
+
+	return ret;
+}
+
+void nfc_llcp_accept_unlink(struct sock *sk)
+{
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+
+	pr_debug("state %d\n", sk->sk_state);
+
+	list_del_init(&llcp_sock->accept_queue);
+	sk_acceptq_removed(llcp_sock->parent);
+	llcp_sock->parent = NULL;
+
+	sock_put(sk);
+}
+
+void nfc_llcp_accept_enqueue(struct sock *parent, struct sock *sk)
+{
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+	struct nfc_llcp_sock *llcp_sock_parent = nfc_llcp_sock(parent);
+
+	/* Lock will be free from unlink */
+	sock_hold(sk);
+
+	list_add_tail(&llcp_sock->accept_queue,
+			&llcp_sock_parent->accept_queue);
+	llcp_sock->parent = parent;
+	sk_acceptq_added(parent);
+}
+
+struct sock *nfc_llcp_accept_dequeue(struct sock *parent,
+					struct socket *newsock)
+{
+	struct nfc_llcp_sock *lsk, *n, *llcp_parent;
+	struct sock *sk;
+
+	llcp_parent = nfc_llcp_sock(parent);
+
+	list_for_each_entry_safe(lsk, n, &llcp_parent->accept_queue,
+							accept_queue) {
+		sk = &lsk->sk;
+		lock_sock(sk);
+
+		if (sk->sk_state == LLCP_CLOSED) {
+			release_sock(sk);
+			nfc_llcp_accept_unlink(sk);
+			continue;
+		}
+
+		if (sk->sk_state == LLCP_CONNECTED || !newsock) {
+			nfc_llcp_accept_unlink(sk);
+			if (newsock)
+				sock_graft(sk, newsock);
+
+			release_sock(sk);
+
+			pr_debug("Returning sk state %d\n", sk->sk_state);
+
+			return sk;
+		}
+
+		release_sock(sk);
+	}
+
+	return NULL;
+}
+
+static int llcp_sock_accept(struct socket *sock, struct socket *newsock,
+								int flags)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	struct sock *sk = sock->sk, *new_sk;
+	long timeo;
+	int ret = 0;
+
+	pr_debug("parent %p\n", sk);
+
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+
+	if (sk->sk_state != LLCP_LISTEN) {
+		ret = -EBADFD;
+		goto error;
+	}
+
+	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+
+	/* Wait for an incoming connection. */
+	add_wait_queue_exclusive(sk_sleep(sk), &wait);
+	while (!(new_sk = nfc_llcp_accept_dequeue(sk, newsock))) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (!timeo) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			ret = sock_intr_errno(timeo);
+			break;
+		}
+
+		release_sock(sk);
+		timeo = schedule_timeout(timeo);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+	}
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(sk_sleep(sk), &wait);
+
+	if (ret)
+		goto error;
+
+	newsock->state = SS_CONNECTED;
+
+	pr_debug("new socket %p\n", new_sk);
+
+error:
+	release_sock(sk);
+
+	return ret;
+}
+
+static int llcp_sock_getname(struct socket *sock, struct sockaddr *addr,
+			     int *len, int peer)
+{
+	struct sockaddr_nfc_llcp *llcp_addr = (struct sockaddr_nfc_llcp *) addr;
+	struct sock *sk = sock->sk;
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+
+	pr_debug("%p\n", sk);
+
+	addr->sa_family = AF_NFC;
+	*len = sizeof(struct sockaddr_nfc_llcp);
+
+	llcp_addr->dev_idx = llcp_sock->dev->idx;
+	llcp_addr->dsap = llcp_sock->dsap;
+	llcp_addr->ssap = llcp_sock->ssap;
+	llcp_addr->service_name_len = llcp_sock->service_name_len;
+	memcpy(llcp_addr->service_name, llcp_sock->service_name,
+					llcp_addr->service_name_len);
+
+	return 0;
+}
+
+static inline unsigned int llcp_accept_poll(struct sock *parent)
+{
+	struct nfc_llcp_sock *llcp_sock, *n, *parent_sock;
+	struct sock *sk;
+
+	parent_sock = nfc_llcp_sock(parent);
+
+	list_for_each_entry_safe(llcp_sock, n, &parent_sock->accept_queue,
+								accept_queue) {
+		sk = &llcp_sock->sk;
+
+		if (sk->sk_state == LLCP_CONNECTED)
+			return POLLIN | POLLRDNORM;
+	}
+
+	return 0;
+}
+
+static unsigned int llcp_sock_poll(struct file *file, struct socket *sock,
+							poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	unsigned int mask = 0;
+
+	pr_debug("%p\n", sk);
+
+	sock_poll_wait(file, sk_sleep(sk), wait);
+
+	if (sk->sk_state == LLCP_LISTEN)
+		return llcp_accept_poll(sk);
+
+	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+		mask |= POLLERR;
+
+	if (!skb_queue_empty(&sk->sk_receive_queue))
+		mask |= POLLIN;
+
+	if (sk->sk_state == LLCP_CLOSED)
+		mask |= POLLHUP;
+
+	return mask;
+}
+
+static int llcp_sock_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct nfc_llcp_local *local;
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+
+	if (!sk)
+		return 0;
+
+	pr_debug("%p\n", sk);
+
+	local = llcp_sock->local;
+	if (local == NULL)
+		return -ENODEV;
+
+	mutex_lock(&local->socket_lock);
+
+	if (llcp_sock == local->sockets[llcp_sock->ssap]) {
+		local->sockets[llcp_sock->ssap] = NULL;
+	} else {
+		struct nfc_llcp_sock *parent, *s, *n;
+
+		parent = local->sockets[llcp_sock->ssap];
+
+		list_for_each_entry_safe(s, n, &parent->list, list)
+			if (llcp_sock == s) {
+				list_del(&s->list);
+				break;
+			}
+
+	}
+
+	mutex_unlock(&local->socket_lock);
+
+	lock_sock(sk);
+
+	/* Send a DISC */
+	if (sk->sk_state == LLCP_CONNECTED)
+		nfc_llcp_disconnect(llcp_sock);
+
+	if (sk->sk_state == LLCP_LISTEN) {
+		struct nfc_llcp_sock *lsk, *n;
+		struct sock *accept_sk;
+
+		list_for_each_entry_safe(lsk, n, &llcp_sock->accept_queue,
+								accept_queue) {
+			accept_sk = &lsk->sk;
+			lock_sock(accept_sk);
+
+			nfc_llcp_disconnect(lsk);
+			nfc_llcp_accept_unlink(accept_sk);
+
+			release_sock(accept_sk);
+
+			sock_set_flag(sk, SOCK_DEAD);
+			sock_orphan(accept_sk);
+			sock_put(accept_sk);
+		}
+	}
+
+	/* Freeing the SAP */
+	if ((sk->sk_state == LLCP_CONNECTED
+			&& llcp_sock->ssap > LLCP_LOCAL_SAP_OFFSET) ||
+	    sk->sk_state == LLCP_BOUND ||
+	    sk->sk_state == LLCP_LISTEN)
+		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
+
+	sock_set_flag(sk, SOCK_DEAD);
+
+	release_sock(sk);
+
+	sock_orphan(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
+							int len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+	struct sockaddr_nfc_llcp *addr = (struct sockaddr_nfc_llcp *)_addr;
+	struct nfc_dev *dev;
+	struct nfc_llcp_local *local;
+	int ret = 0;
+
+	pr_debug("sock %p sk %p flags 0x%x\n", sock, sk, flags);
+
+	if (!addr || len < sizeof(struct sockaddr_nfc) ||
+			addr->sa_family != AF_NFC) {
+		pr_err("Invalid socket\n");
+		return -EINVAL;
+	}
+
+	if (addr->service_name_len == 0 && addr->dsap == 0) {
+		pr_err("Missing service name or dsap\n");
+		return -EINVAL;
+	}
+
+	pr_debug("addr dev_idx=%u target_idx=%u protocol=%u\n", addr->dev_idx,
+					addr->target_idx, addr->nfc_protocol);
+
+	lock_sock(sk);
+
+	if (sk->sk_state == LLCP_CONNECTED) {
+		ret = -EISCONN;
+		goto error;
+	}
+
+	dev = nfc_get_device(addr->dev_idx);
+	if (dev == NULL) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL) {
+		ret = -ENODEV;
+		goto put_dev;
+	}
+
+	device_lock(&dev->dev);
+	if (dev->dep_link_up == false) {
+		ret = -ENOLINK;
+		device_unlock(&dev->dev);
+		goto put_dev;
+	}
+	device_unlock(&dev->dev);
+
+	if (local->rf_mode == NFC_RF_INITIATOR &&
+			addr->target_idx != local->target_idx) {
+		ret = -ENOLINK;
+		goto put_dev;
+	}
+
+	llcp_sock->dev = dev;
+	llcp_sock->local = local;
+	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
+	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		ret = -ENOMEM;
+		goto put_dev;
+	}
+	if (addr->service_name_len == 0)
+		llcp_sock->dsap = addr->dsap;
+	else
+		llcp_sock->dsap = LLCP_SAP_SDP;
+	llcp_sock->nfc_protocol = addr->nfc_protocol;
+	llcp_sock->service_name_len = min_t(unsigned int,
+			addr->service_name_len, NFC_LLCP_MAX_SERVICE_NAME);
+	llcp_sock->service_name = kmemdup(addr->service_name,
+				 llcp_sock->service_name_len, GFP_KERNEL);
+
+	local->sockets[llcp_sock->ssap] = llcp_sock;
+
+	ret = nfc_llcp_send_connect(llcp_sock);
+	if (ret)
+		goto put_dev;
+
+	sk->sk_state = LLCP_CONNECTED;
+
+	release_sock(sk);
+	return 0;
+
+put_dev:
+	nfc_put_device(dev);
+
+error:
+	release_sock(sk);
+	return ret;
+}
+
+static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
+			     struct msghdr *msg, size_t len, int flags)
+{
+	int noblock = flags & MSG_DONTWAIT;
+	struct sock *sk = sock->sk;
+	unsigned int copied, rlen;
+	struct sk_buff *skb, *cskb;
+	int err = 0;
+
+	pr_debug("%p %zu\n", sk, len);
+
+	lock_sock(sk);
+
+	if (sk->sk_state == LLCP_CLOSED &&
+			skb_queue_empty(&sk->sk_receive_queue)) {
+		release_sock(sk);
+		return 0;
+	}
+
+	release_sock(sk);
+
+	if (flags & (MSG_OOB))
+		return -EOPNOTSUPP;
+
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	if (!skb) {
+		pr_err("Recv datagram failed state %d %d %d",
+				sk->sk_state, err, sock_error(sk));
+
+		if (sk->sk_shutdown & RCV_SHUTDOWN)
+			return 0;
+
+		return err;
+	}
+
+	rlen   = skb->len;		/* real length of skb */
+	copied = min_t(unsigned int, rlen, len);
+
+	cskb = skb;
+	if (memcpy_toiovec(msg->msg_iov, cskb->data, copied)) {
+		if (!(flags & MSG_PEEK))
+			skb_queue_head(&sk->sk_receive_queue, skb);
+		return -EFAULT;
+	}
+
+	/* Mark read part of skb as used */
+	if (!(flags & MSG_PEEK)) {
+
+		/* SOCK_STREAM: re-queue skb if it contains unreceived data */
+		if (sk->sk_type == SOCK_STREAM) {
+			skb_pull(skb, copied);
+			if (skb->len) {
+				skb_queue_head(&sk->sk_receive_queue, skb);
+				goto done;
+			}
+		}
+
+		kfree_skb(skb);
+	}
+
+	/* XXX Queue backlogged skbs */
+
+done:
+	/* SOCK_SEQPACKET: return real length if MSG_TRUNC is set */
+	if (sk->sk_type == SOCK_SEQPACKET && (flags & MSG_TRUNC))
+		copied = rlen;
+
+	return copied;
+}
+
+static const struct proto_ops llcp_sock_ops = {
+	.family         = PF_NFC,
+	.owner          = THIS_MODULE,
+	.bind           = llcp_sock_bind,
+	.connect        = llcp_sock_connect,
+	.release        = llcp_sock_release,
+	.socketpair     = sock_no_socketpair,
+	.accept         = llcp_sock_accept,
+	.getname        = llcp_sock_getname,
+	.poll           = llcp_sock_poll,
+	.ioctl          = sock_no_ioctl,
+	.listen         = llcp_sock_listen,
+	.shutdown       = sock_no_shutdown,
+	.setsockopt     = sock_no_setsockopt,
+	.getsockopt     = sock_no_getsockopt,
+	.sendmsg        = sock_no_sendmsg,
+	.recvmsg        = llcp_sock_recvmsg,
+	.mmap           = sock_no_mmap,
+};
+
+static void llcp_sock_destruct(struct sock *sk)
+{
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+
+	pr_debug("%p\n", sk);
+
+	if (sk->sk_state == LLCP_CONNECTED)
+		nfc_put_device(llcp_sock->dev);
+
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	nfc_llcp_sock_free(llcp_sock);
+
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		pr_err("Freeing alive NFC LLCP socket %p\n", sk);
+		return;
+	}
+}
+
+struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
+{
+	struct sock *sk;
+	struct nfc_llcp_sock *llcp_sock;
+
+	sk = sk_alloc(&init_net, PF_NFC, gfp, &llcp_sock_proto);
+	if (!sk)
+		return NULL;
+
+	llcp_sock = nfc_llcp_sock(sk);
+
+	sock_init_data(sock, sk);
+	sk->sk_state = LLCP_CLOSED;
+	sk->sk_protocol = NFC_SOCKPROTO_LLCP;
+	sk->sk_type = type;
+	sk->sk_destruct = llcp_sock_destruct;
+
+	llcp_sock->ssap = 0;
+	llcp_sock->dsap = LLCP_SAP_SDP;
+	llcp_sock->send_n = llcp_sock->send_ack_n = 0;
+	llcp_sock->recv_n = llcp_sock->recv_ack_n = 0;
+	llcp_sock->remote_ready = 1;
+	skb_queue_head_init(&llcp_sock->tx_queue);
+	skb_queue_head_init(&llcp_sock->tx_pending_queue);
+	skb_queue_head_init(&llcp_sock->tx_backlog_queue);
+	INIT_LIST_HEAD(&llcp_sock->list);
+	INIT_LIST_HEAD(&llcp_sock->accept_queue);
+
+	if (sock != NULL)
+		sock->state = SS_UNCONNECTED;
+
+	return sk;
+}
+
+void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
+{
+	kfree(sock->service_name);
+
+	skb_queue_purge(&sock->tx_queue);
+	skb_queue_purge(&sock->tx_pending_queue);
+	skb_queue_purge(&sock->tx_backlog_queue);
+
+	list_del_init(&sock->accept_queue);
+
+	sock->parent = NULL;
+}
+
+static int llcp_sock_create(struct net *net, struct socket *sock,
+				const struct nfc_protocol *nfc_proto)
+{
+	struct sock *sk;
+
+	pr_debug("%p\n", sock);
+
+	if (sock->type != SOCK_STREAM && sock->type != SOCK_DGRAM)
+		return -ESOCKTNOSUPPORT;
+
+	sock->ops = &llcp_sock_ops;
+
+	sk = nfc_llcp_sock_alloc(sock, sock->type, GFP_ATOMIC);
+	if (sk == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static const struct nfc_protocol llcp_nfc_proto = {
+	.id	  = NFC_SOCKPROTO_LLCP,
+	.proto    = &llcp_sock_proto,
+	.owner    = THIS_MODULE,
+	.create   = llcp_sock_create
+};
+
+int __init nfc_llcp_sock_init(void)
+{
+	return nfc_proto_register(&llcp_nfc_proto);
+}
+
+void nfc_llcp_sock_exit(void)
+{
+	nfc_proto_unregister(&llcp_nfc_proto);
+}
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 4d0fb12..2c2c401 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -46,6 +46,60 @@ struct nfc_rawsock {
 #define to_rawsock_sk(_tx_work) \
 	((struct sock *) container_of(_tx_work, struct nfc_rawsock, tx_work))
 
+#ifdef CONFIG_NFC_LLCP
+
+void nfc_llcp_mac_is_down(struct nfc_dev *dev);
+void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
+			u8 comm_mode, u8 rf_mode);
+int nfc_llcp_register_device(struct nfc_dev *dev);
+void nfc_llcp_unregister_device(struct nfc_dev *dev);
+int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len);
+u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *general_bytes_len);
+int __init nfc_llcp_init(void);
+void nfc_llcp_exit(void);
+
+#else
+
+void nfc_llcp_mac_is_down(struct nfc_dev *dev)
+{
+}
+
+void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
+			u8 comm_mode, u8 rf_mode)
+{
+}
+
+static inline int nfc_llcp_register_device(struct nfc_dev *dev)
+{
+	return 0;
+}
+
+static inline void nfc_llcp_unregister_device(struct nfc_dev *dev)
+{
+}
+
+static inline int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
+{
+	return 0;
+}
+
+static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *gb_len)
+{
+	*gb_len = 0;
+	return NULL;
+}
+
+static inline int nfc_llcp_init(void)
+{
+	return 0;
+}
+
+static inline void nfc_llcp_exit(void)
+{
+}
+
+#endif
+
 int __init rawsock_init(void);
 void rawsock_exit(void);
 
-- 
1.7.7.3

