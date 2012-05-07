Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab2EGKdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:33:12 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 20/20] NFC: HCI drivers don't have to keep track of polling state
Date: Mon,  7 May 2012 12:31:31 +0200
Message-Id: <1336386691-24840-21-git-send-email-sameo@linux.intel.com> (sfid-20120507_123325_470448_E76EBBF0)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

The NFC core code already does that for them.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/hci.h |    2 --
 net/nfc/hci/core.c    |   21 ++++-----------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index ae04200..4467c94 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -84,8 +84,6 @@ struct nfc_hci_dev {
 
 	u8 gate2pipe[NFC_HCI_MAX_GATES];
 
-	bool poll_started;
-
 	u8 sw_romlib;
 	u8 sw_patch;
 	u8 sw_flashlib_major;
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 0fdb96f..e1a640d 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -251,11 +251,6 @@ void nfc_hci_event_received(struct nfc_hci_dev *hdev, u8 pipe, u8 event,
 
 	switch (event) {
 	case NFC_HCI_EVT_TARGET_DISCOVERED:
-		if (hdev->poll_started == false) {
-			r = -EPROTO;
-			goto exit;
-		}
-
 		if (skb->len < 1) {	/* no status data? */
 			r = -EPROTO;
 			goto exit;
@@ -489,28 +484,20 @@ static int hci_dev_down(struct nfc_dev *nfc_dev)
 static int hci_start_poll(struct nfc_dev *nfc_dev, u32 protocols)
 {
 	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
-	int r;
 
 	if (hdev->ops->start_poll)
-		r = hdev->ops->start_poll(hdev, protocols);
+		return hdev->ops->start_poll(hdev, protocols);
 	else
-		r = nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
+		return nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
 				       NFC_HCI_EVT_READER_REQUESTED, NULL, 0);
-	if (r == 0)
-		hdev->poll_started = true;
-
-	return r;
 }
 
 static void hci_stop_poll(struct nfc_dev *nfc_dev)
 {
 	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
 
-	if (hdev->poll_started) {
-		nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
-				   NFC_HCI_EVT_END_OPERATION, NULL, 0);
-		hdev->poll_started = false;
-	}
+	nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
+			   NFC_HCI_EVT_END_OPERATION, NULL, 0);
 }
 
 static int hci_activate_target(struct nfc_dev *nfc_dev,
-- 
1.7.9.1

