Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D78395AD3
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754907; cv=none; b=HQWJR389JmoTXVqtVbsFpW02C9LA3HZ8n/hloVp17EWaPc6pVK0r6Sj/wvfvenqq+ecA9Seo6/oh+LHa7aOlZA3IPlYfbVPZAd/x3l/H5m6ZPnxuFI3xmZliukYU/SR3pLvIx4N9QAOXAmdI7GMipcd2WPl+nvpB8oX87Bfv1po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754907; c=relaxed/simple;
	bh=UyNdJQmHPBhjEyK/y/sWb8EQkJzi/7nG2jd0eZiVOVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q/yEBmqM5YyW8RuYbKewWzJ79c7UfYLSKnqC61QDJTCX26AHCfTON6HHJXKHfldyUwJraCeK2M8Ka/x+nBBpFeAKSXhQcuQJzSC+b6+nWG5pKDAYtOY6a5E6R4Z5bhHERrJbLfN+1hcvDhgzwAO9yH4zHLqjykroB646W6MKyvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PInMB3nm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PInMB3nm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754902; x=1822290902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UyNdJQmHPBhjEyK/y/sWb8EQkJzi/7nG2jd0eZiVOVY=;
  b=PInMB3nmVfrY75fd5vSWlJk1QuKQmQTGg8ePJGvp5rlswAli5cBWLz+e
   XyDcCSUplVQKUjyymXQgKhWwk1IUND/NR9ud5AlGASCWtdOaxB/6wAKxH
   iascN4I/NhdJ9cRIqnDz/i4QBESgihqq1xGQYqqP4jKdobMOXqZ0HOkMd
   uN1pZkQUeP1RC8qsG6gzhKL51+g66/WvfLz+/2KO8wGxueV8zYlgbkyjd
   wVJnWOxdEGhcEUpoHYnh1dK2jKmZg2TSbCa5epVTNQsh+6weELW1kqoCD
   N4ScuxoruDeBaeFRqmU03iwnuiGuebnkXyZygrssoRZYJjtMyU8YXKU2Z
   g==;
X-CSE-ConnectionGUID: bITRBHRSRTm3Hs6z/tziRw==
X-CSE-MsgGUID: +tATOoHTQ8Sc41VdLBlw7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296828"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296828"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:02 -0700
X-CSE-ConnectionGUID: JSKBXC0iT0yXqujV1ISBAg==
X-CSE-MsgGUID: 9R5AmET4RkKjSMYZnyNKfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962941"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:01 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: rename io helpers to iwl_trans_ prefix
Date: Wed, 30 Sep 2026 10:56:38 +0300
Message-Id: <20260930104825.9d4850befbc7.Ie580d7156b6b0175bf45e24c93dd4cce1da065ea@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

The iwl-io is a wrapper layer for all the device memory access
operations.

But all it really does is either a combination of other operations, or
tracing and calling the trans function, which calls the bus-specific
implementation.
This makes the code hard to follow.

Those helpers are really part of the transports functionality, so
there is no reason to keep this complexity.

This and the following commit will remove iwl-io.c/h: this renames the
functions to have the trans prefix,
and a next one will move them to iwl-trans.

No functional change.

Assisted-by: GitHubCopilot:claude-opus-4.8
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/dvm/devices.c  |  24 +-
 .../net/wireless/intel/iwlwifi/dvm/eeprom.c   |  56 +--
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  32 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  32 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |  50 +--
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h  |  21 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  12 +-
 drivers/net/wireless/intel/iwlwifi/mld/fw.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   6 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   2 +-
 .../intel/iwlwifi/pcie/ctxt-info-v2.c         |   4 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  16 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  58 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 372 +++++++++---------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  74 ++--
 .../net/wireless/intel/iwlwifi/pcie/utils.c   |   4 +-
 26 files changed, 426 insertions(+), 425 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index b40a769f8e2d..c22f68db3e83 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -45,10 +45,10 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
 	/* Setting digital SVR for 1000 card to 1.32V */
