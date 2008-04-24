Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674AbYDXSzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/21] iwlwifi: remove 49 prefix from general CSR values
Date: Thu, 24 Apr 2008 11:55:19 -0700
Message-Id: <1209063338-6572-3-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205621_268911_AD953377)
In-Reply-To: <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch change CSR49_ to CSR_ for values used in
other HW

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 99c08ea..b1b7363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -618,8 +618,8 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 		    CSR49_HW_IF_CONFIG_REG_BIT_4965_R |
-		    CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI);
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	ret = iwl_grab_nic_access(priv);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index df9949a..f8de32b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -106,9 +106,9 @@
 
 /* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR49_HW_IF_CONFIG_REG_BIT_4965_R	(0x00000010)
-#define CSR49_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
-#define CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
-#define CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
+#define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
+#define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI 	(0x00000100)
+#define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
 
 #define CSR39_HW_IF_CONFIG_REG_BIT_3945_MB         (0x00000100)
 #define CSR39_HW_IF_CONFIG_REG_BIT_3945_MM         (0x00000200)
-- 
1.5.3.4

