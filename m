Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab1E0QIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:01 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlagn: free the ICT ISR when the request_irq failed
Date: Fri, 27 May 2011 08:40:29 -0700
Message-Id: <1306510833-32049-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180807_493294_2C8FEA49)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Fix a memory leak in case request_irq fails.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 58ed9a0..a90cb1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3615,8 +3615,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	free_irq(priv->pci_dev->irq, priv);
-	iwl_free_isr_ict(priv);
  out_disable_msi:
+	iwl_free_isr_ict(priv);
 	pci_disable_msi(priv->pci_dev);
 	iwl_uninit_drv(priv);
  out_free_eeprom:
-- 
1.7.0.4

