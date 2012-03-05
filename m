Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab2CDX6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:10 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 16/22] NFC: Unlink LLCP child sockets from llcp_sock_release
Date: Mon,  5 Mar 2012 01:03:48 +0100
Message-Id: <1330905834-6994-17-git-send-email-sameo@linux.intel.com> (sfid-20120305_005815_571275_B023C5A9)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parent socket (the bound one) could be freed before its children, so
we should unlink the children without trying to reach it through the parent.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/sock.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index b8bef36..d386177 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -327,20 +327,10 @@ static int llcp_sock_release(struct socket *sock)
 
 	mutex_lock(&local->socket_lock);
 
-	if (llcp_sock == local->sockets[llcp_sock->ssap]) {
+	if (llcp_sock == local->sockets[llcp_sock->ssap])
 		local->sockets[llcp_sock->ssap] = NULL;
-	} else {
-		struct nfc_llcp_sock *parent, *s, *n;
-
-		parent = local->sockets[llcp_sock->ssap];
-
-		list_for_each_entry_safe(s, n, &parent->list, list)
-			if (llcp_sock == s) {
-				list_del(&s->list);
-				break;
-			}
-
-	}
+	else
+		list_del(&llcp_sock->list);
 
 	mutex_unlock(&local->socket_lock);
 
-- 
1.7.7.3

