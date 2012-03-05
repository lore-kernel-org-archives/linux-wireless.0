Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29513 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab2CDX6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:33 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 21/22] NFC: Core code identation fixes
Date: Mon,  5 Mar 2012 01:03:53 +0100
Message-Id: <1330905834-6994-22-git-send-email-sameo@linux.intel.com> (sfid-20120305_005837_473501_DCAEDF37)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |   24 ++++++++++----------
 net/nfc/af_nfc.c      |    2 +-
 net/nfc/core.c        |   28 ++++++++++-------------
 net/nfc/netlink.c     |   57 +++++++++++++++++++++++-------------------------
 net/nfc/nfc.h         |   13 +++++------
 net/nfc/rawsock.c     |   16 +++++++-------
 6 files changed, 66 insertions(+), 74 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index d608e4e..bac070b 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -57,11 +57,11 @@ struct nfc_ops {
 			   u8 *gb, size_t gb_len);
 	int (*dep_link_down)(struct nfc_dev *dev);
 	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
-							u32 protocol);
+			       u32 protocol);
 	void (*deactivate_target)(struct nfc_dev *dev, u32 target_idx);
 	int (*data_exchange)(struct nfc_dev *dev, u32 target_idx,
-				struct sk_buff *skb, data_exchange_cb_t cb,
-							void *cb_context);
+			     struct sk_buff *skb, data_exchange_cb_t cb,
+			     void *cb_context);
 };
 
 #define NFC_TARGET_IDX_ANY -1
@@ -110,9 +110,9 @@ struct nfc_dev {
 extern struct class nfc_class;
 
 struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
-					u32 supported_protocols,
-					int tx_headroom,
-					int tx_tailroom);
+				    u32 supported_protocols,
+				    int tx_headroom,
+				    int tx_tailroom);
 
 /**
  * nfc_free_device - free nfc device
@@ -135,7 +135,7 @@ void nfc_unregister_device(struct nfc_dev *dev);
  * @dev: The parent device
  */
 static inline void nfc_set_parent_dev(struct nfc_dev *nfc_dev,
-					struct device *dev)
+				      struct device *dev)
 {
 	nfc_dev->dev.parent = dev;
 }
@@ -172,15 +172,15 @@ static inline const char *nfc_device_name(struct nfc_dev *dev)
 }
 
 struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
-					unsigned int flags, unsigned int size,
-					unsigned int *err);
+				   unsigned int flags, unsigned int size,
+				   unsigned int *err);
 struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 
 int nfc_set_remote_general_bytes(struct nfc_dev *dev,
-					u8 *gt, u8 gt_len);
+				 u8 *gt, u8 gt_len);
 
-int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
-							int ntargets);
+int nfc_targets_found(struct nfc_dev *dev,
+		      struct nfc_target *targets, int ntargets);
 
 int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 		       u8 comm_mode, u8 rf_mode);
diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
index da67756..9d68441 100644
--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -30,7 +30,7 @@ static DEFINE_RWLOCK(proto_tab_lock);
 static const struct nfc_protocol *proto_tab[NFC_SOCKPROTO_MAX];
 
 static int nfc_sock_create(struct net *net, struct socket *sock, int proto,
-								int kern)
+			   int kern)
 {
 	int rc = -EPROTONOSUPPORT;
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index f4f526f..295d129 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -256,7 +256,7 @@ error:
 }
 
 int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
