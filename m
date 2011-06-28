Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38443 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab1F1SVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:21:54 -0400
Received: by mail-yw0-f46.google.com with SMTP id 9so191290ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 11:21:53 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	padovan@profusion.mobi, rdunlap@xenotime.net,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH v4 4/6] NFC: add the NFC socket raw protocol
Date: Tue, 28 Jun 2011 15:20:44 -0300
Message-Id: <1309285246-8495-5-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110628_203943_626656_3F807F8B)
In-Reply-To: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>

This socket protocol is used to perform data exchange with NFC
targets.

Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h |   13 ++-
 net/nfc/Makefile    |    2 +-
 net/nfc/core.c      |    7 +
 net/nfc/nfc.h       |   14 ++
 net/nfc/rawsock.c   |  351 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 385 insertions(+), 2 deletions(-)
 create mode 100644 net/nfc/rawsock.c

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 15f8cb3..330a4c5 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -24,6 +24,9 @@
 #ifndef __LINUX_NFC_H
 #define __LINUX_NFC_H
 
+#include <linux/types.h>
+#include <linux/socket.h>
+
 #define NFC_GENL_NAME "nfc"
 #define NFC_GENL_VERSION 1
 
@@ -109,7 +112,15 @@ enum nfc_attrs {
 #define NFC_PROTO_ISO14443_MASK	(1 << NFC_PROTO_ISO14443)
 #define NFC_PROTO_NFC_DEP_MASK	(1 << NFC_PROTO_NFC_DEP)
 
+struct sockaddr_nfc {
+	sa_family_t sa_family;
+	__u32 dev_idx;
+	__u32 target_idx;
+	__u32 nfc_protocol;
+};
+
 /* NFC socket protocols */
-#define NFC_SOCKPROTO_MAX	0
+#define NFC_SOCKPROTO_RAW	0
+#define NFC_SOCKPROTO_MAX	1
 
 #endif /*__LINUX_NFC_H */
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index e081fdb..16250c3 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_NFC) += nfc.o
 
-nfc-objs := core.o netlink.o af_nfc.o
+nfc-objs := core.o netlink.o af_nfc.o rawsock.o
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 23e7ed7..259dd43 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -409,6 +409,10 @@ static int __init nfc_init(void)
 	/* the first generation must not be 0 */
 	nfc_devlist_generation = 1;
 
+	rc = rawsock_init();
+	if (rc)
+		goto err_rawsock;
+
 	rc = af_nfc_init();
 	if (rc)
 		goto err_af_nfc;
@@ -416,6 +420,8 @@ static int __init nfc_init(void)
 	return 0;
 
 err_af_nfc:
+	rawsock_exit();
+err_rawsock:
 	nfc_genl_exit();
 err_genl:
 	class_unregister(&nfc_class);
@@ -425,6 +431,7 @@ err_genl:
 static void __exit nfc_exit(void)
 {
 	af_nfc_exit();
+	rawsock_exit();
 	nfc_genl_exit();
 	class_unregister(&nfc_class);
 }
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 70a1c3a..66c520e 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -39,6 +39,20 @@ struct nfc_protocol {
 			const struct nfc_protocol *nfc_proto);
 };
 
