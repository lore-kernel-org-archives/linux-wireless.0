Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35137 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbDZIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2015 04:37:25 -0400
From: Firo Yang <firogm@gmail.com>
To: lauro.venancio@openbossa.org
Cc: aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	christophe.ricard@gmail.com, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org, Firo Yang <firogm@gmail.com>
Subject: [PATCH] NFC: st21nfcb: Remove inappropriate kfree on a devm_kzalloc pointer
Date: Sun, 26 Apr 2015 16:37:18 +0800
Message-Id: <1430037438-11617-1-git-send-email-firogm@gmail.com> (sfid-20150426_103827_414259_4682347B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ndev->driver_data is alloced by devm_kzalloc(), we do not
need the inappropriate kfree to free it in driver's remove function.
Freeing will trigger when driver unloads, so I remove it.

Signed-off-by: Firo Yang <firogm@gmail.com>
---
 drivers/nfc/st21nfcb/st21nfcb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nfc/st21nfcb/st21nfcb.c b/drivers/nfc/st21nfcb/st21nfcb.c
index ca9871a..c7dc282 100644
--- a/drivers/nfc/st21nfcb/st21nfcb.c
+++ b/drivers/nfc/st21nfcb/st21nfcb.c
@@ -131,11 +131,8 @@ EXPORT_SYMBOL_GPL(st21nfcb_nci_probe);
 
 void st21nfcb_nci_remove(struct nci_dev *ndev)
 {
-	struct st21nfcb_nci_info *info = nci_get_drvdata(ndev);
-
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
-	kfree(info);
 }
 EXPORT_SYMBOL_GPL(st21nfcb_nci_remove);
 
-- 
2.1.0

