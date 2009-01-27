Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZA0WZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/7] iwlwifi: check return value of pci_enable_device
Date: Tue, 27 Jan 2009 14:27:55 -0800
Message-Id: <1233095278-5850-5-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232515_781270_F60E3553)
In-Reply-To: <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

pci_enable_device is tagged with __must_check therefore
don't ignore the return value in pci_resume handlers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2307c75..eab238e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3763,9 +3763,12 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 static int iwl_pci_resume(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
 	pci_restore_state(pdev);
 	iwl_enable_interrupts(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 72ff20e..346a301 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5824,9 +5824,12 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 static int iwl3945_pci_resume(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
 	pci_restore_state(pdev);
 
 	if (priv->is_open)
-- 
1.5.4.3

