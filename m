Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATO3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:29:34 -0500
Date: Mon, 20 Jan 2014 17:29:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] NFC: potential overflows in microread_target_discovered()
Message-ID: <20140120142900.GA4954@elgon.mountain> (sfid-20140120_152939_377233_B294D587)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch says that skb->data is untrusted so we need to check to make sure
that the memcpy() doesn't overflow.

Fixes: cfad1ba87150 ('NFC: Initial support for Inside Secure microread')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Compile tested only.

diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index f868333271aa..963a4a5dc88e 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -501,9 +501,13 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
 		targets->sens_res =
 			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
-		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
-		       skb->data[MICROREAD_EMCF_A_LEN]);
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
+		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
+		       targets->nfcid1_len);
 		break;
 	case MICROREAD_GATE_ID_MREAD_ISO_A_3:
 		targets->supported_protocols =
@@ -511,9 +515,13 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
 		targets->sens_res =
 			 be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A3_ATQA]);
 		targets->sel_res = skb->data[MICROREAD_EMCF_A3_SAK];
-		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
-		       skb->data[MICROREAD_EMCF_A3_LEN]);
 		targets->nfcid1_len = skb->data[MICROREAD_EMCF_A3_LEN];
+		if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
+			r = -EINVAL;
+			goto exit_free;
+		}
+		memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A3_UID],
+		       targets->nfcid1_len);
 		break;
 	case MICROREAD_GATE_ID_MREAD_ISO_B:
 		targets->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
