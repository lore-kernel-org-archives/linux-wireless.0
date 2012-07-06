Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:11 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 25/33] NFC: LLCP late binding
Date: Fri,  6 Jul 2012 22:09:45 +0200
Message-Id: <1341605393-32056-26-git-send-email-sameo@linux.intel.com> (sfid-20120706_220533_417583_B15EDF39)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the LLCP 16 local SAPs we can potentially quickly run out of source
SAPs for non well known services.
With the so called late binding we will reserve an SAP only when we actually
get a client connection for a local service. The SAP will be released once
the last client is gone, leaving it available to other services.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |  241 +++++++++++++++++++++++++++++++++++----------------
 net/nfc/llcp/llcp.h |    2 +
 2 files changed, 166 insertions(+), 77 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 9ab17ec..6094a20 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -131,6 +131,44 @@ int nfc_llcp_local_put(struct nfc_llcp_local *local)
 	return kref_put(&local->ref, local_release);
 }
 
+static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
+					       u8 ssap, u8 dsap)
+{
+	struct sock *sk;
+	struct hlist_node *node;
+	struct nfc_llcp_sock *llcp_sock;
+
+	pr_debug("ssap dsap %d %d\n", ssap, dsap);
+
+	if (ssap == 0 && dsap == 0)
+		return NULL;
+
+	read_lock(&local->sockets.lock);
+
+	llcp_sock = NULL;
+
+	sk_for_each(sk, node, &local->sockets.head) {
+		llcp_sock = nfc_llcp_sock(sk);
+
+		if (llcp_sock->ssap == ssap && llcp_sock->dsap == dsap)
+			break;
+	}
+
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
+static void nfc_llcp_sock_put(struct nfc_llcp_sock *sock)
+{
+	sock_put(&sock->sk);
+}
+
 static void nfc_llcp_timeout_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
@@ -191,6 +229,51 @@ static int nfc_llcp_wks_sap(char *service_name, size_t service_name_len)
 	return -EINVAL;
 }
 
+static
+struct nfc_llcp_sock *nfc_llcp_sock_from_sn(struct nfc_llcp_local *local,
+					    u8 *sn, size_t sn_len)
+{
+	struct sock *sk;
+	struct hlist_node *node;
+	struct nfc_llcp_sock *llcp_sock, *tmp_sock;
+
+	pr_debug("sn %zd %p\n", sn_len, sn);
+
+	if (sn == NULL || sn_len == 0)
+		return NULL;
+
+	read_lock(&local->sockets.lock);
+
+	llcp_sock = NULL;
+
+	sk_for_each(sk, node, &local->sockets.head) {
+		tmp_sock = nfc_llcp_sock(sk);
+
+		pr_debug("llcp sock %p\n", tmp_sock);
+
+		if (tmp_sock->sk.sk_state != LLCP_LISTEN)
+			continue;
+
+		if (tmp_sock->service_name == NULL ||
+		    tmp_sock->service_name_len == 0)
+			continue;
+
+		if (tmp_sock->service_name_len != sn_len)
+			continue;
+
+		if (memcmp(sn, tmp_sock->service_name, sn_len) == 0) {
+			llcp_sock = tmp_sock;
+			break;
+		}
+	}
+
+	read_unlock(&local->sockets.lock);
+
+	pr_debug("Found llcp sock %p\n", llcp_sock);
+
+	return llcp_sock;
+}
+
 u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 			 struct nfc_llcp_sock *sock)
 {
@@ -217,22 +300,19 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 		}
 
 		/*
-		 * This is not a well known service,
-		 * we should try to find a local SDP free spot
+		 * Check if there already is a non WKS socket bound
+		 * to this service name.
 		 */
