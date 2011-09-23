Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50503 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1IWGPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 02:15:06 -0400
Date: Fri, 23 Sep 2011 09:14:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] NFC: use after free on error
Message-ID: <20110923061435.GA4387@elgon.mountain> (sfid-20110923_081529_249970_9D05D9D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We returned a freed variable on some error paths when the intent was
to return a NULL.  Part of the reason this was missed was that the
code was confusing because it had too many gotos so I removed them
and simplified the flow a bit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 895e5fd..06330cd 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -490,19 +490,19 @@ struct nci_dev *nci_allocate_device(struct nci_ops *ops,
 					int tx_headroom,
 					int tx_tailroom)
 {
-	struct nci_dev *ndev = NULL;
+	struct nci_dev *ndev;
 
 	nfc_dbg("entry, supported_protocols 0x%x", supported_protocols);
 
 	if (!ops->open || !ops->close || !ops->send)
-		goto exit;
+		return NULL;
 
 	if (!supported_protocols)
-		goto exit;
+		return NULL;
 
 	ndev = kzalloc(sizeof(struct nci_dev), GFP_KERNEL);
 	if (!ndev)
-		goto exit;
+		return NULL;
 
 	ndev->ops = ops;
 	ndev->tx_headroom = tx_headroom;
@@ -517,13 +517,11 @@ struct nci_dev *nci_allocate_device(struct nci_ops *ops,
 
 	nfc_set_drvdata(ndev->nfc_dev, ndev);
 
-	goto exit;
+	return ndev;
 
 free_exit:
 	kfree(ndev);
-
-exit:
-	return ndev;
+	return NULL;
 }
 EXPORT_SYMBOL(nci_allocate_device);
 