-	/* locking is acquired in iwl_set_bits_mask_prph() function */
-	iwl_set_bits_mask_prph(priv->trans, APMG_DIGITAL_SVR_REG,
-				APMG_SVR_DIGITAL_VOLTAGE_1_32,
-				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
+	/* locking is acquired in iwl_trans_set_bits_mask_prph() function */
+	iwl_trans_set_bits_mask_prph(priv->trans, APMG_DIGITAL_SVR_REG,
+				     APMG_SVR_DIGITAL_VOLTAGE_1_32,
+				     ~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
 }
 
 /**
@@ -184,8 +184,8 @@ static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 2000 series */
 static void iwl2000_nic_config(struct iwl_priv *priv)
 {
-	iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
-		    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
+	iwl_trans_set_bit(priv->trans, CSR_GP_DRIVER_REG,
+			  CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
 
 static const struct iwl_sensitivity_ranges iwl2000_sensitivity = {
@@ -496,16 +496,16 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 	case IWL_DEVICE_FAMILY_6050:
 		/* Indicate calibration version to uCode. */
 		if (priv->nvm_data->calib_version >= 6)
-			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
-					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
+			iwl_trans_set_bit(priv->trans, CSR_GP_DRIVER_REG,
+					  CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 		break;
 	case IWL_DEVICE_FAMILY_6150:
 		/* Indicate calibration version to uCode. */
 		if (priv->nvm_data->calib_version >= 6)
-			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
-					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-		iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
-			    CSR_GP_DRIVER_REG_BIT_6050_1x2);
+			iwl_trans_set_bit(priv->trans, CSR_GP_DRIVER_REG,
+					  CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
+		iwl_trans_set_bit(priv->trans, CSR_GP_DRIVER_REG,
+				  CSR_GP_DRIVER_REG_BIT_6050_1x2);
 		break;
 	default:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c b/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
index d20691f7d82f..aa532635e414 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
@@ -672,13 +672,13 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_trans *trans)
 
 	for (count = 0; count < IWL_EEPROM_SEM_RETRY_LIMIT; count++) {
 		/* Request semaphore */
-		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_EEPROM_OWN_SEM);
+		iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_bits(trans, CSR_HW_IF_CONFIG_REG,
-				    CSR_HW_IF_CONFIG_REG_EEPROM_OWN_SEM,
-				    IWL_EEPROM_SEM_TIMEOUT);
+		ret = iwl_trans_poll_bits(trans, CSR_HW_IF_CONFIG_REG,
+					  CSR_HW_IF_CONFIG_REG_EEPROM_OWN_SEM,
+					  IWL_EEPROM_SEM_TIMEOUT);
 		if (!ret) {
 			IWL_DEBUG_EEPROM(trans->dev,
 					 "Acquired semaphore after %d tries.\n",
@@ -692,8 +692,8 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_trans *trans)
 
 static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
 {
-	iwl_clear_bit(trans, CSR_HW_IF_CONFIG_REG,
-		      CSR_HW_IF_CONFIG_REG_EEPROM_OWN_SEM);
+	iwl_trans_clear_bit(trans, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_EEPROM_OWN_SEM);
 }
 
 static int iwl_eeprom_verify_signature(struct iwl_trans *trans, bool nvm_is_otp)
@@ -736,8 +736,8 @@ static void iwl_set_otp_access_absolute(struct iwl_trans *trans)
 {
 	iwl_trans_read32(trans, CSR_OTP_GP_REG);
 
-	iwl_clear_bit(trans, CSR_OTP_GP_REG,
-		      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
+	iwl_trans_clear_bit(trans, CSR_OTP_GP_REG,
+			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
 static int iwl_nvm_is_otp(struct iwl_trans *trans)
@@ -770,19 +770,19 @@ static int iwl_init_otp_access(struct iwl_trans *trans)
 	if (ret)
 		return ret;
 
-	iwl_set_bits_prph(trans, APMG_PS_CTRL_REG,
-			  APMG_PS_CTRL_VAL_RESET_REQ);
+	iwl_trans_set_bits_prph(trans, APMG_PS_CTRL_REG,
+				APMG_PS_CTRL_VAL_RESET_REQ);
 	udelay(5);
-	iwl_clear_bits_prph(trans, APMG_PS_CTRL_REG,
-			    APMG_PS_CTRL_VAL_RESET_REQ);
+	iwl_trans_clear_bits_prph(trans, APMG_PS_CTRL_REG,
+				  APMG_PS_CTRL_VAL_RESET_REQ);
 
 	/*
 	 * CSR auto clock gate disable bit -
 	 * this is only applicable for HW with OTP shadow RAM
 	 */
 	if (trans->mac_cfg->base->shadow_ram_support)
-		iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-			    CSR_RESET_LINK_PWR_MGMT_DISABLED);
+		iwl_trans_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+				  CSR_RESET_LINK_PWR_MGMT_DISABLED);
 
 	return 0;
 }
@@ -796,9 +796,9 @@ static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
 
 	iwl_trans_write32(trans, CSR_EEPROM_REG,
 			  CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_bits(trans, CSR_EEPROM_REG,
-			    CSR_EEPROM_REG_READ_VALID_MSK,
-			    IWL_EEPROM_ACCESS_TIMEOUT);
+	ret = iwl_trans_poll_bits(trans, CSR_EEPROM_REG,
+				  CSR_EEPROM_REG_READ_VALID_MSK,
+				  IWL_EEPROM_ACCESS_TIMEOUT);
 	if (ret) {
 		IWL_ERR(trans, "Time out reading OTP[%d]\n", addr);
 		return ret;
@@ -809,16 +809,16 @@ static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
 		/* set the uncorrectable OTP ECC bit for acknowledgment */
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
-			    CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
+		iwl_trans_set_bit(trans, CSR_OTP_GP_REG,
+				  CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		IWL_ERR(trans, "Uncorrectable OTP ECC error, abort OTP read\n");
 		return -EINVAL;
 	}
 	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
 		/* continue in this case */
 		/* set the correctable OTP ECC bit for acknowledgment */
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
-			    CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
+		iwl_trans_set_bit(trans, CSR_OTP_GP_REG,
+				  CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
 		IWL_ERR(trans, "Correctable OTP ECC error, continue read\n");
 	}
 	*eeprom_data = cpu_to_le16(r >> 16);
@@ -964,9 +964,9 @@ int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
 				  iwl_trans_read32(trans, CSR_EEPROM_GP) &
 				  ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
-			    CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
-			    CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
+		iwl_trans_set_bit(trans, CSR_OTP_GP_REG,
+				  CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
+				  CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
 		if (!trans->mac_cfg->base->shadow_ram_support) {
 			ret = iwl_find_otp_image(trans, &validblockaddr);
@@ -991,9 +991,9 @@ int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
 			iwl_trans_write32(trans, CSR_EEPROM_REG,
 					  CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_bits(trans, CSR_EEPROM_REG,
-					    CSR_EEPROM_REG_READ_VALID_MSK,
-					    IWL_EEPROM_ACCESS_TIMEOUT);
+			ret = iwl_trans_poll_bits(trans, CSR_EEPROM_REG,
+						  CSR_EEPROM_REG_READ_VALID_MSK,
+						  IWL_EEPROM_ACCESS_TIMEOUT);
 			if (ret) {
 				IWL_ERR(trans,
 					"Time out reading EEPROM[%d]\n", addr);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 9bf16950ebf0..b3f73c773abe 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -2028,17 +2028,17 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 	}
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	iwl_trans_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
+			  CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+			  CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* W/A : NIC is stuck in a reset state after Early PCIe power off
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
 	 */
-	iwl_set_bits_mask_prph(priv->trans, APMG_PS_CTRL_REG,
-			       APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
-			       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
+	iwl_trans_set_bits_mask_prph(priv->trans, APMG_PS_CTRL_REG,
+				     APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
+				     ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
 	if (priv->lib->nic_config)
 		priv->lib->nic_config(priv);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 79ee4fb239b2..77aa7e04854f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -485,14 +485,14 @@ static void iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 		iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
 				  CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		iwl_write_direct32(priv->trans, HBUS_TARG_MBX_C,
-					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
+		iwl_trans_write_direct32(priv->trans, HBUS_TARG_MBX_C,
+					 HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
 			iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
 					  CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			iwl_write_direct32(priv->trans, HBUS_TARG_MBX_C,
-					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
+			iwl_trans_write_direct32(priv->trans, HBUS_TARG_MBX_C,
+						 HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
 		if (flags & CT_CARD_DISABLED)
 			iwl_tt_enter_ct_kill(priv);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 3a0318070bfb..8827e4f317f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -159,7 +159,7 @@ static int iwl_dump_ini_prph_phy_iter_common(struct iwl_fw_runtime *fwrt,
 	indirect_rd_addr += le32_to_cpu(offset);
 
 	dphy_addr = (offset) ? WFPM_LMAC2_PS_CTL_RW : WFPM_LMAC1_PS_CTL_RW;
-	dphy_state = iwl_read_umac_prph_no_grab(fwrt->trans, dphy_addr);
+	dphy_state = iwl_trans_read_umac_prph_no_grab(fwrt->trans, dphy_addr);
 
 	for (i = 0; i < le32_to_cpu(size); i += 4) {
 		if (dphy_state == HBUS_TIMEOUT ||
@@ -508,7 +508,7 @@ iwl_dump_ini_prph_snps_dphyip_iter(struct iwl_fw_runtime *fwrt,
 	indirect_rd_wr_addr += le32_to_cpu(offset);
 
 	dphy_addr = offset ? WFPM_LMAC2_PS_CTL_RW : WFPM_LMAC1_PS_CTL_RW;
-	dphy_state = iwl_read_umac_prph_no_grab(fwrt->trans, dphy_addr);
+	dphy_state = iwl_trans_read_umac_prph_no_grab(fwrt->trans, dphy_addr);
 
 	for (i = 0; i < le32_to_cpu(reg->dev_addr.size); i += 4) {
 		if (dphy_state == HBUS_TIMEOUT ||
@@ -586,13 +586,13 @@ static void iwl_ini_get_rxf_data(struct iwl_fw_runtime *fwrt,
 		switch (fifo_idx) {
 		case 0:
 			data->size = fwrt->smem_cfg.rxfifo2_size;
-			data->offset = iwl_umac_prph(fwrt->trans,
-						     RXF_DIFF_FROM_PREV);
+			data->offset = iwl_trans_umac_prph(fwrt->trans,
+							   RXF_DIFF_FROM_PREV);
 			break;
 		case 1:
 			data->size = fwrt->smem_cfg.rxfifo2_control_size;
-			data->offset = iwl_umac_prph(fwrt->trans,
-						     RXF2C_DIFF_FROM_PREV);
+			data->offset = iwl_trans_umac_prph(fwrt->trans,
+							   RXF2C_DIFF_FROM_PREV);
 			break;
 		}
 	}
@@ -2381,21 +2381,21 @@ static void iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
 				      struct iwl_fw_dbg_params *params)
 {
 	if (trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
+		iwl_trans_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
 		return;
 	}
 
 	if (params) {
-		params->in_sample = iwl_read_umac_prph(trans, DBGC_IN_SAMPLE);
-		params->out_ctrl = iwl_read_umac_prph(trans, DBGC_OUT_CTRL);
+		params->in_sample = iwl_trans_read_umac_prph(trans, DBGC_IN_SAMPLE);
+		params->out_ctrl = iwl_trans_read_umac_prph(trans, DBGC_OUT_CTRL);
 	}
 
-	iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, 0);
+	iwl_trans_write_umac_prph(trans, DBGC_IN_SAMPLE, 0);
 	/* wait for the DBGC to finish writing the internal buffer to DRAM to
 	 * avoid halting the HW while writing
 	 */
 	usleep_range(700, 1000);
-	iwl_write_umac_prph(trans, DBGC_OUT_CTRL, 0);
+	iwl_trans_write_umac_prph(trans, DBGC_OUT_CTRL, 0);
 }
 
 static int iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
@@ -2405,12 +2405,12 @@ static int iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 		return -EIO;
 
 	if (trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		iwl_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
-		iwl_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
-		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
+		iwl_trans_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
+		iwl_trans_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
+		iwl_trans_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
 	} else {
-		iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
-		iwl_write_umac_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
+		iwl_trans_write_umac_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
+		iwl_trans_write_umac_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index 7b9e98a21704..deb7af465746 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -309,7 +309,7 @@ static void iwl_fwrt_dump_iml_error_log(struct iwl_fw_runtime *fwrt)
 		return;
 	}
 
-	error = iwl_read_umac_prph(trans, error);
+	error = iwl_trans_read_umac_prph(trans, error);
 
 	IWL_ERR(trans, "IML/ROM dump:\n");
 
@@ -318,11 +318,11 @@ static void iwl_fwrt_dump_iml_error_log(struct iwl_fw_runtime *fwrt)
 
 	IWL_ERR(fwrt, "0x%08X | IML/ROM error/state\n", error);
 	IWL_ERR(fwrt, "0x%08X | IML/ROM data1\n",
-		iwl_read_umac_prph(trans, data1));
+		iwl_trans_read_umac_prph(trans, data1));
 
 	if (fwrt->trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_22000)
 		IWL_ERR(fwrt, "0x%08X | IML/ROM WFPM_AUTH_KEY_0\n",
-			iwl_read_umac_prph(trans, SB_MODIFY_CFG_FLAG));
+			iwl_trans_read_umac_prph(trans, SB_MODIFY_CFG_FLAG));
 }
 
 #define FSEQ_REG(x) { .addr = (x), .str = #x, }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 545a213df71d..6e863059ffa7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -485,8 +485,8 @@ int iwl_pnvm_load(struct iwl_trans *trans,
 				   iwl_pnvm_complete_fn, trans);
 
 	/* kick the doorbell */
-	iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
-			    UREG_DOORBELL_TO_ISR6_PNVM);
+	iwl_trans_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
+				  UREG_DOORBELL_TO_ISR6_PNVM);
 
 	return iwl_wait_notification(notif_wait, &pnvm_wait,
 				     MVM_UCODE_PNVM_TIMEOUT);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index b9f7e791dd37..11f2b31f6df7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -16,7 +16,7 @@
  *
  * Use iwl_trans_write32() and iwl_trans_read32() family to access these registers;
  * these provide simple PCI bus access, without waking up the MAC.
- * Do not use iwl_write_direct32() family for these registers;
+ * Do not use iwl_trans_write_direct32() family for these registers;
  * no need to "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ.
  * The MAC (uCode processor, etc.) does not need to be powered up for accessing
  * the CSR registers.
@@ -501,7 +501,7 @@ enum {
  * to indirectly access device's internal memory or registers that
  * may be powered-down.
  *
- * Use iwl_write_direct32() family for writing to these registers;
+ * Use iwl_trans_write_direct32() family for writing to these registers;
  * A read operation doesn't exist, can be added if needed.
  * host must "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ
  * to make sure the MAC (uCode processor, etc.) is powered up for accessing
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 515d6b2becc9..09965fb39fb6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -13,8 +13,8 @@
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
-int iwl_poll_bits_mask(struct iwl_trans *trans, u32 addr,
-		       u32 bits, u32 mask, int timeout)
+int iwl_trans_poll_bits_mask(struct iwl_trans *trans, u32 addr,
+			     u32 bits, u32 mask, int timeout)
 {
 	int t = 0;
 
@@ -27,18 +27,18 @@ int iwl_poll_bits_mask(struct iwl_trans *trans, u32 addr,
 
 	return -ETIMEDOUT;
 }
-IWL_EXPORT_SYMBOL(iwl_poll_bits_mask);
+IWL_EXPORT_SYMBOL(iwl_trans_poll_bits_mask);
 
-void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
+void iwl_trans_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		iwl_trans_write32(trans, reg, value);
 		iwl_trans_release_nic_access(trans);
 	}
 }
-IWL_EXPORT_SYMBOL(iwl_write_direct32);
+IWL_EXPORT_SYMBOL(iwl_trans_write_direct32);
 
-u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
+u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		u32 val = iwl_trans_read_prph_no_grab(trans, ofs);
@@ -51,9 +51,9 @@ u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 	/* return as if we have a HW timeout/failure */
 	return 0x5a5a5a5a;
 }
-IWL_EXPORT_SYMBOL(iwl_read_prph);
+IWL_EXPORT_SYMBOL(iwl_trans_read_prph);
 
-void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val, u32 delay_ms)
+void iwl_trans_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val, u32 delay_ms)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		mdelay(delay_ms);
@@ -61,9 +61,9 @@ void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val, u32 delay_m
 		iwl_trans_release_nic_access(trans);
 	}
 }
-IWL_EXPORT_SYMBOL(iwl_write_prph_delay);
+IWL_EXPORT_SYMBOL(iwl_trans_write_prph_delay);
 
-void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
+void iwl_trans_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		iwl_trans_write_prph_no_grab(trans, ofs,
@@ -72,10 +72,10 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 		iwl_trans_release_nic_access(trans);
 	}
 }
-IWL_EXPORT_SYMBOL(iwl_set_bits_prph);
+IWL_EXPORT_SYMBOL(iwl_trans_set_bits_prph);
 
-void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
-			    u32 bits, u32 mask)
+void iwl_trans_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
+				  u32 bits, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		iwl_trans_write_prph_no_grab(trans, ofs,
@@ -84,9 +84,9 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 		iwl_trans_release_nic_access(trans);
 	}
 }
-IWL_EXPORT_SYMBOL(iwl_set_bits_mask_prph);
+IWL_EXPORT_SYMBOL(iwl_trans_set_bits_mask_prph);
 
-void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
+void iwl_trans_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	u32 val;
 
@@ -96,4 +96,4 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 		iwl_trans_release_nic_access(trans);
 	}
 }
-IWL_EXPORT_SYMBOL(iwl_clear_bits_prph);
+IWL_EXPORT_SYMBOL(iwl_trans_clear_bits_prph);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index a26c6525ec40..5cb422a4d9de 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -8,65 +8,65 @@
 #include "iwl-devtrace.h"
 #include "iwl-trans.h"
 
-static inline void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+static inline void iwl_trans_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	iwl_trans_set_bits_mask(trans, reg, mask, mask);
 }
 
-static inline void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+static inline void iwl_trans_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	iwl_trans_set_bits_mask(trans, reg, mask, 0);
 }
 
-int iwl_poll_bits_mask(struct iwl_trans *trans, u32 addr,
-		       u32 bits, u32 mask, int timeout);
-static inline int iwl_poll_bits(struct iwl_trans *trans, u32 addr, u32 bits,
-				int timeout)
+int iwl_trans_poll_bits_mask(struct iwl_trans *trans, u32 addr,
+			     u32 bits, u32 mask, int timeout);
+static inline int iwl_trans_poll_bits(struct iwl_trans *trans, u32 addr, u32 bits,
+				      int timeout)
 {
-	return iwl_poll_bits_mask(trans, addr, bits, bits, timeout);
+	return iwl_trans_poll_bits_mask(trans, addr, bits, bits, timeout);
 }
 
-void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
+void iwl_trans_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 
-u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
-void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs,
-			  u32 val, u32 delay_ms);
-static inline void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
+u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs);
+void iwl_trans_write_prph_delay(struct iwl_trans *trans, u32 ofs,
+				u32 val, u32 delay_ms);
+static inline void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 {
-	iwl_write_prph_delay(trans, ofs, val, 0);
+	iwl_trans_write_prph_delay(trans, ofs, val, 0);
 }
 
