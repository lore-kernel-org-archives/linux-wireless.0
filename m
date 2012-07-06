Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2GFUA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:26 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 29/33] NFC: Dereference LLCP bind socket address after checking for it to be NULL
Date: Fri,  6 Jul 2012 22:09:49 +0200
Message-Id: <1341605393-32056-30-git-send-email-sameo@linux.intel.com> (sfid-20120706_220536_377637_46C349EB)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index e5d8014..6152d05 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -78,11 +78,11 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	struct sockaddr_nfc_llcp llcp_addr;
 	int len, ret = 0;
 
-	pr_debug("sk %p addr %p family %d\n", sk, addr, addr->sa_family);
-
 	if (!addr || addr->sa_family != AF_NFC)
 		return -EINVAL;
 
+	pr_debug("sk %p addr %p family %d\n", sk, addr, addr->sa_family);
+
 	memset(&llcp_addr, 0, sizeof(llcp_addr));
 	len = min_t(unsigned int, sizeof(llcp_addr), alen);
 	memcpy(&llcp_addr, addr, len);
-- 
1.7.10

