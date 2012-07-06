Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab2GFUAk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:40 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 33/33] NFC: Check for llcp_sock and its device from llcp_sock_getname
Date: Fri,  6 Jul 2012 22:09:53 +0200
Message-Id: <1341605393-32056-34-git-send-email-sameo@linux.intel.com> (sfid-20120706_220534_723798_469558B5)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They both can potentially be NULL.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/sock.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 6152d05..ddeb9aa 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -294,6 +294,9 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
 	DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, llcp_addr, uaddr);
 
+	if (llcp_sock == NULL || llcp_sock->dev == NULL)
+		return -EBADFD;
+
 	pr_debug("%p %d %d %d\n", sk, llcp_sock->target_idx,
 		 llcp_sock->dsap, llcp_sock->ssap);
 
-- 
1.7.10

