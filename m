Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9163843CE41;
	Tue, 15 Sep 2026 05:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451211; cv=pass; b=ZSsT1j2ZuBTIqfYU2E6kE65qOBZu7xwVTQrsSOYt48E62U0mmsPR/SLFIerVrSxIt3RqiiDzsbD8CdV/TuM6197q7xtEX+ftSJQ2QgnBgZCDIZEjx89MDIdEHp6osFib0/OvOapGhlf5lB8wAHGhNdCSVLWPSKF4UgzHm45NwWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451211; c=relaxed/simple;
	bh=8pzmrrVnvgNB4HH7DllpTPe7JHx0H0GF9O6s6WxiCKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pc2ddDhjWDCQPDD4/vbutg6LOVVTmDQi7boAmUjPKE3aTzwrJYBUuAkmGK+qi5laSfPfXyTiE7083EGTfg66ebWRz2aekCcPNiKDRQwjgeQKq0cjkWGeDHsMw+nWGEwMCi/Iikm7fnD2utA8SEK+WdcAglWJHBVZHIsO8WBleqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=wPILu8Ft; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="wPILu8Ft"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWH601HYz49Q32;
	Tue, 15 Sep 2026 08:46:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789451202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxfpSm4jC+uUVpycRkrBNbqmuq5JnX7Rrdb/3eU15Yw=;
	b=wPILu8FtcW0Z5+DOGuTSqqAC5VdBj6u7jvyeldHGLwUQGIRMUEsz8tLHPx0iHYf1Lhutaj
	1UE9a0/UwNpWcY2elUQn4r6vqKvlKm6urj3ew6oa+1rSMRY6mlkLREMoEFbigSlOuxjPKG
	Lwda1ay4/SmkYg/HrE8492+aY+vQyFwuyCQvfu9avOBI6g1aCO34JXIA5KYzMPDt6ikVLi
	/Gej+nSPwgWT2GMPbRZUE+wiFlvDeO96JTCATSLwDOhQ0wsjQRdk0mzoEjoXjXNQUv+jUr
	Hm0DP2SiTP+OMblHWt+0wq64FqrV6GYMm4Za32Iq0Bk8bajoAbsNSCTW8mCWUw==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789451202;
	b=uKvEai74zvtiVp52QkmOXTUt1wH2wcNMZklQl6urhQfQ4XnhTQxnGsuH5XabeLeMHIS1xa
	cNv20r7LDwgw6aA379R/SvIlRAnoWzSsZQLSMENjZhd3fooLitPEedftzmcy3AX46Wm3Vb
	dC7yncr6zOjT7kLUEvegagRu1aFXd8iuzZCO6UKaxvFzsM9sWHufDi9hWvHf/GgSV9WKTB
	gQDTTOvFRWxJbdIUSRHjRApfmNTil+9Lp0FhlJTt+ITFK9Jz8lKkwQ2w81i/033Cqzoi6N
	cYorzbpPf81bBqH0Fx6sWDQ2opr0tIsNQae7hQWb9XpQXfbjYcyDtk8xZSe6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789451202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxfpSm4jC+uUVpycRkrBNbqmuq5JnX7Rrdb/3eU15Yw=;
	b=WcREKB8t2A2wv2TiVmFZ0/nOHgA7rTO8smdan7jNLCBDUBLEbL8PdQkPlJNMG+nbzyiUSq
	xOXOuM3P97ZbDCP4+AL99ceb06iFUnx8b7Jkrx7mMCNZ2UqrvuTI2Sx7i30zw1AAYXkK4y
	DrkzJ9PMCgABj6ypchwiJGsgVVM+8pLR0mO9trflJSSqh2exAjdK955heGBRkCZ4yeFEwC
	Y1vkxjGYAgCBJY6Mq/zLtxml58Shy+N0fdlOjR9GImzc89dCKV11uHa1qrUAcbON7Z+jeU
	5HIDj7ttK1mzNhC/hsBV+r2+lh093RZBXlhFCvj80NCaZIfidhw8v1nhnqaWnw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Manivannan Sadhasivam <mani@kernel.org>,
	linux-arm-msm@vger.kernel.org
