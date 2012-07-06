Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2GFT7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:12 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 09/33] NFC: Implement HCI driver or internal error management
Date: Fri,  6 Jul 2012 22:09:29 +0200
Message-Id: <1341605393-32056-10-git-send-email-sameo@linux.intel.com> (sfid-20120706_215916_219699_C9D84835)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

If there is an ongoing HCI command executing, it will be completed,
thereby pushing the error up to the core. Otherwise, HCI will directly
notify the core with the error.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 9a1a12f..e6b2df3 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -736,10 +736,17 @@ EXPORT_SYMBOL(nfc_hci_get_clientdata);
 
 static void nfc_hci_failure(struct nfc_hci_dev *hdev, int err)
 {
-	/*
-	 * TODO: lower layer has permanent failure.
-	 * complete potential HCI command or send an empty tag discovered event
-	 */
+	mutex_lock(&hdev->msg_tx_mutex);
+
+	if (hdev->cmd_pending_msg == NULL) {
+		nfc_driver_failure(hdev->ndev, err);
+		goto exit;
+	}
+
+	__nfc_hci_cmd_completion(hdev, err, NULL);
+
+exit:
+	mutex_unlock(&hdev->msg_tx_mutex);
 }
 
 void nfc_hci_driver_failure(struct nfc_hci_dev *hdev, int err)
-- 
1.7.10