-		ssap = find_first_zero_bit(&local->local_sdp, LLCP_SDP_NUM_SAP);
-		if (ssap == LLCP_SDP_NUM_SAP) {
+		if (nfc_llcp_sock_from_sn(local, sock->service_name,
+					  sock->service_name_len) != NULL) {
 			mutex_unlock(&local->sdp_lock);
 
 			return LLCP_SAP_MAX;
 		}
 
-		pr_debug("SDP ssap %d\n", LLCP_WKS_NUM_SAP + ssap);
-
-		set_bit(ssap, &local->local_sdp);
 		mutex_unlock(&local->sdp_lock);
 
-		return LLCP_WKS_NUM_SAP + ssap;
+		return LLCP_SDP_UNBOUND;
 
 	} else if (sock->ssap != 0 && sock->ssap < LLCP_WKS_NUM_SAP) {
 		if (!test_bit(sock->ssap, &local->local_wks)) {
@@ -276,8 +356,34 @@ void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap)
 		local_ssap = ssap;
 		sdp = &local->local_wks;
 	} else if (ssap < LLCP_LOCAL_NUM_SAP) {
+		atomic_t *client_cnt;
+
 		local_ssap = ssap - LLCP_WKS_NUM_SAP;
 		sdp = &local->local_sdp;
+		client_cnt = &local->local_sdp_cnt[local_ssap];
+
+		pr_debug("%d clients\n", atomic_read(client_cnt));
+
+		mutex_lock(&local->sdp_lock);
+
+		if (atomic_dec_and_test(client_cnt)) {
+			struct nfc_llcp_sock *l_sock;
+
+			pr_debug("No more clients for SAP %d\n", ssap);
+
+			clear_bit(local_ssap, sdp);
+
+			/* Find the listening sock and set it back to UNBOUND */
+			l_sock = nfc_llcp_sock_get(local, ssap, LLCP_SAP_SDP);
+			if (l_sock) {
+				l_sock->ssap = LLCP_SDP_UNBOUND;
+				nfc_llcp_sock_put(l_sock);
+			}
+		}
+
+		mutex_unlock(&local->sdp_lock);
+
+		return;
 	} else if (ssap < LLCP_MAX_SAP) {
 		local_ssap = ssap - LLCP_LOCAL_NUM_SAP;
 		sdp = &local->local_sap;
@@ -292,6 +398,28 @@ void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap)
 	mutex_unlock(&local->sdp_lock);
 }
 
+static u8 nfc_llcp_reserve_sdp_ssap(struct nfc_llcp_local *local)
+{
+	u8 ssap;
+
+	mutex_lock(&local->sdp_lock);
+
+	ssap = find_first_zero_bit(&local->local_sdp, LLCP_SDP_NUM_SAP);
+	if (ssap == LLCP_SDP_NUM_SAP) {
+		mutex_unlock(&local->sdp_lock);
+
+		return LLCP_SAP_MAX;
+	}
+
+	pr_debug("SDP ssap %d\n", LLCP_WKS_NUM_SAP + ssap);
+
+	set_bit(ssap, &local->local_sdp);
+
+	mutex_unlock(&local->sdp_lock);
+
+	return LLCP_WKS_NUM_SAP + ssap;
+}
+
 static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 {
 	u8 *gb_cur, *version_tlv, version, version_length;
@@ -493,74 +621,12 @@ out:
 	return llcp_sock;
 }
 
