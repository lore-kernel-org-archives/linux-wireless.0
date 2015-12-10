Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30285 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbLJHzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 02:55:21 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] NFC: fdp: fix handling return value of
 nci_conn_max_data_pkt_payload_size
Date: Thu, 10 Dec 2015 08:54:04 +0100
Message-id: <1449734044-29181-1-git-send-email-a.hajda@samsung.com> (sfid-20151210_085548_846299_89DA95C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function can return negative values, so its result should
be assigned to signed variable.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2046107

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/nfc/fdp/fdp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 440fac3..37a7134 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -192,7 +192,7 @@ static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 	struct sk_buff *skb;
 	unsigned long len;
 	u8 max_size, payload_size;
-	int rc = 0;
+	int rc;
 
 	if ((type == NCI_PATCH_TYPE_OTP && !info->otp_patch) ||
 	    (type == NCI_PATCH_TYPE_RAM && !info->ram_patch))
@@ -203,11 +203,13 @@ static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 	else
 		fw = info->ram_patch;
 
-	max_size = nci_conn_max_data_pkt_payload_size(ndev, conn_id);
-	if (max_size <= 0)
+	rc = nci_conn_max_data_pkt_payload_size(ndev, conn_id);
+	if (rc <= 0)
 		return -EINVAL;
+	max_size = rc;
 
 	len = fw->size;
+	rc = 0;
 
 	fdp_nci_set_data_pkt_counter(ndev, fdp_nci_send_patch_cb,
 				     DIV_ROUND_UP(fw->size, max_size));
-- 
1.9.1

