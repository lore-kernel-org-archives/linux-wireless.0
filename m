Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6751 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab2GFWmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:42:03 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org,
	Mathias Jeppsson <mathias.jeppsson@sonymobile.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/2] NFC: Fix empty HCI message list check
Date: Sat,  7 Jul 2012 00:53:18 +0200
Message-Id: <1341615199-11246-2-git-send-email-sameo@linux.intel.com> (sfid-20120707_004208_137960_3E0CDDC2)
In-Reply-To: <1341615199-11246-1-git-send-email-sameo@linux.intel.com>
References: <1341615199-11246-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mathias Jeppsson <mathias.jeppsson@sonymobile.com>

list_first_entry() will never return NULL. Instead use
list_for_each_entry_safe() to iterate through the list.

Signed-off-by: Mathias Jeppsson <mathias.jeppsson@sonymobile.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index e1a640d..da6e039 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -682,13 +682,12 @@ EXPORT_SYMBOL(nfc_hci_register_device);
 
 void nfc_hci_unregister_device(struct nfc_hci_dev *hdev)
 {
-	struct hci_msg *msg;
+	struct hci_msg *msg, *n;
 
 	skb_queue_purge(&hdev->rx_hcp_frags);
 	skb_queue_purge(&hdev->msg_rx_queue);
 
-	while ((msg = list_first_entry(&hdev->msg_tx_queue, struct hci_msg,
-				       msg_l)) != NULL) {
+	list_for_each_entry_safe(msg, n, &hdev->msg_tx_queue, msg_l) {
 		list_del(&msg->msg_l);
 		skb_queue_purge(&msg->msg_frags);
 		kfree(msg);
-- 
1.7.10

