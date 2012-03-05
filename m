Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41458 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab2CDX6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:25 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 20/22] NFC: LLCP code identation fixes
Date: Mon,  5 Mar 2012 01:03:52 +0100
Message-Id: <1330905834-6994-21-git-send-email-sameo@linux.intel.com> (sfid-20120305_005829_408619_9CC339FA)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |   39 +++++++++++---------
 net/nfc/llcp/llcp.c     |   93 ++++++++++++++++++++++++-----------------------
 net/nfc/llcp/llcp.h     |    6 ++--
 net/nfc/llcp/sock.c     |   55 +++++++++++++++-------------
 4 files changed, 100 insertions(+), 93 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 7c74b82..7b76eb7 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -118,7 +118,7 @@ u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length)
 }
 
 int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
-			u8 *tlv_array, u16 tlv_array_len)
+		       u8 *tlv_array, u16 tlv_array_len)
 {
 	u8 *tlv = tlv_array, type, length, offset = 0;
 
@@ -164,15 +164,15 @@ int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
 	}
 
 	pr_debug("version 0x%x miu %d lto %d opt 0x%x wks 0x%x rw %d\n",
-		local->remote_version, local->remote_miu,
-		local->remote_lto, local->remote_opt,
-		local->remote_wks, local->remote_rw);
+		 local->remote_version, local->remote_miu,
+		 local->remote_lto, local->remote_opt,
+		 local->remote_wks, local->remote_rw);
 
 	return 0;
 }
 
 static struct sk_buff *llcp_add_header(struct sk_buff *pdu,
-					u8 dsap, u8 ssap, u8 ptype)
+				       u8 dsap, u8 ssap, u8 ptype)
 {
 	u8 header[2];
 
@@ -188,7 +188,8 @@ static struct sk_buff *llcp_add_header(struct sk_buff *pdu,
 	return pdu;
 }
 
-static struct sk_buff *llcp_add_tlv(struct sk_buff *pdu, u8 *tlv, u8 tlv_length)
+static struct sk_buff *llcp_add_tlv(struct sk_buff *pdu, u8 *tlv,
+				    u8 tlv_length)
 {
 	/* XXX Add an skb length check */
 
@@ -201,7 +202,7 @@ static struct sk_buff *llcp_add_tlv(struct sk_buff *pdu, u8 *tlv, u8 tlv_length)
 }
 
 static struct sk_buff *llcp_allocate_pdu(struct nfc_llcp_sock *sock,
-							u8 cmd, u16 size)
+					 u8 cmd, u16 size)
 {
 	struct sk_buff *skb;
 	int err;
@@ -210,7 +211,7 @@ static struct sk_buff *llcp_allocate_pdu(struct nfc_llcp_sock *sock,
 		return NULL;
 
 	skb = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
-					size + LLCP_HEADER_SIZE, &err);
+				 size + LLCP_HEADER_SIZE, &err);
 	if (skb == NULL) {
 		pr_err("Could not allocate PDU\n");
 		return NULL;
@@ -278,7 +279,7 @@ int nfc_llcp_send_symm(struct nfc_dev *dev)
 	skb = llcp_add_header(skb, 0, 0, LLCP_PDU_SYMM);
 
 	return nfc_data_exchange(dev, local->target_idx, skb,
-					nfc_llcp_recv, local);
+				 nfc_llcp_recv, local);
 }
 
 int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
@@ -300,14 +301,15 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 
 	if (sock->service_name != NULL) {
 		service_name_tlv = nfc_llcp_build_tlv(LLCP_TLV_SN,
-					sock->service_name,
-					sock->service_name_len,
-					&service_name_tlv_length);
+						      sock->service_name,
+						      sock->service_name_len,
+						      &service_name_tlv_length);
 		size += service_name_tlv_length;
 	}
 
 	miux = cpu_to_be16(LLCP_MAX_MIUX);
-	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0, &miux_tlv_length);
+	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0,
+				      &miux_tlv_length);
 	size += miux_tlv_length;
 
 	rw = LLCP_MAX_RW;
@@ -324,7 +326,7 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 
 	if (service_name_tlv != NULL)
 		skb = llcp_add_tlv(skb, service_name_tlv,
-					service_name_tlv_length);
+				   service_name_tlv_length);
 
 	skb = llcp_add_tlv(skb, miux_tlv, miux_tlv_length);
 	skb = llcp_add_tlv(skb, rw_tlv, rw_tlv_length);
