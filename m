Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUAS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:18 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 27/33] NFC: Remove warning from nfc_llcp_local_put
Date: Fri,  6 Jul 2012 22:09:47 +0200
Message-Id: <1341605393-32056-28-git-send-email-sameo@linux.intel.com> (sfid-20120706_220532_480299_C489BC8D)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The socket local pointer can be NULL when a socket is created but never
bound or connected.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index f3bc0a9..82f0f75 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -123,8 +123,6 @@ static void local_release(struct kref *ref)
 
 int nfc_llcp_local_put(struct nfc_llcp_local *local)
 {
-	WARN_ON(local == NULL);
-
 	if (local == NULL)
 		return 0;
 
-- 
1.7.10

