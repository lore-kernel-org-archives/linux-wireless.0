Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823Ab0BKSmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/12] iwlwifi: reset card during probe
Date: Thu, 11 Feb 2010 10:42:01 -0800
Message-Id: <1265913725-4279-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

To ensure that card is in a sane state during probe we add a reset call.
This change was prompted by users of kdump who was not able to bring up the
wireless driver in the kdump kernel. The problem here was that the primary
kernel, which is not running at the time, left the wireless card up and
running. When the kdump kernel starts it is thus possible to immediately
receive interrupts from firmware after registering interrupt, but without
being ready to deal with interrupts from firmware yet.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c1eff4c..31b156d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3540,6 +3540,14 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	spin_lock_init(&priv->reg_lock);
 	spin_lock_init(&priv->lock);
+
+	/*
+	 * stop and reset the on-board processor just in case it is in a
+	 * strange state ... like being left stranded by a primary kernel
+	 * and this is now the kdump kernel trying to start up
+	 */
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
 	iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f6e8f45..7af8ab8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4039,6 +4039,13 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	spin_lock_init(&priv->reg_lock);
 	spin_lock_init(&priv->lock);
 
+	/*
+	 * stop and reset the on-board processor just in case it is in a
+	 * strange state ... like being left stranded by a primary kernel
+	 * and this is now the kdump kernel trying to start up
+	 */
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
 	/***********************
 	 * 4. Read EEPROM
 	 * ********************/
-- 
1.6.3.3

