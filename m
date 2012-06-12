Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34230 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2FLUHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 16:07:36 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, linville@tuxdriver.com
Cc: davej@redhat.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] NFC: only put local on destruction if it was created before
Date: Tue, 12 Jun 2012 22:08:19 +0200
Message-Id: <1339531699-7377-1-git-send-email-levinsasha928@gmail.com> (sfid-20120612_220754_023687_78BD0A55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not having 'local' is a valid case when a socket was created but never
bound or connected to anything, so avoid putting 'local' if it was
never created.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 net/nfc/llcp/sock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 2c0b317..54daa10 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -710,7 +710,8 @@ void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
 
 	sock->parent = NULL;
 
-	nfc_llcp_local_put(sock->local);
+	if (sock->local)
+		nfc_llcp_local_put(sock->local);
 }
 
 static int llcp_sock_create(struct net *net, struct socket *sock,
-- 
1.7.8.6

