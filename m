Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60574 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2HOTZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 15:25:59 -0400
Received: by pbbrr13 with SMTP id rr13so260134pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2012 12:25:58 -0700 (PDT)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com
Subject: [PATCH] NFC: Remove repeated code for NULL check
Date: Thu, 16 Aug 2012 00:55:43 +0530
Message-Id: <1345058743-2514-1-git-send-email-s.syam@samsung.com> (sfid-20120815_212604_181703_1A876423)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove the repeated code for checking llcp_sock &
llcp_sock->dev against NULL.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 net/nfc/llcp/sock.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index ddeb9aa..6e188d4 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -300,9 +300,6 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
 	pr_debug("%p %d %d %d\n", sk, llcp_sock->target_idx,
 		 llcp_sock->dsap, llcp_sock->ssap);
 
-	if (llcp_sock == NULL || llcp_sock->dev == NULL)
-		return -EBADFD;
-
 	uaddr->sa_family = AF_NFC;
 
 	*len = sizeof(struct sockaddr_nfc_llcp);
-- 
1.7.9.5

