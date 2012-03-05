Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2CDX5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:47 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 09/22] NFC: Set the right LLCP N(R) value for I frames
Date: Mon,  5 Mar 2012 01:03:41 +0100
Message-Id: <1330905834-6994-10-git-send-email-sameo@linux.intel.com> (sfid-20120305_005751_391943_EDE512CB)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 577bcb9..2506810 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -419,7 +419,7 @@ static u8 nfc_llcp_nr(struct sk_buff *pdu)
 
 static void nfc_llcp_set_nrns(struct nfc_llcp_sock *sock, struct sk_buff *pdu)
 {
-	pdu->data[2] = (sock->send_n << 4) | ((sock->recv_n - 1) % 16);
+	pdu->data[2] = (sock->send_n << 4) | (sock->recv_n % 16);
 	sock->send_n = (sock->send_n + 1) % 16;
 	sock->recv_ack_n = (sock->recv_n - 1) % 16;
 }
-- 
1.7.7.3

