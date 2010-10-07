Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0JGXIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/22] iwlwifi: remove set_pwr_src operation
Date: Thu,  7 Oct 2010 16:07:54 -0700
Message-Id: <1286492881-15743-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The set_pwr_src operation is only ever used from
within the same sub-driver that it is declared
in, so it can just be called directly instead of
being an operation. Also, it is never called to
set the power source to V_aux, so change the two
functions accordingly (but keep the V_aux code
for documentation purposes in a comment).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c    |   26 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   19 ++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   16 ----------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    8 --------
 9 files changed, 30 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8aed9ea..5bdfe9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -196,7 +196,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl1000_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ba3ab04..824c942 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -816,9 +816,12 @@ static u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate)
 	return sta_id;
 }
 
-static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
+static void iwl3945_set_pwr_vmain(struct iwl_priv *priv)
 {
-	if (src == IWL_PWR_SRC_VAUX) {
+/*
+ * (for documentation purposes)
+ * to set power to V_AUX, do
+
 		if (pci_pme_capable(priv->pci_dev, PCI_D3cold)) {
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
@@ -828,16 +831,14 @@ static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
 		}
-	} else {
-		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-				~APMG_PS_CTRL_MSK_PWR_SRC);
+ */
 
-		iwl_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
-			     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
-	}
+	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+			APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+			~APMG_PS_CTRL_MSK_PWR_SRC);
 
-	return 0;
+	iwl_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
+		     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
 }
 
 static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
@@ -1031,9 +1032,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	priv->cfg->ops->lib->apm_ops.init(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	rc = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
-	if (rc)
-		return rc;
+	iwl3945_set_pwr_vmain(priv);
 
 	priv->cfg->ops->lib->apm_ops.config(priv);
 
@@ -2707,7 +2706,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 		.init = iwl3945_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl3945_nic_config,
-		.set_pwr_src = iwl3945_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c192856..cda4a31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2268,7 +2268,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl4965_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 084271e..c90a16c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -370,7 +370,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
@@ -440,7 +439,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 84f1814..02103a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -310,7 +310,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
@@ -383,7 +382,6 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ff5f2fc..0ad0d44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -685,6 +685,23 @@ int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	return 0;
 }
 
+static void iwlagn_set_pwr_vmain(struct iwl_priv *priv)
+{
+/*
+ * (for documentation purposes)
+ * to set power to V_AUX, do:
+
+		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+					       ~APMG_PS_CTRL_MSK_PWR_SRC);
+ */
+
+	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+			       ~APMG_PS_CTRL_MSK_PWR_SRC);
+}
+
 int iwlagn_hw_nic_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -700,7 +717,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+	iwlagn_set_pwr_vmain(priv);
 
 	priv->cfg->ops->lib->apm_ops.config(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8233c64..75472a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -935,22 +935,6 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 		wake_up_interruptible(&priv->wait_command_queue);
 }
 
-int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
-{
-	if (src == IWL_PWR_SRC_VAUX) {
-		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
-			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-					       ~APMG_PS_CTRL_MSK_PWR_SRC);
-	} else {
-		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-				       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-				       ~APMG_PS_CTRL_MSK_PWR_SRC);
-	}
-
-	return 0;
-}
-
 static void iwl_bg_tx_flush(struct work_struct *work)
 {
 	struct iwl_priv *priv =
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f3c3d85..ae77279 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -119,7 +119,6 @@ struct iwl_apm_ops {
 	int (*init)(struct iwl_priv *priv);
 	void (*stop)(struct iwl_priv *priv);
 	void (*config)(struct iwl_priv *priv);
-	int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 };
 
 struct iwl_debugfs_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2b04714..2c57dbd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -282,13 +282,6 @@ struct iwl_channel_info {
  */
 #define IWL_IPAN_MCAST_QUEUE		8
 
-/* Power management (not Tx power) structures */
-
-enum iwl_pwr_src {
-	IWL_PWR_SRC_VMAIN,
-	IWL_PWR_SRC_VAUX,
-};
-
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
@@ -732,7 +725,6 @@ struct iwl_hw_params {
  *
  ****************************************************************************/
 extern void iwl_update_chain_flags(struct iwl_priv *priv);
-extern int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
 extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
-- 
1.7.0.4