@@ -360,7 +362,8 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
 		return -ENODEV;
 
 	miux = cpu_to_be16(LLCP_MAX_MIUX);
-	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0, &miux_tlv_length);
+	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0,
+				      &miux_tlv_length);
 	size += miux_tlv_length;
 
 	rw = LLCP_MAX_RW;
@@ -443,7 +446,7 @@ int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock)
 }
 
 int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
-				struct msghdr *msg, size_t len)
+			  struct msghdr *msg, size_t len)
 {
 	struct sk_buff *pdu;
 	struct sock *sk = &sock->sk;
@@ -462,8 +465,8 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 		return -ENOMEM;
 
 	if (memcpy_fromiovec(msg_data, msg->msg_iov, len)) {
-			kfree(msg_data);
-			return -EFAULT;
+		kfree(msg_data);
+		return -EFAULT;
 	}
 
 	remaining_len = len;
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 8af896d..17a578f 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -37,7 +37,6 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 	struct sock *sk, *parent_sk;
 	int i;
 
-
 	mutex_lock(&local->socket_lock);
 
 	for (i = 0; i < LLCP_MAX_SAP; i++) {
@@ -73,7 +72,7 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 			struct sock *accept_sk;
 
 			list_for_each_entry_safe(lsk, n, &parent->accept_queue,
-								accept_queue) {
+						 accept_queue) {
 				accept_sk = &lsk->sk;
 				lock_sock(accept_sk);
 
@@ -118,7 +117,7 @@ static void nfc_llcp_clear_sdp(struct nfc_llcp_local *local)
 static void nfc_llcp_timeout_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
-							timeout_work);
+						    timeout_work);
 
 	nfc_dep_link_down(local->dev);
 }
@@ -164,7 +163,7 @@ static int nfc_llcp_wks_sap(char *service_name, size_t service_name_len)
 
 	num_wks = ARRAY_SIZE(wks);
 
-	for (sap = 0 ; sap < num_wks; sap++) {
+	for (sap = 0; sap < num_wks; sap++) {
 		if (wks[sap] == NULL)
 			continue;
 
@@ -176,13 +175,13 @@ static int nfc_llcp_wks_sap(char *service_name, size_t service_name_len)
 }
 
 u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
-				struct nfc_llcp_sock *sock)
+			 struct nfc_llcp_sock *sock)
 {
 	mutex_lock(&local->sdp_lock);
 
 	if (sock->service_name != NULL && sock->service_name_len > 0) {
 		int ssap = nfc_llcp_wks_sap(sock->service_name,
-						sock->service_name_len);
+					    sock->service_name_len);
 
 		if (ssap > 0) {
 			pr_debug("WKS %d\n", ssap);
@@ -312,7 +311,7 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 
 	version = LLCP_VERSION_11;
 	version_tlv = nfc_llcp_build_tlv(LLCP_TLV_VERSION, &version,
-							1, &version_length);
+					 1, &version_length);
 	gb_len += version_length;
 
 	/* 1500 ms */
@@ -322,7 +321,7 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 
 	pr_debug("Local wks 0x%lx\n", local->local_wks);
 	wks_tlv = nfc_llcp_build_tlv(LLCP_TLV_WKS, (u8 *)&local->local_wks, 2,
-								&wks_length);
+				     &wks_length);
 	gb_len += wks_length;
 
 	gb_len += ARRAY_SIZE(llcp_magic);
@@ -367,8 +366,7 @@ int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 	memcpy(local->remote_gb, gb, gb_len);
 	local->remote_gb_len = gb_len;
 
-	if (local->remote_gb == NULL ||
-			local->remote_gb_len == 0)
+	if (local->remote_gb == NULL || local->remote_gb_len == 0)
 		return -ENODEV;
 
 	if (memcmp(local->remote_gb, llcp_magic, 3)) {
@@ -377,26 +375,27 @@ int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 	}
 
 	return nfc_llcp_parse_tlv(local,
-			&local->remote_gb[3], local->remote_gb_len - 3);
+				  &local->remote_gb[3],
+				  local->remote_gb_len - 3);
 }
 
 static void nfc_llcp_tx_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
