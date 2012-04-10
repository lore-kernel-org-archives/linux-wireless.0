Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61220 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab2DJRgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:03 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 14/18] NFC: Call llcp_add_header properly when sending LLCP DM or DISC
Date: Tue, 10 Apr 2012 19:43:16 +0200
Message-Id: <1334079800-10671-15-git-send-email-sameo@linux.intel.com> (sfid-20120410_193607_691540_3D1111C8)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dsap and ssap were swapped when sending DN or DISC.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 34ee684..11a3b7d 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -248,7 +248,7 @@ int nfc_llcp_disconnect(struct nfc_llcp_sock *sock)
 
 	skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
 
-	skb = llcp_add_header(skb, sock->ssap, sock->dsap, LLCP_PDU_DISC);
+	skb = llcp_add_header(skb, sock->dsap, sock->ssap, LLCP_PDU_DISC);
 
 	skb_queue_tail(&local->tx_queue, skb);
 
@@ -416,7 +416,7 @@ int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason)
 
 	skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
 
-	skb = llcp_add_header(skb, ssap, dsap, LLCP_PDU_DM);
+	skb = llcp_add_header(skb, dsap, ssap, LLCP_PDU_DM);
 
 	memcpy(skb_put(skb, 1), &reason, 1);
 
-- 
1.7.9.1

