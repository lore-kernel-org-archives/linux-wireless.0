Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29278 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbdHVVrH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 17:47:07 -0400
From: <ryanhsu@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qti.qualcomm.com>
Subject: [PATCH v3 1/2] ath10k: add the PCI PM core suspend/resume ops
Date: Tue, 22 Aug 2017 14:47:34 -0700
Message-ID: <1503438455-6133-1-git-send-email-ryanhsu@qti.qualcomm.com> (sfid-20170822_234712_878848_F0C43791)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qti.qualcomm.com>

The actual PCI suspend/resume in ath10k has been handled in wow.c,
but in the case of the device doesn't support remote wakeup,
the .hif_suspend() and .hif_resume() will never be handled.

  ath10k_wow_op_suspend()
  {
	if (WARN_ON(!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
		    ar->running_fw->fw_file.fw_features))) {
		ret = 1;
		goto exit;
	}

	....

	ret = ath10k_hif_suspend(ar);
  }

So register the PCI PM core to support the suspend/resume if the device
doesn't support remote wakeup.

Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0457e31..4aac0de 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3358,11 +3358,53 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 
 MODULE_DEVICE_TABLE(pci, ath10k_pci_id_table);
 
+#ifdef CONFIG_PM
+
+static int ath10k_pci_pm_suspend(struct device *dev)
+{
+	struct ath10k *ar = dev_get_drvdata(dev);
+	int ret;
+
+	if (test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
+		     ar->running_fw->fw_file.fw_features))
+		return 0;
+
+	ret = ath10k_hif_suspend(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to suspend hif: %d\n", ret);
+
+	return ret;
+}
+
+static int ath10k_pci_pm_resume(struct device *dev)
+{
+	struct ath10k *ar = dev_get_drvdata(dev);
+	int ret;
+
+	if (test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
+		     ar->running_fw->fw_file.fw_features))
+		return 0;
+
+	ret = ath10k_hif_resume(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to resume hif: %d\n", ret);
+
+	return ret;
+}
+
+SIMPLE_DEV_PM_OPS(ath10k_pci_pm_ops,
+		  ath10k_pci_pm_suspend,
+		  ath10k_pci_pm_resume);
+#endif
+
 static struct pci_driver ath10k_pci_driver = {
 	.name = "ath10k_pci",
 	.id_table = ath10k_pci_id_table,
 	.probe = ath10k_pci_probe,
 	.remove = ath10k_pci_remove,
+#ifdef CONFIG_PM
+	.driver.pm = &ath10k_pci_pm_ops,
+#endif
 };
 
 static int __init ath10k_pci_init(void)
-- 
1.9.1