-							tx_work);
+						    tx_work);
 	struct sk_buff *skb;
 
 	skb = skb_dequeue(&local->tx_queue);
 	if (skb != NULL) {
 		pr_debug("Sending pending skb\n");
 		nfc_data_exchange(local->dev, local->target_idx,
-					skb, nfc_llcp_recv, local);
+				  skb, nfc_llcp_recv, local);
 	} else {
 		nfc_llcp_send_symm(local->dev);
 	}
 
 	mod_timer(&local->link_timer,
-			jiffies + msecs_to_jiffies(local->remote_lto));
+		  jiffies + msecs_to_jiffies(local->remote_lto));
 }
 
 static u8 nfc_llcp_dsap(struct sk_buff *pdu)
@@ -432,7 +431,7 @@ static void nfc_llcp_set_nrns(struct nfc_llcp_sock *sock, struct sk_buff *pdu)
 }
 
 static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
-						u8 ssap, u8 dsap)
+					       u8 ssap, u8 dsap)
 {
 	struct nfc_llcp_sock *sock, *llcp_sock, *n;
 
@@ -456,7 +455,7 @@ static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
 
 	list_for_each_entry_safe(llcp_sock, n, &sock->list, list) {
 		pr_debug("llcp_sock %p sk %p dsap %d\n", llcp_sock,
-				&llcp_sock->sk, llcp_sock->dsap);
+			 &llcp_sock->sk, llcp_sock->dsap);
 		if (llcp_sock->dsap == dsap) {
 			sock_hold(&llcp_sock->sk);
 			mutex_unlock(&local->socket_lock);
@@ -500,7 +499,7 @@ static u8 *nfc_llcp_connect_sn(struct sk_buff *skb, size_t *sn_len)
 }
 
 static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
-				struct sk_buff *skb)
+				  struct sk_buff *skb)
 {
 	struct sock *new_sk, *parent;
 	struct nfc_llcp_sock *sock, *new_sock;
@@ -512,7 +511,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	pr_debug("%d %d\n", dsap, ssap);
 
 	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
-				skb->len - LLCP_HEADER_SIZE);
+			   skb->len - LLCP_HEADER_SIZE);
 
 	if (dsap != LLCP_SAP_SDP) {
 		bound_sap = dsap;
@@ -531,7 +530,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 		lock_sock(&sock->sk);
 
 		if (sock->dsap == LLCP_SAP_SDP &&
-				sock->sk.sk_state == LLCP_LISTEN)
+		    sock->sk.sk_state == LLCP_LISTEN)
 			goto enqueue;
 	} else {
 		u8 *sn;
@@ -547,23 +546,23 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 
 		mutex_lock(&local->socket_lock);
 		for (bound_sap = 0; bound_sap < LLCP_LOCAL_SAP_OFFSET;
-								bound_sap++) {
+		     bound_sap++) {
 			sock = local->sockets[bound_sap];
 			if (sock == NULL)
 				continue;
 
 			if (sock->service_name == NULL ||
-				sock->service_name_len == 0)
+			    sock->service_name_len == 0)
 					continue;
 
 			if (sock->service_name_len != sn_len)
 				continue;
 
 			if (sock->dsap == LLCP_SAP_SDP &&
-					sock->sk.sk_state == LLCP_LISTEN &&
-					!memcmp(sn, sock->service_name, sn_len)) {
+			    sock->sk.sk_state == LLCP_LISTEN &&
+			    !memcmp(sn, sock->service_name, sn_len)) {
 				pr_debug("Found service name at SAP %d\n",
-								bound_sap);
+					 bound_sap);
 				sock_hold(&sock->sk);
 				mutex_unlock(&local->socket_lock);
 
@@ -588,8 +587,7 @@ enqueue:
 		goto fail;
 	}
 
-	new_sk = nfc_llcp_sock_alloc(NULL, parent->sk_type,
-				     GFP_ATOMIC);
+	new_sk = nfc_llcp_sock_alloc(NULL, parent->sk_type, GFP_ATOMIC);
 	if (new_sk == NULL) {
 		reason = LLCP_DM_REJ;
 		release_sock(&sock->sk);
@@ -640,12 +638,12 @@ int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 	struct nfc_llcp_local *local = sock->local;
 
 	pr_debug("Remote ready %d tx queue len %d remote rw %d",
-		sock->remote_ready, skb_queue_len(&sock->tx_pending_queue),
-		local->remote_rw);
+		 sock->remote_ready, skb_queue_len(&sock->tx_pending_queue),
+		 local->remote_rw);
 
 	/* Try to queue some I frames for transmission */
 	while (sock->remote_ready &&
-		skb_queue_len(&sock->tx_pending_queue) < local->remote_rw) {
+	       skb_queue_len(&sock->tx_pending_queue) < local->remote_rw) {
 		struct sk_buff *pdu, *pending_pdu;
 
 		pdu = skb_dequeue(&sock->tx_queue);
@@ -666,7 +664,7 @@ int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 }
 
 static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
