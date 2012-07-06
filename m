Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548Ab2GFWm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:42:29 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org,
	Mathias Jeppsson <mathias.jeppsson@sonymobile.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/2] NFC: Fix order of arguments to list_add_tail() when queueing HCP frames
Date: Sat,  7 Jul 2012 00:53:19 +0200
Message-Id: <1341615199-11246-3-git-send-email-sameo@linux.intel.com> (sfid-20120707_004232_344418_BD3D4A69)
In-Reply-To: <1341615199-11246-1-git-send-email-sameo@linux.intel.com>
References: <1341615199-11246-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mathias Jeppsson <mathias.jeppsson@sonymobile.com>

The HCP message should be added to transmit queue, not the other way around.

Signed-off-by: Mathias Jeppsson <mathias.jeppsson@sonymobile.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/hcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
index 7212cf2..f4dad1a 100644
--- a/net/nfc/hci/hcp.c
+++ b/net/nfc/hci/hcp.c
@@ -105,7 +105,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 	}
 
 	mutex_lock(&hdev->msg_tx_mutex);
-	list_add_tail(&hdev->msg_tx_queue, &cmd->msg_l);
+	list_add_tail(&cmd->msg_l, &hdev->msg_tx_queue);
 	mutex_unlock(&hdev->msg_tx_mutex);
 
 	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
-- 
1.7.10

