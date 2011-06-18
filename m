Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1FRQFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/25] iwlagn: don't disable interrupts after the NIC has been reset
Date: Sat, 18 Jun 2011 08:34:10 -0700
Message-Id: <1308411271-26093-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180620_215251_D9E95681)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is superfluous to disable the interrupts after we reset the NIC. The only
entity that could enable the interrupts after the NIC is reset is the driver.
So remove this pointless action.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d66f1c2..0c747c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3485,7 +3485,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-	unsigned long flags;
 	u16 pci_cmd, num_mac;
 	u32 hw_rev;
 
@@ -3646,10 +3645,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/********************
 	 * 7. Setup services
 	 ********************/
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	pci_enable_msi(priv->pci_dev);
 
 	iwl_alloc_isr_ict(priv);
-- 
1.7.0.4

