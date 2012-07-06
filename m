Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:04 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 23/33] NFC: Forbid LLCP service name reusing
Date: Fri,  6 Jul 2012 22:09:43 +0200
Message-Id: <1341605393-32056-24-git-send-email-sameo@linux.intel.com> (sfid-20120706_220534_173496_08B6099D)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a typo and return the correct error when trying to
bind 2 sockets to the same service name.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/sock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index 211cb23..e5d8014 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -121,8 +121,10 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 					  GFP_KERNEL);
 
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
-	if (llcp_sock->ssap == LLCP_MAX_SAP)
+	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		ret = -EADDRINUSE;
 		goto put_dev;
+	}
 
 	llcp_sock->reserved_ssap = llcp_sock->ssap;
 
-- 
1.7.10

