Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab0GaQyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/8] iwlagn: log pci revision id
Date: Sat, 31 Jul 2010 08:34:06 -0700
Message-Id: <1280590452-10655-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Log the information after reading the PCI_REVISION_ID
from pci config space,

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 74b917c..982e2c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3930,6 +3930,7 @@ static void iwl_hw_detect(struct iwl_priv *priv)
 	priv->hw_rev = _iwl_read32(priv, CSR_HW_REV);
 	priv->hw_wa_rev = _iwl_read32(priv, CSR_HW_REV_WA_REG);
 	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &priv->rev_id);
+	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", priv->rev_id);
 }
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-- 
1.7.0.4

