Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbZJBUtw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/13] iwlwifi: validate the signature for EEPROM and OTP
Date: Fri,  2 Oct 2009 13:44:06 -0700
Message-Id: <1254516247-4085-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Both 1000 & 6000 series NICs contain on-chip OTP memory that
replaces the off-chip EEPROM memory. The nature of OTP means
there is a limited number of times a particular board can go through the
factory flow and be (re)calibrated. As a consequence there will be some boards
that contain EEPROM memory because OTP blocks were full.

In the signature validation routine, iwlwifi needs to make sure
"select bit" and "EEPROM/OTP signature" agree on the type of
NVM to be used to configure the system.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    |    7 +++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   33 ++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 06437d1..8f183e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -230,13 +230,18 @@
 
 /* EEPROM GP */
 #define CSR_EEPROM_GP_VALID_MSK		(0x00000007)
-#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
 #define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
 #define CSR_OTP_GP_REG_DEVICE_SELECT	(0x00010000) /* 0 - EEPROM, 1 - OTP */
 #define CSR_OTP_GP_REG_OTP_ACCESS_MODE	(0x00020000) /* 0 - absolute, 1 - relative */
 #define CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK          (0x00100000) /* bit 20 */
 #define CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK        (0x00200000) /* bit 21 */
 
+/* EEPROM signature */
+#define CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP	(0x00000000)
+#define CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP		(0x00000001)
+#define CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K		(0x00000002)
+#define CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K		(0x00000004)
+
 /* CSR GIO */
 #define CSR_GIO_REG_VAL_L0S_ENABLED	(0x00000002)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 6e83312..2e8c405 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -215,12 +215,35 @@ static const struct iwl_txpwr_section enhinfo[] = {
 
 int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 {
-	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
-	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
-		return -ENOENT;
+	u32 gp = iwl_read32(priv, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+	int ret = 0;
+
+	IWL_DEBUG_INFO(priv, "EEPROM signature=0x%08x\n", gp);
+	switch (gp) {
+	case CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP:
+		if (priv->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
+			IWL_ERR(priv, "EEPROM with bad signature: 0x%08x\n",
+				gp);
+			ret = -ENOENT;
+		}
+		break;
+	case CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K:
+	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
+		if (priv->nvm_device_type != NVM_DEVICE_TYPE_EEPROM) {
+			IWL_ERR(priv, "OTP with bad signature: 0x%08x\n", gp);
+			ret = -ENOENT;
+		}
+		break;
+	case CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP:
+	default:
+		IWL_ERR(priv, "bad EEPROM/OTP signature, type=%s, "
+			"EEPROM_GP=0x%08x\n",
+			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			? "OTP" : "EEPROM", gp);
+		ret = -ENOENT;
+		break;
 	}
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(iwlcore_eeprom_verify_signature);
 
-- 
1.5.6.3

