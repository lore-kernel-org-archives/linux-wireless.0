Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab2FFKGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:36 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 01/29] NFC: Take a reference on the LLCP local pointer when creating a socket
Date: Wed,  6 Jun 2012 12:16:18 +0200
Message-Id: <1338977806-30279-2-git-send-email-sameo@linux.intel.com> (sfid-20120606_120639_204045_97C621D0)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LLCP sockets point to their local LLCP service, so they need to take a
reference on it.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   46 +++++++++++++++++++++++++++++++---------------
 net/nfc/llcp/llcp.h |    4 ++++
 net/nfc/llcp/sock.c |   14 +++++---------
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 42994fa..0f6dd3a 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -59,8 +59,6 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 			release_sock(sk);
 
 			sock_orphan(sk);
-
-			s->local = NULL;
 		}
 
 		parent_sk = &parent->sk;
@@ -83,8 +81,6 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 				release_sock(accept_sk);
 
 				sock_orphan(accept_sk);
-
-				lsk->local = NULL;
 			}
 		}
 
@@ -96,13 +92,39 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 		release_sock(parent_sk);
 
 		sock_orphan(parent_sk);
-
-		parent->local = NULL;
 	}
 
 	mutex_unlock(&local->socket_lock);
 }
 
+struct nfc_llcp_local *nfc_llcp_local_get(struct nfc_llcp_local *local)
+{
+	kref_get(&local->ref);
+
+	return local;
+}
+
+static void local_release(struct kref *ref)
+{
+	struct nfc_llcp_local *local;
+
+	local = container_of(ref, struct nfc_llcp_local, ref);
+
+	list_del(&local->list);
+	nfc_llcp_socket_release(local);
+	del_timer_sync(&local->link_timer);
+	skb_queue_purge(&local->tx_queue);
+	destroy_workqueue(local->tx_wq);
+	destroy_workqueue(local->rx_wq);
+	kfree_skb(local->rx_pending);
+	kfree(local);
+}
+
+int nfc_llcp_local_put(struct nfc_llcp_local *local)
+{
+	return kref_put(&local->ref, local_release);
+}
+
 static void nfc_llcp_clear_sdp(struct nfc_llcp_local *local)
 {
 	mutex_lock(&local->sdp_lock);
@@ -612,7 +634,7 @@ enqueue:
 
 	new_sock = nfc_llcp_sock(new_sk);
 	new_sock->dev = local->dev;
-	new_sock->local = local;
+	new_sock->local = nfc_llcp_local_get(local);
 	new_sock->nfc_protocol = sock->nfc_protocol;
 	new_sock->ssap = bound_sap;
 	new_sock->dsap = ssap;
@@ -943,6 +965,7 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 
 	local->dev = ndev;
 	INIT_LIST_HEAD(&local->list);
+	kref_init(&local->ref);
 	mutex_init(&local->sdp_lock);
 	mutex_init(&local->socket_lock);
 	init_timer(&local->link_timer);
@@ -1015,14 +1038,7 @@ void nfc_llcp_unregister_device(struct nfc_dev *dev)
 		return;
 	}
 
-	list_del(&local->list);
-	nfc_llcp_socket_release(local);
-	del_timer_sync(&local->link_timer);
-	skb_queue_purge(&local->tx_queue);
-	destroy_workqueue(local->tx_wq);
-	destroy_workqueue(local->rx_wq);
-	kfree_skb(local->rx_pending);
-	kfree(local);
+	nfc_llcp_local_put(local);
 }
 
 int __init nfc_llcp_init(void)
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 50680ce..bc61955 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -44,6 +44,8 @@ struct nfc_llcp_local {
 	struct list_head list;
 	struct nfc_dev *dev;
 
+	struct kref ref;
+
 	struct mutex sdp_lock;
 	struct mutex socket_lock;
 
@@ -165,6 +167,8 @@ struct nfc_llcp_sock {
 
 
 struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev);
+struct nfc_llcp_local *nfc_llcp_local_get(struct nfc_llcp_local *local);
+int nfc_llcp_local_put(struct nfc_llcp_local *local);
 u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 			 struct nfc_llcp_sock *sock);
 u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 3f339b1..9ac397b 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -111,7 +111,7 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	}
 
 	llcp_sock->dev = dev;
-	llcp_sock->local = local;
+	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->nfc_protocol = llcp_addr.nfc_protocol;
 	llcp_sock->service_name_len = min_t(unsigned int,
 					    llcp_addr.service_name_len,
@@ -487,7 +487,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	}
 
 	llcp_sock->dev = dev;
-	llcp_sock->local = local;
+	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		ret = -ENOMEM;
@@ -701,8 +701,6 @@ struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
 
 void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 {
-	struct nfc_llcp_local *local = sock->local;
-
 	kfree(sock->service_name);
 
 	skb_queue_purge(&sock->tx_queue);
@@ -710,13 +708,11 @@ void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 	skb_queue_purge(&sock->tx_backlog_queue);
 
 	list_del_init(&sock->accept_queue);
-
-	if (local != NULL && sock == local->sockets[sock->ssap])
-		local->sockets[sock->ssap] = NULL;
-	else
-		list_del_init(&sock->list);
+	list_del_init(&sock->list);
 
 	sock->parent = NULL;
+
+	nfc_llcp_local_put(sock->local);
 }
 
 static int llcp_sock_create(struct net *net, struct socket *sock,
-- 
1.7.9.1

