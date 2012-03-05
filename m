Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54701 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab2CDX6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:20 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 19/22] NFC: Fix LLCP sockets releasing path
Date: Mon,  5 Mar 2012 01:03:51 +0100
Message-Id: <1330905834-6994-20-git-send-email-sameo@linux.intel.com> (sfid-20120305_005825_124432_DB563AAF)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The socket local pointer needs to be set to NULL when the adapter is
removed or the MAC goes down.
If the socket release code is called after such an event, the socket
reference count still needs to be decreased in order for the socket to
eventually be freed.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   15 +++++++++++----
 net/nfc/llcp/sock.c |   23 +++++++++++++++--------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 3ce646e..8af896d 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -47,7 +47,7 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 
 		/* Release all child sockets */
 		list_for_each_entry_safe(s, n, &parent->list, list) {
-			list_del(&s->list);
+			list_del_init(&s->list);
 			sk = &s->sk;
 
 			lock_sock(sk);
@@ -56,9 +56,12 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 				nfc_put_device(s->dev);
 
 			sk->sk_state = LLCP_CLOSED;
-			sock_set_flag(sk, SOCK_DEAD);
 
 			release_sock(sk);
+
+			sock_orphan(sk);
+
+			s->local = NULL;
 		}
 
 		parent_sk = &parent->sk;
@@ -77,11 +80,12 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 				nfc_llcp_accept_unlink(accept_sk);
 
 				accept_sk->sk_state = LLCP_CLOSED;
-				sock_set_flag(accept_sk, SOCK_DEAD);
 
 				release_sock(accept_sk);
 
 				sock_orphan(accept_sk);
+
+				lsk->local = NULL;
 			}
 		}
 
@@ -89,9 +93,12 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 			nfc_put_device(parent->dev);
 
 		parent_sk->sk_state = LLCP_CLOSED;
-		sock_set_flag(parent_sk, SOCK_DEAD);
 
 		release_sock(parent_sk);
+
+		sock_orphan(parent_sk);
+
+		parent->local = NULL;
 	}
 
 	mutex_unlock(&local->socket_lock);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index d386177..35825e2 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -315,6 +315,7 @@ static int llcp_sock_release(struct socket *sock)
 	struct sock *sk = sock->sk;
 	struct nfc_llcp_local *local;
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+	int err = 0;
 
 	if (!sk)
 		return 0;
@@ -322,15 +323,17 @@ static int llcp_sock_release(struct socket *sock)
 	pr_debug("%p\n", sk);
 
 	local = llcp_sock->local;
-	if (local == NULL)
-		return -ENODEV;
+	if (local == NULL) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	mutex_lock(&local->socket_lock);
 
 	if (llcp_sock == local->sockets[llcp_sock->ssap])
 		local->sockets[llcp_sock->ssap] = NULL;
 	else
-		list_del(&llcp_sock->list);
+		list_del_init(&llcp_sock->list);
 
 	mutex_unlock(&local->socket_lock);
 
@@ -354,9 +357,7 @@ static int llcp_sock_release(struct socket *sock)
 
 			release_sock(accept_sk);
 
-			sock_set_flag(sk, SOCK_DEAD);
 			sock_orphan(accept_sk);
-			sock_put(accept_sk);
 		}
 	}
 
@@ -367,14 +368,13 @@ static int llcp_sock_release(struct socket *sock)
 	    sk->sk_state == LLCP_LISTEN)
 		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
-	sock_set_flag(sk, SOCK_DEAD);
-
 	release_sock(sk);
 
+out:
 	sock_orphan(sk);
 	sock_put(sk);
 
-	return 0;
+	return err;
 }
 
 static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
@@ -645,6 +645,8 @@ struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp)
 
 void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 {
+	struct nfc_llcp_local *local = sock->local;
+
 	kfree(sock->service_name);
 
 	skb_queue_purge(&sock->tx_queue);
@@ -653,6 +655,11 @@ void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 
 	list_del_init(&sock->accept_queue);
 
+	if (local != NULL && sock == local->sockets[sock->ssap])
+		local->sockets[sock->ssap] = NULL;
+	else
+		list_del_init(&sock->list);
+
 	sock->parent = NULL;
 }
 
-- 
1.7.7.3

