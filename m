Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61541 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab2EGKck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:40 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 13/20] NFC: Quiet nci/data.c sparse noise about plain integer as NULL pointer
Date: Mon,  7 May 2012 12:31:24 +0200
Message-Id: <1336386691-24840-14-git-send-email-sameo@linux.intel.com> (sfid-20120507_123242_450001_3EF39410)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: H Hartley Sweeten <hartleys@visionengravers.com>

Pointers should be cleared with NULL, not 0.

Quiets a couple sparse warnings of the type:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/nci/data.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index a0bc326..76c48c5 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -49,7 +49,7 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 
 	if (cb) {
 		ndev->data_exchange_cb = NULL;
-		ndev->data_exchange_cb_context = 0;
+		ndev->data_exchange_cb_context = NULL;
 
 		/* forward skb to nfc core */
 		cb(cb_context, skb, err);
@@ -200,10 +200,10 @@ static void nci_add_rx_data_frag(struct nci_dev *ndev,
 			pr_err("error adding room for accumulated rx data\n");
 
 			kfree_skb(skb);
-			skb = 0;
+			skb = NULL;
 
 			kfree_skb(ndev->rx_data_reassembly);
-			ndev->rx_data_reassembly = 0;
+			ndev->rx_data_reassembly = NULL;
 
 			err = -ENOMEM;
 			goto exit;
@@ -216,7 +216,7 @@ static void nci_add_rx_data_frag(struct nci_dev *ndev,
 
 		/* third, free old reassembly */
 		kfree_skb(ndev->rx_data_reassembly);
-		ndev->rx_data_reassembly = 0;
+		ndev->rx_data_reassembly = NULL;
 	}
 
 	if (pbf == NCI_PBF_CONT) {
-- 
1.7.9.1

