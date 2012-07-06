Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2GFT7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:01 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 06/33] NFC: Changed HCI cmd execution completion result to std linux errno
Date: Fri,  6 Jul 2012 22:09:26 +0200
Message-Id: <1341605393-32056-7-git-send-email-sameo@linux.intel.com> (sfid-20120706_215906_533778_0EF09914)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

An HCI command can complete either from an HCI response
(with an HCI result) or as a consequence of any other system
error during processing. The completion therefore needs to take
a standard errno code. The HCI response will convert its result
to a standard errno before calling the completion.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/command.c |   18 +++---------------
 net/nfc/hci/core.c    |   20 ++++++++++++++++----
 net/nfc/hci/hci.h     |    7 ++++---
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/net/nfc/hci/command.c b/net/nfc/hci/command.c
index 8729abf..12cd6f3 100644
--- a/net/nfc/hci/command.c
+++ b/net/nfc/hci/command.c
@@ -28,26 +28,14 @@
 
 #include "hci.h"
 
-static int nfc_hci_result_to_errno(u8 result)
-{
-	switch (result) {
-	case NFC_HCI_ANY_OK:
-		return 0;
-	case NFC_HCI_ANY_E_TIMEOUT:
-		return -ETIMEDOUT;
-	default:
-		return -1;
-	}
-}
-
-static void nfc_hci_execute_cb(struct nfc_hci_dev *hdev, u8 result,
+static void nfc_hci_execute_cb(struct nfc_hci_dev *hdev, int err,
 			       struct sk_buff *skb, void *cb_data)
 {
 	struct hcp_exec_waiter *hcp_ew = (struct hcp_exec_waiter *)cb_data;
 
-	pr_debug("HCI Cmd completed with HCI result=%d\n", result);
+	pr_debug("HCI Cmd completed with result=%d\n", err);
 
-	hcp_ew->exec_result = nfc_hci_result_to_errno(result);
+	hcp_ew->exec_result = err;
 	if (hcp_ew->exec_result == 0)
 		hcp_ew->result_skb = skb;
 	else
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 7d4fdbc..5be7405 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -32,6 +32,18 @@
 /* Largest headroom needed for outgoing HCI commands */
 #define HCI_CMDS_HEADROOM 1
 
+static int nfc_hci_result_to_errno(u8 result)
+{
+	switch (result) {
+	case NFC_HCI_ANY_OK:
+		return 0;
+	case NFC_HCI_ANY_E_TIMEOUT:
+		return -ETIME;
+	default:
+		return -1;
+	}
+}
+
 static void nfc_hci_msg_tx_work(struct work_struct *work)
 {
 	struct nfc_hci_dev *hdev = container_of(work, struct nfc_hci_dev,
@@ -46,7 +58,7 @@ static void nfc_hci_msg_tx_work(struct work_struct *work)
 		if (timer_pending(&hdev->cmd_timer) == 0) {
 			if (hdev->cmd_pending_msg->cb)
 				hdev->cmd_pending_msg->cb(hdev,
-							  NFC_HCI_ANY_E_TIMEOUT,
+							  -ETIME,
 							  NULL,
 							  hdev->
 							  cmd_pending_msg->
@@ -71,8 +83,7 @@ next_msg:
 			kfree_skb(skb);
 			skb_queue_purge(&msg->msg_frags);
 			if (msg->cb)
-				msg->cb(hdev, NFC_HCI_ANY_E_NOK, NULL,
-					msg->cb_context);
+				msg->cb(hdev, r, NULL, msg->cb_context);
 			kfree(msg);
 			break;
 		}
@@ -129,7 +140,8 @@ void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
 	del_timer_sync(&hdev->cmd_timer);
 
 	if (hdev->cmd_pending_msg->cb)
-		hdev->cmd_pending_msg->cb(hdev, result, skb,
+		hdev->cmd_pending_msg->cb(hdev, nfc_hci_result_to_errno(result),
+					  skb,
 					  hdev->cmd_pending_msg->cb_context);
 	else
 		kfree_skb(skb);
diff --git a/net/nfc/hci/hci.h b/net/nfc/hci/hci.h
index 45f2fe4..d3cde07 100644
--- a/net/nfc/hci/hci.h
+++ b/net/nfc/hci/hci.h
@@ -37,10 +37,11 @@ struct hcp_packet {
 
 /*
  * HCI command execution completion callback.
- * result will be one of the HCI response codes.
- * skb contains the response data and must be disposed.
+ * result will be a standard linux error (may be converted from HCI response)
+ * skb contains the response data and must be disposed, or may be NULL if
+ * an error occured
  */
-typedef void (*hci_cmd_cb_t) (struct nfc_hci_dev *hdev, u8 result,
+typedef void (*hci_cmd_cb_t) (struct nfc_hci_dev *hdev, int result,
 			      struct sk_buff *skb, void *cb_data);
 
 struct hcp_exec_waiter {
-- 
1.7.10