+struct nfc_rawsock {
+	struct sock sk;
+	struct nfc_dev *dev;
+	u32 target_idx;
+	struct work_struct tx_work;
+	bool tx_work_scheduled;
+};
+#define nfc_rawsock(sk) ((struct nfc_rawsock *) sk)
+#define to_rawsock_sk(_tx_work) \
+	((struct sock *) container_of(_tx_work, struct nfc_rawsock, tx_work))
+
+int __init rawsock_init(void);
+void rawsock_exit(void);
+
 int __init af_nfc_init(void);
 void af_nfc_exit(void);
 int nfc_proto_register(const struct nfc_protocol *nfc_proto);
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
new file mode 100644
index 0000000..e588e04
--- /dev/null
+++ b/net/nfc/rawsock.c
@@ -0,0 +1,351 @@
+/*
+ * Copyright (C) 2011 Instituto Nokia de Tecnologia
+ *
+ * Authors:
+ *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+ *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
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
+#include <net/tcp_states.h>
+#include <linux/nfc.h>
+
+#include "nfc.h"
+
+static void rawsock_write_queue_purge(struct sock *sk)
+{
+	NFC_DBG("");
+
+	spin_lock_bh(&sk->sk_write_queue.lock);
+	__skb_queue_purge(&sk->sk_write_queue);
+	nfc_rawsock(sk)->tx_work_scheduled = false;
+	spin_unlock_bh(&sk->sk_write_queue.lock);
+}
+
+static void rawsock_report_error(struct sock *sk, int err)
+{
+	NFC_DBG("");
+
+	sk->sk_shutdown = SHUTDOWN_MASK;
+	sk->sk_err = -err;
+	sk->sk_error_report(sk);
+
+	rawsock_write_queue_purge(sk);
+}
+
+static int rawsock_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	NFC_DBG("");
+
+	sock_orphan(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
+							int len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct sockaddr_nfc *addr = (struct sockaddr_nfc *)_addr;
+	struct nfc_dev *dev;
+	int rc = 0;
+
+	NFC_DBG("");
+
+	if (!addr || len < sizeof(struct sockaddr_nfc) ||
+		addr->sa_family != AF_NFC)
+		return -EINVAL;
+
+	lock_sock(sk);
+
+	if (sock->state == SS_CONNECTED) {
+		rc = -EISCONN;
+		goto error;
+	}
+
+	dev = nfc_get_device(addr->dev_idx);
+	if (!dev) {
+		rc = -ENODEV;
+		goto error;
+	}
+
+	if (addr->target_idx > dev->target_idx - 1 ||
+		addr->target_idx < dev->target_idx - dev->n_targets) {
+		rc = -EINVAL;
+		goto error;
+	}
+
+	if (addr->target_idx > dev->target_idx - 1 ||
+		addr->target_idx < dev->target_idx - dev->n_targets) {
+		rc = -EINVAL;
+		goto error;
+	}
+
+	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);
+	if (rc)
+		goto put_dev;
+
+	nfc_rawsock(sk)->dev = dev;
+	nfc_rawsock(sk)->target_idx = addr->target_idx;
+	sock->state = SS_CONNECTED;
+	sk->sk_state = TCP_ESTABLISHED;
+	sk->sk_state_change(sk);
+
+	release_sock(sk);
+	return 0;
+
+put_dev:
+	nfc_put_device(dev);
+error:
+	release_sock(sk);
+	return rc;
+}
+
+static int rawsock_add_header(struct sk_buff *skb)
+{
+
+	if (skb_cow_head(skb, 1))
+		return -ENOMEM;
+
+	*skb_push(skb, 1) = 0;
+
+	return 0;
+}
+
+static void rawsock_data_exchange_complete(void *context, struct sk_buff *skb,
+								int err)
+{
+	struct sock *sk = (struct sock *) context;
+
+	BUG_ON(in_irq());
+
+	if (err)
+		goto error;
+
+	err = rawsock_add_header(skb);
+	if (err)
+		goto error;
+
+	err = sock_queue_rcv_skb(sk, skb);
+	if (err)
+		goto error;
+
+	spin_lock_bh(&sk->sk_write_queue.lock);
+	if (!skb_queue_empty(&sk->sk_write_queue))
+		schedule_work(&nfc_rawsock(sk)->tx_work);
+	else
+		nfc_rawsock(sk)->tx_work_scheduled = false;
+	spin_unlock_bh(&sk->sk_write_queue.lock);
+
+	sock_put(sk);
+	return;
+
+error:
+	rawsock_report_error(sk, err);
+	sock_put(sk);
+}
+
+static void rawsock_tx_work(struct work_struct *work)
+{
+	struct sock *sk = to_rawsock_sk(work);
+	struct nfc_dev *dev = nfc_rawsock(sk)->dev;
+	u32 target_idx = nfc_rawsock(sk)->target_idx;
+	struct sk_buff *skb;
+	int rc;
+
+	if (sk->sk_shutdown & SEND_SHUTDOWN) {
+		rawsock_write_queue_purge(sk);
+		return;
+	}
+
+	skb = skb_dequeue(&sk->sk_write_queue);
+
+	sock_hold(sk);
+	rc = nfc_data_exchange(dev, target_idx, skb,
+				rawsock_data_exchange_complete, sk);
+	if (rc) {
+		rawsock_report_error(sk, rc);
+		sock_put(sk);
+	}
+}
+
+static int rawsock_sendmsg(struct kiocb *iocb, struct socket *sock,
+					struct msghdr *msg, size_t len)
+{
+	struct sock *sk = sock->sk;
+	struct sk_buff *skb;
+	int rc;
+
+	NFC_DBG("");
+
+	if (msg->msg_namelen)
+		return -EOPNOTSUPP;
+
+	if (sock->state != SS_CONNECTED)
+		return -ENOTCONN;
+
+	skb = sock_alloc_send_skb(sk, len, msg->msg_flags & MSG_DONTWAIT,
+									&rc);
+	if (!skb)
+		return rc;
+
+	rc = memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len);
+	if (rc < 0) {
+		kfree_skb(skb);
+		return rc;
+	}
+
+	spin_lock_bh(&sk->sk_write_queue.lock);
+	__skb_queue_tail(&sk->sk_write_queue, skb);
+	if (!nfc_rawsock(sk)->tx_work_scheduled) {
+		schedule_work(&nfc_rawsock(sk)->tx_work);
+		nfc_rawsock(sk)->tx_work_scheduled = true;
+	}
+	spin_unlock_bh(&sk->sk_write_queue.lock);
+
+	return len;
+}
+
+static int rawsock_recvmsg(struct kiocb *iocb, struct socket *sock,
+				struct msghdr *msg, size_t len, int flags)
+{
+	int noblock = flags & MSG_DONTWAIT;
+	struct sock *sk = sock->sk;
+	struct sk_buff *skb;
+	int copied;
+	int rc;
+
+	NFC_DBG("");
+
+	skb = skb_recv_datagram(sk, flags, noblock, &rc);
+	if (!skb)
+		return rc;
+
+	msg->msg_namelen = 0;
+
+	copied = skb->len;
+	if (len < copied) {
+		msg->msg_flags |= MSG_TRUNC;
+		copied = len;
+	}
+
+	rc = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+
+	skb_free_datagram(sk, skb);
+
+	return rc ? : copied;
+}
+
+
+static const struct proto_ops rawsock_ops = {
+	.family         = PF_NFC,
+	.owner          = THIS_MODULE,
+	.release        = rawsock_release,
+	.bind           = sock_no_bind,
+	.connect        = rawsock_connect,
+	.socketpair     = sock_no_socketpair,
+	.accept         = sock_no_accept,
+	.getname        = sock_no_getname,
+	.poll           = datagram_poll,
+	.ioctl          = sock_no_ioctl,
+	.listen         = sock_no_listen,
+	.shutdown       = sock_no_shutdown,
+	.setsockopt     = sock_no_setsockopt,
+	.getsockopt     = sock_no_getsockopt,
+	.sendmsg        = rawsock_sendmsg,
+	.recvmsg        = rawsock_recvmsg,
+	.mmap           = sock_no_mmap,
+};
+
+static void rawsock_destruct(struct sock *sk)
+{
+	NFC_DBG("");
+
+	if (sk->sk_state == TCP_ESTABLISHED) {
+		nfc_deactivate_target(nfc_rawsock(sk)->dev,
+					nfc_rawsock(sk)->target_idx);
+		nfc_put_device(nfc_rawsock(sk)->dev);
+	}
+
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		NFC_ERR("Freeing alive NFC raw socket %p", sk);
+		return;
+	}
+}
+
+static int rawsock_create(struct net *net, struct socket *sock,
+				const struct nfc_protocol *nfc_proto)
+{
+	struct sock *sk;
+
+	NFC_DBG("");
+
+	if (sock->type != SOCK_SEQPACKET)
+		return -ESOCKTNOSUPPORT;
+
+	sock->ops = &rawsock_ops;
+
+	sk = sk_alloc(net, PF_NFC, GFP_KERNEL, nfc_proto->proto);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_init_data(sock, sk);
+	sk->sk_protocol = nfc_proto->id;
+	sk->sk_destruct = rawsock_destruct;
+	sock->state = SS_UNCONNECTED;
+
+	INIT_WORK(&nfc_rawsock(sk)->tx_work, rawsock_tx_work);
+	nfc_rawsock(sk)->tx_work_scheduled = false;
+
+	return 0;
+}
+
+static struct proto rawsock_proto = {
+	.name     = "NFC_RAW",
+	.owner    = THIS_MODULE,
+	.obj_size = sizeof(struct nfc_rawsock),
+};
+
+static const struct nfc_protocol rawsock_nfc_proto = {
+	.id	  = NFC_SOCKPROTO_RAW,
+	.proto    = &rawsock_proto,
+	.owner    = THIS_MODULE,
+	.create   = rawsock_create
+};
+
+int __init rawsock_init(void)
+{
+	int rc;
+
+	NFC_DBG("");
+
+	rc = nfc_proto_register(&rawsock_nfc_proto);
+
+	return rc;
+}
+
+void rawsock_exit(void)
+{
+	NFC_DBG("");
+
+	nfc_proto_unregister(&rawsock_nfc_proto);
+}
-- 
1.7.5.4

