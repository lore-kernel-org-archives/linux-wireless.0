Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760709Ab2EJRg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:36:27 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/2] NFC: Queue I frame fragments to the LLCP sockets queue tail
Date: Thu, 10 May 2012 19:45:52 +0200
Message-Id: <1336671952-22678-3-git-send-email-sameo@linux.intel.com> (sfid-20120510_194237_756553_75B98DD4)
In-Reply-To: <1336671952-22678-1-git-send-email-sameo@linux.intel.com>
References: <1336671952-22678-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After testing our stack with large SNEP messages, we realized the fragments
were arriving in reversed order.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index ef10ffc..1e02a38 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -488,7 +488,7 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 
 		memcpy(skb_put(pdu, frag_len), msg_ptr, frag_len);
 
-		skb_queue_head(&sock->tx_queue, pdu);
+		skb_queue_tail(&sock->tx_queue, pdu);
 
 		lock_sock(sk);
 
-- 
1.7.9.1

