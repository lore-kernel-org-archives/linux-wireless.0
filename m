Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2GFT65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:58:57 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 05/33] NFC: Implement HCP reaggregation allocation error case
Date: Fri,  6 Jul 2012 22:09:25 +0200
Message-Id: <1341605393-32056-6-git-send-email-sameo@linux.intel.com> (sfid-20120706_215900_697946_1E8EA6C7)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

We can now report an ENOMEM error up to the HCI layer.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/core.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 1a009d5..7d4fdbc 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -717,12 +717,18 @@ void *nfc_hci_get_clientdata(struct nfc_hci_dev *hdev)
 }
 EXPORT_SYMBOL(nfc_hci_get_clientdata);
 
-void nfc_hci_driver_failure(struct nfc_hci_dev *hdev, int err)
+static void nfc_hci_failure(struct nfc_hci_dev *hdev, int err)
 {
-	/* TODO: lower layer has permanent failure.
+	/*
+	 * TODO: lower layer has permanent failure.
 	 * complete potential HCI command or send an empty tag discovered event
 	 */
 }
+
+void nfc_hci_driver_failure(struct nfc_hci_dev *hdev, int err)
+{
+	nfc_hci_failure(hdev, err);
+}
 EXPORT_SYMBOL(nfc_hci_driver_failure);
 
 void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb)
@@ -755,9 +761,8 @@ void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 		hcp_skb = nfc_alloc_recv_skb(NFC_HCI_HCP_PACKET_HEADER_LEN +
 					     msg_len, GFP_KERNEL);
 		if (hcp_skb == NULL) {
-			/* TODO ELa: cannot deliver HCP message. How to
-			 * propagate error up?
-			 */
+			nfc_hci_failure(hdev, -ENOMEM);
+			return;
 		}
 
 		*skb_put(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN) = pipe;
-- 
1.7.10

