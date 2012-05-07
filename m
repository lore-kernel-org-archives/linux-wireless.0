Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab2EGKcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:47 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 15/20] NFC: Quiet nci/ntf.c sparse noise about plain integer as NULL pointer
Date: Mon,  7 May 2012 12:31:26 +0200
Message-Id: <1336386691-24840-16-git-send-email-sameo@linux.intel.com> (sfid-20120507_123250_527610_36B0B4BC)
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
 net/nfc/nci/ntf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 99e1632..cb26461 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -497,7 +497,7 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 	/* drop partial rx data packet */
 	if (ndev->rx_data_reassembly) {
 		kfree_skb(ndev->rx_data_reassembly);
-		ndev->rx_data_reassembly = 0;
+		ndev->rx_data_reassembly = NULL;
 	}
 
 	/* complete the data exchange transaction, if exists */
-- 
1.7.9.1

