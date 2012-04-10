Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab2DJRfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:05 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 01/18 3.4] NFC: Fix the LLCP Tx fragmentation loop
Date: Tue, 10 Apr 2012 19:43:03 +0200
Message-Id: <1334079800-10671-2-git-send-email-sameo@linux.intel.com> (sfid-20120410_193510_177568_9B6FADE5)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 7b76eb7..ef10ffc 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -474,7 +474,7 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 
 	while (remaining_len > 0) {
 
-		frag_len = min_t(u16, local->remote_miu, remaining_len);
+		frag_len = min_t(size_t, local->remote_miu, remaining_len);
 
 		pr_debug("Fragment %zd bytes remaining %zd",
 			 frag_len, remaining_len);
@@ -497,7 +497,7 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 		release_sock(sk);
 
 		remaining_len -= frag_len;
-		msg_ptr += len;
+		msg_ptr += frag_len;
 	}
 
 	kfree(msg_data);
-- 
1.7.9.1

