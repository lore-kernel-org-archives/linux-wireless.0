Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57512 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2GFT7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:09 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 08/33] NFC: Factorize HCI cmd completion
Date: Fri,  6 Jul 2012 22:09:28 +0200
Message-Id: <1341605393-32056-9-git-send-email-sameo@linux.intel.com> (sfid-20120706_215912_825249_EE685568)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

HCI cmd can be completed either from an HCI response or from an
internal driver or HCI error. This requires to factorize the
completion code outside of the device lock.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/core.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 5be7405..9a1a12f 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -127,21 +127,13 @@ static void nfc_hci_msg_rx_work(struct work_struct *work)
 	}
 }
 
-void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
-			   struct sk_buff *skb)
+static void __nfc_hci_cmd_completion(struct nfc_hci_dev *hdev, int err,
+				     struct sk_buff *skb)
 {
-	mutex_lock(&hdev->msg_tx_mutex);
-
-	if (hdev->cmd_pending_msg == NULL) {
-		kfree_skb(skb);
-		goto exit;
-	}
-
 	del_timer_sync(&hdev->cmd_timer);
 
 	if (hdev->cmd_pending_msg->cb)
-		hdev->cmd_pending_msg->cb(hdev, nfc_hci_result_to_errno(result),
-					  skb,
+		hdev->cmd_pending_msg->cb(hdev, err, skb,
 					  hdev->cmd_pending_msg->cb_context);
 	else
 		kfree_skb(skb);
@@ -150,6 +142,19 @@ void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
 	hdev->cmd_pending_msg = NULL;
 
 	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+}
+
+void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
+			   struct sk_buff *skb)
+{
+	mutex_lock(&hdev->msg_tx_mutex);
+
+	if (hdev->cmd_pending_msg == NULL) {
+		kfree_skb(skb);
+		goto exit;
+	}
+
+	__nfc_hci_cmd_completion(hdev, nfc_hci_result_to_errno(result), skb);
 
 exit:
 	mutex_unlock(&hdev->msg_tx_mutex);
-- 
1.7.10

