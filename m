Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab2DJRfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:47 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 11/18] NFC: Dump LLCP frames
Date: Tue, 10 Apr 2012 19:43:13 +0200
Message-Id: <1334079800-10671-12-git-send-email-sameo@linux.intel.com> (sfid-20120410_195903_375942_AEC82249)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At KERN_DEBUG level.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 17a578f..d5e87c3 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -388,6 +388,9 @@ static void nfc_llcp_tx_work(struct work_struct *work)
 	skb = skb_dequeue(&local->tx_queue);
 	if (skb != NULL) {
 		pr_debug("Sending pending skb\n");
+		print_hex_dump(KERN_DEBUG, "LLCP Tx: ", DUMP_PREFIX_OFFSET,
+			       16, 1, skb->data, skb->len, true);
+
 		nfc_data_exchange(local->dev, local->target_idx,
 				  skb, nfc_llcp_recv, local);
 	} else {
@@ -814,6 +817,10 @@ static void nfc_llcp_rx_work(struct work_struct *work)
 
 	pr_debug("ptype 0x%x dsap 0x%x ssap 0x%x\n", ptype, dsap, ssap);
 
+	if (ptype != LLCP_PDU_SYMM)
+		print_hex_dump(KERN_DEBUG, "LLCP Rx: ", DUMP_PREFIX_OFFSET,
+			       16, 1, skb->data, skb->len, true);
+
 	switch (ptype) {
 	case LLCP_PDU_SYMM:
 		pr_debug("SYMM\n");
-- 
1.7.9.1

