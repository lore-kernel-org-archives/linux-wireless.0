Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16256 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2GFT6y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:58:54 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 04/33] NFC: Remove an impossible HCI error case
Date: Fri,  6 Jul 2012 22:09:24 +0200
Message-Id: <1341605393-32056-5-git-send-email-sameo@linux.intel.com> (sfid-20120706_215857_146658_A4C90783)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

nfc_hci_recv_frame can not be called with a NULL skb.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/core.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 1dc6485..1a009d5 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -735,16 +735,6 @@ void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 	struct sk_buff *frag_skb;
 	int msg_len;
 
-	if (skb == NULL) {
-		/* TODO ELa: lower layer had permanent failure, need to
-		 * propagate that up
-		 */
-
-		skb_queue_purge(&hdev->rx_hcp_frags);
-
-		return;
-	}
-
 	packet = (struct hcp_packet *)skb->data;
 	if ((packet->header & ~NFC_HCI_FRAGMENT) == 0) {
 		skb_queue_tail(&hdev->rx_hcp_frags, skb);
-- 
1.7.10

