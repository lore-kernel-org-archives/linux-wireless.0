Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2GFT6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:58:47 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/33] NFC: Removed addressed shdlc TODOs
Date: Fri,  6 Jul 2012 22:09:22 +0200
Message-Id: <1341605393-32056-3-git-send-email-sameo@linux.intel.com> (sfid-20120706_215850_175837_11DAA99C)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

The questions asked in the comments have been answered and addressed.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/shdlc.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index d7c74d1..18d1536 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -340,15 +340,6 @@ static void nfc_shdlc_connect_complete(struct nfc_shdlc *shdlc, int r)
 		shdlc->state = SHDLC_CONNECTED;
 	} else {
 		shdlc->state = SHDLC_DISCONNECTED;
-
-		/*
-		 * TODO: Could it be possible that there are pending
-		 * executing commands that are waiting for connect to complete
-		 * before they can be carried? As connect is a blocking
-		 * operation, it would require that the userspace process can
-		 * send commands on the same device from a second thread before
-		 * the device is up. I don't think that is possible, is it?
-		 */
 	}
 
 	shdlc->connect_result = r;
@@ -926,8 +917,6 @@ void nfc_shdlc_free(struct nfc_shdlc *shdlc)
 {
 	pr_debug("\n");
 
-	/* TODO: Check that this cannot be called while still in use */
-
 	nfc_hci_unregister_device(shdlc->hdev);
 	nfc_hci_free_device(shdlc->hdev);
 
-- 
1.7.10

