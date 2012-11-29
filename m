Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52889 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2K2W1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:27:38 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, Larry.Finger@lwfinger.net,
	chunkeey@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] p54pci: use SIMPLE_DEV_PM_OPS
Date: Thu, 29 Nov 2012 23:27:16 +0100
Message-Id: <1354228037-1700-3-git-send-email-hauke@hauke-m.de> (sfid-20121129_232741_619803_6DAB0A3E)
In-Reply-To: <1354228037-1700-1-git-send-email-hauke@hauke-m.de>
References: <1354228037-1700-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54pci does not provide any runtime pm callbacks, so support for
PM_RUNTIME is not needed and we could go to PM_SLEEP.
This also makes it possible to use SIMPLE_DEV_PM_OPS instead of
manually filling struct dev_pm_ops.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/p54/p54pci.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index b439079..810c343 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -659,7 +659,7 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
 	p54_free_common(dev);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int p54p_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -681,19 +681,12 @@ static int p54p_resume(struct device *device)
 	return pci_set_power_state(pdev, PCI_D0);
 }
 
-static const struct dev_pm_ops p54pci_pm_ops = {
-	.suspend = p54p_suspend,
-	.resume = p54p_resume,
-	.freeze = p54p_suspend,
-	.thaw = p54p_resume,
-	.poweroff = p54p_suspend,
-	.restore = p54p_resume,
-};
+static SIMPLE_DEV_PM_OPS(p54pci_pm_ops, p54p_suspend, p54p_resume);
 
 #define P54P_PM_OPS (&p54pci_pm_ops)
 #else
 #define P54P_PM_OPS (NULL)
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static struct pci_driver p54p_driver = {
 	.name		= "p54pci",
-- 
1.7.10.4

