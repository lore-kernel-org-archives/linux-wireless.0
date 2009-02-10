Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbZBJXPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 18:15:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: drop PCIe workaround applicable for development boards
Date: Tue, 10 Feb 2009 15:19:03 -0800
Message-Id: <1234307944-21820-3-git-send-email-reinette.chatre@intel.com> (sfid-20090211_001540_812799_D531CF04)
In-Reply-To: <1234307944-21820-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1234307944-21820-1-git-send-email-reinette.chatre@intel.com>
 <1234307944-21820-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch remove w/a used for development boards.
These boards are not available thus no need to keep it inside driver

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ead947b..bd0140b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -381,21 +381,11 @@ out:
 static void iwl4965_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	u16 dctl;
 	u16 radio_cfg;
 	u16 lctl;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if ((priv->rev_id & 0x80) == 0x80 && (priv->rev_id & 0x7f) < 8) {
-		int pos = pci_find_capability(priv->pci_dev, PCI_CAP_ID_EXP);
-		pci_read_config_word(priv->pci_dev, pos + PCI_EXP_DEVCTL, &dctl);
-
-		/* Enable No Snoop field */
-		pci_write_config_word(priv->pci_dev, pos + PCI_EXP_DEVCTL,
-					dctl & ~PCI_EXP_DEVCTL_NOSNOOP_EN);
-	}
-
 	lctl = iwl_pcie_link_ctl(priv);
 
 	/* HW bug W/A - negligible power consumption */
-- 
1.5.4.3

