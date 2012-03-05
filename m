Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965118Ab2CEUiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 16/33] iwlwifi: reduce IDI code ifdef
Date: Mon,  5 Mar 2012 11:24:34 -0800
Message-Id: <1330975491-19680-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213814_471001_8F09EF4A)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code in the two branches of the #ifdef
is almost the same so move the common code
outside the #ifdef.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index d109b0f..c5e339e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -278,17 +278,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 #ifdef CONFIG_IWLWIFI_IDI
 	iwl_trans = iwl_trans_idi_alloc(shrd, pdev, ent);
-	if (iwl_trans == NULL) {
-		err = -ENOMEM;
-		goto out_free_bus;
-	}
-
-	shrd->trans = iwl_trans;
-	pci_set_drvdata(pdev, iwl_trans);
-
-	err = iwl_drv_start(shrd, iwl_trans, cfg);
 #else
 	iwl_trans = iwl_trans_pcie_alloc(shrd, pdev, ent);
+#endif
 	if (iwl_trans == NULL) {
 		err = -ENOMEM;
 		goto out_free_bus;
@@ -298,7 +290,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, iwl_trans);
 
 	err = iwl_drv_start(shrd, iwl_trans, cfg);
-#endif
 	if (err)
 		goto out_free_trans;
 
-- 
1.7.0.4

