Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54088 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1LTO4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 09:56:38 -0500
Received: by mail-yx0-f174.google.com with SMTP id m11so4040485yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 06:56:37 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 2/2] NFC: Handle error during NCI data exchange
Date: Tue, 20 Dec 2011 16:57:41 +0200
Message-Id: <1324393061-32173-3-git-send-email-ilane@ti.com> (sfid-20111220_155640_317136_8A714A5C)
In-Reply-To: <1324393061-32173-1-git-send-email-ilane@ti.com>
References: <1324393061-32173-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Add support for NCI Interface Error Notification.
When this notification is received and we're during a
data exchange transaction, indicate an error to the NFC
core layer via the data exchange callback.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h |    6 ++++++
 net/nfc/nci/ntf.c     |   18 ++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 2a7fdb2..2be95e2 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -260,6 +260,12 @@ struct nci_core_conn_credit_ntf {
 	struct conn_credit_entry	conn_entries[NCI_MAX_NUM_CONN];
 } __packed;
 
+#define NCI_OP_CORE_INTF_ERROR_NTF	nci_opcode_pack(NCI_GID_CORE, 0x08)
+struct nci_core_intf_error_ntf {
+	__u8	status;
+	__u8	conn_id;
+} __packed;
+
 #define NCI_OP_RF_INTF_ACTIVATED_NTF	nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
 struct rf_tech_specific_params_nfca_poll {
 	__u16	sens_res;
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index c8813ed..352f7a2 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -71,6 +71,20 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 		queue_work(ndev->tx_wq, &ndev->tx_work);
 }
 
+static void nci_core_conn_intf_error_ntf_packet(struct nci_dev *ndev,
+						struct sk_buff *skb)
+{
+	struct nci_core_intf_error_ntf *ntf = (void *) skb->data;
+
+	ntf->conn_id = nci_conn_id(&ntf->conn_id);
+
+	pr_debug("status 0x%x, conn_id %d\n", ntf->status, ntf->conn_id);
+
+	/* complete the data exchange transaction, if exists */
+	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+		nci_data_exchange_complete(ndev, NULL, -EIO);
+}
+
 static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
 {
@@ -280,6 +294,10 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		nci_core_conn_credits_ntf_packet(ndev, skb);
 		break;
 
+	case NCI_OP_CORE_INTF_ERROR_NTF:
+		nci_core_conn_intf_error_ntf_packet(ndev, skb);
+		break;
+
 	case NCI_OP_RF_INTF_ACTIVATED_NTF:
 		nci_rf_intf_activated_ntf_packet(ndev, skb);
 		break;
-- 
1.7.0.4