Cc: Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Andy Gross <agross@kernel.org>,
	linux-kernel@vger.kernel.org,
	mhi@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [PATCH v7 11/15] net: qrtr: ns: support multiple endpoints
Date: Tue, 15 Sep 2026 08:42:03 +0300
Message-Id: <20260915054207.2513877-12-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis Kenzior <denkenz@gmail.com>

Extend the qrtr name service with the concept of an endpoint.  Endpoints
can be remote or local, and are represented by a unique endpoint id.
This allows the qrtr name service to support multiple devices
(endpoints) that might have overlapping node / port combinations.

The socket used by the name service is subscribed to receive endpoint
information via a mechanism similar to the SOL_QRTR QRTR_REPORT_ENDPOINT
socket option.  Internal data structures are then extended to track
endpoint information in addition to nodes and ports.

The name service directs packets to the endpoint originating the
request.  For NEW_SERVER and DEL_SERVER messages triggered using lookups
or due to remote endpoints sending the corresponding message, qrtr name
service generates a NEW_SERVER and DEL_SERVER messages to all local
sockets registered to receive such notifications.  The messages are made
to look as if they're coming from the remote endpoint using a special
extension to AF_QRTR sendmsg operation.  This extension only works for
the local socket that owns the QRTR_PORT_CTRL port (name service).

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/af_qrtr.c |  12 ++
 net/qrtr/ns.c      | 313 ++++++++++++++++++++++++++++-----------------
 net/qrtr/qrtr.h    |   1 +
 3 files changed, 209 insertions(+), 117 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index c139786c56f39..b27c5a659795d 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -107,6 +107,13 @@ static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
 	return container_of(sk, struct qrtr_sock, sk);
 }
 
+void qrtr_sock_set_report_endpoint(struct sock *sk)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sk);
+
+	assign_bit(QRTR_F_REPORT_ENDPOINT, &ipc->flags, 1);
+}
+
 int qrtr_msg_get_endpoint(struct msghdr *msg, u32 *out_endpoint_id)
 {
 	struct cmsghdr *cmsg;
@@ -1165,6 +1172,11 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 
 		/* control messages already require the type as 'command' */
 		skb_copy_bits(skb, 0, &qrtr_type, 4);
+		/*
+		 * Allow local name service to make packets appear as if
+		 * they originated remotely
+		 */
+		endpoint_id = msg_endpoint_id;
 	}
 
 	type = le32_to_cpu(qrtr_type);
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index a3348e40d9275..31dfa764e186a 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2020, Linaro Ltd.
  */
 
+#define pr_fmt(fmt) "QRTR NS: "fmt
 #include <linux/module.h>
 #include <linux/qrtr.h>
 #include <linux/workqueue.h>
@@ -16,7 +17,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/qrtr.h>
 