-void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
-void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
-			    u32 bits, u32 mask);
-void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
+void iwl_trans_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
+void iwl_trans_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
+				  u32 bits, u32 mask);
+void iwl_trans_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 
 /*
  * UMAC periphery address space changed from 0xA00000 to 0xD00000 starting from
  * device family AX200. So peripheries used in families above and below AX200
- * should go through iwl_..._umac_..._prph.
+ * should go through iwl_trans_..._umac_..._prph.
  */
-static inline u32 iwl_umac_prph(struct iwl_trans *trans, u32 ofs)
+static inline u32 iwl_trans_umac_prph(struct iwl_trans *trans, u32 ofs)
 {
 	return ofs + trans->mac_cfg->umac_prph_offset;
 }
 
-static inline u32 iwl_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
+static inline u32 iwl_trans_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
 	return iwl_trans_read_prph_no_grab(trans, ofs +
 					   trans->mac_cfg->umac_prph_offset);
 }
 
-static inline u32 iwl_read_umac_prph(struct iwl_trans *trans, u32 ofs)
+static inline u32 iwl_trans_read_umac_prph(struct iwl_trans *trans, u32 ofs)
 {
-	return iwl_read_prph(trans, ofs + trans->mac_cfg->umac_prph_offset);
+	return iwl_trans_read_prph(trans, ofs + trans->mac_cfg->umac_prph_offset);
 }
 
-static inline void iwl_write_umac_prph(struct iwl_trans *trans, u32 ofs,
-				       u32 val)
+static inline void iwl_trans_write_umac_prph(struct iwl_trans *trans, u32 ofs,
+					     u32 val)
 {
-	iwl_write_prph(trans,  ofs + trans->mac_cfg->umac_prph_offset, val);
+	iwl_trans_write_prph(trans,  ofs + trans->mac_cfg->umac_prph_offset, val);
 }
 
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 9e02a498b5f9..9a8355514c4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1410,7 +1410,7 @@ static int iwl_set_hw_address(struct iwl_trans *trans,
 
 	if (!trans->csme_own)
 		IWL_INFO(trans, "base HW address: %pM, OTP minor version: 0x%x\n",
-			 data->hw_addr, iwl_read_prph(trans, REG_OTP_MINOR));
+			 data->hw_addr, iwl_trans_read_prph(trans, REG_OTP_MINOR));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
index 1eaff898ca3c..22a7da73a918 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2014 Intel Mobile Communications GmbH
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __iwl_scd_h__
 #define __iwl_scd_h__
@@ -13,40 +14,40 @@
 static inline void iwl_scd_txq_set_chain(struct iwl_trans *trans,
 					 u16 txq_id)
 {
-	iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
+	iwl_trans_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
 }
 
 static inline void iwl_scd_txq_enable_agg(struct iwl_trans *trans,
 					  u16 txq_id)
 {
-	iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+	iwl_trans_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
 }
 
 static inline void iwl_scd_txq_disable_agg(struct iwl_trans *trans,
 					   u16 txq_id)
 {
-	iwl_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+	iwl_trans_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
 }
 
 static inline void iwl_scd_disable_agg(struct iwl_trans *trans)
 {
-	iwl_set_bits_prph(trans, SCD_AGGR_SEL, 0);
+	iwl_trans_set_bits_prph(trans, SCD_AGGR_SEL, 0);
 }
 
 static inline void iwl_scd_activate_fifos(struct iwl_trans *trans)
 {
-	iwl_write_prph(trans, SCD_TXFACT, IWL_MASK(0, 7));
+	iwl_trans_write_prph(trans, SCD_TXFACT, IWL_MASK(0, 7));
 }
 
 static inline void iwl_scd_deactivate_fifos(struct iwl_trans *trans)
 {
-	iwl_write_prph(trans, SCD_TXFACT, 0);
+	iwl_trans_write_prph(trans, SCD_TXFACT, 0);
 }
 
 static inline void iwl_scd_enable_set_active(struct iwl_trans *trans,
 					     u32 value)
 {
-	iwl_write_prph(trans, SCD_EN_CTRL, value);
+	iwl_trans_write_prph(trans, SCD_EN_CTRL, value);
 }
 
 static inline unsigned int SCD_QUEUE_WRPTR(unsigned int chnl)
@@ -76,9 +77,9 @@ static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
 static inline void iwl_scd_txq_set_inactive(struct iwl_trans *trans,
 					    u16 txq_id)
 {
-	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
-		       (0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		       (1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+	iwl_trans_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
+			     (0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+			     (1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 123eca3f5d0a..59b4e180825f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -453,14 +453,14 @@ void iwl_trans_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 void iwl_trans_force_nmi(struct iwl_trans *trans)
 {
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_9000)
-		iwl_write_prph_delay(trans, DEVICE_SET_NMI_REG,
-				     DEVICE_SET_NMI_VAL_DRV, 1);
+		iwl_trans_write_prph_delay(trans, DEVICE_SET_NMI_REG,
+					   DEVICE_SET_NMI_VAL_DRV, 1);
 	else if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
-		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
-				    UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER);
+		iwl_trans_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
+					  UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER);
 	else if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_BZ)
-		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
-				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
+		iwl_trans_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
+					  UREG_DOORBELL_TO_ISR6_NMI_BIT);
 	else
 		iwl_trans_write32(trans, CSR_DOORBELL_VECTOR,
 				  UREG_DOORBELL_TO_ISR6_NMI_BIT);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index 7891afd556a8..3b9f412cdff2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -207,11 +207,11 @@ static void iwl_mld_print_alive_notif_timeout(struct iwl_mld *mld)
 
 	IWL_ERR(mld,
 		"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
-		iwl_read_umac_prph(trans, UMAG_SB_CPU_1_STATUS),
-		iwl_read_umac_prph(trans,
-				   UMAG_SB_CPU_2_STATUS));
+		iwl_trans_read_umac_prph(trans, UMAG_SB_CPU_1_STATUS),
+		iwl_trans_read_umac_prph(trans,
+					 UMAG_SB_CPU_2_STATUS));
 #define IWL_FW_PRINT_REG_INFO(reg_name) \
-	IWL_ERR(mld, #reg_name ": 0x%x\n", iwl_read_umac_prph(trans, reg_name))
+	IWL_ERR(mld, #reg_name ": 0x%x\n", iwl_trans_read_umac_prph(trans, reg_name))
 
 	IWL_FW_PRINT_REG_INFO(WFPM_LMAC1_PD_NOTIFICATION);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 95d6f36b9fd9..71832d92024d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -37,7 +37,7 @@ static const struct iwl_op_mode_ops iwl_mld_ops;
 
 int iwl_mld_get_systime(struct iwl_mld *mld, u32 *gp2)
 {
-	*gp2 = iwl_read_prph(mld->trans,
+	*gp2 = iwl_trans_read_prph(mld->trans,
 			     mld->trans->mac_cfg->base->gp2_reg_addr);
 
 	if (*gp2 == 0x5a5a5a5a)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 06502f57e823..48f8bab4dc85 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1548,7 +1548,7 @@ iwl_dbgfs_prph_reg_read(struct file *file,
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Reg 0x%x: (0x%x)\n",
 		mvm->dbgfs_prph_reg_addr,
-		iwl_read_prph(mvm->trans, mvm->dbgfs_prph_reg_addr));
+		iwl_trans_read_prph(mvm->trans, mvm->dbgfs_prph_reg_addr));
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -1569,7 +1569,7 @@ iwl_dbgfs_prph_reg_write(struct iwl_mvm *mvm, char *buf,
 	if (args != 2)
 		return -EINVAL;
 
-	iwl_write_prph(mvm->trans, mvm->dbgfs_prph_reg_addr, value);
+	iwl_trans_write_prph(mvm->trans, mvm->dbgfs_prph_reg_addr, value);
 
 out:
 	return count;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c3402f5e47a0..9b4637a3d1ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -263,7 +263,7 @@ static bool iwl_wait_phy_db_entry(struct iwl_notif_wait_data *notif_wait,
 static void iwl_mvm_print_pd_notification(struct iwl_mvm *mvm)
 {
 #define IWL_FW_PRINT_REG_INFO(reg_name) \
-	IWL_ERR(mvm, #reg_name ": 0x%x\n", iwl_read_umac_prph(trans, reg_name))
+	IWL_ERR(mvm, #reg_name ": 0x%x\n", iwl_trans_read_umac_prph(trans, reg_name))
 
 	struct iwl_trans *trans = mvm->trans;
 	enum iwl_device_family device_family = trans->mac_cfg->device_family;
@@ -332,13 +332,13 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	    IWL_DEVICE_FAMILY_AX210) {
 		/* print these registers regardless of alive fail/success */
 		IWL_INFO(mvm, "WFPM_UMAC_PD_NOTIFICATION: 0x%x\n",
-			 iwl_read_umac_prph(mvm->trans, WFPM_ARC1_PD_NOTIFICATION));
+			 iwl_trans_read_umac_prph(mvm->trans, WFPM_ARC1_PD_NOTIFICATION));
 		IWL_INFO(mvm, "WFPM_LMAC2_PD_NOTIFICATION: 0x%x\n",
-			 iwl_read_umac_prph(mvm->trans, WFPM_LMAC2_PD_NOTIFICATION));
+			 iwl_trans_read_umac_prph(mvm->trans, WFPM_LMAC2_PD_NOTIFICATION));
 		IWL_INFO(mvm, "WFPM_AUTH_KEY_0: 0x%x\n",
-			 iwl_read_umac_prph(mvm->trans, SB_MODIFY_CFG_FLAG));
+			 iwl_trans_read_umac_prph(mvm->trans, SB_MODIFY_CFG_FLAG));
 		IWL_INFO(mvm, "CNVI_SCU_SEQ_DATA_DW9: 0x%x\n",
-			 iwl_read_prph(mvm->trans, CNVI_SCU_SEQ_DATA_DW9));
+			 iwl_trans_read_prph(mvm->trans, CNVI_SCU_SEQ_DATA_DW9));
 	}
 
 	if (ret) {
@@ -349,15 +349,15 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 					IWL_DEVICE_FAMILY_22000) {
 			IWL_ERR(mvm,
 				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
-				iwl_read_umac_prph(trans, UMAG_SB_CPU_1_STATUS),
-				iwl_read_umac_prph(trans,
-						   UMAG_SB_CPU_2_STATUS));
+				iwl_trans_read_umac_prph(trans, UMAG_SB_CPU_1_STATUS),
+				iwl_trans_read_umac_prph(trans,
+							 UMAG_SB_CPU_2_STATUS));
 		} else if (trans->mac_cfg->device_family >=
 			   IWL_DEVICE_FAMILY_8000) {
 			IWL_ERR(mvm,
 				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
-				iwl_read_prph(trans, SB_CPU_1_STATUS),
-				iwl_read_prph(trans, SB_CPU_2_STATUS));
+				iwl_trans_read_prph(trans, SB_CPU_1_STATUS),
+				iwl_trans_read_prph(trans, SB_CPU_2_STATUS));
 		}
 
 		iwl_mvm_print_pd_notification(mvm);
@@ -374,15 +374,15 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		} else if (trans->mac_cfg->device_family >=
 					IWL_DEVICE_FAMILY_9000) {
 			IWL_ERR(mvm, "UMAC PC: 0x%x\n",
-				iwl_read_umac_prph(trans,
-						   UREG_UMAC_CURRENT_PC));
+				iwl_trans_read_umac_prph(trans,
+							 UREG_UMAC_CURRENT_PC));
 			IWL_ERR(mvm, "LMAC PC: 0x%x\n",
-				iwl_read_umac_prph(trans,
-						   UREG_LMAC1_CURRENT_PC));
+				iwl_trans_read_umac_prph(trans,
+							 UREG_LMAC1_CURRENT_PC));
 			if (iwl_mvm_is_cdb_supported(mvm))
 				IWL_ERR(mvm, "LMAC2 PC: 0x%x\n",
-					iwl_read_umac_prph(trans,
-						UREG_LMAC2_CURRENT_PC));
+					iwl_trans_read_umac_prph(trans,
+								 UREG_LMAC2_CURRENT_PC));
 		}
 
 		if (ret == -ETIMEDOUT && !mvm->fw_product_reset)
