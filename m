Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41743 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaKFKUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 05:20:46 -0500
Received: by mail-pd0-f179.google.com with SMTP id g10so876920pdj.24
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 02:20:45 -0800 (PST)
Message-ID: <1415269241.17088.1.camel@phoenix> (sfid-20141106_112051_269850_09A9AA92)
Subject: [PATCH] NFC: llcp: Use list_for_each_entry in llcp_accept_poll
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 06 Nov 2014 18:20:41 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

list_for_each_entry_safe() is necessary if list objects are deleted from
the list while traversing it. Not the case here, so we can use the base
list_for_each_entry variant.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 net/nfc/llcp_sock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 83bc785..e181e29 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -524,13 +524,13 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
 
 static inline unsigned int llcp_accept_poll(struct sock *parent)
 {
-	struct nfc_llcp_sock *llcp_sock, *n, *parent_sock;
+	struct nfc_llcp_sock *llcp_sock, *parent_sock;
 	struct sock *sk;
 
 	parent_sock = nfc_llcp_sock(parent);
 
-	list_for_each_entry_safe(llcp_sock, n, &parent_sock->accept_queue,
-				 accept_queue) {
+	list_for_each_entry(llcp_sock, &parent_sock->accept_queue,
+			    accept_queue) {
 		sk = &llcp_sock->sk;
 
 		if (sk->sk_state == LLCP_CONNECTED)
-- 
1.9.1



