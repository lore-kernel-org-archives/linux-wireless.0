Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab0GaQyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/8] iwlwifi: make iwl_hw_detect static to _agn
Date: Sat, 31 Jul 2010 08:34:05 -0700
Message-Id: <1280590452-10655-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

iwl_hw_detect() only used by _agn, make it static

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 --------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 35337b1..74b917c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3925,6 +3925,13 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.flush = iwl_mac_flush,
 };
 
+static void iwl_hw_detect(struct iwl_priv *priv)
+{
+	priv->hw_rev = _iwl_read32(priv, CSR_HW_REV);
+	priv->hw_wa_rev = _iwl_read32(priv, CSR_HW_REV_WA_REG);
+	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &priv->rev_id);
+}
+
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8024d44..dbc279d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -183,14 +183,6 @@ out:
 }
 EXPORT_SYMBOL(iwl_alloc_all);
 
-void iwl_hw_detect(struct iwl_priv *priv)
-{
-	priv->hw_rev = _iwl_read32(priv, CSR_HW_REV);
-	priv->hw_wa_rev = _iwl_read32(priv, CSR_HW_REV_WA_REG);
-	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &priv->rev_id);
-}
-EXPORT_SYMBOL(iwl_hw_detect);
-
 /*
  * QoS  support
 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e9d23f2..7e51a9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -346,7 +346,6 @@ struct iwl_cfg {
 
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
-void iwl_hw_detect(struct iwl_priv *priv);
 void iwl_activate_qos(struct iwl_priv *priv);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
-- 
1.7.0.4