-					u8 comm_mode, u8 rf_mode)
+		       u8 comm_mode, u8 rf_mode)
 {
 	dev->dep_link_up = true;
 	dev->dep_rf_mode = rf_mode;
@@ -336,10 +336,8 @@ error:
  *
  * The user must wait for the callback before calling this function again.
  */
-int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx,
-					struct sk_buff *skb,
-					data_exchange_cb_t cb,
-					void *cb_context)
+int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
+		      data_exchange_cb_t cb, void *cb_context)
 {
 	int rc;
 
@@ -363,8 +361,7 @@ error:
 
 int nfc_set_remote_general_bytes(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 {
-	pr_debug("dev_name=%s gb_len=%d\n",
-			dev_name(&dev->dev), gb_len);
+	pr_debug("dev_name=%s gb_len=%d\n", dev_name(&dev->dev), gb_len);
 
 	if (gb_len > NFC_MAX_GT_LEN)
 		return -EINVAL;
@@ -380,8 +377,8 @@ EXPORT_SYMBOL(nfc_set_remote_general_bytes);
  * @gfp: gfp flags
  */
 struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
-					unsigned int flags, unsigned int size,
-					unsigned int *err)
+				   unsigned int flags, unsigned int size,
+				   unsigned int *err)
 {
 	struct sk_buff *skb;
 	unsigned int total_size;
@@ -428,8 +425,8 @@ EXPORT_SYMBOL(nfc_alloc_recv_skb);
  * are found. After calling this function, the device driver must stop
  * polling for targets.
  */
-int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
-							int n_targets)
+int nfc_targets_found(struct nfc_dev *dev,
+		      struct nfc_target *targets, int n_targets)
 {
 	pr_debug("dev_name=%s n_targets=%d\n", dev_name(&dev->dev), n_targets);
 
@@ -441,7 +438,7 @@ int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
 
 	kfree(dev->targets);
 	dev->targets = kmemdup(targets, n_targets * sizeof(struct nfc_target),
-								GFP_ATOMIC);
+			       GFP_ATOMIC);
 
 	if (!dev->targets) {
 		dev->n_targets = 0;
@@ -501,15 +498,14 @@ struct nfc_dev *nfc_get_device(unsigned idx)
  * @supported_protocols: NFC protocols supported by the device
  */
 struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
-					u32 supported_protocols,
-					int tx_headroom,
-					int tx_tailroom)
+				    u32 supported_protocols,
+				    int tx_headroom, int tx_tailroom)
 {
 	static atomic_t dev_no = ATOMIC_INIT(0);
 	struct nfc_dev *dev;
 
 	if (!ops->start_poll || !ops->stop_poll || !ops->activate_target ||
-		!ops->deactivate_target || !ops->data_exchange)
+	    !ops->deactivate_target || !ops->data_exchange)
 		return NULL;
 
 	if (!supported_protocols)
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index fa620d0..6404052 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -52,31 +52,30 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 };
 
 static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
-					struct netlink_callback *cb, int flags)
+				struct netlink_callback *cb, int flags)
 {
 	void *hdr;
 
 	hdr = genlmsg_put(msg, NETLINK_CB(cb->skb).pid, cb->nlh->nlmsg_seq,
-				&nfc_genl_family, flags, NFC_CMD_GET_TARGET);
+			  &nfc_genl_family, flags, NFC_CMD_GET_TARGET);
 	if (!hdr)
 		return -EMSGSIZE;
 
 	genl_dump_check_consistent(cb, hdr, &nfc_genl_family);
 
 	NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target->idx);
-	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS,
-				target->supported_protocols);
+	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS, target->supported_protocols);
 	NLA_PUT_U16(msg, NFC_ATTR_TARGET_SENS_RES, target->sens_res);
 	NLA_PUT_U8(msg, NFC_ATTR_TARGET_SEL_RES, target->sel_res);
 	if (target->nfcid1_len > 0)
 		NLA_PUT(msg, NFC_ATTR_TARGET_NFCID1, target->nfcid1_len,
-				target->nfcid1);
+			target->nfcid1);
 	if (target->sensb_res_len > 0)
 		NLA_PUT(msg, NFC_ATTR_TARGET_SENSB_RES, target->sensb_res_len,
-				target->sensb_res);
+			target->sensb_res);
 	if (target->sensf_res_len > 0)
 		NLA_PUT(msg, NFC_ATTR_TARGET_SENSF_RES, target->sensf_res_len,
-				target->sensf_res);
+			target->sensf_res);
 
 	return genlmsg_end(msg, hdr);
 
@@ -92,9 +91,9 @@ static struct nfc_dev *__get_device_from_cb(struct netlink_callback *cb)
 	u32 idx;
 
 	rc = nlmsg_parse(cb->nlh, GENL_HDRLEN + nfc_genl_family.hdrsize,
-						nfc_genl_family.attrbuf,
-						nfc_genl_family.maxattr,
-						nfc_genl_policy);
+			 nfc_genl_family.attrbuf,
+			 nfc_genl_family.maxattr,
+			 nfc_genl_policy);
 	if (rc < 0)
 		return ERR_PTR(rc);
 