-				struct sk_buff *skb)
+			       struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
 	struct sock *sk;
@@ -724,7 +722,7 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 
 	if (ptype == LLCP_PDU_RR)
 		llcp_sock->remote_ready = true;
-        else if (ptype == LLCP_PDU_RNR)
+	else if (ptype == LLCP_PDU_RNR)
 		llcp_sock->remote_ready = false;
 
 	if (nfc_llcp_queue_i_frames(llcp_sock) == 0)
@@ -735,7 +733,7 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 }
 
 static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
-				struct sk_buff *skb)
+			       struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
 	struct sock *sk;
@@ -757,7 +755,6 @@ static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
 		nfc_llcp_sock_put(llcp_sock);
 	}
 
-
 	if (sk->sk_state == LLCP_CONNECTED) {
 		nfc_put_device(local->dev);
 		sk->sk_state = LLCP_CLOSED;
@@ -770,13 +767,11 @@ static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
 	nfc_llcp_sock_put(llcp_sock);
 }
 
-static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
-				struct sk_buff *skb)
+static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
 	u8 dsap, ssap;
 
-
 	dsap = nfc_llcp_dsap(skb);
 	ssap = nfc_llcp_ssap(skb);
 
@@ -795,7 +790,7 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
 	llcp_sock->dsap = ssap;
 
 	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
-				skb->len - LLCP_HEADER_SIZE);
+			   skb->len - LLCP_HEADER_SIZE);
 
 	nfc_llcp_sock_put(llcp_sock);
 }
@@ -803,7 +798,7 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
 static void nfc_llcp_rx_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
-								rx_work);
+						    rx_work);
 	u8 dsap, ssap, ptype;
 	struct sk_buff *skb;
 
@@ -861,7 +856,7 @@ void nfc_llcp_recv(void *data, struct sk_buff *skb, int err)
 
 	pr_debug("Received an LLCP PDU\n");
 	if (err < 0) {
-		pr_err("err %d", err);
+		pr_err("err %d\n", err);
 		return;
 	}
 
@@ -907,7 +902,7 @@ void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
 		queue_work(local->tx_wq, &local->tx_work);
 	} else {
 		mod_timer(&local->link_timer,
-			jiffies + msecs_to_jiffies(local->remote_lto));
+			  jiffies + msecs_to_jiffies(local->remote_lto));
 	}
 }
 
@@ -933,8 +928,10 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	skb_queue_head_init(&local->tx_queue);
 	INIT_WORK(&local->tx_work, nfc_llcp_tx_work);
 	snprintf(name, sizeof(name), "%s_llcp_tx_wq", dev_name(dev));
-	local->tx_wq = alloc_workqueue(name,
-			WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	local->tx_wq =
+		alloc_workqueue(name,
+				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				1);
 	if (local->tx_wq == NULL) {
 		err = -ENOMEM;
 		goto err_local;
@@ -943,8 +940,10 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	local->rx_pending = NULL;
 	INIT_WORK(&local->rx_work, nfc_llcp_rx_work);
 	snprintf(name, sizeof(name), "%s_llcp_rx_wq", dev_name(dev));
-	local->rx_wq = alloc_workqueue(name,
-			WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	local->rx_wq =
+		alloc_workqueue(name,
+				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				1);
 	if (local->rx_wq == NULL) {
 		err = -ENOMEM;
 		goto err_tx_wq;
@@ -952,8 +951,10 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 
 	INIT_WORK(&local->timeout_work, nfc_llcp_timeout_work);
 	snprintf(name, sizeof(name), "%s_llcp_timeout_wq", dev_name(dev));
-	local->timeout_wq = alloc_workqueue(name,
-			WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	local->timeout_wq =
+		alloc_workqueue(name,
+				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				1);
 	if (local->timeout_wq == NULL) {
 		err = -ENOMEM;
 		goto err_rx_wq;
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 70e1762..50680ce 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -166,7 +166,7 @@ struct nfc_llcp_sock {
 
 struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev);
 u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
-				struct nfc_llcp_sock *sock);
+			 struct nfc_llcp_sock *sock);
 u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local);
 void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap);
 int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock);
@@ -180,7 +180,7 @@ struct sock *nfc_llcp_accept_dequeue(struct sock *sk, struct socket *newsock);
 
 /* TLV API */
 int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
-			u8 *tlv_array, u16 tlv_array_len);
+		       u8 *tlv_array, u16 tlv_array_len);
 
 /* Commands API */
 void nfc_llcp_recv(void *data, struct sk_buff *skb, int err);
