Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbYICDbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:32 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 28/39] iwlwifi: workaround interrupt handling no some platforms
Date: Wed,  3 Sep 2008 11:26:48 +0800
Message-Id: <1220412419-15404-29-git-send-email-yi.zhu@intel.com> (sfid-20080903_055044_580970_0FDFAD15)
In-Reply-To: <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
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
index aad0ddc..10980c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2602,6 +2602,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
+	u16 pci_cmd;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -2612,6 +2613,13 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
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

