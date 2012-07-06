Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39784 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:00 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 22/33] NFC: Release LLCP SAP when the owner is released
Date: Fri,  6 Jul 2012 22:09:42 +0200
Message-Id: <1341605393-32056-23-git-send-email-sameo@linux.intel.com> (sfid-20120706_220535_235837_C6BA634B)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LLCP SAP should only be freed when the socket owning it is released.
As long as the socket is alive, the SAP should be reserved in order to
e.g. send the right wks array when bringing the MAC up.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   13 -------------
 net/nfc/llcp/llcp.h |    3 +++
 net/nfc/llcp/sock.c |    9 ++++++++-
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 0c8d25e..1031abd 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -131,17 +131,6 @@ int nfc_llcp_local_put(struct nfc_llcp_local *local)
 	return kref_put(&local->ref, local_release);
 }
 
-static void nfc_llcp_clear_sdp(struct nfc_llcp_local *local)
-{
-	mutex_lock(&local->sdp_lock);
-
-	local->local_wks = 0;
-	local->local_sdp = 0;
-	local->local_sap = 0;
-
-	mutex_unlock(&local->sdp_lock);
-}
-
 static void nfc_llcp_timeout_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
@@ -993,8 +982,6 @@ void nfc_llcp_mac_is_down(struct nfc_dev *dev)
 	if (local == NULL)
 		return;
 
-	nfc_llcp_clear_sdp(local);
-
 	/* Close and purge all existing sockets */
 	nfc_llcp_socket_release(local, true);
 }
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 7286c86..374cc47 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -113,6 +113,9 @@ struct nfc_llcp_sock {
 	/* Is the remote peer ready to receive */
 	u8 remote_ready;
 
+	/* Reserved source SAP */
+	u8 reserved_ssap;
+
 	struct sk_buff_head tx_queue;
 	struct sk_buff_head tx_pending_queue;
 	struct sk_buff_head tx_backlog_queue;
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index b08e99d..211cb23 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -124,6 +124,8 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	if (llcp_sock->ssap == LLCP_MAX_SAP)
 		goto put_dev;
 
+	llcp_sock->reserved_ssap = llcp_sock->ssap;
+
 	nfc_llcp_sock_link(&local->sockets, sk);
 
 	pr_debug("Socket bound to SAP %d\n", llcp_sock->ssap);
@@ -409,7 +411,8 @@ static int llcp_sock_release(struct socket *sock)
 		}
 	}
 
-	nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
+	if (llcp_sock->reserved_ssap < LLCP_SAP_MAX)
+		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
 	release_sock(sk);
 
@@ -489,6 +492,9 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 		ret = -ENOMEM;
 		goto put_dev;
 	}
+
+	llcp_sock->reserved_ssap = llcp_sock->ssap;
+
 	if (addr->service_name_len == 0)
 		llcp_sock->dsap = addr->dsap;
 	else
@@ -690,6 +696,7 @@ struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
 	llcp_sock->send_n = llcp_sock->send_ack_n = 0;
 	llcp_sock->recv_n = llcp_sock->recv_ack_n = 0;
 	llcp_sock->remote_ready = 1;
+	llcp_sock->reserved_ssap = LLCP_SAP_MAX;
 	skb_queue_head_init(&llcp_sock->tx_queue);
 	skb_queue_head_init(&llcp_sock->tx_pending_queue);
 	skb_queue_head_init(&llcp_sock->tx_backlog_queue);
-- 
1.7.10

