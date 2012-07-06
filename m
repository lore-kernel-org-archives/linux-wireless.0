Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2GFUAd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:33 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 31/33] NFC: Use communicate thru only for PaSoRi when trying to read Felica tags
Date: Fri,  6 Jul 2012 22:09:51 +0200
Message-Id: <1341605393-32056-32-git-send-email-sameo@linux.intel.com> (sfid-20120706_220532_264084_9C049CAD)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise DATA_EXCHANGE seems to be just fine.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 37786ff..84d8175 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1806,7 +1806,17 @@ static int pn533_build_tx_frame(struct pn533 *dev, struct sk_buff *skb,
 
 	if (target == true) {
 		switch (dev->device_type) {
-		case PN533_DEVICE_STD:
+		case PN533_DEVICE_PASORI:
+			if (dev->tgt_active_prot == NFC_PROTO_FELICA) {
+				skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN - 1);
+				out_frame = (struct pn533_frame *) skb->data;
+				pn533_tx_frame_init(out_frame,
+						    PN533_CMD_IN_COMM_THRU);
+
+				break;
+			}
+
+		default:
 			skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN);
 			out_frame = (struct pn533_frame *) skb->data;
 			pn533_tx_frame_init(out_frame,
@@ -1815,19 +1825,8 @@ static int pn533_build_tx_frame(struct pn533 *dev, struct sk_buff *skb,
 			memcpy(PN533_FRAME_CMD_PARAMS_PTR(out_frame),
 			       &tg, sizeof(u8));
 			out_frame->datalen += sizeof(u8);
-			break;
-
-		case PN533_DEVICE_PASORI:
-			skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN - 1);
-			out_frame = (struct pn533_frame *) skb->data;
-			pn533_tx_frame_init(out_frame, PN533_CMD_IN_COMM_THRU);
 
 			break;
-
-		default:
-			nfc_dev_err(&dev->interface->dev,
-				    "Unknown device type %d", dev->device_type);
-			return -EINVAL;
 		}
 
 	} else {
-- 
1.7.10

