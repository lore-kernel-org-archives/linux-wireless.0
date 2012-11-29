Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52873 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2K2W1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:27:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, Larry.Finger@lwfinger.net,
	chunkeey@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] ath9k: use SIMPLE_DEV_PM_OPS
Date: Thu, 29 Nov 2012 23:27:15 +0100
Message-Id: <1354228037-1700-2-git-send-email-hauke@hauke-m.de> (sfid-20121129_232739_470635_E3A13346)
In-Reply-To: <1354228037-1700-1-git-send-email-hauke@hauke-m.de>
References: <1354228037-1700-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k does not provide any runtime pm callbacks, so support for
PM_RUNTIME is not needed and we could go to PM_SLEEP.
This also makes it possible to use SIMPLE_DEV_PM_OPS instead of
manually filling struct dev_pm_ops.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/ath/ath9k/pci.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 9553203..8e9b826 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -287,7 +287,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	pci_release_region(pdev, 0);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static int ath_pci_suspend(struct device *device)
 {
@@ -333,22 +333,15 @@ static int ath_pci_resume(struct device *device)
 	return 0;
 }
 
-static const struct dev_pm_ops ath9k_pm_ops = {
-	.suspend = ath_pci_suspend,
-	.resume = ath_pci_resume,
-	.freeze = ath_pci_suspend,
-	.thaw = ath_pci_resume,
-	.poweroff = ath_pci_suspend,
-	.restore = ath_pci_resume,
-};
+static SIMPLE_DEV_PM_OPS(ath9k_pm_ops, ath_pci_suspend, ath_pci_resume);
 
 #define ATH9K_PM_OPS	(&ath9k_pm_ops)
 
-#else /* !CONFIG_PM */
+#else /* !CONFIG_PM_SLEEP */
 
 #define ATH9K_PM_OPS	NULL
 
-#endif /* !CONFIG_PM */
+#endif /* !CONFIG_PM_SLEEP */
 
 
 MODULE_DEVICE_TABLE(pci, ath_pci_id_table);
-- 
1.7.10.4

