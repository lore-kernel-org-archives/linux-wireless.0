Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab0AVWXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/17] iwlwifi: reorder device setup
Date: Fri, 22 Jan 2010 14:22:53 -0800
Message-Id: <1264198978-5915-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

It is better to first notify cfg80211 about the hw
rfkill state (so the rfkill device that will be
registered won't have the wrong state while being
registered), and the power/tt variable init can
(and probably should) also be done first.

Also rename iwl_setup_mac to
iwl_mac_setup_register to better describe what it
really does.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 537837b..6ea2238 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2608,7 +2608,7 @@ void iwl_post_associate(struct iwl_priv *priv)
  * Not a mac80211 entry point function, but it fits in with all the
  * other mac80211 functions grouped here.
  */
-static int iwl_setup_mac(struct iwl_priv *priv)
+static int iwl_mac_setup_register(struct iwl_priv *priv)
 {
 	int ret;
 	struct ieee80211_hw *hw = priv->hw;
@@ -3621,9 +3621,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
 
-	/**********************************
-	 * 8. Setup and register mac80211
-	 **********************************/
+	/*********************************************
+	 * 8. Enable interrupts and read RFKILL state
+	 *********************************************/
 
 	/* enable interrupts if needed: hw bug w/a */
 	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
@@ -3634,14 +3634,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	iwl_enable_interrupts(priv);
 
-	err = iwl_setup_mac(priv);
-	if (err)
-		goto out_remove_sysfs;
-
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err)
-		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
-
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -3653,6 +3645,18 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
+
+	/**************************************************
+	 * 9. Setup and register with mac80211 and debugfs
+	 **************************************************/
+	err = iwl_mac_setup_register(priv);
+	if (err)
+		goto out_remove_sysfs;
+
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err)
+		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
+
 	return 0;
 
  out_remove_sysfs:
-- 
1.6.3.3

