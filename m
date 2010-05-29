Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:52454 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab0E2WeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 May 2010 18:34:00 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org,
	Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] ath5k: depend on CONFIG_PM_SLEEP for suspend/resume functions
Date: Sun, 30 May 2010 00:02:18 +0200
Message-Id: <1275170538-7304-1-git-send-email-tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building a kernel with CONFIG_PM=y but neither suspend nor
hibernate support, the compiler complains about the static functions
ath5k_pci_suspend() and ath5k_pci_resume() not being used:

drivers/net/wireless/ath/ath5k/base.c:713:12: warning: ‘ath5k_pci_suspend’ defined but not used
drivers/net/wireless/ath/ath5k/base.c:722:12: warning: ‘ath5k_pci_resume’ defined but not used

Depending on CONFIG_PM_SLEEP rather than CONFIG_PM fixes the issue.

Signed-off-by: Tobias Doerffel <tobias.doerffel@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8a36aa6..d4bab48 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -195,7 +195,7 @@ static const struct ieee80211_rate ath5k_rates[] = {
 static int __devinit	ath5k_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 static void __devexit	ath5k_pci_remove(struct pci_dev *pdev);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int		ath5k_pci_suspend(struct device *dev);
 static int		ath5k_pci_resume(struct device *dev);
 
@@ -203,7 +203,7 @@ static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
 #define ATH5K_PM_OPS	(&ath5k_pm_ops)
 #else
 #define ATH5K_PM_OPS	NULL
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static struct pci_driver ath5k_pci_driver = {
 	.name		= KBUILD_MODNAME,
@@ -709,7 +709,7 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	ieee80211_free_hw(hw);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ath5k_pci_suspend(struct device *dev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(to_pci_dev(dev));
@@ -735,7 +735,7 @@ static int ath5k_pci_resume(struct device *dev)
 	ath5k_led_enable(sc);
 	return 0;
 }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 
 /***********************\
-- 
1.7.0.4