-static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
-					       u8 ssap, u8 dsap)
-{
-	struct sock *sk;
-	struct hlist_node *node;
-	struct nfc_llcp_sock *llcp_sock;
-
-	pr_debug("ssap dsap %d %d\n", ssap, dsap);
-
-	if (ssap == 0 && dsap == 0)
-		return NULL;
-
-	read_lock(&local->sockets.lock);
-
-	llcp_sock = NULL;
-
-	sk_for_each(sk, node, &local->sockets.head) {
-		llcp_sock = nfc_llcp_sock(sk);
-
-		if (llcp_sock->ssap == ssap &&
-		    llcp_sock->dsap == dsap)
-			break;
-	}
-
-	read_unlock(&local->sockets.lock);
-
-	if (llcp_sock == NULL)
-		return NULL;
-
-	sock_hold(&llcp_sock->sk);
-
-	return llcp_sock;
-}
-
 static struct nfc_llcp_sock *nfc_llcp_sock_get_sn(struct nfc_llcp_local *local,
 						  u8 *sn, size_t sn_len)
 {
-	struct sock *sk;
-	struct hlist_node *node;
 	struct nfc_llcp_sock *llcp_sock;
 
-	pr_debug("sn %zd\n", sn_len);
-
-	if (sn == NULL || sn_len == 0)
-		return NULL;
-
-	read_lock(&local->sockets.lock);
-
-	llcp_sock = NULL;
-
-	sk_for_each(sk, node, &local->sockets.head) {
-		llcp_sock = nfc_llcp_sock(sk);
-
-		if (llcp_sock->sk.sk_state != LLCP_LISTEN)
-			continue;
-
-		if (llcp_sock->service_name == NULL ||
-		    llcp_sock->service_name_len == 0)
-			continue;
-
-		if (llcp_sock->service_name_len != sn_len)
-			continue;
-
-		if (memcmp(sn, llcp_sock->service_name, sn_len) == 0)
-			break;
-	}
-
-	read_unlock(&local->sockets.lock);
+	llcp_sock = nfc_llcp_sock_from_sn(local, sn, sn_len);
 
 	if (llcp_sock == NULL)
 		return NULL;
@@ -570,11 +636,6 @@ static struct nfc_llcp_sock *nfc_llcp_sock_get_sn(struct nfc_llcp_local *local,
 	return llcp_sock;
 }
 
-static void nfc_llcp_sock_put(struct nfc_llcp_sock *sock)
-{
-	sock_put(&sock->sk);
-}
-
 static u8 *nfc_llcp_connect_sn(struct sk_buff *skb, size_t *sn_len)
 {
 	u8 *tlv = &skb->data[2], type, length;
@@ -646,6 +707,21 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 		goto fail;
 	}
 
+	if (sock->ssap == LLCP_SDP_UNBOUND) {
+		u8 ssap = nfc_llcp_reserve_sdp_ssap(local);
+
+		pr_debug("First client, reserving %d\n", ssap);
+
+		if (ssap == LLCP_SAP_MAX) {
+			reason = LLCP_DM_REJ;
+			release_sock(&sock->sk);
+			sock_put(&sock->sk);
+			goto fail;
+		}
+
+		sock->ssap = ssap;
+	}
+
 	new_sk = nfc_llcp_sock_alloc(NULL, parent->sk_type, GFP_ATOMIC);
 	if (new_sk == NULL) {
 		reason = LLCP_DM_REJ;
@@ -659,10 +735,21 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	new_sock->local = nfc_llcp_local_get(local);
 	new_sock->miu = local->remote_miu;
 	new_sock->nfc_protocol = sock->nfc_protocol;
-	new_sock->ssap = sock->ssap;
 	new_sock->dsap = ssap;
 	new_sock->target_idx = local->target_idx;
 	new_sock->parent = parent;
+	new_sock->ssap = sock->ssap;
+	if (sock->ssap < LLCP_LOCAL_NUM_SAP && sock->ssap >= LLCP_WKS_NUM_SAP) {
+		atomic_t *client_count;
+
+		pr_debug("reserved_ssap %d for %p\n", sock->ssap, new_sock);
+
+		client_count =
+			&local->local_sdp_cnt[sock->ssap - LLCP_WKS_NUM_SAP];
+
+		atomic_inc(client_count);
+		new_sock->reserved_ssap = sock->ssap;
+	}
 
 	nfc_llcp_parse_connection_tlv(new_sock, &skb->data[LLCP_HEADER_SIZE],
 				      skb->len - LLCP_HEADER_SIZE);
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 374cc47..83b8bba 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -37,6 +37,7 @@ enum llcp_state {
 #define LLCP_LOCAL_NUM_SAP 32
 #define LLCP_LOCAL_SAP_OFFSET (LLCP_WKS_NUM_SAP + LLCP_SDP_NUM_SAP)
 #define LLCP_MAX_SAP (LLCP_WKS_NUM_SAP + LLCP_SDP_NUM_SAP + LLCP_LOCAL_NUM_SAP)
+#define LLCP_SDP_UNBOUND   (LLCP_MAX_SAP + 1)
 
 struct nfc_llcp_sock;
 
@@ -69,6 +70,7 @@ struct nfc_llcp_local {
 	unsigned long local_wks;      /* Well known services */
 	unsigned long local_sdp;      /* Local services  */
 	unsigned long local_sap; /* Local SAPs, not available for discovery */
+	atomic_t local_sdp_cnt[LLCP_SDP_NUM_SAP];
 
 	/* local */
 	u8 gb[NFC_MAX_GT_LEN];
-- 
1.7.10

