Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21515 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab2FFKIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:06 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 24/29] NFC: Send a receiver ready frame only to reply to an I frame
Date: Wed,  6 Jun 2012 12:16:41 +0200
Message-Id: <1338977806-30279-25-git-send-email-sameo@linux.intel.com> (sfid-20120606_120814_845050_EE1C7905)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending an RR as a reply to another RR is fine but not quite logical.
We should send RRs only as a reply to I frames.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 0fc60da..3fe68e1 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -810,7 +810,7 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 	else if (ptype == LLCP_PDU_RNR)
 		llcp_sock->remote_ready = false;
 
-	if (nfc_llcp_queue_i_frames(llcp_sock) == 0)
+	if (nfc_llcp_queue_i_frames(llcp_sock) == 0 && ptype == LLCP_PDU_I)
 		nfc_llcp_send_rr(llcp_sock);
 
 	release_sock(sk);
-- 
1.7.9.1

