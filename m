Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64714 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2FFKGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:40 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/29] NFC: Socket linked list
Date: Wed,  6 Jun 2012 12:16:19 +0200
Message-Id: <1338977806-30279-3-git-send-email-sameo@linux.intel.com> (sfid-20120606_120642_999405_6F4EF1C8)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify the LLCP sockets structure by putting all the connected ones
into a single linked list.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |  249 ++++++++++++++++++++++++++++-----------------------
 net/nfc/llcp/llcp.h |   12 ++-
 net/nfc/llcp/sock.c |   32 +++----
 3 files changed, 158 insertions(+), 135 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 0f6dd3a..262aa82 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -31,45 +31,41 @@ static u8 llcp_magic[3] = {0x46, 0x66, 0x6d};
 
 static struct list_head llcp_devices;
 
-static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
+void nfc_llcp_sock_link(struct llcp_sock_list *l, struct sock *sk)
 {
-	struct nfc_llcp_sock *parent, *s, *n;
-	struct sock *sk, *parent_sk;
-	int i;
-
-	mutex_lock(&local->socket_lock);
-
-	for (i = 0; i < LLCP_MAX_SAP; i++) {
-		parent = local->sockets[i];
-		if (parent == NULL)
-			continue;
-
-		/* Release all child sockets */
-		list_for_each_entry_safe(s, n, &parent->list, list) {
-			list_del_init(&s->list);
-			sk = &s->sk;
-
-			lock_sock(sk);
+	write_lock(&l->lock);
+	sk_add_node(sk, &l->head);
+	write_unlock(&l->lock);
+}
 
-			if (sk->sk_state == LLCP_CONNECTED)
-				nfc_put_device(s->dev);
+void nfc_llcp_sock_unlink(struct llcp_sock_list *l, struct sock *sk)
+{
+	write_lock(&l->lock);
+	sk_del_node_init(sk);
+	write_unlock(&l->lock);
+}
 
-			sk->sk_state = LLCP_CLOSED;
+static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
+{
+	struct sock *sk;
+	struct hlist_node *node, *tmp;
+	struct nfc_llcp_sock *llcp_sock;
 
-			release_sock(sk);
+	write_lock(&local->sockets.lock);
 
-			sock_orphan(sk);
-		}
+	sk_for_each_safe(sk, node, tmp, &local->sockets.head) {
+		llcp_sock = nfc_llcp_sock(sk);
 
-		parent_sk = &parent->sk;
+		lock_sock(sk);
 
-		lock_sock(parent_sk);
+		if (sk->sk_state == LLCP_CONNECTED)
+			nfc_put_device(llcp_sock->dev);
 
-		if (parent_sk->sk_state == LLCP_LISTEN) {
+		if (sk->sk_state == LLCP_LISTEN) {
 			struct nfc_llcp_sock *lsk, *n;
 			struct sock *accept_sk;
 
-			list_for_each_entry_safe(lsk, n, &parent->accept_queue,
+			list_for_each_entry_safe(lsk, n, &llcp_sock->accept_queue,
 						 accept_queue) {
 				accept_sk = &lsk->sk;
 				lock_sock(accept_sk);
@@ -84,17 +80,16 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 			}
 		}
 
-		if (parent_sk->sk_state == LLCP_CONNECTED)
-			nfc_put_device(parent->dev);
+		sk->sk_state = LLCP_CLOSED;
 
-		parent_sk->sk_state = LLCP_CLOSED;
+		release_sock(sk);
 
-		release_sock(parent_sk);
+		sock_orphan(sk);
 
-		sock_orphan(parent_sk);
+		sk_del_node_init(sk);
 	}
 
-	mutex_unlock(&local->socket_lock);
+	write_unlock(&local->sockets.lock);
 }
 
 struct nfc_llcp_local *nfc_llcp_local_get(struct nfc_llcp_local *local)
@@ -122,6 +117,11 @@ static void local_release(struct kref *ref)
 
 int nfc_llcp_local_put(struct nfc_llcp_local *local)
 {
+	WARN_ON(local == NULL);
+
+	if (local == NULL)
+		return 0;
+
 	return kref_put(&local->ref, local_release);
 }
 
@@ -465,46 +465,107 @@ static void nfc_llcp_set_nrns(struct nfc_llcp_sock *sock, struct sk_buff *pdu)
 	sock->recv_ack_n = (sock->recv_n - 1) % 16;
 }
 
+static struct nfc_llcp_sock *nfc_llcp_connecting_sock_get(struct nfc_llcp_local *local,
+							  u8 ssap)
+{
+	struct sock *sk;
+	struct nfc_llcp_sock *llcp_sock;
+	struct hlist_node *node;
+
+	read_lock(&local->connecting_sockets.lock);
+
+	sk_for_each(sk, node, &local->connecting_sockets.head) {
+		llcp_sock = nfc_llcp_sock(sk);
+
+		if (llcp_sock->ssap == ssap)
+			goto out;
+	}
+
+	llcp_sock = NULL;
+
+out:
+	read_unlock(&local->connecting_sockets.lock);
+
+	sock_hold(&llcp_sock->sk);
+
+	return llcp_sock;
+}
+
 static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
 					       u8 ssap, u8 dsap)
 {
-	struct nfc_llcp_sock *sock, *llcp_sock, *n;
+	struct sock *sk;
+	struct hlist_node *node;
+	struct nfc_llcp_sock *llcp_sock;
 
 	pr_debug("ssap dsap %d %d\n", ssap, dsap);
 
 	if (ssap == 0 && dsap == 0)
 		return NULL;
 
-	mutex_lock(&local->socket_lock);
-	sock = local->sockets[ssap];
-	if (sock == NULL) {
-		mutex_unlock(&local->socket_lock);
-		return NULL;
-	}
+	read_lock(&local->sockets.lock);
+
+	llcp_sock = NULL;
 
-	pr_debug("root dsap %d (%d)\n", sock->dsap, dsap);
+	sk_for_each(sk, node, &local->sockets.head) {
+		llcp_sock = nfc_llcp_sock(sk);
 
-	if (sock->dsap == dsap) {
-		sock_hold(&sock->sk);
-		mutex_unlock(&local->socket_lock);
-		return sock;
+		if (llcp_sock->ssap == ssap &&
+		    llcp_sock->dsap == dsap)
+			break;
 	}
 
-	list_for_each_entry_safe(llcp_sock, n, &sock->list, list) {
-		pr_debug("llcp_sock %p sk %p dsap %d\n", llcp_sock,
-			 &llcp_sock->sk, llcp_sock->dsap);
-		if (llcp_sock->dsap == dsap) {
-			sock_hold(&llcp_sock->sk);
-			mutex_unlock(&local->socket_lock);
-			return llcp_sock;
-		}
+	read_unlock(&local->sockets.lock);
+
+	if (llcp_sock == NULL)
+		return NULL;
+
+	sock_hold(&llcp_sock->sk);
+
+	return llcp_sock;
+}
+
+static struct nfc_llcp_sock *nfc_llcp_sock_get_sn(struct nfc_llcp_local *local,
+						  u8 *sn, size_t sn_len)
+{
+	struct sock *sk;
+	struct hlist_node *node;
+	struct nfc_llcp_sock *llcp_sock;
+
+	pr_debug("sn %zd\n", sn_len);
+
+	if (sn == NULL || sn_len == 0)
+		return NULL;
+
+	read_lock(&local->sockets.lock);
+
+	llcp_sock = NULL;
+
+	sk_for_each(sk, node, &local->sockets.head) {
+		llcp_sock = nfc_llcp_sock(sk);
+
+		if (llcp_sock->sk.sk_state != LLCP_LISTEN)
+			continue;
+
+		if (llcp_sock->service_name == NULL ||
+		    llcp_sock->service_name_len == 0)
+			continue;
+
+		if (llcp_sock->service_name_len != sn_len)
+			continue;
+
+		if (memcmp(sn, llcp_sock->service_name, sn_len) == 0)
+			break;
 	}
 
-	pr_err("Could not find socket for %d %d\n", ssap, dsap);
+	read_unlock(&local->sockets.lock);
 
-	mutex_unlock(&local->socket_lock);
+	if (llcp_sock == NULL)
+		return NULL;
 
-	return NULL;
+	sock_hold(&llcp_sock->sk);
+
+	return llcp_sock;
 }
 
 static void nfc_llcp_sock_put(struct nfc_llcp_sock *sock)
@@ -540,7 +601,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 {
 	struct sock *new_sk, *parent;
 	struct nfc_llcp_sock *sock, *new_sock;
-	u8 dsap, ssap, bound_sap, reason;
+	u8 dsap, ssap, reason;
 
 	dsap = nfc_llcp_dsap(skb);
 	ssap = nfc_llcp_ssap(skb);
@@ -551,24 +612,11 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 			   skb->len - LLCP_HEADER_SIZE);
 
 	if (dsap != LLCP_SAP_SDP) {
-		bound_sap = dsap;
-
-		mutex_lock(&local->socket_lock);
-		sock = local->sockets[dsap];
-		if (sock == NULL) {
-			mutex_unlock(&local->socket_lock);
+		sock = nfc_llcp_sock_get(local, dsap, LLCP_SAP_SDP);
+		if (sock == NULL || sock->sk.sk_state != LLCP_LISTEN) {
 			reason = LLCP_DM_NOBOUND;
 			goto fail;
 		}
-
-		sock_hold(&sock->sk);
-		mutex_unlock(&local->socket_lock);
-
-		lock_sock(&sock->sk);
-
-		if (sock->dsap == LLCP_SAP_SDP &&
-		    sock->sk.sk_state == LLCP_LISTEN)
-			goto enqueue;
 	} else {
 		u8 *sn;
 		size_t sn_len;
@@ -581,40 +629,15 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 
 		pr_debug("Service name length %zu\n", sn_len);
 
-		mutex_lock(&local->socket_lock);
-		for (bound_sap = 0; bound_sap < LLCP_LOCAL_SAP_OFFSET;
-		     bound_sap++) {
-			sock = local->sockets[bound_sap];
-			if (sock == NULL)
-				continue;
-
-			if (sock->service_name == NULL ||
-			    sock->service_name_len == 0)
-					continue;
-
-			if (sock->service_name_len != sn_len)
-				continue;
-
-			if (sock->dsap == LLCP_SAP_SDP &&
-			    sock->sk.sk_state == LLCP_LISTEN &&
-			    !memcmp(sn, sock->service_name, sn_len)) {
-				pr_debug("Found service name at SAP %d\n",
-					 bound_sap);
-				sock_hold(&sock->sk);
-				mutex_unlock(&local->socket_lock);
-
-				lock_sock(&sock->sk);
-
-				goto enqueue;
-			}
+		sock = nfc_llcp_sock_get_sn(local, sn, sn_len);
+		if (sock == NULL) {
+			reason = LLCP_DM_NOBOUND;
+			goto fail;
 		}
-		mutex_unlock(&local->socket_lock);
 	}
 
-	reason = LLCP_DM_NOBOUND;
-	goto fail;
+	lock_sock(&sock->sk);
 
-enqueue:
 	parent = &sock->sk;
 
 	if (sk_acceptq_is_full(parent)) {
@@ -636,13 +659,13 @@ enqueue:
 	new_sock->dev = local->dev;
 	new_sock->local = nfc_llcp_local_get(local);
 	new_sock->nfc_protocol = sock->nfc_protocol;
-	new_sock->ssap = bound_sap;
+	new_sock->ssap = sock->ssap;
 	new_sock->dsap = ssap;
 	new_sock->parent = parent;
 
 	pr_debug("new sock %p sk %p\n", new_sock, &new_sock->sk);
 
-	list_add_tail(&new_sock->list, &sock->list);
+	nfc_llcp_sock_link(&local->sockets, new_sk);
 
 	nfc_llcp_accept_enqueue(&sock->sk, new_sk);
 
@@ -813,11 +836,7 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 	dsap = nfc_llcp_dsap(skb);
 	ssap = nfc_llcp_ssap(skb);
 
-	llcp_sock = nfc_llcp_sock_get(local, dsap, ssap);
-
-	if (llcp_sock == NULL)
-		llcp_sock = nfc_llcp_sock_get(local, dsap, LLCP_SAP_SDP);
-
+	llcp_sock = nfc_llcp_connecting_sock_get(local, dsap);
 	if (llcp_sock == NULL) {
 		pr_err("Invalid CC\n");
 		nfc_llcp_send_dm(local, dsap, ssap, LLCP_DM_NOCONN);
@@ -825,9 +844,13 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 		return;
 	}
 
-	llcp_sock->dsap = ssap;
 	sk = &llcp_sock->sk;
 
+	/* Unlink from connecting and link to the client array */
+	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+	nfc_llcp_sock_link(&local->sockets, sk);
+	llcp_sock->dsap = ssap;
+
 	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
 			   skb->len - LLCP_HEADER_SIZE);
 
@@ -967,7 +990,6 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	INIT_LIST_HEAD(&local->list);
 	kref_init(&local->ref);
 	mutex_init(&local->sdp_lock);
-	mutex_init(&local->socket_lock);
 	init_timer(&local->link_timer);
 	local->link_timer.data = (unsigned long) local;
 	local->link_timer.function = nfc_llcp_symm_timer;
@@ -1007,6 +1029,9 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 		goto err_rx_wq;
 	}
 
+	local->sockets.lock = __RW_LOCK_UNLOCKED(local->sockets.lock);
+	local->connecting_sockets.lock = __RW_LOCK_UNLOCKED(local->connecting_sockets.lock);
+
 	nfc_llcp_build_gb(local);
 
 	local->remote_miu = LLCP_DEFAULT_MIU;
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index bc61955..7053304 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -40,6 +40,11 @@ enum llcp_state {
 
 struct nfc_llcp_sock;
 
+struct llcp_sock_list {
+	struct hlist_head head;
+	rwlock_t          lock;
+};
+
 struct nfc_llcp_local {
 	struct list_head list;
 	struct nfc_dev *dev;
@@ -47,7 +52,6 @@ struct nfc_llcp_local {
 	struct kref ref;
 
 	struct mutex sdp_lock;
-	struct mutex socket_lock;
 
 	struct timer_list link_timer;
 	struct sk_buff_head tx_queue;
@@ -82,12 +86,12 @@ struct nfc_llcp_local {
 	u8  remote_rw;
 
 	/* sockets array */
-	struct nfc_llcp_sock *sockets[LLCP_MAX_SAP];
+	struct llcp_sock_list sockets;
+	struct llcp_sock_list connecting_sockets;
 };
 
 struct nfc_llcp_sock {
 	struct sock sk;
-	struct list_head list;
 	struct nfc_dev *dev;
 	struct nfc_llcp_local *local;
 	u32 target_idx;
@@ -166,6 +170,8 @@ struct nfc_llcp_sock {
 #define LLCP_DM_REJ     0x03
 
 
+void nfc_llcp_sock_link(struct llcp_sock_list *l, struct sock *s);
+void nfc_llcp_sock_unlink(struct llcp_sock_list *l, struct sock *s);
 struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev);
 struct nfc_llcp_local *nfc_llcp_local_get(struct nfc_llcp_local *local);
 int nfc_llcp_local_put(struct nfc_llcp_local *local);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 9ac397b..8a60b53 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -124,7 +124,7 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	if (llcp_sock->ssap == LLCP_MAX_SAP)
 		goto put_dev;
 
-	local->sockets[llcp_sock->ssap] = llcp_sock;
+	nfc_llcp_sock_link(&local->sockets, sk);
 
 	pr_debug("Socket bound to SAP %d\n", llcp_sock->ssap);
 
@@ -379,15 +379,6 @@ static int llcp_sock_release(struct socket *sock)
 		goto out;
 	}
 
-	mutex_lock(&local->socket_lock);
-
-	if (llcp_sock == local->sockets[llcp_sock->ssap])
-		local->sockets[llcp_sock->ssap] = NULL;
-	else
-		list_del_init(&llcp_sock->list);
-
-	mutex_unlock(&local->socket_lock);
-
 	lock_sock(sk);
 
 	/* Send a DISC */
@@ -412,14 +403,12 @@ static int llcp_sock_release(struct socket *sock)
 		}
 	}
 
-	/* Freeing the SAP */
-	if ((sk->sk_state == LLCP_CONNECTED
-	     && llcp_sock->ssap > LLCP_LOCAL_SAP_OFFSET) ||
-	    sk->sk_state == LLCP_BOUND || sk->sk_state == LLCP_LISTEN)
-		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
+	nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
 	release_sock(sk);
 
+	nfc_llcp_sock_unlink(&local->sockets, sk);
+
 out:
 	sock_orphan(sk);
 	sock_put(sk);
@@ -505,21 +494,26 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
 
-	local->sockets[llcp_sock->ssap] = llcp_sock;
+	nfc_llcp_sock_link(&local->connecting_sockets, sk);
 
 	ret = nfc_llcp_send_connect(llcp_sock);
 	if (ret)
-		goto put_dev;
+		goto sock_unlink;
 
 	ret = sock_wait_state(sk, LLCP_CONNECTED,
 			      sock_sndtimeo(sk, flags & O_NONBLOCK));
 	if (ret)
-		goto put_dev;
+		goto sock_unlink;
 
 	release_sock(sk);
 
 	return 0;
 
+sock_unlink:
+	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+
+	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+
 put_dev:
 	nfc_put_device(dev);
 
@@ -690,7 +684,6 @@ struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
 	skb_queue_head_init(&llcp_sock->tx_queue);
 	skb_queue_head_init(&llcp_sock->tx_pending_queue);
 	skb_queue_head_init(&llcp_sock->tx_backlog_queue);
-	INIT_LIST_HEAD(&llcp_sock->list);
 	INIT_LIST_HEAD(&llcp_sock->accept_queue);
 
 	if (sock != NULL)
@@ -708,7 +701,6 @@ void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 	skb_queue_purge(&sock->tx_backlog_queue);
 
 	list_del_init(&sock->accept_queue);
-	list_del_init(&sock->list);
 
 	sock->parent = NULL;
 
-- 
1.7.9.1

