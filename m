Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32850 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbLJIgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 03:36:21 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] NFC: fdp: fix handling return value of fdp_nci_create_conn
Date: Thu, 10 Dec 2015 09:35:03 +0100
Message-id: <1449736503-6615-1-git-send-email-a.hajda@samsung.com> (sfid-20151210_093702_141986_2854598F)
In-reply-to: <1449733982-29120-1-git-send-email-a.hajda@samsung.com>
References: <1449733982-29120-1-git-send-email-a.hajda@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function can return negative values, so its result should
be assigned to signed variable.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2046107

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
v2: fixed typo in goto instruction

 drivers/nfc/fdp/fdp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index ccb07a1..4dfd1ef 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -368,11 +368,10 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 		goto out;
 
 	/* Patch data connection creation */
-	conn_id = fdp_nci_create_conn(ndev);
-	if (conn_id < 0) {
-		r = conn_id;
+	r = fdp_nci_create_conn(ndev);
+	if (r < 0)
 		goto out;
-	}
+	conn_id = r;
 
 	/* Send the patch over the data connection */
 	r = fdp_nci_send_patch(ndev, conn_id, NCI_PATCH_TYPE_OTP);
@@ -439,11 +438,10 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 		goto out;
 
 	/* Patch data connection creation */
-	conn_id = fdp_nci_create_conn(ndev);
-	if (conn_id < 0) {
-		r = conn_id;
+	r = fdp_nci_create_conn(ndev);
+	if (r < 0)
 		goto out;
-	}
+	conn_id = r;
 
 	/* Send the patch over the data connection */
 	r = fdp_nci_send_patch(ndev, conn_id, NCI_PATCH_TYPE_RAM);
-- 
1.9.1

