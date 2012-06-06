Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24629 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2FFKGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:44 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 03/29] NFC: Move LLCP receiver window value to socket structure
Date: Wed,  6 Jun 2012 12:16:20 +0200
Message-Id: <1338977806-30279-4-git-send-email-sameo@linux.intel.com> (sfid-20120606_120646_770467_373BAB3D)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RW can only be fetched from a CONNECT or a CC frame thus making it an
end points specific value, not a link one.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 net/nfc/llcp/llcp.c     |   21 ++++++++++-----------
 net/nfc/llcp/llcp.h     |    9 ++++++---
 net/nfc/llcp/sock.c     |    1 +
 4 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index bf8ae4f..eb51864 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -117,8 +117,8 @@ u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length)
 	return tlv;
 }
 
-int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
-		       u8 *tlv_array, u16 tlv_array_len)
+int nfc_llcp_parse_gb_tlv(struct nfc_llcp_local *local,
+			  u8 *tlv_array, u16 tlv_array_len)
 {
 	u8 *tlv = tlv_array, type, length, offset = 0;
 
@@ -149,8 +149,42 @@ int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
 		case LLCP_TLV_OPT:
 			local->remote_opt = llcp_tlv_opt(tlv);
 			break;
+		default:
+			pr_err("Invalid gt tlv value 0x%x\n", type);
+			break;
+		}
+
+		offset += length + 2;
+		tlv += length + 2;
+	}
+
+	pr_debug("version 0x%x miu %d lto %d opt 0x%x wks 0x%x\n",
+		 local->remote_version, local->remote_miu,
+		 local->remote_lto, local->remote_opt,
+		 local->remote_wks);
+
+	return 0;
+}
+
+int nfc_llcp_parse_connection_tlv(struct nfc_llcp_sock *sock,
+				  u8 *tlv_array, u16 tlv_array_len)
+{
+	u8 *tlv = tlv_array, type, length, offset = 0;
+
+	pr_debug("TLV array length %d\n", tlv_array_len);
+
+	if (sock == NULL)
+		return -ENOTCONN;
+
+	while (offset < tlv_array_len) {
+		type = tlv[0];
+		length = tlv[1];
+
+		pr_debug("type 0x%x length %d\n", type, length);
+
+		switch (type) {
 		case LLCP_TLV_RW:
-			local->remote_rw = llcp_tlv_rw(tlv);
+			sock->rw = llcp_tlv_rw(tlv);
 			break;
 		case LLCP_TLV_SN:
 			break;
@@ -163,10 +197,7 @@ int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
 		tlv += length + 2;
 	}
 
-	pr_debug("version 0x%x miu %d lto %d opt 0x%x wks 0x%x rw %d\n",
-		 local->remote_version, local->remote_miu,
-		 local->remote_lto, local->remote_opt,
-		 local->remote_wks, local->remote_rw);
+	pr_debug("sock %p rw %d\n", sock, sock->rw);
 
 	return 0;
 }
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 262aa82..d3efc5b 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -406,9 +406,9 @@ int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 		return -EINVAL;
 	}
 
-	return nfc_llcp_parse_tlv(local,
-				  &local->remote_gb[3],
-				  local->remote_gb_len - 3);
+	return nfc_llcp_parse_gb_tlv(local,
+				     &local->remote_gb[3],
+				     local->remote_gb_len - 3);
 }
 
 static void nfc_llcp_tx_work(struct work_struct *work)
@@ -608,9 +608,6 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 
 	pr_debug("%d %d\n", dsap, ssap);
 
-	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
-			   skb->len - LLCP_HEADER_SIZE);
-
 	if (dsap != LLCP_SAP_SDP) {
 		sock = nfc_llcp_sock_get(local, dsap, LLCP_SAP_SDP);
 		if (sock == NULL || sock->sk.sk_state != LLCP_LISTEN) {
@@ -663,6 +660,9 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	new_sock->dsap = ssap;
 	new_sock->parent = parent;
 
+	nfc_llcp_parse_connection_tlv(new_sock, &skb->data[LLCP_HEADER_SIZE],
+				      skb->len - LLCP_HEADER_SIZE);
+
 	pr_debug("new sock %p sk %p\n", new_sock, &new_sock->sk);
 
 	nfc_llcp_sock_link(&local->sockets, new_sk);
@@ -699,11 +699,11 @@ int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 
 	pr_debug("Remote ready %d tx queue len %d remote rw %d",
 		 sock->remote_ready, skb_queue_len(&sock->tx_pending_queue),
-		 local->remote_rw);
+		 sock->rw);
 
 	/* Try to queue some I frames for transmission */
 	while (sock->remote_ready &&
-	       skb_queue_len(&sock->tx_pending_queue) < local->remote_rw) {
+	       skb_queue_len(&sock->tx_pending_queue) < sock->rw) {
 		struct sk_buff *pdu, *pending_pdu;
 
 		pdu = skb_dequeue(&sock->tx_queue);
@@ -851,8 +851,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 	nfc_llcp_sock_link(&local->sockets, sk);
 	llcp_sock->dsap = ssap;
 
-	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
-			   skb->len - LLCP_HEADER_SIZE);
+	nfc_llcp_parse_connection_tlv(llcp_sock, &skb->data[LLCP_HEADER_SIZE],
+				      skb->len - LLCP_HEADER_SIZE);
 
 	sk->sk_state = LLCP_CONNECTED;
 	sk->sk_state_change(sk);
@@ -1036,7 +1036,6 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 
 	local->remote_miu = LLCP_DEFAULT_MIU;
 	local->remote_lto = LLCP_DEFAULT_LTO;
-	local->remote_rw = LLCP_DEFAULT_RW;
 
 	list_add(&llcp_devices, &local->list);
 
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 7053304..add03e7 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -83,7 +83,6 @@ struct nfc_llcp_local {
 	u16 remote_lto;
 	u8  remote_opt;
 	u16 remote_wks;
-	u8  remote_rw;
 
 	/* sockets array */
 	struct llcp_sock_list sockets;
@@ -97,10 +96,12 @@ struct nfc_llcp_sock {
 	u32 target_idx;
 	u32 nfc_protocol;
 
+	/* Link parameters */
 	u8 ssap;
 	u8 dsap;
 	char *service_name;
 	size_t service_name_len;
+	u8 rw;
 
 	/* Link variables */
 	u8 send_n;
@@ -189,8 +190,10 @@ void nfc_llcp_accept_enqueue(struct sock *parent, struct sock *sk);
 struct sock *nfc_llcp_accept_dequeue(struct sock *sk, struct socket *newsock);
 
 /* TLV API */
-int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
-		       u8 *tlv_array, u16 tlv_array_len);
+int nfc_llcp_parse_gb_tlv(struct nfc_llcp_local *local,
+			  u8 *tlv_array, u16 tlv_array_len);
+int nfc_llcp_parse_connection_tlv(struct nfc_llcp_sock *sock,
+				  u8 *tlv_array, u16 tlv_array_len);
 
 /* Commands API */
 void nfc_llcp_recv(void *data, struct sk_buff *skb, int err);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 8a60b53..aab077e 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -678,6 +678,7 @@ struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
 
 	llcp_sock->ssap = 0;
 	llcp_sock->dsap = LLCP_SAP_SDP;
+	llcp_sock->rw = LLCP_DEFAULT_RW;
 	llcp_sock->send_n = llcp_sock->send_ack_n = 0;
 	llcp_sock->recv_n = llcp_sock->recv_ack_n = 0;
 	llcp_sock->remote_ready = 1;
-- 
1.7.9.1

