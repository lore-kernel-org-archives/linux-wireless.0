Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34704 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2EGKcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:21 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 08/20] NFC: LLCP connect must wait for a CC frame
Date: Mon,  7 May 2012 12:31:19 +0200
Message-Id: <1336386691-24840-9-git-send-email-sameo@linux.intel.com> (sfid-20120507_123228_098383_F308323B)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Blocking sockets should sleep on a CC (Connection Complete) reception
from the connect() call.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    7 +++++++
 net/nfc/llcp/sock.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 92988aa..42994fa 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -448,6 +448,8 @@ static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
 {
 	struct nfc_llcp_sock *sock, *llcp_sock, *n;
 
+	pr_debug("ssap dsap %d %d\n", ssap, dsap);
+
 	if (ssap == 0 && dsap == 0)
 		return NULL;
 
@@ -783,6 +785,7 @@ static void nfc_llcp_recv_disc(struct nfc_llcp_local *local,
 static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 {
 	struct nfc_llcp_sock *llcp_sock;
+	struct sock *sk;
 	u8 dsap, ssap;
 
 	dsap = nfc_llcp_dsap(skb);
@@ -801,10 +804,14 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 	}
 
 	llcp_sock->dsap = ssap;
+	sk = &llcp_sock->sk;
 
 	nfc_llcp_parse_tlv(local, &skb->data[LLCP_HEADER_SIZE],
 			   skb->len - LLCP_HEADER_SIZE);
 
+	sk->sk_state = LLCP_CONNECTED;
+	sk->sk_state_change(sk);
+
 	nfc_llcp_sock_put(llcp_sock);
 }
 
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index c13e02e..99196d3 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -27,6 +27,42 @@
 #include "../nfc.h"
 #include "llcp.h"
 
+static int sock_wait_state(struct sock *sk, int state, unsigned long timeo)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	int err = 0;
+
+	pr_debug("sk %p", sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (sk->sk_state != state) {
+		if (!timeo) {
+			err = -EINPROGRESS;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeo);
+			break;
+		}
+
+		release_sock(sk);
+		timeo = schedule_timeout(timeo);
+		lock_sock(sk);
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		err = sock_error(sk);
+		if (err)
+			break;
+	}
+
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return err;
+}
+
 static struct proto llcp_sock_proto = {
 	.name     = "NFC_LLCP",
 	.owner    = THIS_MODULE,
@@ -462,9 +498,13 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	if (ret)
 		goto put_dev;
 
-	sk->sk_state = LLCP_CONNECTED;
+	ret = sock_wait_state(sk, LLCP_CONNECTED,
+			      sock_sndtimeo(sk, flags & O_NONBLOCK));
+	if (ret)
+		goto put_dev;
 
 	release_sock(sk);
+
 	return 0;
 
 put_dev:
-- 
1.7.9.1