-static DEFINE_XARRAY(nodes);
+static DEFINE_XARRAY(endpoints);
 
 static struct {
 	struct socket *sock;
@@ -62,6 +63,7 @@ struct qrtr_server {
 
 	unsigned int node;
 	unsigned int port;
+	u32 endpoint_id;
 
 	struct list_head qli;
 };
@@ -72,6 +74,11 @@ struct qrtr_node {
 	u32 server_count;
 };
 
+struct qrtr_ns_endpoint {
+	unsigned int id;
+	struct xarray nodes;
+};
+
 /* Max nodes, server, lookup limits are chosen based on the current platform
  * requirements. If the requirement changes in the future, these values can be
  * increased.
@@ -82,35 +89,90 @@ struct qrtr_node {
 
 static u16 node_count;
 
-static struct qrtr_node *node_get(unsigned int node_id)
+static struct qrtr_node *node_get(u32 endpoint_id, unsigned int node_id)
 {
+	struct qrtr_ns_endpoint *endpoint;
 	struct qrtr_node *node;
+	bool new_endpoint = false;
+
+	endpoint = xa_load(&endpoints, endpoint_id);
+	if (!endpoint) {
+		endpoint = kzalloc_obj(*endpoint);
+		if (!endpoint)
+			return NULL;
+
+		endpoint->id = endpoint_id;
+		xa_init(&endpoint->nodes);
+
+		if (xa_store(&endpoints, endpoint_id, endpoint, GFP_KERNEL)) {
+			kfree(endpoint);
+			return NULL;
+		}
+
+		new_endpoint = true;
+	}
 
-	node = xa_load(&nodes, node_id);
+	node = xa_load(&endpoint->nodes, node_id);
 	if (node)
 		return node;
 
 	if (node_count >= QRTR_NS_MAX_NODES) {
 		pr_err_ratelimited("QRTR clients exceed max node limit!\n");
-		return NULL;
+		goto error;
 	}
 
 	/* If node didn't exist, allocate and insert it to the tree */
 	node = kzalloc_obj(*node);
 	if (!node)
-		return NULL;
+		goto error;
 
 	node->id = node_id;
 	xa_init(&node->servers);
 
-	if (xa_store(&nodes, node_id, node, GFP_KERNEL)) {
+	if (xa_store(&endpoint->nodes, node_id, node, GFP_KERNEL)) {
 		kfree(node);
-		return NULL;
+		goto error;
 	}
 
 	node_count++;
 
 	return node;
+error:
+	if (new_endpoint) {
+		xa_erase(&endpoints, endpoint_id);
+		kfree(endpoint);
+	}
+
+	return NULL;
+}
+
+static void node_erase(u32 endpoint_id, unsigned int node_id)
+{
+	struct qrtr_ns_endpoint *endpoint;
+	struct qrtr_node *node;
+
+	endpoint = xa_load(&endpoints, endpoint_id);
+	if (!endpoint)
+		return;
+
+	node = xa_load(&endpoint->nodes, node_id);
+	if (!node)
+		return;
+
+	xa_erase(&endpoint->nodes, node_id);
+	kfree(node);
+	node_count--;
+}
+
+static struct qrtr_node *node_lookup(u32 endpoint_id, unsigned int node_id)
+{
+	struct qrtr_ns_endpoint *endpoint;
+
+	endpoint = xa_load(&endpoints, endpoint_id);
+	if (!endpoint)
+		return NULL;
+
+	return xa_load(&endpoint->nodes, node_id);
 }
 
 static int server_match(const struct qrtr_server *srv,
@@ -126,19 +188,42 @@ static int server_match(const struct qrtr_server *srv,
 	return (srv->instance & ifilter) == f->instance;
 }
 
-static int service_announce_new(struct sockaddr_qrtr *dest,
-				struct qrtr_server *srv)
+static int qrtr_ns_sendmsg(u32 endpoint_id, struct sockaddr_qrtr *dest,
+			   struct qrtr_ctrl_pkt *pkt)
 {
-	struct qrtr_ctrl_pkt pkt;
 	struct msghdr msg = { };
 	struct kvec iv;
+	u8 control[CMSG_SPACE(sizeof(endpoint_id))];
+	struct cmsghdr *cmsg;
+
+	iv.iov_base = pkt;
+	iv.iov_len = sizeof(*pkt);
+
+	msg.msg_name = (struct sockaddr *)dest;
+	msg.msg_namelen = sizeof(*dest);
+
+	if (endpoint_id) {
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
+
+		cmsg = CMSG_FIRSTHDR(&msg);
+		cmsg->cmsg_level = SOL_QRTR;
+		cmsg->cmsg_type = QRTR_ENDPOINT;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(endpoint_id));
+		memcpy(CMSG_DATA(cmsg), &endpoint_id, sizeof(endpoint_id));
+	}
+
+	return kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(*pkt));
+}
+
+static int service_announce_new(u32 endpoint_id, struct sockaddr_qrtr *dest,
+				struct qrtr_server *srv)
+{
+	struct qrtr_ctrl_pkt pkt;
 
 	trace_qrtr_ns_service_announce_new(srv->service, srv->instance,
 					   srv->node, srv->port);
 
-	iv.iov_base = &pkt;
-	iv.iov_len = sizeof(pkt);
-
 	memset(&pkt, 0, sizeof(pkt));
 	pkt.cmd = cpu_to_le32(QRTR_TYPE_NEW_SERVER);
 	pkt.server.service = cpu_to_le32(srv->service);
@@ -146,26 +231,18 @@ static int service_announce_new(struct sockaddr_qrtr *dest,
 	pkt.server.node = cpu_to_le32(srv->node);
 	pkt.server.port = cpu_to_le32(srv->port);
 
-	msg.msg_name = (struct sockaddr *)dest;
-	msg.msg_namelen = sizeof(*dest);
-
-	return kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	return qrtr_ns_sendmsg(endpoint_id, dest, &pkt);
 }
 
-static void service_announce_del(struct sockaddr_qrtr *dest,
+static void service_announce_del(u32 endpoint_id, struct sockaddr_qrtr *dest,
 				 struct qrtr_server *srv)
 {
 	struct qrtr_ctrl_pkt pkt;
-	struct msghdr msg = { };
-	struct kvec iv;
 	int ret;
 
 	trace_qrtr_ns_service_announce_del(srv->service, srv->instance,
 					   srv->node, srv->port);
 
-	iv.iov_base = &pkt;
-	iv.iov_len = sizeof(pkt);
-
 	memset(&pkt, 0, sizeof(pkt));
 	pkt.cmd = cpu_to_le32(QRTR_TYPE_DEL_SERVER);
 	pkt.server.service = cpu_to_le32(srv->service);
@@ -173,26 +250,24 @@ static void service_announce_del(struct sockaddr_qrtr *dest,
 	pkt.server.node = cpu_to_le32(srv->node);
 	pkt.server.port = cpu_to_le32(srv->port);
 
-	msg.msg_name = (struct sockaddr *)dest;
-	msg.msg_namelen = sizeof(*dest);
-
-	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	ret = qrtr_ns_sendmsg(endpoint_id, dest, &pkt);
 	if (ret < 0 && ret != -ENODEV)
 		pr_err("failed to announce del service\n");
 
 	return;
 }
 
-static void lookup_notify(struct sockaddr_qrtr *to, struct qrtr_server *srv,
-			  bool new)
+static void lookup_notify(u32 endpoint_id, struct sockaddr_qrtr *to,
+			  struct qrtr_server *srv, bool new)
 {
 	struct qrtr_ctrl_pkt pkt;
-	struct msghdr msg = { };
-	struct kvec iv;
 	int ret;
 
-	iv.iov_base = &pkt;
-	iv.iov_len = sizeof(pkt);
+	/*
+	 * Notify a local client at @to about a server change.  The aux data
+	 * will look as if it came from the endpoint that reported the event
+	 * (remote or local)
+	 */
 
 	memset(&pkt, 0, sizeof(pkt));
 	pkt.cmd = new ? cpu_to_le32(QRTR_TYPE_NEW_SERVER) :
@@ -204,28 +279,25 @@ static void lookup_notify(struct sockaddr_qrtr *to, struct qrtr_server *srv,
 		pkt.server.port = cpu_to_le32(srv->port);
 	}
 
-	msg.msg_name = (struct sockaddr *)to;
-	msg.msg_namelen = sizeof(*to);
-
-	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	ret = qrtr_ns_sendmsg(endpoint_id, to, &pkt);
 	if (ret < 0 && ret != -ENODEV)
 		pr_err("failed to send lookup notification\n");
 }
 
-static int announce_servers(struct sockaddr_qrtr *sq)
+static int announce_servers(u32 endpoint_id, struct sockaddr_qrtr *sq)
 {
 	struct qrtr_server *srv;
 	struct qrtr_node *node;
 	unsigned long index;
 	int ret;
 
-	node = node_get(qrtr_ns.local_node);
+	node = node_lookup(qrtr_ns.local_node, qrtr_ns.local_node);
 	if (!node)
 		return 0;
 
-	/* Announce the list of servers registered in this node */
+	/* Announce servers registered on local endpoint to remote endpoint */
 	xa_for_each(&node->servers, index, srv) {
-		ret = service_announce_new(sq, srv);
+		ret = service_announce_new(endpoint_id, sq, srv);
 		if (ret < 0) {
 			if (ret == -ENODEV)
 				continue;
@@ -237,7 +309,8 @@ static int announce_servers(struct sockaddr_qrtr *sq)
 	return 0;
 }
 
-static struct qrtr_server *server_add(unsigned int service,
+static struct qrtr_server *server_add(u32 endpoint_id,
+				      unsigned int service,
 				      unsigned int instance,
 				      unsigned int node_id,
 				      unsigned int port)
@@ -249,7 +322,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	if (!service || !port)
 		return NULL;
 
-	node = node_get(node_id);
+	node = node_get(endpoint_id, node_id);
 	if (!node)
 		return NULL;
 
@@ -293,7 +366,8 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
+static int server_del(u32 endpoint_id, struct qrtr_node *node,
+		      unsigned int port, bool bcast)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -305,9 +379,10 @@ static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 
 	xa_erase(&node->servers, port);
 
-	/* Broadcast the removal of local servers */
+	/* Broadcast the removal of local servers to remote endpoints */
 	if (srv->node == qrtr_ns.local_node && bcast)
-		service_announce_del(&qrtr_ns.bcast_sq, srv);
+		service_announce_del(qrtr_ns.local_node,
+				     &qrtr_ns.bcast_sq, srv);
 
 	/* Announce the service's disappearance to observers */
 	list_for_each(li, &qrtr_ns.lookups) {
@@ -317,7 +392,7 @@ static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 		if (lookup->instance && lookup->instance != srv->instance)
 			continue;
 
-		lookup_notify(&lookup->sq, srv, false);
+		lookup_notify(endpoint_id, &lookup->sq, srv, false);
 	}
 
 	kfree(srv);
@@ -326,23 +401,15 @@ static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 	return 0;
 }
 
-static int say_hello(struct sockaddr_qrtr *dest)
+static int say_hello(u32 endpoint_id, struct sockaddr_qrtr *dest)
 {
 	struct qrtr_ctrl_pkt pkt;
-	struct msghdr msg = { };
-	struct kvec iv;
 	int ret;
 
-	iv.iov_base = &pkt;
-	iv.iov_len = sizeof(pkt);
-
 	memset(&pkt, 0, sizeof(pkt));
 	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
 
-	msg.msg_name = (struct sockaddr *)dest;
-	msg.msg_namelen = sizeof(*dest);
-
-	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	ret = qrtr_ns_sendmsg(endpoint_id, dest, &pkt);
 	if (ret < 0)
 		pr_err("failed to send hello msg\n");
 
@@ -350,42 +417,38 @@ static int say_hello(struct sockaddr_qrtr *dest)
 }
 
 /* Announce the list of servers registered on the local node */
-static int ctrl_cmd_hello(struct sockaddr_qrtr *sq)
+static int ctrl_cmd_hello(u32 endpoint_id, struct sockaddr_qrtr *sq)
 {
 	int ret;
 
-	ret = say_hello(sq);
+	/* Send Hello and New Server messages to remote endpoint */
+	ret = say_hello(endpoint_id, sq);
 	if (ret < 0)
 		return ret;
 
-	return announce_servers(sq);
+	return announce_servers(endpoint_id, sq);
 }
 
-static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
+static int ctrl_cmd_bye(u32 endpoint_id, struct sockaddr_qrtr *from)
 {
 	struct qrtr_node *local_node;
 	struct qrtr_ctrl_pkt pkt;
 	struct qrtr_server *srv;
 	struct sockaddr_qrtr sq;
-	struct msghdr msg = { };
 	struct qrtr_node *node;
 	unsigned long index;
-	struct kvec iv;
 	int ret = 0;
 
-	iv.iov_base = &pkt;
-	iv.iov_len = sizeof(pkt);
-
-	node = node_get(from->sq_node);
+	node = node_get(endpoint_id, from->sq_node);
 	if (!node)
 		return 0;
 
 	/* Advertise removal of this client to all servers of remote node */
 	xa_for_each(&node->servers, index, srv)
-		server_del(node, srv->port, true);
+		server_del(endpoint_id, node, srv->port, true);
 
 	/* Advertise the removal of this client to all local servers */
-	local_node = node_get(qrtr_ns.local_node);
+	local_node = node_get(qrtr_ns.local_node, qrtr_ns.local_node);
 	if (!local_node) {
 		ret = 0;
 		goto delete_node;
@@ -400,10 +463,8 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		sq.sq_node = srv->node;
 		sq.sq_port = srv->port;
 
-		msg.msg_name = (struct sockaddr *)&sq;
-		msg.msg_namelen = sizeof(sq);
-
-		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+		/* Bye will look as if it came from endpoint_id */
+		ret = qrtr_ns_sendmsg(endpoint_id, &sq, &pkt);
 		if (ret < 0 && ret != -ENODEV) {
 			pr_err("failed to send bye cmd\n");
 			goto delete_node;
@@ -414,32 +475,25 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 	ret = 0;
 
 delete_node:
-	xa_erase(&nodes, from->sq_node);
-	kfree(node);
-	node_count--;
+	node_erase(endpoint_id, from->sq_node);
 
 	return ret;
 }
 
-static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
+static int ctrl_cmd_del_client(u32 endpoint_id, struct sockaddr_qrtr *from,
 			       unsigned int node_id, unsigned int port)
 {
 	struct qrtr_node *local_node;
 	struct qrtr_lookup *lookup;
 	struct qrtr_ctrl_pkt pkt;
-	struct msghdr msg = { };
 	struct qrtr_server *srv;
 	struct sockaddr_qrtr sq;
 	struct qrtr_node *node;
 	struct list_head *tmp;
 	struct list_head *li;
 	unsigned long index;
-	struct kvec iv;
 	int ret;
 
-	iv.iov_base = &pkt;
-	iv.iov_len = sizeof(pkt);
-
 	/* Don't accept spoofed messages */
 	if (from->sq_node != node_id)
 		return -EINVAL;
@@ -465,12 +519,12 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	 * DEL_SERVER. Neighbours would've already removed the server belonging
 	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
 	 */
-	node = node_get(node_id);
+	node = node_lookup(endpoint_id, node_id);
 	if (node)
-		server_del(node, port, false);
+		server_del(endpoint_id, node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
-	local_node = node_get(qrtr_ns.local_node);
+	local_node = node_lookup(qrtr_ns.local_node, qrtr_ns.local_node);
 	if (!local_node)
 		return 0;
 
@@ -484,10 +538,8 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		sq.sq_node = srv->node;
 		sq.sq_port = srv->port;
 
-		msg.msg_name = (struct sockaddr *)&sq;
-		msg.msg_namelen = sizeof(sq);
-
-		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+		/* Del Client will look as if it came from endpoint_id */
+		ret = qrtr_ns_sendmsg(endpoint_id, &sq, &pkt);
 		if (ret < 0 && ret != -ENODEV) {
 			pr_err("failed to send del client cmd\n");
 			return ret;
@@ -496,7 +548,7 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 	return 0;
 }
 
-static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
+static int ctrl_cmd_new_server(u32 endpoint_id, struct sockaddr_qrtr *from,
 			       unsigned int service, unsigned int instance,
 			       unsigned int node_id, unsigned int port)
 {
@@ -511,12 +563,16 @@ static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
 		port = from->sq_port;
 	}
 
-	srv = server_add(service, instance, node_id, port);
-	if (!srv)
+	srv = server_add(endpoint_id, service, instance, node_id, port);
+	if (!srv) {
+		pr_err("Failed to add server\n");
 		return -EINVAL;
+	}
 
 	if (srv->node == qrtr_ns.local_node) {
-		ret = service_announce_new(&qrtr_ns.bcast_sq, srv);
+		/* Broadcast local server info to all peer endpoints */
+		ret = service_announce_new(qrtr_ns.local_node,
+					   &qrtr_ns.bcast_sq, srv);
 		if (ret < 0) {
 			pr_err("failed to announce new service\n");
 			return ret;
@@ -531,13 +587,13 @@ static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
 		if (lookup->instance && lookup->instance != instance)
 			continue;
 
-		lookup_notify(&lookup->sq, srv, true);
+		lookup_notify(endpoint_id, &lookup->sq, srv, true);
 	}
 
 	return ret;
 }
 
-static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
+static int ctrl_cmd_del_server(u32 endpoint_id, struct sockaddr_qrtr *from,
 			       unsigned int service, unsigned int instance,
 			       unsigned int node_id, unsigned int port)
 {
@@ -553,24 +609,22 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (from->sq_node == qrtr_ns.local_node && from->sq_port != port)
 		return -EINVAL;
 
-	node = node_get(node_id);
+	node = node_lookup(endpoint_id, node_id);
 	if (!node)
 		return -ENOENT;
 
-	server_del(node, port, true);
+	server_del(endpoint_id, node, port, true);
 
 	return 0;
 }
 
-static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
+static int ctrl_cmd_new_lookup(u32 endpoint_id, struct sockaddr_qrtr *from,
 			       unsigned int service, unsigned int instance)
 {
 	struct qrtr_server_filter filter;
 	struct qrtr_lookup *lookup;
-	struct qrtr_server *srv;
-	struct qrtr_node *node;
-	unsigned long node_idx;
-	unsigned long srv_idx;
+	unsigned long id;
+	struct qrtr_ns_endpoint *endpoint;
 
 	/* Accept only local observers */
 	if (from->sq_node != qrtr_ns.local_node)
@@ -595,22 +649,30 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
 	filter.service = service;
 	filter.instance = instance;
 
-	xa_for_each(&nodes, node_idx, node) {
-		xa_for_each(&node->servers, srv_idx, srv) {
-			if (!server_match(srv, &filter))
-				continue;
+	xa_for_each(&endpoints, id, endpoint) {
+		struct qrtr_node *node;
+		unsigned long node_idx;
+
+		xa_for_each(&endpoint->nodes, node_idx, node) {
+			unsigned long srv_idx;
+			struct qrtr_server *srv;
 
-			lookup_notify(from, srv, true);
+			xa_for_each(&node->servers, srv_idx, srv) {
+				if (!server_match(srv, &filter))
+					continue;
+
+				lookup_notify(id, from, srv, true);
+			}
 		}
 	}
 
 	/* Empty notification, to indicate end of listing */
-	lookup_notify(from, NULL, true);
+	lookup_notify(0, from, NULL, true);
 
 	return 0;
 }
 
-static void ctrl_cmd_del_lookup(struct sockaddr_qrtr *from,
+static void ctrl_cmd_del_lookup(u32 endpoint_id, struct sockaddr_qrtr *from,
 				unsigned int service, unsigned int instance)
 {
 	struct qrtr_lookup *lookup;
@@ -644,6 +706,7 @@ static void qrtr_ns_worker(struct work_struct *work)
 	ssize_t msglen;
 	void *recv_buf;
 	struct kvec iv;
+	u8 control[32];
 	int ret;
 
 	msg.msg_name = (struct sockaddr *)&sq;
@@ -654,8 +717,12 @@ static void qrtr_ns_worker(struct work_struct *work)
 		return;
 
 	for (;;) {
+		u32 endpoint_id;
+
 		iv.iov_base = recv_buf;
 		iv.iov_len = recv_buf_size;
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
 
 		msglen = kernel_recvmsg(qrtr_ns.sock, &msg, &iv, 1,
 					iv.iov_len, MSG_DONTWAIT);
@@ -668,6 +735,16 @@ static void qrtr_ns_worker(struct work_struct *work)
 			break;
 		}
 
+		/* AUX data is written direct into the control buffer */
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control) - msg.msg_controllen;
+
+		ret = qrtr_msg_get_endpoint(&msg, &endpoint_id);
+		if (ret < 0) {
+			pr_err("error receiving endpoint id: %d\n", ret);
+			break;
+		}
+
 		if ((size_t)msglen < sizeof(*pkt))
 			break;
 
@@ -681,25 +758,25 @@ static void qrtr_ns_worker(struct work_struct *work)
 		ret = 0;
 		switch (cmd) {
 		case QRTR_TYPE_HELLO:
-			ret = ctrl_cmd_hello(&sq);
+			ret = ctrl_cmd_hello(endpoint_id, &sq);
 			break;
 		case QRTR_TYPE_BYE:
-			ret = ctrl_cmd_bye(&sq);
+			ret = ctrl_cmd_bye(endpoint_id, &sq);
 			break;
 		case QRTR_TYPE_DEL_CLIENT:
-			ret = ctrl_cmd_del_client(&sq,
+			ret = ctrl_cmd_del_client(endpoint_id, &sq,
 					le32_to_cpu(pkt->client.node),
 					le32_to_cpu(pkt->client.port));
 			break;
 		case QRTR_TYPE_NEW_SERVER:
-			ret = ctrl_cmd_new_server(&sq,
+			ret = ctrl_cmd_new_server(endpoint_id, &sq,
 					le32_to_cpu(pkt->server.service),
 					le32_to_cpu(pkt->server.instance),
 					le32_to_cpu(pkt->server.node),
 					le32_to_cpu(pkt->server.port));
 			break;
 		case QRTR_TYPE_DEL_SERVER:
-			ret = ctrl_cmd_del_server(&sq,
+			ret = ctrl_cmd_del_server(endpoint_id, &sq,
 					 le32_to_cpu(pkt->server.service),
 					 le32_to_cpu(pkt->server.instance),
 					 le32_to_cpu(pkt->server.node),
@@ -710,12 +787,12 @@ static void qrtr_ns_worker(struct work_struct *work)
 		case QRTR_TYPE_RESUME_TX:
 			break;
 		case QRTR_TYPE_NEW_LOOKUP:
-			ret = ctrl_cmd_new_lookup(&sq,
+			ret = ctrl_cmd_new_lookup(endpoint_id, &sq,
 					 le32_to_cpu(pkt->server.service),
 					 le32_to_cpu(pkt->server.instance));
 			break;
 		case QRTR_TYPE_DEL_LOOKUP:
-			ctrl_cmd_del_lookup(&sq,
+			ctrl_cmd_del_lookup(endpoint_id, &sq,
 				    le32_to_cpu(pkt->server.service),
 				    le32_to_cpu(pkt->server.instance));
 			break;
@@ -749,6 +826,8 @@ int qrtr_ns_init(void)
 	if (ret < 0)
 		return ret;
 
+	qrtr_sock_set_report_endpoint(qrtr_ns.sock->sk);
+
 	ret = kernel_getsockname(qrtr_ns.sock, (struct sockaddr *)&sq);
 	if (ret < 0) {
 		pr_err("failed to get socket name\n");
@@ -777,7 +856,7 @@ int qrtr_ns_init(void)
 	qrtr_ns.bcast_sq.sq_node = QRTR_NODE_BCAST;
 	qrtr_ns.bcast_sq.sq_port = QRTR_PORT_CTRL;
 
-	ret = say_hello(&qrtr_ns.bcast_sq);
+	ret = say_hello(qrtr_ns.local_node, &qrtr_ns.bcast_sq);
 	if (ret < 0)
 		goto err_wq;
 
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index 22fcecbf8de23..b4f50336ae75a 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -35,5 +35,6 @@ int qrtr_ns_init(void);
 void qrtr_ns_remove(void);
 
 int qrtr_msg_get_endpoint(struct msghdr *msg, u32 *out_endpoint_id);
+void qrtr_sock_set_report_endpoint(struct sock *sk);
 
 #endif
-- 
2.34.1

