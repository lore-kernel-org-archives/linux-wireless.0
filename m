Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33064 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbbLJHy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 02:54:27 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] NFC: fdp: fix handling return value of fdp_nci_create_conn
Date: Thu, 10 Dec 2015 08:53:02 +0100
Message-id: <1449733982-29120-1-git-send-email-a.hajda@samsung.com> (sfid-20151210_085723_063088_3BB0EB55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function can return negative values, so its result should
be assigned to signed variable.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2046107

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/nfc/fdp/fdp.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index ccb07a1..440fac3 100644
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
-		goto out;
-	}
+	r = fdp_nci_create_conn(ndev);
+	if (r < 0)
+		got out;
+	conn_id = r;
 
 	/* Send the patch over the data connection */
 	r = fdp_nci_send_patch(ndev, conn_id, NCI_PATCH_TYPE_RAM);
-- 
1.9.1

