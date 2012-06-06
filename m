Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51211 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2FFKHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:31 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 15/29] NFC: Don't hold a NULL connecting LLCP socket lock
Date: Wed,  6 Jun 2012 12:16:32 +0200
Message-Id: <1338977806-30279-16-git-send-email-sameo@linux.intel.com> (sfid-20120606_120737_560856_601BB841)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 5705e6d..b694313 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -477,8 +477,10 @@ static struct nfc_llcp_sock *nfc_llcp_connecting_sock_get(struct nfc_llcp_local
 	sk_for_each(sk, node, &local->connecting_sockets.head) {
 		llcp_sock = nfc_llcp_sock(sk);
 
-		if (llcp_sock->ssap == ssap)
+		if (llcp_sock->ssap == ssap) {
+			sock_hold(&llcp_sock->sk);
 			goto out;
+		}
 	}
 
 	llcp_sock = NULL;
@@ -486,8 +488,6 @@ static struct nfc_llcp_sock *nfc_llcp_connecting_sock_get(struct nfc_llcp_local
 out:
 	read_unlock(&local->connecting_sockets.lock);
 
-	sock_hold(&llcp_sock->sk);
-
 	return llcp_sock;
 }
 
-- 
1.7.9.1