@@ -616,7 +616,7 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm)
 	mvm->rfkill_safe_init_done = false;
 
 	if (mvm->trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_AX210) {
-		sb_cfg = iwl_read_umac_prph(mvm->trans, SB_MODIFY_CFG_FLAG);
+		sb_cfg = iwl_trans_read_umac_prph(mvm->trans, SB_MODIFY_CFG_FLAG);
 		/* if needed, we'll reset this on our way out later */
 		mvm->fw_product_reset = sb_cfg == SB_CFG_RESIDES_IN_ROM;
 		if (mvm->fw_product_reset && iwl_mei_pldr_req())
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 93d5cab87f64..653c620361d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -138,9 +138,9 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	 * to lose ownership and not being able to obtain it back.
 	 */
 	if (!mvm->trans->mac_cfg->base->apmg_not_supported)
-		iwl_set_bits_mask_prph(mvm->trans, APMG_PS_CTRL_REG,
-				       APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
-				       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
+		iwl_trans_set_bits_mask_prph(mvm->trans, APMG_PS_CTRL_REG,
+					     APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
+					     ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 }
 
 static void iwl_mvm_rx_monitor_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2fd4a9961145..cd0d89feecea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1159,7 +1159,7 @@ u32 iwl_mvm_get_systime(struct iwl_mvm *mvm)
 	    mvm->trans->mac_cfg->base->gp2_reg_addr)
 		reg_addr = mvm->trans->mac_cfg->base->gp2_reg_addr;
 
-	return iwl_read_prph(mvm->trans, reg_addr);
+	return iwl_trans_read_prph(mvm->trans, reg_addr);
 }
 
 void iwl_mvm_get_sync_time(struct iwl_mvm *mvm, int clock_type,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index 917010a7d8ef..0009a05511af 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -319,8 +319,8 @@ void iwl_pcie_ctxt_info_v2_kick(struct iwl_trans *trans)
 	iwl_pcie_write64(trans, CSR_IML_DATA_ADDR, trans_pcie->iml_dma_addr);
 	iwl_trans_pcie_write32(trans, CSR_IML_SIZE_ADDR, trans_pcie->iml_len);
 
-	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
-		    CSR_AUTO_FUNC_BOOT_ENA);
+	iwl_trans_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
+			  CSR_AUTO_FUNC_BOOT_ENA);
 }
 
 void iwl_pcie_ctxt_info_v2_free(struct iwl_trans *trans, bool alive)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 96821850298f..d74742df2fe5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1103,8 +1103,8 @@ static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 		 * when we power down the device we need set the bit to allow it
 		 * to wake up the PCI-E bus for RF-kill interrupts.
 		 */
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_RFKILL_WAKE_L1A_EN);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_RFKILL_WAKE_L1A_EN);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index cf6beba6041f..e3fe5a912a8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -147,15 +147,15 @@ int iwl_pcie_rx_stop(struct iwl_trans *trans)
 {
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
 		/* TODO: remove this once fw does it */
-		iwl_write_umac_prph(trans, RFH_RXF_DMA_CFG_AX210, 0);
+		iwl_trans_write_umac_prph(trans, RFH_RXF_DMA_CFG_AX210, 0);
 		return iwl_pcie_poll_umac_prph_bit(trans, RFH_GEN_STATUS_AX210,
 						   RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
 	} else if (trans->mac_cfg->mq_rx_supported) {
-		iwl_write_prph(trans, RFH_RXF_DMA_CFG, 0);
+		iwl_trans_write_prph(trans, RFH_RXF_DMA_CFG, 0);
 		return iwl_pcie_poll_prph_bit(trans, RFH_GEN_STATUS,
 					      RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
 	} else {
-		iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+		iwl_trans_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 		return iwl_pcie_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
 						FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
 						1000);
@@ -184,8 +184,8 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO(trans, "Rx queue requesting wakeup, GP1 = 0x%x\n",
 				       reg);
-			iwl_set_bit(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+					  CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			rxq->need_update = true;
 			return;
 		}
@@ -895,7 +895,7 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 
 	/* W/A for interrupt coalescing bug in 7260 and 3160 */
 	if (trans->cfg->host_interrupt_operation_mode)
-		iwl_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
+		iwl_trans_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
 }
 
 static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
@@ -1692,9 +1692,9 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (trans->cfg->internal_wimax_coex &&
 	    !trans->mac_cfg->base->apmg_not_supported &&
-	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
+	    (!(iwl_trans_read_prph(trans, APMG_CLK_CTRL_REG) &
 			     APMS_CLK_VAL_MRB_FUNC_MODE) ||
-	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
+	     (iwl_trans_read_prph(trans, APMG_PS_CTRL_REG) &
 			    APMG_PS_CTRL_VAL_RESET_REQ))) {
 		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 		iwl_op_mode_wimax_active(trans->op_mode);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 91d0b935fca6..dce6043fe962 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -32,18 +32,18 @@ int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
 	 * Disable L0s without affecting L1;
 	 * don't wait for ICH L0s (ICH bug W/A)
 	 */
-	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+	iwl_trans_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
 	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+	iwl_trans_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
 
 	/*
 	 * Enable HAP INTA (interrupt from management bus) to
 	 * wake device's PCI Express link L1a -> L0s
 	 */
-	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_HAP_WAKE);
+	iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			  CSR_HW_IF_CONFIG_REG_HAP_WAKE);
 
 	iwl_pcie_apm_config(trans);
 
@@ -65,14 +65,14 @@ static void iwl_pcie_gen2_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 			iwl_pcie_gen2_apm_init(trans);
 
 		/* inform ME that we are leaving */
-		iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-			    CSR_RESET_LINK_PWR_MGMT_DISABLED);
-		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_WAKE_ME |
-			    CSR_HW_IF_CONFIG_REG_WAKE_ME_PCIE_OWNER_EN);
+		iwl_trans_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+				  CSR_RESET_LINK_PWR_MGMT_DISABLED);
+		iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_WAKE_ME |
+				  CSR_HW_IF_CONFIG_REG_WAKE_ME_PCIE_OWNER_EN);
 		mdelay(1);
-		iwl_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-			      CSR_RESET_LINK_PWR_MGMT_DISABLED);
+		iwl_trans_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+				    CSR_RESET_LINK_PWR_MGMT_DISABLED);
 		mdelay(5);
 	}
 
@@ -88,11 +88,11 @@ static void iwl_pcie_gen2_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
 	 */
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_MAC_INIT);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_INIT);
 	else
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 }
 
 static void
@@ -105,11 +105,11 @@ _iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans,
 	trans_pcie->fw_reset_state = FW_RESET_REQUESTED;
 
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
-		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
-				    UREG_NIC_SET_NMI_DRIVER_RESET_HANDSHAKE);
+		iwl_trans_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
+					  UREG_NIC_SET_NMI_DRIVER_RESET_HANDSHAKE);
 	else if (trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_AX210)
-		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
-				    UREG_DOORBELL_TO_ISR6_RESET_HANDSHAKE);
+		iwl_trans_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
+					  UREG_DOORBELL_TO_ISR6_RESET_HANDSHAKE);
 	else
 		iwl_trans_pcie_write32(trans, CSR_DOORBELL_VECTOR,
 				       UREG_DOORBELL_TO_ISR6_RESET_HANDSHAKE);
@@ -281,7 +281,7 @@ static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
 		return -ENOMEM;
 
 	/* enable shadow regs in HW */
-	iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
+	iwl_trans_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
 	IWL_DEBUG_INFO(trans, "Enabling shadow registers in device\n");
 
 	return 0;
@@ -342,7 +342,7 @@ static void iwl_pcie_get_rf_name(struct iwl_trans *trans)
 	case CSR_HW_RFID_TYPE(CSR_HW_RF_ID_TYPE_HR):
 	case CSR_HW_RFID_TYPE(CSR_HW_RF_ID_TYPE_HR1):
 	case CSR_HW_RFID_TYPE(CSR_HW_RF_ID_TYPE_HRCDB):
-		version = iwl_read_prph(trans, CNVI_MBOX_C);
+		version = iwl_trans_read_prph(trans, CNVI_MBOX_C);
 		switch (version) {
 		case 0x20000:
 			pos += scnprintf(buf + pos, buflen - pos, " B3");
@@ -410,7 +410,7 @@ void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans)
 
 	step_reg = trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_SC ?
 		   CNVI_PMU_STEP_FLOW_SC : CNVI_PMU_STEP_FLOW_BZ;
