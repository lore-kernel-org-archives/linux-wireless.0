Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4804 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab2DJRfv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:51 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 12/18] NFC: No need to apply twice the modulo op to LLCP's recv_n
Date: Tue, 10 Apr 2012 19:43:14 +0200
Message-Id: <1334079800-10671-13-git-send-email-sameo@linux.intel.com> (sfid-20120410_193554_675792_05605CEF)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

recv_n is set properly when receiving an HDLC frame.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    2 +-
 net/nfc/llcp/llcp.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index ef10ffc..4aa52b8 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -522,7 +522,7 @@ int nfc_llcp_send_rr(struct nfc_llcp_sock *sock)
 
 	skb_put(skb, LLCP_SEQUENCE_SIZE);
 
-	skb->data[2] = sock->recv_n % 16;
+	skb->data[2] = sock->recv_n;
 
 	skb_queue_head(&local->tx_queue, skb);
 
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index d5e87c3..2cf01e6 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -428,7 +428,7 @@ static u8 nfc_llcp_nr(struct sk_buff *pdu)
 
 static void nfc_llcp_set_nrns(struct nfc_llcp_sock *sock, struct sk_buff *pdu)
 {
-	pdu->data[2] = (sock->send_n << 4) | (sock->recv_n % 16);
+	pdu->data[2] = (sock->send_n << 4) | (sock->recv_n);
 	sock->send_n = (sock->send_n + 1) % 16;
 	sock->recv_ack_n = (sock->recv_n - 1) % 16;
 }
-- 
1.7.9.1