@@ -193,7 +193,7 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock);
 int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason);
 int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock);
 int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
-				struct msghdr *msg, size_t len);
+			  struct msghdr *msg, size_t len);
 int nfc_llcp_send_rr(struct nfc_llcp_sock *sock);
 
 /* Socket API */
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 35825e2..c13e02e 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -78,9 +78,11 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	llcp_sock->local = local;
 	llcp_sock->nfc_protocol = llcp_addr.nfc_protocol;
 	llcp_sock->service_name_len = min_t(unsigned int,
-			llcp_addr.service_name_len, NFC_LLCP_MAX_SERVICE_NAME);
+					    llcp_addr.service_name_len,
+					    NFC_LLCP_MAX_SERVICE_NAME);
 	llcp_sock->service_name = kmemdup(llcp_addr.service_name,
-				llcp_sock->service_name_len, GFP_KERNEL);
+					  llcp_sock->service_name_len,
+					  GFP_KERNEL);
 
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_MAX_SAP)
@@ -110,7 +112,7 @@ static int llcp_sock_listen(struct socket *sock, int backlog)
 	lock_sock(sk);
 
 	if ((sock->type != SOCK_SEQPACKET && sock->type != SOCK_STREAM)
-			|| sk->sk_state != LLCP_BOUND) {
+	    || sk->sk_state != LLCP_BOUND) {
 		ret = -EBADFD;
 		goto error;
 	}
@@ -149,13 +151,13 @@ void nfc_llcp_accept_enqueue(struct sock *parent, struct sock *sk)
 	sock_hold(sk);
 
 	list_add_tail(&llcp_sock->accept_queue,
-			&llcp_sock_parent->accept_queue);
+		      &llcp_sock_parent->accept_queue);
 	llcp_sock->parent = parent;
 	sk_acceptq_added(parent);
 }
 
 struct sock *nfc_llcp_accept_dequeue(struct sock *parent,
-					struct socket *newsock)
+				     struct socket *newsock)
 {
 	struct nfc_llcp_sock *lsk, *n, *llcp_parent;
 	struct sock *sk;
@@ -163,7 +165,7 @@ struct sock *nfc_llcp_accept_dequeue(struct sock *parent,
 	llcp_parent = nfc_llcp_sock(parent);
 
 	list_for_each_entry_safe(lsk, n, &llcp_parent->accept_queue,
-							accept_queue) {
+				 accept_queue) {
 		sk = &lsk->sk;
 		lock_sock(sk);
 
@@ -192,7 +194,7 @@ struct sock *nfc_llcp_accept_dequeue(struct sock *parent,
 }
 
 static int llcp_sock_accept(struct socket *sock, struct socket *newsock,
-								int flags)
+			    int flags)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct sock *sk = sock->sk, *new_sk;
@@ -248,7 +250,7 @@ error:
 static int llcp_sock_getname(struct socket *sock, struct sockaddr *addr,
 			     int *len, int peer)
 {
-	struct sockaddr_nfc_llcp *llcp_addr = (struct sockaddr_nfc_llcp *) addr;
+	struct sockaddr_nfc_llcp *llcp_addr = (struct sockaddr_nfc_llcp *)addr;
 	struct sock *sk = sock->sk;
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
 
@@ -262,7 +264,7 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *addr,
 	llcp_addr->ssap = llcp_sock->ssap;
 	llcp_addr->service_name_len = llcp_sock->service_name_len;
 	memcpy(llcp_addr->service_name, llcp_sock->service_name,
-					llcp_addr->service_name_len);
+	       llcp_addr->service_name_len);
 
 	return 0;
 }
@@ -275,7 +277,7 @@ static inline unsigned int llcp_accept_poll(struct sock *parent)
 	parent_sock = nfc_llcp_sock(parent);
 
 	list_for_each_entry_safe(llcp_sock, n, &parent_sock->accept_queue,
-								accept_queue) {
+				 accept_queue) {
 		sk = &llcp_sock->sk;
 
 		if (sk->sk_state == LLCP_CONNECTED)
@@ -286,7 +288,7 @@ static inline unsigned int llcp_accept_poll(struct sock *parent)
 }
 
 static unsigned int llcp_sock_poll(struct file *file, struct socket *sock,
-							poll_table *wait)
+				   poll_table *wait)
 {
 	struct sock *sk = sock->sk;
 	unsigned int mask = 0;
@@ -348,7 +350,7 @@ static int llcp_sock_release(struct socket *sock)
 		struct sock *accept_sk;
 
 		list_for_each_entry_safe(lsk, n, &llcp_sock->accept_queue,
-								accept_queue) {
+					 accept_queue) {
 			accept_sk = &lsk->sk;
 			lock_sock(accept_sk);
 
@@ -363,9 +365,8 @@ static int llcp_sock_release(struct socket *sock)
 
 	/* Freeing the SAP */
 	if ((sk->sk_state == LLCP_CONNECTED
-			&& llcp_sock->ssap > LLCP_LOCAL_SAP_OFFSET) ||
-	    sk->sk_state == LLCP_BOUND ||
-	    sk->sk_state == LLCP_LISTEN)
+	     && llcp_sock->ssap > LLCP_LOCAL_SAP_OFFSET) ||
+	    sk->sk_state == LLCP_BOUND || sk->sk_state == LLCP_LISTEN)
 		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
 	release_sock(sk);