-	trans->step_urm = !!(iwl_read_prph(trans, step_reg) &
+	trans->step_urm = !!(iwl_trans_read_prph(trans, step_reg) &
 			     CNVI_PMU_STEP_FLOW_FORCE_URM);
 }
 
@@ -440,8 +440,8 @@ static bool iwl_pcie_set_ltr(struct iwl_trans *trans)
 
 	if (trans->mac_cfg->integrated &&
 	    trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_22000) {
-		iwl_write_prph(trans, HPM_MAC_LTR_CSR, HPM_MAC_LRT_ENABLE_ALL);
-		iwl_write_prph(trans, HPM_UMAC_LTR, ltr_val);
+		iwl_trans_write_prph(trans, HPM_MAC_LTR_CSR, HPM_MAC_LRT_ENABLE_ALL);
+		iwl_trans_write_prph(trans, HPM_UMAC_LTR, ltr_val);
 		return true;
 	}
 
@@ -593,12 +593,12 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 		IWL_DEBUG_POWER(trans, "function scratch register value is 0x%08x\n",
 				iwl_trans_pcie_read32(trans, CSR_FUNC_SCRATCH));
 		iwl_trans_pcie_write32(trans, CSR_FUNC_SCRATCH, CSR_FUNC_SCRATCH_INIT_VALUE);
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_ROM_START);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_ROM_START);
 	} else if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
-		iwl_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
+		iwl_trans_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
 	} else {
-		iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
+		iwl_trans_write_prph(trans, UREG_CPU_INIT_RUN, 1);
 	}
 
 	if (keep_ram_busy)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ce7d01a36688..8da0cc603070 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -79,12 +79,12 @@ int iwl_trans_pcie_sw_reset(struct iwl_trans *trans, bool retake_ownership)
 {
 	/* Reset entire device - do controller reset (results in SHRD_HW_RST) */
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_SW_RESET);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_SW_RESET);
 		usleep_range(10000, 20000);
 	} else {
-		iwl_set_bit(trans, CSR_RESET,
-			    CSR_RESET_REG_FLAG_SW_RESET);
+		iwl_trans_set_bit(trans, CSR_RESET,
+				  CSR_RESET_REG_FLAG_SW_RESET);
 		usleep_range(5000, 6000);
 	}
 
@@ -188,13 +188,13 @@ static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 		return;
 
 	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
-		iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
-				       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-				       ~APMG_PS_CTRL_MSK_PWR_SRC);
+		iwl_trans_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
+					     APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+					     ~APMG_PS_CTRL_MSK_PWR_SRC);
 	else
-		iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
-				       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-				       ~APMG_PS_CTRL_MSK_PWR_SRC);
+		iwl_trans_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
+					     APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+					     ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
 
 /* PCI registers */
@@ -211,7 +211,7 @@ void iwl_pcie_apm_config(struct iwl_trans *trans)
 	 * and in newer hardware they are not officially supported at
 	 * all, so we must always set the L0S_DISABLED bit.
 	 */
-	iwl_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_DISABLED);
+	iwl_trans_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_DISABLED);
 
 	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL, &lctl);
 	trans_pcie->pm_support = !(lctl & PCI_EXP_LNKCTL_ASPM_L0S);
@@ -241,31 +241,31 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 
 	/* Disable L0S exit timer (platform NMI Work/Around) */
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_8000)
-		iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
-			    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+		iwl_trans_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+				  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
 	/*
 	 * Disable L0s without affecting L1;
 	 *  don't wait for ICH L0s (ICH bug W/A)
 	 */
-	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+	iwl_trans_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
 	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+	iwl_trans_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
 
 	/*
 	 * Enable HAP INTA (interrupt from management bus) to
 	 * wake device's PCI Express link L1a -> L0s
 	 */
-	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_HAP_WAKE);
+	iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			  CSR_HW_IF_CONFIG_REG_HAP_WAKE);
 
 	iwl_pcie_apm_config(trans);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (trans->mac_cfg->base->pll_cfg)
-		iwl_set_bit(trans, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
+		iwl_trans_set_bit(trans, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
 	ret = iwl_trans_activate_nic(trans);
 	if (ret)
@@ -286,11 +286,11 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 		 * just to discard the value. But that's the way the hardware
 		 * seems to like it.
 		 */
-		iwl_read_prph(trans, OSC_CLK);
-		iwl_read_prph(trans, OSC_CLK);
-		iwl_set_bits_prph(trans, OSC_CLK, OSC_CLK_FORCE_CONTROL);
-		iwl_read_prph(trans, OSC_CLK);
-		iwl_read_prph(trans, OSC_CLK);
+		iwl_trans_read_prph(trans, OSC_CLK);
+		iwl_trans_read_prph(trans, OSC_CLK);
+		iwl_trans_set_bits_prph(trans, OSC_CLK, OSC_CLK_FORCE_CONTROL);
+		iwl_trans_read_prph(trans, OSC_CLK);
+		iwl_trans_read_prph(trans, OSC_CLK);
 	}
 
 	/*
@@ -301,17 +301,17 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	 * bits already set by default in "CLK_CTRL_REG" after reset.
 	 */
 	if (!trans->mac_cfg->base->apmg_not_supported) {
-		iwl_write_prph(trans, APMG_CLK_EN_REG,
-			       APMG_CLK_VAL_DMA_CLK_RQT);
+		iwl_trans_write_prph(trans, APMG_CLK_EN_REG,
+				     APMG_CLK_VAL_DMA_CLK_RQT);
 		udelay(20);
 
 		/* Disable L1-Active */
-		iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
-				  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+		iwl_trans_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
+					APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 		/* Clear the interrupt in APMG if the NIC is in RFKILL */
-		iwl_write_prph(trans, APMG_RTC_INT_STT_REG,
-			       APMG_RTC_INT_STT_RFKILL);
+		iwl_trans_write_prph(trans, APMG_RTC_INT_STT_REG,
+				     APMG_RTC_INT_STT_RFKILL);
 	}
 
 	set_bit(STATUS_DEVICE_ENABLED, &trans->status);
@@ -353,8 +353,8 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 	 * Clear "disable persistence" to avoid LP XTAL resetting when
 	 * SHRD_HW_RST is applied in S3.
 	 */
-	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
-				    APMG_PCIDEV_STT_VAL_PERSIST_DIS);
+	iwl_trans_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
+				  APMG_PCIDEV_STT_VAL_PERSIST_DIS);
 
 	/*
 	 * Force APMG XTAL to be active to prevent its disabling by HW
@@ -386,14 +386,14 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 	 * Enable persistence mode to avoid LP XTAL resetting when
 	 * SHRD_HW_RST is applied in S3.
 	 */
-	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_PERSISTENCE);
+	iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			  CSR_HW_IF_CONFIG_REG_PERSISTENCE);
 
 	/*
 	 * Clear "initialization complete" bit to move adapter from
 	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
 	 */
-	iwl_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_trans_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* Activates XTAL resources monitor */
 	iwl_pcie_set_bit(trans, CSR_MONITOR_CFG_REG,
@@ -417,18 +417,18 @@ void iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 	/* stop device's busmaster DMA activity */
 
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_BUS_MASTER_DISABLE_REQ);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_BUS_MASTER_DISABLE_REQ);
 
-		ret = iwl_poll_bits(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_BUS_MASTER_DISABLE_STATUS,
-				    100);
+		ret = iwl_trans_poll_bits(trans, CSR_GP_CNTRL,
+					  CSR_GP_CNTRL_REG_FLAG_BUS_MASTER_DISABLE_STATUS,
+					  100);
 		usleep_range(10000, 20000);
 	} else {
-		iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+		iwl_trans_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-		ret = iwl_poll_bits(trans, CSR_RESET,
-				    CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+		ret = iwl_trans_poll_bits(trans, CSR_RESET,
+					  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	}
 
 	if (ret)
@@ -447,18 +447,18 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 
 		/* inform ME that we are leaving */
 		if (trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_7000)
-			iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
-					  APMG_PCIDEV_STT_VAL_WAKE_ME);
+			iwl_trans_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
+						APMG_PCIDEV_STT_VAL_WAKE_ME);
 		else if (trans->mac_cfg->device_family >=
 			 IWL_DEVICE_FAMILY_8000) {
-			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-				    CSR_RESET_LINK_PWR_MGMT_DISABLED);
-			iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-				    CSR_HW_IF_CONFIG_REG_WAKE_ME |
-				    CSR_HW_IF_CONFIG_REG_WAKE_ME_PCIE_OWNER_EN);
+			iwl_trans_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+					  CSR_RESET_LINK_PWR_MGMT_DISABLED);
+			iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+					  CSR_HW_IF_CONFIG_REG_WAKE_ME |
+					  CSR_HW_IF_CONFIG_REG_WAKE_ME_PCIE_OWNER_EN);
 			mdelay(1);
-			iwl_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-				      CSR_RESET_LINK_PWR_MGMT_DISABLED);
+			iwl_trans_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+					    CSR_RESET_LINK_PWR_MGMT_DISABLED);
 		}
 		mdelay(5);
 	}
@@ -479,7 +479,7 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 	 * Clear "initialization complete" bit to move adapter from
 	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
 	 */
-	iwl_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_trans_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 }
 
 static int iwl_pcie_nic_init(struct iwl_trans *trans)
@@ -512,7 +512,7 @@ static int iwl_pcie_nic_init(struct iwl_trans *trans)
 
 	if (trans->mac_cfg->base->shadow_reg_enable) {
 		/* enable shadow regs in HW */
-		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
+		iwl_trans_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
 		IWL_DEBUG_INFO(trans, "Enabling shadow registers in device\n");
 	}
 
@@ -525,16 +525,16 @@ static int iwl_pcie_set_hw_ready(struct iwl_trans *trans)
 {
 	int ret;
 
-	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_PCI_OWN_SET);
+	iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			  CSR_HW_IF_CONFIG_REG_PCI_OWN_SET);
 
 	/* See if we got it */
-	ret = iwl_poll_bits(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_PCI_OWN_SET,
-			    HW_READY_TIMEOUT);
+	ret = iwl_trans_poll_bits(trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_PCI_OWN_SET,
+				  HW_READY_TIMEOUT);
 
 	if (!ret)
-		iwl_set_bit(trans, CSR_MBOX_SET_REG, CSR_MBOX_SET_REG_OS_ALIVE);
+		iwl_trans_set_bit(trans, CSR_MBOX_SET_REG, CSR_MBOX_SET_REG_OS_ALIVE);
 
 	IWL_DEBUG_INFO(trans, "hardware%s ready\n", ret ? " not" : "");
 	return ret;
@@ -555,16 +555,16 @@ int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 		return 0;
 	}
 
