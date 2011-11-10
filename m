Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab1KJBdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 28/28] iwlagn: move nvm_device_type from iwl_priv to iwl_trans
Date: Wed,  9 Nov 2011 16:39:31 -0800
Message-Id: <1320885571-19122-29-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023348_324028_D7F11E0A)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The nvm_device_type is eeprom related and does not need to be part
of the iwl_priv structure.  Move it and eliminate access to the iwl_priv
structure.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c  |   28 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-trans.h   |    3 +++
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 42871ba..68b04f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -430,7 +430,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
 	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s, "
 			"version: 0x%x\n",
-			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			(trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 			 ? "OTP" : "EEPROM", eeprom_ver);
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2c68b9b..556e4a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -944,7 +944,6 @@ struct iwl_priv {
 
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
-	int    nvm_device_type;
 	struct iwl_eeprom_calib_info *calib_info;
 
 	enum nl80211_iftype iw_mode;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 2fcde58..dcada08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -182,32 +182,32 @@ static void iwl_eeprom_release_semaphore(struct iwl_bus *bus)
 
 }
 
-static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
+static int iwl_eeprom_verify_signature(struct iwl_trans *trans)
 {
-	u32 gp = iwl_read32(bus(priv), CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+	u32 gp = iwl_read32(bus(trans), CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
-	IWL_DEBUG_EEPROM(priv, "EEPROM signature=0x%08x\n", gp);
+	IWL_DEBUG_EEPROM(trans, "EEPROM signature=0x%08x\n", gp);
 	switch (gp) {
 	case CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP:
-		if (priv->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
-			IWL_ERR(priv, "EEPROM with bad signature: 0x%08x\n",
+		if (trans->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
+			IWL_ERR(trans, "EEPROM with bad signature: 0x%08x\n",
 				gp);
 			ret = -ENOENT;
 		}
 		break;
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K:
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
-		if (priv->nvm_device_type != NVM_DEVICE_TYPE_EEPROM) {
-			IWL_ERR(priv, "OTP with bad signature: 0x%08x\n", gp);
+		if (trans->nvm_device_type != NVM_DEVICE_TYPE_EEPROM) {
+			IWL_ERR(trans, "OTP with bad signature: 0x%08x\n", gp);
 			ret = -ENOENT;
 		}
 		break;
 	case CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP:
 	default:
-		IWL_ERR(priv, "bad EEPROM/OTP signature, type=%s, "
+		IWL_ERR(trans, "bad EEPROM/OTP signature, type=%s, "
 			"EEPROM_GP=0x%08x\n",
-			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			(trans->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 			? "OTP" : "EEPROM", gp);
 		ret = -ENOENT;
 		break;
@@ -660,8 +660,8 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	priv->nvm_device_type = iwl_get_nvm_type(bus(priv), hw_rev);
-	if (priv->nvm_device_type == -ENOENT)
+	trans(priv)->nvm_device_type = iwl_get_nvm_type(bus(priv), hw_rev);
+	if (trans(priv)->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
 	sz = priv->cfg->base_params->eeprom_size;
@@ -675,7 +675,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 
 	iwl_apm_init(priv);
 
-	ret = iwl_eeprom_verify_signature(priv);
+	ret = iwl_eeprom_verify_signature(trans(priv));
 	if (ret < 0) {
 		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
@@ -690,7 +690,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		goto err;
 	}
 
-	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
+	if (trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
 		ret = iwl_init_otp_access(bus(priv));
 		if (ret) {
@@ -744,7 +744,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	}
 
 	IWL_DEBUG_EEPROM(priv, "NVM Type: %s, version: 0x%x\n",
-		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+		       (trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 		       ? "OTP" : "EEPROM",
 		       iwl_eeprom_query16(priv, EEPROM_VERSION));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7839362..50227eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -247,6 +247,9 @@ struct iwl_trans {
 	struct fw_img ucode_init;
 	struct fw_img ucode_wowlan;
 
+	/* eeprom related variables */
+	int    nvm_device_type;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __attribute__((__aligned__(sizeof(void *))));
-- 
1.7.0.4

