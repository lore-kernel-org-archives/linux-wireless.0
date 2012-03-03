Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59721 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2CCUZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 15:25:24 -0500
Received: by eekc41 with SMTP id c41so1008341eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 12:25:23 -0800 (PST)
Subject: [PATCH 2/2] p54pci: use new driver.pm interface for suspend/resume
Cc: linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 3 Mar 2012 21:25:19 +0100
To: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201203032125.19574.chunkeey@googlemail.com> (sfid-20120303_212527_791338_4A76FD31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/p54pci.c |   48 ++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index b1f51a2..d4860ac 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -624,36 +624,39 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM
-static int p54p_suspend(struct pci_dev *pdev, pm_message_t state)
+static int p54p_suspend(struct device *device)
 {
-	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-	struct p54p_priv *priv = dev->priv;
-
-	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
-		ieee80211_stop_queues(dev);
-		p54p_stop(dev);
-	}
+	struct pci_dev *pdev = to_pci_dev(device);
 
 	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	pci_set_power_state(pdev, PCI_D3hot);
+	pci_disable_device(pdev);
 	return 0;
 }
 
-static int p54p_resume(struct pci_dev *pdev)
+static int p54p_resume(struct device *device)
 {
-	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-	struct p54p_priv *priv = dev->priv;
+	struct pci_dev *pdev = to_pci_dev(device);
+	int err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
+	err = pci_reenable_device(pdev);
+	if (err)
+		return err;
+	return pci_set_power_state(pdev, PCI_D0);
+}
 
-	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
-		p54p_open(dev);
-		ieee80211_wake_queues(dev);
-	}
+static const struct dev_pm_ops p54pci_pm_ops = {
+	.suspend = p54p_suspend,
+	.resume = p54p_resume,
+	.freeze = p54p_suspend,
+	.thaw = p54p_resume,
+	.poweroff = p54p_suspend,
+	.restore = p54p_resume,
+};
 
-	return 0;
-}
+#define P54P_PM_OPS (&p54pci_pm_ops)
+#else
+#define P54P_PM_OPS (NULL)
 #endif /* CONFIG_PM */
 
 static struct pci_driver p54p_driver = {
@@ -661,10 +664,7 @@ static struct pci_driver p54p_driver = {
 	.id_table	= p54p_table,
 	.probe		= p54p_probe,
 	.remove		= __devexit_p(p54p_remove),
-#ifdef CONFIG_PM
-	.suspend	= p54p_suspend,
-	.resume		= p54p_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= P54P_PM_OPS,
 };
 
 static int __init p54p_init(void)
-- 
1.7.9.1

