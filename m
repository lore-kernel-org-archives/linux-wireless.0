Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118Ab2GFT7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:49 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 19/33] NFC: Fix LLCP getname socket op
Date: Fri,  6 Jul 2012 22:09:39 +0200
Message-Id: <1341605393-32056-20-git-send-email-sameo@linux.intel.com> (sfid-20120706_220534_976101_08F7E938)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the right target index and use a better socket declaration routine.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/sock.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 05ca5a6..b08e99d 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -283,22 +283,25 @@ error:
 	return ret;
 }
 
-static int llcp_sock_getname(struct socket *sock, struct sockaddr *addr,
+static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
 			     int *len, int peer)
 {
-	struct sockaddr_nfc_llcp *llcp_addr = (struct sockaddr_nfc_llcp *)addr;
 	struct sock *sk = sock->sk;
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+	DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, llcp_addr, uaddr);
 
-	pr_debug("%p\n", sk);
+	pr_debug("%p %d %d %d\n", sk, llcp_sock->target_idx,
+		 llcp_sock->dsap, llcp_sock->ssap);
 
 	if (llcp_sock == NULL || llcp_sock->dev == NULL)
 		return -EBADFD;
 
-	addr->sa_family = AF_NFC;
+	uaddr->sa_family = AF_NFC;
+
 	*len = sizeof(struct sockaddr_nfc_llcp);
 
 	llcp_addr->dev_idx = llcp_sock->dev->idx;
+	llcp_addr->target_idx = llcp_sock->target_idx;
 	llcp_addr->dsap = llcp_sock->dsap;
 	llcp_addr->ssap = llcp_sock->ssap;
 	llcp_addr->service_name_len = llcp_sock->service_name_len;
-- 
1.7.10

