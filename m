Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51299 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbYDXSzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 19/21] iwlwifi-5000: add nic config handler for 5000 HW
Date: Thu, 24 Apr 2008 11:55:36 -0700
Message-Id: <1209063338-6572-20-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205637_492576_C98A405E)
In-Reply-To: <1209063338-6572-19-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-15-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-16-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-17-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-18-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-19-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds nic config handler for 5000 HW Family

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   33 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d8e3dd7..df62835 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -86,6 +86,38 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
+static void iwl5000_nic_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	u16 radio_cfg;
+	u8 val_link;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
+
+	/* disable L1 entry -- workaround for pre-B1 */
+	pci_write_config_byte(priv->pci_dev, PCI_LINK_CTRL, val_link & ~0x02);
+
+	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+
+	/* write radio config values to register */
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) < EEPROM_5000_RF_CFG_TYPE_MAX)
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+
+	/* set CSR_HW_CONFIG_REG for uCode use */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+
+
 /*
  * EEPROM
  */
@@ -407,6 +439,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
+		.config = iwl5000_nic_init,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 06ed300..dc1f027 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -295,6 +295,7 @@ struct iwl_eeprom_calib_info {
 
 #define EEPROM_3945_RF_CFG_TYPE_MAX  0x0
 #define EEPROM_4965_RF_CFG_TYPE_MAX  0x1
+#define EEPROM_5000_RF_CFG_TYPE_MAX  0x3
 
 /*
  * Per-channel regulatory data.
-- 
1.5.3.4

