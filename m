Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26259 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2EGKcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:25 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 09/20] NFC: Update the LLCP poll mask
Date: Mon,  7 May 2012 12:31:20 +0200
Message-Id: <1336386691-24840-10-git-send-email-sameo@linux.intel.com> (sfid-20120507_123232_648062_A289B117)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the poll mask depending on the socket state. POLLOUT was missing
for example.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/sock.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 99196d3..3f339b1 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -340,11 +340,24 @@ static unsigned int llcp_sock_poll(struct file *file, struct socket *sock,
 		mask |= POLLERR;
 
 	if (!skb_queue_empty(&sk->sk_receive_queue))
-		mask |= POLLIN;
+		mask |= POLLIN | POLLRDNORM;
 
 	if (sk->sk_state == LLCP_CLOSED)
 		mask |= POLLHUP;
 
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		mask |= POLLRDHUP | POLLIN | POLLRDNORM;
+
+	if (sk->sk_shutdown == SHUTDOWN_MASK)
+		mask |= POLLHUP;
+
+	if (sock_writeable(sk))
+		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
+	else
+		set_bit(SOCK_ASYNC_NOSPACE, &sk->sk_socket->flags);
+
+	pr_debug("mask 0x%x\n", mask);
+
 	return mask;
 }
 
-- 
1.7.9.1

