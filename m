Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FFNXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/29] iwlwifi: fix rf configuration
Date: Wed,  6 Jun 2012 15:22:04 +0200
Message-Id: <1338988930-11561-23-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152323_604373_571F4937)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Johannes noticed this was completely messed up.
We got confused between masks and bit position.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/eeprom.c |   17 +++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-csr.h    |   16 ++++++++++++++--
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/eeprom.c b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
index b4da76d..b382b16 100644
--- a/drivers/net/wireless/iwlwifi/dvm/eeprom.c
+++ b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
@@ -1136,10 +1136,19 @@ void iwl_rf_config(struct iwl_priv *priv)
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
-		iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
-			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+		u32 reg_val =
+			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE |
+			EEPROM_RF_CFG_STEP_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_STEP |
+			EEPROM_RF_CFG_DASH_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
+
+		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
+
 		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
 			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
 			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 5975054..41dc691 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -155,9 +155,21 @@
 #define CSR_DBG_LINK_PWR_MGMT_REG	(CSR_BASE+0x250)
 
 /* Bits for CSR_HW_IF_CONFIG_REG */
-#define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
-#define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI 	(0x00000100)
+#define CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH	(0x00000003)
+#define CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP	(0x0000000C)
+#define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x000000C0)
+#define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
 #define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
+#define CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE	(0x00000C00)
+#define CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH	(0x00003000)
+#define CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP	(0x0000C000)
+
+#define CSR_HW_IF_CONFIG_REG_POS_MAC_DASH	(0)
+#define CSR_HW_IF_CONFIG_REG_POS_MAC_STEP	(2)
+#define CSR_HW_IF_CONFIG_REG_POS_BOARD_VER	(6)
+#define CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE	(10)
+#define CSR_HW_IF_CONFIG_REG_POS_PHY_DASH	(12)
+#define CSR_HW_IF_CONFIG_REG_POS_PHY_STEP	(14)
 
 #define CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A	(0x00080000)
 #define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM	(0x00200000)
-- 
1.7.10

