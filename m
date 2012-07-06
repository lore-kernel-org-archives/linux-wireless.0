Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2GFT6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:58:42 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 01/33] NFC: Prepare asynchronous error management for driver and shdlc
Date: Fri,  6 Jul 2012 22:09:21 +0200
Message-Id: <1341605393-32056-2-git-send-email-sameo@linux.intel.com> (sfid-20120706_215846_263345_9BB5AD38)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/hci.h |    2 ++
 net/nfc/hci/core.c    |    8 ++++++++
 net/nfc/hci/shdlc.c   |   19 +++++++++++--------
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index e30e6a8..d25dd9b 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -112,6 +112,8 @@ void nfc_hci_unregister_device(struct nfc_hci_dev *hdev);
 void nfc_hci_set_clientdata(struct nfc_hci_dev *hdev, void *clientdata);
 void *nfc_hci_get_clientdata(struct nfc_hci_dev *hdev);
 
+void nfc_hci_driver_failure(struct nfc_hci_dev *hdev, int err);
+
 /* Host IDs */
 #define NFC_HCI_HOST_CONTROLLER_ID	0x00
 #define NFC_HCI_TERMINAL_HOST_ID	0x01
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index a8b0b71..1dc6485 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -717,6 +717,14 @@ void *nfc_hci_get_clientdata(struct nfc_hci_dev *hdev)
 }
 EXPORT_SYMBOL(nfc_hci_get_clientdata);
 
+void nfc_hci_driver_failure(struct nfc_hci_dev *hdev, int err)
+{
+	/* TODO: lower layer has permanent failure.
+	 * complete potential HCI command or send an empty tag discovered event
+	 */
+}
+EXPORT_SYMBOL(nfc_hci_driver_failure);
+
 void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hcp_packet *packet;
diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 6b836e6..d7c74d1 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -523,10 +523,6 @@ static void nfc_shdlc_handle_send_queue(struct nfc_shdlc *shdlc)
 
 		r = shdlc->ops->xmit(shdlc, skb);
 		if (r < 0) {
-			/*
-			 * TODO: Cannot send, shdlc machine is dead, we
-			 * must propagate the information up to HCI.
-			 */
 			shdlc->hard_fault = r;
 			break;
 		}
@@ -590,6 +586,11 @@ static void nfc_shdlc_sm_work(struct work_struct *work)
 		skb_queue_purge(&shdlc->ack_pending_q);
 		break;
 	case SHDLC_CONNECTING:
+		if (shdlc->hard_fault) {
+			nfc_shdlc_connect_complete(shdlc, shdlc->hard_fault);
+			break;
+		}
+
 		if (shdlc->connect_tries++ < 5)
 			r = nfc_shdlc_connect_initiate(shdlc);
 		else
@@ -610,6 +611,11 @@ static void nfc_shdlc_sm_work(struct work_struct *work)
 		}
 
 		nfc_shdlc_handle_rcv_queue(shdlc);
+
+		if (shdlc->hard_fault) {
+			nfc_shdlc_connect_complete(shdlc, shdlc->hard_fault);
+			break;
+		}
 		break;
 	case SHDLC_CONNECTED:
 		nfc_shdlc_handle_rcv_queue(shdlc);
@@ -637,10 +643,7 @@ static void nfc_shdlc_sm_work(struct work_struct *work)
 		}
 
 		if (shdlc->hard_fault) {
-			/*
-			 * TODO: Handle hard_fault that occured during
-			 * this invocation of the shdlc worker
-			 */
+			nfc_hci_driver_failure(shdlc->hdev, shdlc->hard_fault);
 		}
 		break;
 	default:
-- 
1.7.10

