Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZJPVZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/10] iwlwifi: set auto clock gate disable bit for 6x00/6x50 series
Date: Fri, 16 Oct 2009 14:25:56 -0700
Message-Id: <1255728358-29976-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6x00 and 6x50 series NIC with OTP shadow RAM, set auto clock gate
disable bit when initializing OTP access.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 ++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 401e1e0..b6ed5a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -109,8 +109,9 @@
  * Bit fields:
  *  3-2:  0 = A, 1 = B, 2 = C, 3 = D step
  */
-#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
-#define CSR_DBG_HPET_MEM_REG	(CSR_BASE+0x240)
+#define CSR_HW_REV_WA_REG		(CSR_BASE+0x22C)
+#define CSR_DBG_HPET_MEM_REG		(CSR_BASE+0x240)
+#define CSR_DBG_LINK_PWR_MGMT_REG	(CSR_BASE+0x250)
 
 /* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR49_HW_IF_CONFIG_REG_BIT_4965_R	(0x00000010)
@@ -195,6 +196,7 @@
 #define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
 #define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
 #define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
+#define CSR_RESET_LINK_PWR_MGMT_DISABLED             (0x80000000)
 
 /* GP (general purpose) CONTROL */
 #define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 2e8c405..9429cb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -358,6 +358,14 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 		udelay(5);
 		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				    APMG_PS_CTRL_VAL_RESET_REQ);
+
+		/*
+		 * CSR auto clock gate disable bit -
+		 * this is only applicable for HW with OTP shadow RAM
+		 */
+		if (priv->cfg->shadow_ram_support)
+			iwl_set_bit(priv, CSR_DBG_LINK_PWR_MGMT_REG,
+				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
 	return ret;
 }
-- 
1.5.6.3