@@ -378,7 +379,7 @@ out:
 }
 
 static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
-							int len, int flags)
+			     int len, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
@@ -390,7 +391,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	pr_debug("sock %p sk %p flags 0x%x\n", sock, sk, flags);
 
 	if (!addr || len < sizeof(struct sockaddr_nfc) ||
-			addr->sa_family != AF_NFC) {
+	    addr->sa_family != AF_NFC) {
 		pr_err("Invalid socket\n");
 		return -EINVAL;
 	}
@@ -401,7 +402,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	}
 
 	pr_debug("addr dev_idx=%u target_idx=%u protocol=%u\n", addr->dev_idx,
-					addr->target_idx, addr->nfc_protocol);
+		 addr->target_idx, addr->nfc_protocol);
 
 	lock_sock(sk);
 
@@ -431,7 +432,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	device_unlock(&dev->dev);
 
 	if (local->rf_mode == NFC_RF_INITIATOR &&
-			addr->target_idx != local->target_idx) {
+	    addr->target_idx != local->target_idx) {
 		ret = -ENOLINK;
 		goto put_dev;
 	}
@@ -449,9 +450,11 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 		llcp_sock->dsap = LLCP_SAP_SDP;
 	llcp_sock->nfc_protocol = addr->nfc_protocol;
 	llcp_sock->service_name_len = min_t(unsigned int,
-			addr->service_name_len, NFC_LLCP_MAX_SERVICE_NAME);
+					    addr->service_name_len,
+					    NFC_LLCP_MAX_SERVICE_NAME);
 	llcp_sock->service_name = kmemdup(addr->service_name,
-				 llcp_sock->service_name_len, GFP_KERNEL);
+					  llcp_sock->service_name_len,
+					  GFP_KERNEL);
 
 	local->sockets[llcp_sock->ssap] = llcp_sock;
 
@@ -473,7 +476,7 @@ error:
 }
 
 static int llcp_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
-				struct msghdr *msg, size_t len)
+			     struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
@@ -514,7 +517,7 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	lock_sock(sk);
 
 	if (sk->sk_state == LLCP_CLOSED &&
-			skb_queue_empty(&sk->sk_receive_queue)) {
+	    skb_queue_empty(&sk->sk_receive_queue)) {
 		release_sock(sk);
 		return 0;
 	}
@@ -527,7 +530,7 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		pr_err("Recv datagram failed state %d %d %d",
-				sk->sk_state, err, sock_error(sk));
+		       sk->sk_state, err, sock_error(sk));
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
@@ -535,7 +538,7 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 		return err;
 	}
 
-	rlen   = skb->len;		/* real length of skb */
+	rlen = skb->len;		/* real length of skb */
 	copied = min_t(unsigned int, rlen, len);
 
 	cskb = skb;
@@ -664,7 +667,7 @@ void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 }
 
 static int llcp_sock_create(struct net *net, struct socket *sock,
-				const struct nfc_protocol *nfc_proto)
+			    const struct nfc_protocol *nfc_proto)
 {
 	struct sock *sk;
 
-- 
1.7.7.3

