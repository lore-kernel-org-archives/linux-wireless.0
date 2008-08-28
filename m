Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYH1J3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/11] iwlwifi: workaround interrupt handling no some platforms
Date: Thu, 28 Aug 2008 17:25:04 +0800
Message-Id: <1219915510-3647-6-git-send-email-yi.zhu@intel.com> (sfid-20080828_112917_000593_E9415FD1)
In-Reply-To: <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds workaround for an interrupt related hardware bug on
some platforms.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e35db85..4986137 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2601,6 +2601,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
+	u16 pci_cmd;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -2611,6 +2612,13 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 	pci_restore_state(priv->pci_dev);
 	pci_enable_msi(priv->pci_dev);
 
+	/* enable interrupts if needed: hw bug w/a */
+	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
+	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
+		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
+		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
+	}
+
 	ret = request_irq(priv->pci_dev->irq, iwl4965_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (ret) {
-- 
1.5.3.6

