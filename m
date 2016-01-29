Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34483 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcA2Thw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 14:37:52 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: netdev@vger.kernel.org
Cc: dvyukov@google.com, linux-wireless@vger.kernel.org,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 net] nfc: close a race condition in llcp_sock_getname()
Date: Fri, 29 Jan 2016 11:37:40 -0800
Message-Id: <1454096260-20396-1-git-send-email-xiyou.wangcong@gmail.com> (sfid-20160129_203759_238088_A1283A24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

llcp_sock_getname() checks llcp_sock->dev to make sure
llcp_sock is already connected or bound, however, we could
be in the middle of llcp_sock_bind() where llcp_sock->dev
is bound and llcp_sock->service_name_len is set,
but llcp_sock->service_name is not, in this case we would
lead to copy some bytes from a NULL pointer.

Just lock the sock since this is not a hot path anyway.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/nfc/llcp_sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index ecf0a01..b9edf5f 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -509,6 +509,11 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
 	memset(llcp_addr, 0, sizeof(*llcp_addr));
 	*len = sizeof(struct sockaddr_nfc_llcp);
 
+	lock_sock(sk);
+	if (!llcp_sock->dev) {
+		release_sock(sk);
+		return -EBADFD;
+	}
 	llcp_addr->sa_family = AF_NFC;
 	llcp_addr->dev_idx = llcp_sock->dev->idx;
 	llcp_addr->target_idx = llcp_sock->target_idx;
@@ -518,6 +523,7 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
 	llcp_addr->service_name_len = llcp_sock->service_name_len;
 	memcpy(llcp_addr->service_name, llcp_sock->service_name,
 	       llcp_addr->service_name_len);
+	release_sock(sk);
 
 	return 0;
 }
-- 
1.8.3.1

