Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24629 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2FFKGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:48 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 04/29] NFC: Move LLCP MIU extension value to socket structure
Date: Wed,  6 Jun 2012 12:16:21 +0200
Message-Id: <1338977806-30279-5-git-send-email-sameo@linux.intel.com> (sfid-20120606_120651_263325_AF943E9D)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MIU extension value can be received during the PAX or during the
connection establishment process. It's definitely a connection related value
rather than a link one.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    7 +++++--
 net/nfc/llcp/llcp.c     |    1 +
 net/nfc/llcp/llcp.h     |    1 +
 net/nfc/llcp/sock.c     |    2 ++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index eb51864..850e5cf 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -183,6 +183,9 @@ int nfc_llcp_parse_connection_tlv(struct nfc_llcp_sock *sock,
 		pr_debug("type 0x%x length %d\n", type, length);
 
 		switch (type) {
+		case LLCP_TLV_MIUX:
+			sock->miu = llcp_tlv_miux(tlv) + 128;
+			break;
 		case LLCP_TLV_RW:
 			sock->rw = llcp_tlv_rw(tlv);
 			break;
@@ -197,7 +200,7 @@ int nfc_llcp_parse_connection_tlv(struct nfc_llcp_sock *sock,
 		tlv += length + 2;
 	}
 
-	pr_debug("sock %p rw %d\n", sock, sock->rw);
+	pr_debug("sock %p rw %d miu %d\n", sock, sock->rw, sock->miu);
 
 	return 0;
 }
@@ -505,7 +508,7 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 
 	while (remaining_len > 0) {
 
-		frag_len = min_t(size_t, local->remote_miu, remaining_len);
+		frag_len = min_t(size_t, sock->miu, remaining_len);
 
 		pr_debug("Fragment %zd bytes remaining %zd",
 			 frag_len, remaining_len);
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index d3efc5b..5f7aa3f 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -655,6 +655,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	new_sock = nfc_llcp_sock(new_sk);
 	new_sock->dev = local->dev;
 	new_sock->local = nfc_llcp_local_get(local);
+	new_sock->miu = local->remote_miu;
 	new_sock->nfc_protocol = sock->nfc_protocol;
 	new_sock->ssap = sock->ssap;
 	new_sock->dsap = ssap;
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index add03e7..7286c86 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -102,6 +102,7 @@ struct nfc_llcp_sock {
 	char *service_name;
 	size_t service_name_len;
 	u8 rw;
+	u16 miu;
 
 	/* Link variables */
 	u8 send_n;
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index aab077e..30e3cc7 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -477,6 +477,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 
 	llcp_sock->dev = dev;
 	llcp_sock->local = nfc_llcp_local_get(local);
+	llcp_sock->miu = llcp_sock->local->remote_miu;
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		ret = -ENOMEM;
@@ -679,6 +680,7 @@ struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
 	llcp_sock->ssap = 0;
 	llcp_sock->dsap = LLCP_SAP_SDP;
 	llcp_sock->rw = LLCP_DEFAULT_RW;
+	llcp_sock->miu = LLCP_DEFAULT_MIU;
 	llcp_sock->send_n = llcp_sock->send_ack_n = 0;
 	llcp_sock->recv_n = llcp_sock->recv_ack_n = 0;
 	llcp_sock->remote_ready = 1;
-- 
1.7.9.1