@@ -111,7 +110,7 @@ static struct nfc_dev *__get_device_from_cb(struct netlink_callback *cb)
 }
 
 static int nfc_genl_dump_targets(struct sk_buff *skb,
-				struct netlink_callback *cb)
+				 struct netlink_callback *cb)
 {
 	int i = cb->args[0];
 	struct nfc_dev *dev = (struct nfc_dev *) cb->args[1];
@@ -131,7 +130,7 @@ static int nfc_genl_dump_targets(struct sk_buff *skb,
 
 	while (i < dev->n_targets) {
 		rc = nfc_genl_send_target(skb, &dev->targets[i], cb,
-								NLM_F_MULTI);
+					  NLM_F_MULTI);
 		if (rc < 0)
 			break;
 
@@ -167,7 +166,7 @@ int nfc_genl_targets_found(struct nfc_dev *dev)
 		return -ENOMEM;
 
 	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
-				NFC_EVENT_TARGETS_FOUND);
+			  NFC_EVENT_TARGETS_FOUND);
 	if (!hdr)
 		goto free_msg;
 
@@ -194,7 +193,7 @@ int nfc_genl_device_added(struct nfc_dev *dev)
 		return -ENOMEM;
 
 	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
-				NFC_EVENT_DEVICE_ADDED);
+			  NFC_EVENT_DEVICE_ADDED);
 	if (!hdr)
 		goto free_msg;
 
@@ -226,7 +225,7 @@ int nfc_genl_device_removed(struct nfc_dev *dev)
 		return -ENOMEM;
 
 	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
-				NFC_EVENT_DEVICE_REMOVED);
+			  NFC_EVENT_DEVICE_REMOVED);
 	if (!hdr)
 		goto free_msg;
 
@@ -246,14 +245,14 @@ free_msg:
 }
 
 static int nfc_genl_send_device(struct sk_buff *msg, struct nfc_dev *dev,
-						u32 pid, u32 seq,
-						struct netlink_callback *cb,
-						int flags)
+				u32 pid, u32 seq,
+				struct netlink_callback *cb,
+				int flags)
 {
 	void *hdr;
 
 	hdr = genlmsg_put(msg, pid, seq, &nfc_genl_family, flags,
-							NFC_CMD_GET_DEVICE);
+			  NFC_CMD_GET_DEVICE);
 	if (!hdr)
 		return -EMSGSIZE;
 
@@ -273,7 +272,7 @@ nla_put_failure:
 }
 
 static int nfc_genl_dump_devices(struct sk_buff *skb,
-				struct netlink_callback *cb)
+				 struct netlink_callback *cb)
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 	struct nfc_dev *dev = (struct nfc_dev *) cb->args[1];
@@ -300,8 +299,7 @@ static int nfc_genl_dump_devices(struct sk_buff *skb,
 		int rc;
 
 		rc = nfc_genl_send_device(skb, dev, NETLINK_CB(cb->skb).pid,
-							cb->nlh->nlmsg_seq,
-							cb, NLM_F_MULTI);
+					  cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
 		if (rc < 0)
 			break;
 
@@ -326,7 +324,7 @@ static int nfc_genl_dump_devices_done(struct netlink_callback *cb)
 }
 
 int nfc_genl_dep_link_up_event(struct nfc_dev *dev, u32 target_idx,
-						u8 comm_mode, u8 rf_mode)
+			       u8 comm_mode, u8 rf_mode)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -337,8 +335,7 @@ int nfc_genl_dep_link_up_event(struct nfc_dev *dev, u32 target_idx,
 	if (!msg)
 		return -ENOMEM;
 
-	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
-				NFC_CMD_DEP_LINK_UP);
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0, NFC_CMD_DEP_LINK_UP);
 	if (!hdr)
 		goto free_msg;
 
@@ -375,7 +372,7 @@ int nfc_genl_dep_link_down_event(struct nfc_dev *dev)
 		return -ENOMEM;
 
 	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
-				NFC_CMD_DEP_LINK_DOWN);
+			  NFC_CMD_DEP_LINK_DOWN);
 	if (!hdr)
 		goto free_msg;
 
@@ -417,7 +414,7 @@ static int nfc_genl_get_device(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rc = nfc_genl_send_device(msg, dev, info->snd_pid, info->snd_seq,
-								NULL, 0);
+				  NULL, 0);
 	if (rc < 0)
 		goto out_free;
 
@@ -484,7 +481,7 @@ static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 	pr_debug("Poll start\n");
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
-		!info->attrs[NFC_ATTR_PROTOCOLS])
+	    !info->attrs[NFC_ATTR_PROTOCOLS])
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
@@ -640,7 +637,7 @@ static struct genl_ops nfc_genl_ops[] = {
 };
 
 static int nfc_genl_rcv_nl_event(struct notifier_block *this,
-						unsigned long event, void *ptr)
+				 unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
 	struct class_dev_iter iter;
