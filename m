Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:16819 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZA0KAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 05:00:49 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1407186eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 02:00:48 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 27 Jan 2009 12:00:48 +0200
Message-ID: <b25312890901270200h24037f31jaf83f62acb031d1d@mail.gmail.com> (sfid-20090127_110054_150664_09F62B76)
Subject: [PATCH ] iwlwifi: fix iwlwifi warning (pci_enable_device).
From: Rami Rosen <roszenrami@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes build warnings which are caused as a result
of iwl-agn.c and iwl3945-base.c resume methods.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-testing)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 757a9bd..7cf727c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4117,7 +4117,10 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);

 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_device(pdev);
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR "pci_enable_device failed on resume\n");
+		return -ENODEV;
+	}
 	pci_restore_state(pdev);
 	iwl_enable_interrupts(priv);

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 25a3508..3ca24d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6307,7 +6307,10 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);

 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_device(pdev);
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR "pci_enable_device failed on resume\n");
+		return -ENODEV;
+	}
 	pci_restore_state(pdev);

 	if (priv->is_open)
