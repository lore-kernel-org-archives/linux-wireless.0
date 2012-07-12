Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab2GLS16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 14:27:58 -0400
Date: Thu, 12 Jul 2012 20:27:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>
Subject: [PATCH 1/2 v2] NFC: Set target nfcid1 for all HCI reader A targets
Message-ID: <20120712182754.GE23772@sortiz-mobl> (sfid-20120712_202801_763497_C72D0202)
References: <1342113454-23110-1-git-send-email-sameo@linux.intel.com>
 <1342113454-23110-2-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342113454-23110-2-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Eric Lapuyade <eric.lapuyade@intel.com>

Without the discovered target nfcid1 and its length set properly, type 2
tags detection fails with the pn544 as it checks for them from
pn544_hci_complete_target_discovered().

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Reported-by: Mathias Jeppsson <mathias.jeppsson@sonymobile.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
v2: Add proper changelog and fix a checkpatch warning

---
 net/nfc/hci/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index e1a640d..c48f534 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -170,6 +170,7 @@ static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
 	struct nfc_target *targets;
 	struct sk_buff *atqa_skb = NULL;
 	struct sk_buff *sak_skb = NULL;
+	struct sk_buff *uid_skb = NULL;
 	int r;
 
 	pr_debug("from gate %d\n", gate);
@@ -205,6 +206,19 @@ static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
 		targets->sens_res = be16_to_cpu(*(u16 *)atqa_skb->data);
 		targets->sel_res = sak_skb->data[0];
 
+		r = nfc_hci_get_param(hdev, NFC_HCI_RF_READER_A_GATE,
+				      NFC_HCI_RF_READER_A_UID, &uid_skb);
+		if (r < 0)
+			goto exit;
+
+		if (uid_skb->len == 0 || uid_skb->len > NFC_NFCID1_MAXSIZE) {
+			r = -EPROTO;
+			goto exit;
+		}
+
+		memcpy(targets->nfcid1, uid_skb->data, uid_skb->len);
+		targets->nfcid1_len = uid_skb->len;
+
 		if (hdev->ops->complete_target_discovered) {
 			r = hdev->ops->complete_target_discovered(hdev, gate,
 								  targets);
@@ -240,6 +254,7 @@ exit:
 	kfree(targets);
 	kfree_skb(atqa_skb);
 	kfree_skb(sak_skb);
+	kfree_skb(uid_skb);
 
 	return r;
 }
-- 
1.7.10

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