-	iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-		    CSR_RESET_LINK_PWR_MGMT_DISABLED);
+	iwl_trans_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+			  CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	usleep_range(1000, 2000);
 
 	for (iter = 0; iter < 10; iter++) {
 		int t = 0;
 
 		/* If HW is not ready, prepare the conditions to check again */
-		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_WAKE_ME);
+		iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_WAKE_ME);
 
 		do {
 			ret = iwl_pcie_set_hw_ready(trans);
@@ -688,16 +688,16 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 			extended_addr = true;
 
 		if (extended_addr)
-			iwl_set_bits_prph(trans, LMPM_CHICK,
-					  LMPM_CHICK_EXTENDED_ADDR_SPACE);
+			iwl_trans_set_bits_prph(trans, LMPM_CHICK,
+						LMPM_CHICK_EXTENDED_ADDR_SPACE);
 
 		memcpy(v_addr, (const u8 *)section->data + offset, copy_size);
 		ret = iwl_pcie_load_firmware_chunk(trans, dst_addr, p_addr,
 						   copy_size);
 
 		if (extended_addr)
-			iwl_clear_bits_prph(trans, LMPM_CHICK,
-					    LMPM_CHICK_EXTENDED_ADDR_SPACE);
+			iwl_trans_clear_bits_prph(trans, LMPM_CHICK,
+						  LMPM_CHICK_EXTENDED_ADDR_SPACE);
 
 		if (ret) {
 			IWL_ERR(trans,
@@ -753,7 +753,7 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 		/* Notify ucode of loaded section number and status */
 		val = iwl_pcie_read_direct32(trans, FH_UCODE_LOAD_STATUS);
 		val = val | (sec_num << shift_param);
-		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
+		iwl_trans_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
 
 		sec_num = (sec_num << 1) | 0x1;
 	}
@@ -764,18 +764,18 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 
 	if (trans->mac_cfg->gen2) {
 		if (cpu == 1)
-			iwl_write_prph(trans, UREG_UCODE_LOAD_STATUS,
-				       0xFFFF);
+			iwl_trans_write_prph(trans, UREG_UCODE_LOAD_STATUS,
+					     0xFFFF);
 		else
-			iwl_write_prph(trans, UREG_UCODE_LOAD_STATUS,
-				       0xFFFFFFFF);
+			iwl_trans_write_prph(trans, UREG_UCODE_LOAD_STATUS,
+					     0xFFFFFFFF);
 	} else {
 		if (cpu == 1)
-			iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS,
-					   0xFFFF);
+			iwl_trans_write_direct32(trans, FH_UCODE_LOAD_STATUS,
+						 0xFFFF);
 		else
-			iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS,
-					   0xFFFFFFFF);
+			iwl_trans_write_direct32(trans, FH_UCODE_LOAD_STATUS,
+						 0xFFFFFFFF);
 	}
 
 	return 0;
@@ -836,8 +836,8 @@ static void iwl_pcie_apply_destination_ini(struct iwl_trans *trans)
 	    IWL_FW_INI_LOCATION_SRAM_PATH) {
 		IWL_DEBUG_FW(trans, "WRT: Applying SMEM buffer destination\n");
 		/* set sram monitor by enabling bit 7 */
-		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_MONITOR_SRAM);
+		iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_BIT_MONITOR_SRAM);
 
 		return;
 	}
@@ -852,11 +852,11 @@ static void iwl_pcie_apply_destination_ini(struct iwl_trans *trans)
 	IWL_DEBUG_FW(trans, "WRT: Applying DRAM destination (alloc_id=%u)\n",
 		     alloc_id);
 
-	iwl_write_umac_prph(trans, MON_BUFF_BASE_ADDR_VER2,
-			    frag->physical >> MON_BUFF_SHIFT_VER2);
-	iwl_write_umac_prph(trans, MON_BUFF_END_ADDR_VER2,
-			    (frag->physical + frag->size - 256) >>
-			    MON_BUFF_SHIFT_VER2);
+	iwl_trans_write_umac_prph(trans, MON_BUFF_BASE_ADDR_VER2,
+				  frag->physical >> MON_BUFF_SHIFT_VER2);
+	iwl_trans_write_umac_prph(trans, MON_BUFF_END_ADDR_VER2,
+				  (frag->physical + frag->size - 256) >>
+				  MON_BUFF_SHIFT_VER2);
 }
 
 void iwl_pcie_apply_destination(struct iwl_trans *trans)
@@ -887,22 +887,22 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 			iwl_trans_pcie_write32(trans, addr, val);
 			break;
 		case CSR_SETBIT:
-			iwl_set_bit(trans, addr, BIT(val));
+			iwl_trans_set_bit(trans, addr, BIT(val));
 			break;
 		case CSR_CLEARBIT:
-			iwl_clear_bit(trans, addr, BIT(val));
+			iwl_trans_clear_bit(trans, addr, BIT(val));
 			break;
 		case PRPH_ASSIGN:
-			iwl_write_prph(trans, addr, val);
+			iwl_trans_write_prph(trans, addr, val);
 			break;
 		case PRPH_SETBIT:
-			iwl_set_bits_prph(trans, addr, BIT(val));
+			iwl_trans_set_bits_prph(trans, addr, BIT(val));
 			break;
 		case PRPH_CLEARBIT:
-			iwl_clear_bits_prph(trans, addr, BIT(val));
+			iwl_trans_clear_bits_prph(trans, addr, BIT(val));
 			break;
 		case PRPH_BLOCKBIT:
-			if (iwl_read_prph(trans, addr) & BIT(val)) {
+			if (iwl_trans_read_prph(trans, addr) & BIT(val)) {
 				IWL_ERR(trans,
 					"BIT(%u) in address 0x%x is 1, stopping FW configuration\n",
 					val, addr);
@@ -918,16 +918,16 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 
 monitor:
 	if (dest->monitor_mode == EXTERNAL_MODE && fw_mon->size) {
-		iwl_write_prph(trans, le32_to_cpu(dest->base_reg),
-			       fw_mon->physical >> dest->base_shift);
+		iwl_trans_write_prph(trans, le32_to_cpu(dest->base_reg),
+				     fw_mon->physical >> dest->base_shift);
 		if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_8000)
-			iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
-				       (fw_mon->physical + fw_mon->size -
-					256) >> dest->end_shift);
+			iwl_trans_write_prph(trans, le32_to_cpu(dest->end_reg),
+					     (fw_mon->physical + fw_mon->size -
+					      256) >> dest->end_shift);
 		else
-			iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
-				       (fw_mon->physical + fw_mon->size) >>
-				       dest->end_shift);
+			iwl_trans_write_prph(trans, le32_to_cpu(dest->end_reg),
+					     (fw_mon->physical + fw_mon->size) >>
+					     dest->end_shift);
 	}
 }
 
@@ -947,9 +947,9 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 
 	if (image->is_dual_cpus) {
 		/* set CPU2 header address */
-		iwl_write_prph(trans,
-			       LMPM_SECURE_UCODE_LOAD_CPU2_HDR_ADDR,
-			       LMPM_SECURE_CPU2_HDR_MEM_SPACE);
+		iwl_trans_write_prph(trans,
+				     LMPM_SECURE_UCODE_LOAD_CPU2_HDR_ADDR,
+				     LMPM_SECURE_CPU2_HDR_MEM_SPACE);
 
 		/* load to FW the binary sections of CPU2 */
 		ret = iwl_pcie_load_cpu_sections(trans, image, 2,
@@ -982,18 +982,18 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 		iwl_pcie_apply_destination(trans);
 
 	IWL_DEBUG_POWER(trans, "Original WFPM value = 0x%08X\n",
-			iwl_read_prph(trans, WFPM_GP2));
+			iwl_trans_read_prph(trans, WFPM_GP2));
 
 	/*
 	 * Set default value. On resume reading the values that were
 	 * zeored can provide debug data on the resume flow.
 	 * This is for debugging only and has no functional impact.
 	 */
-	iwl_write_prph(trans, WFPM_GP2, 0x01010101);
+	iwl_trans_write_prph(trans, WFPM_GP2, 0x01010101);
 
 	/* configure the ucode to be ready to get the secured image */
 	/* release CPU reset */
-	iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
+	iwl_trans_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
 
 	/* load to FW the binary Secured sections of CPU1 */
 	ret = iwl_pcie_load_cpu_sections_8000(trans, image, 1,
@@ -1080,8 +1080,8 @@ static void iwl_pcie_map_list(struct iwl_trans *trans,
 
 	for (i = 0; i < arr_size; i++) {
 		iwl_trans_pcie_write8(trans, CSR_MSIX_IVAR(causes[i].addr), val);
-		iwl_clear_bit(trans, causes[i].mask_reg,
-			      BIT(causes[i].bit));
+		iwl_trans_clear_bit(trans, causes[i].mask_reg,
+				    BIT(causes[i].bit));
 	}
 }
 
@@ -1141,8 +1141,8 @@ void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 	if (!trans_pcie->msix_enabled) {
 		if (trans->mac_cfg->mq_rx_supported &&
 		    test_bit(STATUS_DEVICE_ENABLED, &trans->status))
-			iwl_write_umac_prph(trans, UREG_CHICK,
-					    UREG_CHICK_MSI_ENABLE);
+			iwl_trans_write_umac_prph(trans, UREG_CHICK,
+						  UREG_CHICK_MSI_ENABLE);
 		return;
 	}
 	/*
@@ -1151,7 +1151,7 @@ void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 	 * prph.
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
-		iwl_write_umac_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
+		iwl_trans_write_umac_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
 
 	/*
 	 * Each cause from the causes list above and the RX causes is
@@ -1215,19 +1215,19 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool from_irq)
 
 		/* Power-down device's busmaster DMA clocks */
 		if (!trans->mac_cfg->base->apmg_not_supported) {
-			iwl_write_prph(trans, APMG_CLK_DIS_REG,
-				       APMG_CLK_VAL_DMA_CLK_RQT);
+			iwl_trans_write_prph(trans, APMG_CLK_DIS_REG,
+					     APMG_CLK_VAL_DMA_CLK_RQT);
 			udelay(5);
 		}
 	}
 
 	/* Make sure (redundant) we've released our request to stay awake */
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
 	else
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
 	iwl_pcie_apm_stop(trans, false);
@@ -1444,15 +1444,15 @@ static void iwl_pcie_d3_complete_suspend(struct iwl_trans *trans,
 	iwl_pcie_synchronize_irqs(trans);
 
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_MAC_INIT);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_INIT);
 	} else {
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 	}
 
 	if (reset) {
@@ -1478,9 +1478,9 @@ static int iwl_pcie_d3_handshake(struct iwl_trans *trans, bool suspend)
 	trans_pcie->sx_state = IWL_SX_WAITING;
 
 	if (trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_AX210)
-		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
-				    suspend ? UREG_DOORBELL_TO_ISR6_SUSPEND :
-					      UREG_DOORBELL_TO_ISR6_RESUME);
+		iwl_trans_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
+					  suspend ? UREG_DOORBELL_TO_ISR6_SUSPEND :
+					  UREG_DOORBELL_TO_ISR6_RESUME);
 	else
 		iwl_trans_pcie_write32(trans, CSR_IPC_SLEEP_CONTROL,
 				       suspend ? CSR_IPC_SLEEP_CONTROL_SUSPEND :
@@ -1515,8 +1515,8 @@ int iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool reset)
 
 	if (!reset)
 		/* Enable persistence mode to avoid reset */
