Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2GFT7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:45 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 18/33] NFC: Update LLCP socket target index when getting a connection
Date: Fri,  6 Jul 2012 22:09:38 +0200
Message-Id: <1341605393-32056-19-git-send-email-sameo@linux.intel.com> (sfid-20120706_220532_934337_D3CE3534)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Getting a valid CONNECT means we have a valid target index.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 5d503ee..eee4b92 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -677,6 +677,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	new_sock->nfc_protocol = sock->nfc_protocol;
 	new_sock->ssap = sock->ssap;
 	new_sock->dsap = ssap;
+	new_sock->target_idx = local->target_idx;
 	new_sock->parent = parent;
 
 	nfc_llcp_parse_connection_tlv(new_sock, &skb->data[LLCP_HEADER_SIZE],
-- 
1.7.10