@@ -693,7 +690,7 @@ int __init nfc_genl_init(void)
 	int rc;
 
 	rc = genl_register_family_with_ops(&nfc_genl_family, nfc_genl_ops,
-					ARRAY_SIZE(nfc_genl_ops));
+					   ARRAY_SIZE(nfc_genl_ops));
 	if (rc)
 		return rc;
 
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 2fd83b1..ec8794c 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -32,7 +32,7 @@ struct nfc_protocol {
 	struct proto *proto;
 	struct module *owner;
 	int (*create)(struct net *net, struct socket *sock,
-			const struct nfc_protocol *nfc_proto);
+		      const struct nfc_protocol *nfc_proto);
 };
 
 struct nfc_rawsock {
@@ -65,7 +65,7 @@ static inline void nfc_llcp_mac_is_down(struct nfc_dev *dev)
 }
 
 static inline void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
-			u8 comm_mode, u8 rf_mode)
+				      u8 comm_mode, u8 rf_mode)
 {
 }
 
@@ -78,7 +78,8 @@ static inline void nfc_llcp_unregister_device(struct nfc_dev *dev)
 {
 }
 
-static inline int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
+static inline int nfc_llcp_set_remote_gb(struct nfc_dev *dev,
+					 u8 *gb, u8 gb_len)
 {
 	return 0;
 }
@@ -168,9 +169,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol);
 
 int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx);
 
-int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx,
-					struct sk_buff *skb,
-					data_exchange_cb_t cb,
-					void *cb_context);
+int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
+		      data_exchange_cb_t cb, void *cb_context);
 
 #endif /* __LOCAL_NFC_H */
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 5325439..5a839ce 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -63,7 +63,7 @@ static int rawsock_release(struct socket *sock)
 }
 
 static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
-							int len, int flags)
+			   int len, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct sockaddr_nfc *addr = (struct sockaddr_nfc *)_addr;
@@ -73,7 +73,7 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
 	pr_debug("sock=%p sk=%p flags=%d\n", sock, sk, flags);
 
 	if (!addr || len < sizeof(struct sockaddr_nfc) ||
-		addr->sa_family != AF_NFC)
+	    addr->sa_family != AF_NFC)
 		return -EINVAL;
 
 	pr_debug("addr dev_idx=%u target_idx=%u protocol=%u\n",
@@ -120,7 +120,7 @@ static int rawsock_add_header(struct sk_buff *skb)
 }
 
 static void rawsock_data_exchange_complete(void *context, struct sk_buff *skb,
-								int err)
+					   int err)
 {
 	struct sock *sk = (struct sock *) context;
 
@@ -173,7 +173,7 @@ static void rawsock_tx_work(struct work_struct *work)
 
 	sock_hold(sk);
 	rc = nfc_data_exchange(dev, target_idx, skb,
-				rawsock_data_exchange_complete, sk);
+			       rawsock_data_exchange_complete, sk);
 	if (rc) {
 		rawsock_report_error(sk, rc);
 		sock_put(sk);
@@ -181,7 +181,7 @@ static void rawsock_tx_work(struct work_struct *work)
 }
 
 static int rawsock_sendmsg(struct kiocb *iocb, struct socket *sock,
-					struct msghdr *msg, size_t len)
+			   struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct nfc_dev *dev = nfc_rawsock(sk)->dev;
@@ -218,7 +218,7 @@ static int rawsock_sendmsg(struct kiocb *iocb, struct socket *sock,
 }
 
 static int rawsock_recvmsg(struct kiocb *iocb, struct socket *sock,
-				struct msghdr *msg, size_t len, int flags)
+			   struct msghdr *msg, size_t len, int flags)
 {
 	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
@@ -274,7 +274,7 @@ static void rawsock_destruct(struct sock *sk)
 
 	if (sk->sk_state == TCP_ESTABLISHED) {
 		nfc_deactivate_target(nfc_rawsock(sk)->dev,
-					nfc_rawsock(sk)->target_idx);
+				      nfc_rawsock(sk)->target_idx);
 		nfc_put_device(nfc_rawsock(sk)->dev);
 	}
 
@@ -287,7 +287,7 @@ static void rawsock_destruct(struct sock *sk)
 }
 
 static int rawsock_create(struct net *net, struct socket *sock,
-				const struct nfc_protocol *nfc_proto)
+			  const struct nfc_protocol *nfc_proto)
 {
 	struct sock *sk;
 
-- 
1.7.7.3