-		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_PERSISTENCE);
+		iwl_trans_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_PERSISTENCE);
 
 	ret = iwl_pcie_d3_handshake(trans, true);
 	if (ret)
@@ -1535,11 +1535,11 @@ int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	int ret;
 
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ);
 	else
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	ret = iwl_trans_activate_nic(trans);
 	if (ret) {
@@ -1563,8 +1563,8 @@ int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	iwl_pcie_set_pwr(trans, false);
 
 	if (!reset) {
-		iwl_clear_bit(trans, CSR_GP_CNTRL,
-			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		iwl_trans_clear_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	} else {
 		iwl_trans_pcie_tx_reset(trans);
 
@@ -1577,7 +1577,7 @@ int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	}
 
 	IWL_DEBUG_POWER(trans, "WFPM value upon resume = 0x%08X\n",
-			iwl_read_umac_prph(trans, WFPM_GP2));
+			iwl_trans_read_umac_prph(trans, WFPM_GP2));
 
 	val = iwl_trans_pcie_read32(trans, CSR_RESET);
 	if (val & CSR_RESET_REG_FLAG_NEVO_RESET) {
@@ -1745,9 +1745,9 @@ static int iwl_trans_pcie_clear_persistence_bit(struct iwl_trans *trans)
 		return 0;
 	}
 
-	hpm = iwl_read_umac_prph_no_grab(trans, HPM_DEBUG);
+	hpm = iwl_trans_read_umac_prph_no_grab(trans, HPM_DEBUG);
 	if (!iwl_trans_is_hw_error_value(hpm) && (hpm & PERSISTENCE_BIT)) {
-		u32 wprot_val = iwl_read_umac_prph_no_grab(trans, wprot);
+		u32 wprot_val = iwl_trans_read_umac_prph_no_grab(trans, wprot);
 
 		if (wprot_val & PREG_WFPM_ACCESS) {
 			IWL_ERR(trans,
@@ -1769,15 +1769,15 @@ static int iwl_pcie_gen2_force_power_gating(struct iwl_trans *trans)
 	if (ret < 0)
 		return ret;
 
-	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			  HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
+	iwl_trans_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
+				HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
 	udelay(20);
-	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			  HPM_HIPM_GEN_CFG_CR_PG_EN |
-			  HPM_HIPM_GEN_CFG_CR_SLP_EN);
+	iwl_trans_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
+				HPM_HIPM_GEN_CFG_CR_PG_EN |
+				HPM_HIPM_GEN_CFG_CR_SLP_EN);
 	udelay(20);
-	iwl_clear_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			    HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
+	iwl_trans_clear_bits_prph(trans, HPM_HIPM_GEN_CFG,
+				  HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
 
 	return iwl_trans_pcie_sw_reset(trans, true);
 }
@@ -2383,7 +2383,7 @@ bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
 	 * and do not save/restore SRAM when power cycling.
 	 */
-	ret = iwl_poll_bits_mask(trans, CSR_GP_CNTRL, poll, mask, 15000);
+	ret = iwl_trans_poll_bits_mask(trans, CSR_GP_CNTRL, poll, mask, 15000);
 	if (unlikely(ret)) {
 		u32 cntrl = iwl_trans_pcie_read32(trans, CSR_GP_CNTRL);
 
@@ -3237,8 +3237,8 @@ static u32 iwl_trans_pcie_fh_regs_dump(struct iwl_trans *trans,
 		     i += sizeof(u32))
 			*val++ = cpu_to_le32(iwl_trans_pcie_read32(trans, i));
 	else
-		for (i = iwl_umac_prph(trans, FH_MEM_LOWER_BOUND_GEN2);
-		     i < iwl_umac_prph(trans, FH_MEM_UPPER_BOUND_GEN2);
+		for (i = iwl_trans_umac_prph(trans, FH_MEM_LOWER_BOUND_GEN2);
+		     i < iwl_trans_umac_prph(trans, FH_MEM_UPPER_BOUND_GEN2);
 		     i += sizeof(u32))
 			*val++ = cpu_to_le32(iwl_trans_pcie_read_prph(trans,
 								      i));
@@ -3264,8 +3264,8 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 
 	iwl_pcie_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
 	for (i = 0; i < buf_size_in_dwords; i++)
-		buffer[i] = iwl_read_umac_prph_no_grab(trans,
-						       MON_DMARB_RD_DATA_ADDR);
+		buffer[i] = iwl_trans_read_umac_prph_no_grab(trans,
+							     MON_DMARB_RD_DATA_ADDR);
 	iwl_pcie_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
 
 	iwl_trans_release_nic_access(trans);
@@ -3294,14 +3294,14 @@ iwl_trans_pcie_dump_pointers(struct iwl_trans *trans,
 		wrap_cnt = MON_BUFF_CYCLE_CNT;
 	}
 
-	write_ptr_val = iwl_read_prph(trans, write_ptr);
+	write_ptr_val = iwl_trans_read_prph(trans, write_ptr);
 	fw_mon_data->fw_mon_cycle_cnt =
-		cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
+		cpu_to_le32(iwl_trans_read_prph(trans, wrap_cnt));
 	fw_mon_data->fw_mon_base_ptr =
-		cpu_to_le32(iwl_read_prph(trans, base));
+		cpu_to_le32(iwl_trans_read_prph(trans, base));
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
 		fw_mon_data->fw_mon_base_high_ptr =
-			cpu_to_le32(iwl_read_prph(trans, base_high));
+			cpu_to_le32(iwl_trans_read_prph(trans, base_high));
 		write_ptr_val &= DBGC_CUR_DBGBUF_STATUS_OFFSET_MSK;
 		/* convert wrtPtr to DWs, to align with all HWs */
 		write_ptr_val >>= 2;
@@ -3339,13 +3339,13 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 			 * shifting
 			 */
 			if (trans->dbg.dest_tlv->version) {
-				base = (iwl_read_prph(trans, base) &
+				base = (iwl_trans_read_prph(trans, base) &
 					IWL_LDBG_M2S_BUF_BA_MSK) <<
 				       trans->dbg.dest_tlv->base_shift;
 				base *= IWL_M2S_UNIT_SIZE;
 				base += trans->mac_cfg->base->smem_offset;
 			} else {
-				base = iwl_read_prph(trans, base) <<
+				base = iwl_trans_read_prph(trans, base) <<
 				       trans->dbg.dest_tlv->base_shift;
 			}
 
@@ -3380,7 +3380,7 @@ static int iwl_trans_get_fw_monitor_len(struct iwl_trans *trans, u32 *len)
 
 		if (trans->dbg.dest_tlv->version == 1) {
 			cfg_reg = le32_to_cpu(trans->dbg.dest_tlv->base_reg);
-			cfg_reg = iwl_read_prph(trans, cfg_reg);
+			cfg_reg = iwl_trans_read_prph(trans, cfg_reg);
 			base = (cfg_reg & IWL_LDBG_M2S_BUF_BA_MSK) <<
 				trans->dbg.dest_tlv->base_shift;
 			base *= IWL_M2S_UNIT_SIZE;
@@ -3394,9 +3394,9 @@ static int iwl_trans_get_fw_monitor_len(struct iwl_trans *trans, u32 *len)
 			base = le32_to_cpu(trans->dbg.dest_tlv->base_reg);
 			end = le32_to_cpu(trans->dbg.dest_tlv->end_reg);
 
-			base = iwl_read_prph(trans, base) <<
+			base = iwl_trans_read_prph(trans, base) <<
 			       trans->dbg.dest_tlv->base_shift;
-			end = iwl_read_prph(trans, end) <<
+			end = iwl_trans_read_prph(trans, end) <<
 			      trans->dbg.dest_tlv->end_shift;
 
 			/* Make "end" point to the actual end */
@@ -3454,8 +3454,8 @@ iwl_trans_pcie_dump_data(struct iwl_trans *trans, u32 dump_mask,
 	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_FH_REGS)) {
 		if (trans->mac_cfg->gen2)
 			len += sizeof(*data) +
-			       (iwl_umac_prph(trans, FH_MEM_UPPER_BOUND_GEN2) -
-				iwl_umac_prph(trans, FH_MEM_LOWER_BOUND_GEN2));
+			       (iwl_trans_umac_prph(trans, FH_MEM_UPPER_BOUND_GEN2) -
+				iwl_trans_umac_prph(trans, FH_MEM_LOWER_BOUND_GEN2));
 		else
 			len += sizeof(*data) +
 			       (FH_MEM_UPPER_BOUND -
@@ -3860,19 +3860,19 @@ iwl_trans_pcie_alloc(struct pci_dev *pdev,
 void iwl_trans_pcie_copy_imr_fh(struct iwl_trans *trans,
 				u32 dst_addr, u64 src_addr, u32 byte_cnt)
 {
-	iwl_write_prph(trans, IMR_UREG_CHICK,
-		       iwl_read_prph(trans, IMR_UREG_CHICK) |
-		       IMR_UREG_CHICK_HALT_UMAC_PERMANENTLY_MSK);
-	iwl_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_SRAM_ADDR, dst_addr);
-	iwl_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_DRAM_ADDR_LSB,
-		       (u32)(src_addr & 0xFFFFFFFF));
-	iwl_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_DRAM_ADDR_MSB,
-		       iwl_get_dma_hi_addr(src_addr));
-	iwl_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_BC, byte_cnt);
-	iwl_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_CTRL,
-		       IMR_TFH_SRV_DMA_CHNL0_CTRL_D2S_IRQ_TARGET_POS |
-		       IMR_TFH_SRV_DMA_CHNL0_CTRL_D2S_DMA_EN_POS |
-		       IMR_TFH_SRV_DMA_CHNL0_CTRL_D2S_RS_MSK);
+	iwl_trans_write_prph(trans, IMR_UREG_CHICK,
+			     iwl_trans_read_prph(trans, IMR_UREG_CHICK) |
+			     IMR_UREG_CHICK_HALT_UMAC_PERMANENTLY_MSK);
+	iwl_trans_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_SRAM_ADDR, dst_addr);
+	iwl_trans_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_DRAM_ADDR_LSB,
+			     (u32)(src_addr & 0xFFFFFFFF));
+	iwl_trans_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_DRAM_ADDR_MSB,
+			     iwl_get_dma_hi_addr(src_addr));
+	iwl_trans_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_BC, byte_cnt);
+	iwl_trans_write_prph(trans, IMR_TFH_SRV_DMA_CHNL0_CTRL,
+			     IMR_TFH_SRV_DMA_CHNL0_CTRL_D2S_IRQ_TARGET_POS |
+			     IMR_TFH_SRV_DMA_CHNL0_CTRL_D2S_DMA_EN_POS |
+			     IMR_TFH_SRV_DMA_CHNL0_CTRL_D2S_RS_MSK);
 }
 
 int iwl_trans_pcie_copy_imr(struct iwl_trans *trans,
@@ -3914,8 +3914,8 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	/* wait until the device is ready to access the prph registers */
 	if (iwl_trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_DR ||
 	    iwl_trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_SC) {
-		u32 req = iwl_read_umac_prph_no_grab(iwl_trans,
-						     WFPM_RSRCS_4PHS_REQ_STTS);
+		u32 req = iwl_trans_read_umac_prph_no_grab(iwl_trans,
+							   WFPM_RSRCS_4PHS_REQ_STTS);
 		int ret;
 
 		if (!(req & RSRC_REQ_CNVR_TOP)) {
@@ -3936,7 +3936,7 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	}
 
 	/* Enable access to peripheral registers */
-	val = iwl_read_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG);
+	val = iwl_trans_read_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG);
 	val |= WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK;
 	iwl_pcie_write_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG, val);
 
@@ -3968,7 +3968,7 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	}
 
 	/* Read cdb info (also contains the jacket info if needed in the future */
-	hw_wfpm_id = iwl_read_umac_prph_no_grab(iwl_trans, WFPM_OTP_CFG1_ADDR);
+	hw_wfpm_id = iwl_trans_read_umac_prph_no_grab(iwl_trans, WFPM_OTP_CFG1_ADDR);
 
 	IWL_INFO(iwl_trans, "Detected crf-id 0x%x, cnv-id 0x%x wfpm id 0x%x\n",
 		 info->hw_crf_id, info->hw_cnv_id, hw_wfpm_id);
@@ -3985,8 +3985,8 @@ static int map_crf_id(struct iwl_trans *iwl_trans,
 	u32 val = info->hw_crf_id;
 	u32 step_id = REG_CRF_ID_STEP(val);
 	u32 slave_id = REG_CRF_ID_SLAVE(val);
-	u32 hw_wfpm_id = iwl_read_umac_prph_no_grab(iwl_trans,
-						    WFPM_OTP_CFG1_ADDR);
+	u32 hw_wfpm_id = iwl_trans_read_umac_prph_no_grab(iwl_trans,
+							  WFPM_OTP_CFG1_ADDR);
 	u32 cdb_id_wfpm = WFPM_OTP_CFG1_IS_CDB(hw_wfpm_id);
 
 	/* Map between crf id to rf id */
@@ -4256,13 +4256,13 @@ int iwl_pcie_activate_nic(struct iwl_trans *trans)
 	 * D0U* --> D0A* (powered-up active) state.
 	 */
 	if (mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ |
-			    CSR_GP_CNTRL_REG_FLAG_MAC_INIT);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_BZ_MAC_ACCESS_REQ |
+				  CSR_GP_CNTRL_REG_FLAG_MAC_INIT);
 		poll_ready = CSR_GP_CNTRL_REG_FLAG_MAC_STATUS;
 	} else {
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+		iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+				  CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 		poll_ready = CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY;
 	}
 
@@ -4271,10 +4271,10 @@ int iwl_pcie_activate_nic(struct iwl_trans *trans)
 
 	/*
 	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is supported, e.g. iwl_write_prph()
+	 * device-internal resources is supported, e.g. iwl_trans_write_prph()
 	 * and accesses to uCode SRAM.
 	 */
-	err = iwl_poll_bits(trans, CSR_GP_CNTRL, poll_ready, 25000);
+	err = iwl_trans_poll_bits(trans, CSR_GP_CNTRL, poll_ready, 25000);
 	if (err < 0) {
 		IWL_DEBUG_INFO(trans, "Failed to wake NIC\n");
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index cd744f7002b6..c217e5189df4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -104,8 +104,8 @@ static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO(trans, "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
 				       txq_id, reg);
-			iwl_set_bit(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			iwl_trans_set_bit(trans, CSR_GP_CNTRL,
+					  CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			txq->need_update = true;
 			return;
 		}
@@ -493,21 +493,21 @@ void iwl_pcie_tx_start(struct iwl_trans *trans)
 	       sizeof(trans_pcie->txqs.queue_used));
 
 	trans_pcie->scd_base_addr =
-		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
+		iwl_trans_read_prph(trans, SCD_SRAM_BASE_ADDR);
 
 	/* reset context data, TX status and translation data */
 	iwl_trans_write_mem(trans, trans_pcie->scd_base_addr +
 				   SCD_CONTEXT_MEM_LOWER_BOUND,
 			    NULL, clear_dwords);
 
-	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
-		       trans_pcie->txqs.scd_bc_tbls.dma >> 10);
+	iwl_trans_write_prph(trans, SCD_DRAM_BASE_ADDR,
+			     trans_pcie->txqs.scd_bc_tbls.dma >> 10);
 
 	/* The chain extension of the SCD doesn't work well. This feature is
 	 * enabled by default by the HW, so we need to disable it manually.
 	 */
 	if (trans->mac_cfg->base->scd_chain_ext_wa)
-		iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
+		iwl_trans_write_prph(trans, SCD_CHAINEXT_EN, 0);
 
 	iwl_trans_ac_txq_enable(trans, trans->conf.cmd_queue,
 				trans->conf.cmd_fifo,
@@ -518,19 +518,19 @@ void iwl_pcie_tx_start(struct iwl_trans *trans)
 
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM; chan++)
-		iwl_write_direct32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
-				   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-				   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+		iwl_trans_write_direct32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+					 FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+					 FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	/* Update FH chicken bits */
 	reg_val = iwl_pcie_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
-			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+	iwl_trans_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
+				 reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	/* Enable L1-Active */
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_8000)
-		iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
-				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+		iwl_trans_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
+					  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
@@ -553,17 +553,17 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 						FH_MEM_CBBC_QUEUE(trans, txq_id),
 						txq->dma_addr);
 		else
-			iwl_write_direct32(trans,
-					   FH_MEM_CBBC_QUEUE(trans, txq_id),
-					   txq->dma_addr >> 8);
+			iwl_trans_write_direct32(trans,
+						 FH_MEM_CBBC_QUEUE(trans, txq_id),
+						 txq->dma_addr >> 8);
 		iwl_pcie_txq_unmap(trans, txq_id);
 		txq->read_ptr = 0;
 		txq->write_ptr = 0;
 	}
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
-			   trans_pcie->kw.dma >> 4);
+	iwl_trans_write_direct32(trans, FH_KW_MEM_ADDR_REG,
+				 trans_pcie->kw.dma >> 4);
 
 	/*
 	 * Send 0 as the scd_base_addr since the device may have be reset
@@ -591,7 +591,7 @@ static void iwl_pcie_tx_stop_fh(struct iwl_trans *trans)
 	}
 
 	/* Wait for DMA channels to be idle */
-	ret = iwl_poll_bits(trans, FH_TSSR_TX_STATUS_REG, mask, 5000);
+	ret = iwl_trans_poll_bits(trans, FH_TSSR_TX_STATUS_REG, mask, 5000);
 	if (ret)
 		IWL_ERR(trans,
 			"Failing on timeout while stopping DMA channel %d [0x%08x]\n",
@@ -684,7 +684,7 @@ void iwl_txq_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 		return;
 	}
 
-	status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id));
+	status = iwl_trans_read_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id));
 	fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
 	active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
 
@@ -693,9 +693,9 @@ void iwl_txq_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 		txq_id, active ? "" : "in", fifo,
 		jiffies_to_msecs(txq->wd_timeout),
 		txq->read_ptr, txq->write_ptr,
-		iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id)) &
+		iwl_trans_read_prph(trans, SCD_QUEUE_RDPTR(txq_id)) &
 			(trans->mac_cfg->base->max_tfd_queue_size - 1),
-			iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq_id)) &
+			iwl_trans_read_prph(trans, SCD_QUEUE_WRPTR(txq_id)) &
 			(trans->mac_cfg->base->max_tfd_queue_size - 1),
 			iwl_pcie_read_direct32(trans, FH_TX_TRB_REG(fifo)));
 }
@@ -955,8 +955,8 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	iwl_scd_deactivate_fifos(trans);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
-			   trans_pcie->kw.dma >> 4);
+	iwl_trans_write_direct32(trans, FH_KW_MEM_ADDR_REG,
+				 trans_pcie->kw.dma >> 4);
 
 	spin_unlock_bh(&trans_pcie->irq_lock);
 
@@ -984,14 +984,14 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		 * queue.
 		 * Circular buffer (TFD queue in DRAM) physical base address
 		 */
-		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
-				   trans_pcie->txqs.txq[txq_id]->dma_addr >> 8);
+		iwl_trans_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
+					 trans_pcie->txqs.txq[txq_id]->dma_addr >> 8);
 	}
 
-	iwl_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
+	iwl_trans_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
 	if (trans->mac_cfg->base->num_of_queues > 20)
-		iwl_set_bits_prph(trans, SCD_GP_CTRL,
-				  SCD_GP_CTRL_ENABLE_31_QUEUES);
+		iwl_trans_set_bits_prph(trans, SCD_GP_CTRL,
+					SCD_GP_CTRL_ENABLE_31_QUEUES);
 
 	return 0;
 error:
@@ -1222,13 +1222,13 @@ bool iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
 	txq->read_ptr = (ssn & 0xff);
 	txq->write_ptr = (ssn & 0xff);
-	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-			   (ssn & 0xff) | (txq_id << 8));
+	iwl_trans_write_direct32(trans, HBUS_TARG_WRPTR,
+				 (ssn & 0xff) | (txq_id << 8));
 
 	if (cfg) {
 		u8 frame_limit = cfg->frame_limit;
 
-		iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
+		iwl_trans_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
 
 		/* Set up Tx window size and frame limit for this queue */
 		iwl_trans_write_mem32(trans, trans_pcie->scd_base_addr +
@@ -1240,11 +1240,11 @@ bool iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			SCD_QUEUE_CTX_REG2_VAL(FRAME_LIMIT, frame_limit));
 
 		/* Set up status area in SRAM, map to Tx DMA/FIFO, activate */
-		iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
-			       (1 << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			       (cfg->fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
-			       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
-			       SCD_QUEUE_STTS_REG_MSK);
+		iwl_trans_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
+				     (1 << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+				     (cfg->fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
+				     (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
+				     SCD_QUEUE_STTS_REG_MSK);
 
 		/* enable the scheduler for this queue (only) */
 		if (txq_id == trans->conf.cmd_queue &&
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
index 4365ffb0fd37..eb54b5da1d25 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
@@ -139,7 +139,7 @@ int iwl_pcie_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 	int t = 0;
 
 	do {
-		if ((iwl_read_prph(trans, addr) & mask) == (bits & mask))
+		if ((iwl_trans_read_prph(trans, addr) & mask) == (bits & mask))
 			return 0;
 		udelay(IWL_PCIE_POLL_INTERVAL);
 		t += IWL_PCIE_POLL_INTERVAL;
@@ -163,7 +163,7 @@ int iwl_pcie_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
 	int t = 0;
 
 	do {
-		if ((iwl_read_umac_prph_no_grab(trans, addr) & mask) ==
+		if ((iwl_trans_read_umac_prph_no_grab(trans, addr) & mask) ==
 		    (bits & mask))
 			return 0;
 		udelay(IWL_PCIE_POLL_INTERVAL);
-- 
2.34.1

