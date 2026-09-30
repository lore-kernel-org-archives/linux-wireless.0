Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6DB45041A
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759890; cv=none; b=HLDNb2sLxExftbANjFRO4MMn8raGYKQCwDBukhGoJGSlEDmznVl6KRfF30tmDduaNGrrVC8VV7KwRNqc7rqoBLHOpFKK15/o7GP85y90wzpx5Pl0oBAP6TpD173g3DqB7GJhX95WaDIKBGITFCbyMT84GsaqiJjf9jAn6MQYuo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759890; c=relaxed/simple;
	bh=T3AthGb4C82H7GhbOwrYluTWnptlEGiWyzuUOWjXc9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ru5UieOWNIoO4V0echzydwmsrHPimEJvNv78aKmOQx6t/4uWvl2VN4aey5X4jDDVpK1ZESSxJnQ1x5RBtoN85afbeO52gPEhh4RgyQrVfWeoZo01R9NTRWiOVYiY4ov2YiPosdBacgtntMsnhU+QQy3xTyNkKutXvoZ6NQkuSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3D0rgzs; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3D0rgzs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759886; x=1822295886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T3AthGb4C82H7GhbOwrYluTWnptlEGiWyzuUOWjXc9k=;
  b=h3D0rgzszKE/U0zs7K4ygAdZBzT7eToVl22GGmB70ZQ41Kvhy399g3BE
   fMYunFP6A+2aRDclKJAX7I+VT8oOa9NnxfdSvn9nIHXQIP3bLVcqfr9C4
   sE0GRDlR0ewipxhiC5FNfrw8IdlJOO2JKjHeumGVKeJTWrBnPmfat8oQC
   YSshV4TSPcvqQW3LYsfeHFZfsnUJXhDhp2Z4ueqCvUtP39PTZeSOhWoQc
   DJIWswX/hsfoxmqtaW2aDpRMexCEZM8ap/vE94MOAsCIILg8ticM875kQ
   N3+Ino1YnSivKElpvCoyiK6fbTe/lSWO3JkIAm8IrS8wuDXhu+AK8ZZ+j
   Q==;
X-CSE-ConnectionGUID: aKDVtYCrSq+0e3GGkYyM2Q==
X-CSE-MsgGUID: wUeqMMrgQNei8/ttfUJmWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447021"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447021"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:06 -0700
X-CSE-ConnectionGUID: lYGlEcTCSdmr6MXYN0OiRg==
X-CSE-MsgGUID: jhTm04ASTdu1UrsEeAy1dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673530"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:04 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 06/15] wifi: iwlwifi: avoid unnecessary indirection
Date: Wed, 30 Sep 2026 12:19:43 +0300
Message-Id: <20260930121740.8a85afed9cd7.If4806e645949ec73b8c734486605d7d4ea8ada4e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
References: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Some helpers in iwl-io are no more than thin wrappers that do tracing and
call the underlying iwl_trans_* function, which in turn calls the bus
specific implementation.
This forces an unneeded indirection for calls from within pcie, and in
general makes the code harder to follow.

Move the tracing to the pcie implementation and get rid of those wrappers:
change the pcie callers to call the pcie implementation directly, and the
callers outside the transport - to call the iwl_trans_* API.

This also improves the current callers of the pcie specific
implementations to include tracing, which they didn't have before this
commit.

Assisted-by: GitHubCopilot:claude-opus-4.8
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  |   4 +-
 .../net/wireless/intel/iwlwifi/dvm/devices.c  |   6 +-
 .../net/wireless/intel/iwlwifi/dvm/eeprom.c   |  30 ++---
 drivers/net/wireless/intel/iwlwifi/dvm/led.c  |  10 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  22 +--
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |  10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c   |  12 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   8 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |   2 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-io.h  |  18 +--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  42 ++----
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |   4 -
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  12 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c  |   6 +-
 .../intel/iwlwifi/pcie/ctxt-info-v2.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  58 ++++----
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 124 ++++++++---------
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  34 ++---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 127 +++++++++---------
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  14 +-
 .../net/wireless/intel/iwlwifi/pcie/utils.c   |   8 +-
 .../net/wireless/intel/iwlwifi/pcie/utils.h   |  14 +-
 27 files changed, 282 insertions(+), 315 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index ec94c43ba28c..ed041710c74f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2018, 2025 Intel Corporation
+ * Copyright (C) 2018, 2025-2026 Intel Corporation
  *****************************************************************************/
 
 #include <linux/slab.h>
@@ -1788,7 +1788,7 @@ static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	u32 pwrsave_status;
 
-	pwrsave_status = iwl_read32(priv->trans, CSR_GP_CNTRL) &
+	pwrsave_status = iwl_trans_read32(priv->trans, CSR_GP_CNTRL) &
 			CSR_GP_REG_POWER_SAVE_STATUS_MSK;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index 7f83f1bbdaad..b40a769f8e2d 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2019, 2025 Intel Corporation
+ * Copyright (C) 2019, 2025-2026 Intel Corporation
  *****************************************************************************/
 
 #include <linux/units.h>
@@ -490,8 +490,8 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		break;
 	case IWL_DEVICE_FAMILY_6000i:
 		/* 2x2 IPA phy type */
-		iwl_write32(priv->trans, CSR_GP_DRIVER_REG,
-			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
+		iwl_trans_write32(priv->trans, CSR_GP_DRIVER_REG,
+				  CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 		break;
 	case IWL_DEVICE_FAMILY_6050:
 		/* Indicate calibration version to uCode. */
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c b/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
index 6de2517188f7..d20691f7d82f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2005-2014, 2018-2019, 2021, 2024-2025 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2019, 2021, 2024-2026 Intel Corporation
  */
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -698,7 +698,7 @@ static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
 
 static int iwl_eeprom_verify_signature(struct iwl_trans *trans, bool nvm_is_otp)
 {
-	u32 gp = iwl_read32(trans, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+	u32 gp = iwl_trans_read32(trans, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 
 	IWL_DEBUG_EEPROM(trans->dev, "EEPROM signature=0x%08x\n", gp);
 
@@ -734,7 +734,7 @@ static int iwl_eeprom_verify_signature(struct iwl_trans *trans, bool nvm_is_otp)
 
 static void iwl_set_otp_access_absolute(struct iwl_trans *trans)
 {
-	iwl_read32(trans, CSR_OTP_GP_REG);
+	iwl_trans_read32(trans, CSR_OTP_GP_REG);
 
 	iwl_clear_bit(trans, CSR_OTP_GP_REG,
 		      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
@@ -755,7 +755,7 @@ static int iwl_nvm_is_otp(struct iwl_trans *trans)
 	case CSR_HW_REV_TYPE_5150:
 		return 0;
 	default:
-		otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
+		otpgp = iwl_trans_read32(trans, CSR_OTP_GP_REG);
 		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
 			return 1;
 		return 0;
@@ -794,8 +794,8 @@ static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
 	u32 r;
 	u32 otpgp;
 
-	iwl_write32(trans, CSR_EEPROM_REG,
-		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+	iwl_trans_write32(trans, CSR_EEPROM_REG,
+			  CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 	ret = iwl_poll_bits(trans, CSR_EEPROM_REG,
 			    CSR_EEPROM_REG_READ_VALID_MSK,
 			    IWL_EEPROM_ACCESS_TIMEOUT);
@@ -803,9 +803,9 @@ static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
 		IWL_ERR(trans, "Time out reading OTP[%d]\n", addr);
 		return ret;
 	}
-	r = iwl_read32(trans, CSR_EEPROM_REG);
+	r = iwl_trans_read32(trans, CSR_EEPROM_REG);
 	/* check for ECC errors: */
-	otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
+	otpgp = iwl_trans_read32(trans, CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
 		/* set the uncorrectable OTP ECC bit for acknowledgment */
@@ -918,7 +918,7 @@ static int iwl_find_otp_image(struct iwl_trans *trans,
 int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
 {
 	__le16 *e;
-	u32 gp = iwl_read32(trans, CSR_EEPROM_GP);
+	u32 gp = iwl_trans_read32(trans, CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
@@ -960,9 +960,9 @@ int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
 			goto err_unlock;
 		}
 
-		iwl_write32(trans, CSR_EEPROM_GP,
-			    iwl_read32(trans, CSR_EEPROM_GP) &
-			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
+		iwl_trans_write32(trans, CSR_EEPROM_GP,
+				  iwl_trans_read32(trans, CSR_EEPROM_GP) &
+				  ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
 		iwl_set_bit(trans, CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
@@ -988,8 +988,8 @@ int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			iwl_write32(trans, CSR_EEPROM_REG,
-				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+			iwl_trans_write32(trans, CSR_EEPROM_REG,
+					  CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
 			ret = iwl_poll_bits(trans, CSR_EEPROM_REG,
 					    CSR_EEPROM_REG_READ_VALID_MSK,
@@ -999,7 +999,7 @@ int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
 					"Time out reading EEPROM[%d]\n", addr);
 				goto err_unlock;
 			}
-			r = iwl_read32(trans, CSR_EEPROM_REG);
+			r = iwl_trans_read32(trans, CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index cec2ebdfd651..6fa02cd0ab04 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2019, 2025 Intel Corporation
+ * Copyright (C) 2019, 2025-2026 Intel Corporation
  *****************************************************************************/
 
 
@@ -49,7 +49,7 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 /* Set led register off */
 void iwlagn_led_enable(struct iwl_priv *priv)
 {
-	iwl_write32(priv->trans, CSR_LED_REG, CSR_LED_REG_TURN_ON);
+	iwl_trans_write32(priv->trans, CSR_LED_REG, CSR_LED_REG_TURN_ON);
 }
 
 /*
@@ -85,10 +85,10 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	};
 	u32 reg;
 
-	reg = iwl_read32(priv->trans, CSR_LED_REG);
+	reg = iwl_trans_read32(priv->trans, CSR_LED_REG);
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl_write32(priv->trans, CSR_LED_REG,
-			    reg & CSR_LED_BSM_CTRL_MSK);
+		iwl_trans_write32(priv->trans, CSR_LED_REG,
+				  reg & CSR_LED_BSM_CTRL_MSK);
 
 	return iwl_dvm_send_cmd(priv, &cmd);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index a0a26ef482a5..1da59e724054 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright(C) 2018 - 2019, 2022 - 2025 Intel Corporation
+ * Copyright(C) 2018 - 2019, 2022 - 2026 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -375,8 +375,8 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		goto error;
 
 	/* let the ucode operate on its own */
-	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
-		    CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+	iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
+			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	iwl_trans_d3_suspend(priv->trans, true);
 
@@ -455,8 +455,8 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 		goto out_unlock;
 
 	/* uCode is no longer operating by itself */
-	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+	iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
+			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	base = priv->device_pointers.error_event_table;
 	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 6bd5b6d84b2a..9bf16950ebf0 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014, 2018 - 2022 Intel Corporation. All rights reserved.
- * Copyright(c) 2024-2025 Intel Corporation. All rights reserved.
+ * Copyright(c) 2024-2026 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
@@ -413,7 +413,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		return;
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, ptr);
+	iwl_trans_write32(priv->trans, HBUS_TARG_MEM_RADDR, ptr);
 
 	/*
 	 * Refuse to read more than would have fit into the log from
@@ -429,13 +429,13 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	 * place event id # at far right for easier visual parsing.
 	 */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
+		ev = iwl_trans_read32(priv->trans, HBUS_TARG_MEM_RDAT);
+		time = iwl_trans_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			trace_iwlwifi_dev_ucode_cont_event(
 					priv->trans->dev, 0, time, ev);
 		} else {
-			data = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
+			data = iwl_trans_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 			trace_iwlwifi_dev_ucode_cont_event(
 					priv->trans->dev, time, data, ev);
 		}
@@ -661,8 +661,8 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	struct iwl_ct_kill_throttling_config adv_cmd;
 	int ret = 0;
 
-	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+	iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
+			  CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 
 	priv->thermal_throttle.ct_kill_toggle = false;
 
@@ -1731,13 +1731,13 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		return pos;
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
+	iwl_trans_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		ev = iwl_trans_read32(trans, HBUS_TARG_MEM_RDAT);
+		time = iwl_trans_read32(trans, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			if (bufsz) {
@@ -1751,7 +1751,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 					time, ev);
 			}
 		} else {
-			data = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+			data = iwl_trans_read32(trans, HBUS_TARG_MEM_RDAT);
 			if (bufsz) {
 				pos += scnprintf(*buf + pos, bufsz - pos,
 						"EVT_LOGT:%010u:0x%08x:%04u\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 088302a238de..79ee4fb239b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -3,7 +3,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Deutschland GmbH
- * Copyright(c) 2018, 2020-2021, 2025 Intel Corporation
+ * Copyright(c) 2018, 2020-2021, 2025-2026 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portionhelp of the ieee80211 subsystem header files.
@@ -482,15 +482,15 @@ static void iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
 		     CT_CARD_DISABLED)) {
 
-		iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
-			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+		iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
+				  CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 		iwl_write_direct32(priv->trans, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
-			iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
-				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+			iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
+					  CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 			iwl_write_direct32(priv->trans, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
index fc9cf0531024..c4ee22876f77 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2018, 2020 Intel Corporation
+ * Copyright (C) 2018, 2020, 2026 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -146,15 +146,15 @@ static void iwl_tt_check_exit_ct_kill(struct timer_list *t)
 
 	if (tt->state == IWL_TI_CT_KILL) {
 		if (priv->thermal_throttle.ct_kill_toggle) {
-			iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
-				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+			iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
+					  CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = false;
 		} else {
-			iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
-				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+			iwl_trans_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
+					  CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = true;
 		}
-		iwl_read32(priv->trans, CSR_UCODE_DRV_GP1);
+		iwl_trans_read32(priv->trans, CSR_UCODE_DRV_GP1);
 		if (iwl_trans_grab_nic_access(priv->trans))
 			iwl_trans_release_nic_access(priv->trans);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index bbbf3669a555..eef89c141564 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -404,7 +404,7 @@ void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 	}
 
 	if (fwrt->trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		u32 scratch = iwl_read32(fwrt->trans, CSR_FUNC_SCRATCH);
+		u32 scratch = iwl_trans_read32(fwrt->trans, CSR_FUNC_SCRATCH);
 
 		IWL_ERR(fwrt, "Function Scratch status:\n");
 		IWL_ERR(fwrt, "0x%08X | Func Scratch\n", scratch);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index ba14e583a4ad..b9f7e791dd37 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -14,7 +14,7 @@
  * low power states due to driver-invoked device resets
  * (e.g. CSR_RESET_REG_FLAG_SW_RESET) or uCode-driven power-saving modes.
  *
- * Use iwl_write32() and iwl_read32() family to access these registers;
+ * Use iwl_trans_write32() and iwl_trans_read32() family to access these registers;
  * these provide simple PCI bus access, without waking up the MAC.
  * Do not use iwl_write_direct32() family for these registers;
  * no need to "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ.
@@ -36,7 +36,7 @@
 #define CSR_GP_CNTRL            (CSR_BASE+0x024)
 #define CSR_FUNC_SCRATCH        (CSR_BASE+0x02c) /* Scratch register - used for FW dbg */
 
-/* 2nd byte of CSR_INT_COALESCING, not accessible via iwl_write32()! */
+/* 2nd byte of CSR_INT_COALESCING, not accessible via iwl_trans_write32()! */
 #define CSR_INT_PERIODIC_REG	(CSR_BASE+0x005)
 
 /*
@@ -474,7 +474,7 @@ enum {
  * indirect read/write via HEEP_CTRL_WRD_PCIEX_CTRL (0xEC) and
  * HEEP_CTRL_WRD_PCIEX_DATA (0xF4) registers.
  *
- * Use iwl_write32()/iwl_read32() family to access these registers. The MAC HW
+ * Use iwl_trans_write32()/iwl_trans_read32() family to access these registers. The MAC HW
  * need not be powered up so no "grab inc access" is required.
  */
 
@@ -507,7 +507,7 @@ enum {
  * to make sure the MAC (uCode processor, etc.) is powered up for accessing
  * internal resources.
  *
- * Do not use iwl_write32()/iwl_read32() family to access these registers;
+ * Do not use iwl_trans_write32()/iwl_trans_read32() family to access these registers;
  * these provide only simple PCI bus access, without waking up the MAC.
  */
 #define HBUS_BASE	(0x400)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 5aca343372d5..cc6044222b5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -931,7 +931,7 @@ static void iwl_dbg_tlv_apply_config(struct iwl_fw_runtime *fwrt,
 			for (count = 0; count < len; count++) {
 				address = le32_to_cpu(config_list->addr_val[count].address);
 				value = le32_to_cpu(config_list->addr_val[count].value);
-				iwl_write32(fwrt->trans, address + offset, value);
+				iwl_trans_write32(fwrt->trans, address + offset, value);
 				IWL_DEBUG_FW(fwrt, "WRT: CSR: count %u, add: %u val: %u\n",
 					     count, address, value);
 			}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
index 0af9d8362c5b..a0cc40119890 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
@@ -3,6 +3,7 @@
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2016-2017 Intel Deutschland GmbH
+ * Copyright (C) 2026 Intel Corporation
  *****************************************************************************/
 
 #if !defined(__IWLWIFI_DEVICE_TRACE_IO) || defined(TRACE_HEADER_MULTI_READ)
@@ -65,23 +66,6 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 		  __get_str(dev), __entry->offs, __entry->val)
 );
 
-TRACE_EVENT(iwlwifi_dev_iowrite64,
-	TP_PROTO(const struct device *dev, u64 offs, u64 val),
-	TP_ARGS(dev, offs, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u64, offs)
-		__field(u64, val)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->offs = offs;
-		__entry->val = val;
-	),
-	TP_printk("[%s] write io[%llu] = %llu)",
-		  __get_str(dev), __entry->offs, __entry->val)
-);
-
 TRACE_EVENT(iwlwifi_dev_iowrite_prph32,
 	TP_PROTO(const struct device *dev, u32 offs, u32 val),
 	TP_ARGS(dev, offs, val),
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 297f4550ae72..085074be2549 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -11,22 +11,6 @@
 #include "iwl-csr.h"
 #include "iwl-debug.h"
 
-void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
-{
-	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val);
-	iwl_trans_write32(trans, ofs, val);
-}
-IWL_EXPORT_SYMBOL(iwl_write32);
-
-u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
-{
-	u32 val = iwl_trans_read32(trans, ofs);
-
-	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val);
-	return val;
-}
-IWL_EXPORT_SYMBOL(iwl_read32);
-
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
 int iwl_poll_bits_mask(struct iwl_trans *trans, u32 addr,
@@ -35,7 +19,7 @@ int iwl_poll_bits_mask(struct iwl_trans *trans, u32 addr,
 	int t = 0;
 
 	do {
-		if ((iwl_read32(trans, addr) & mask) == (bits & mask))
+		if ((iwl_trans_read32(trans, addr) & mask) == (bits & mask))
 			return 0;
 		udelay(IWL_POLL_INTERVAL);
 		t += IWL_POLL_INTERVAL;
@@ -48,7 +32,7 @@ IWL_EXPORT_SYMBOL(iwl_poll_bits_mask);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_write32(trans, reg, value);
+		iwl_trans_write32(trans, reg, value);
 		iwl_trans_release_nic_access(trans);
 	}
 }
@@ -61,12 +45,6 @@ u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 	return val;
 }
 
-void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
-{
-	trace_iwlwifi_dev_iowrite_prph32(trans->dev, ofs, val);
-	iwl_trans_write_prph_no_grab(trans, ofs, val);
-}
-
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
@@ -86,7 +64,7 @@ void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val, u32 delay_m
 {
 	if (iwl_trans_grab_nic_access(trans)) {
 		mdelay(delay_ms);
-		iwl_write_prph_no_grab(trans, ofs, val);
+		iwl_trans_write_prph_no_grab(trans, ofs, val);
 		iwl_trans_release_nic_access(trans);
 	}
 }
@@ -95,9 +73,9 @@ IWL_EXPORT_SYMBOL(iwl_write_prph_delay);
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_write_prph_no_grab(trans, ofs,
-				       iwl_read_prph_no_grab(trans, ofs) |
-				       mask);
+		iwl_trans_write_prph_no_grab(trans, ofs,
+					     iwl_read_prph_no_grab(trans, ofs) |
+					     mask);
 		iwl_trans_release_nic_access(trans);
 	}
 }
@@ -107,9 +85,9 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_write_prph_no_grab(trans, ofs,
-				       (iwl_read_prph_no_grab(trans, ofs) &
-					mask) | bits);
+		iwl_trans_write_prph_no_grab(trans, ofs,
+					     (iwl_read_prph_no_grab(trans, ofs) &
+					      mask) | bits);
 		iwl_trans_release_nic_access(trans);
 	}
 }
@@ -121,7 +99,7 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 
 	if (iwl_trans_grab_nic_access(trans)) {
 		val = iwl_read_prph_no_grab(trans, ofs);
-		iwl_write_prph_no_grab(trans, ofs, (val & ~mask));
+		iwl_trans_write_prph_no_grab(trans, ofs, (val & ~mask));
 		iwl_trans_release_nic_access(trans);
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index b24c5eeca206..b33bc4822e5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -8,9 +8,6 @@
 #include "iwl-devtrace.h"
 #include "iwl-trans.h"
 
-void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val);
-u32 iwl_read32(struct iwl_trans *trans, u32 ofs);
-
 static inline void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	iwl_trans_set_bits_mask(trans, reg, mask, mask);
@@ -34,7 +31,6 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs);
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
-void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val);
 void iwl_write_prph_delay(struct iwl_trans *trans, u32 ofs,
 			  u32 val, u32 delay_ms);
 static inline void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 413dd55115f8..76cba6ac0c8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1312,10 +1312,10 @@ static void iwl_flip_hw_address(__le32 mac_addr0, __le32 mac_addr1, u8 *dest)
 static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
 					struct iwl_nvm_data *data)
 {
-	__le32 mac_addr0 = cpu_to_le32(iwl_read32(trans,
-						  CSR_MAC_ADDR0_STRAP(trans)));
-	__le32 mac_addr1 = cpu_to_le32(iwl_read32(trans,
-						  CSR_MAC_ADDR1_STRAP(trans)));
+	__le32 mac_addr0 = cpu_to_le32(iwl_trans_read32(trans,
+							CSR_MAC_ADDR0_STRAP(trans)));
+	__le32 mac_addr1 = cpu_to_le32(iwl_trans_read32(trans,
+							CSR_MAC_ADDR1_STRAP(trans)));
 
 	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 	/*
@@ -1325,8 +1325,8 @@ static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
 	if (is_valid_ether_addr(data->hw_addr))
 		return;
 
-	mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_OTP(trans)));
-	mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_OTP(trans)));
+	mac_addr0 = cpu_to_le32(iwl_trans_read32(trans, CSR_MAC_ADDR0_OTP(trans)));
+	mac_addr1 = cpu_to_le32(iwl_trans_read32(trans, CSR_MAC_ADDR1_OTP(trans)));
 
 	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index b3e39f0bbea4..2d0bb3de7df5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -432,11 +432,13 @@ void iwl_trans_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	iwl_trans_pcie_write32(trans, ofs, val);
 }
+IWL_EXPORT_SYMBOL(iwl_trans_write32);
 
 u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 {
 	return iwl_trans_pcie_read32(trans, ofs);
 }
+IWL_EXPORT_SYMBOL(iwl_trans_read32);
 
 u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
 {
@@ -460,8 +462,8 @@ void iwl_trans_force_nmi(struct iwl_trans *trans)
 		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
 				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
 	else
-		iwl_write32(trans, CSR_DOORBELL_VECTOR,
-			    UREG_DOORBELL_TO_ISR6_NMI_BIT);
+		iwl_trans_write32(trans, CSR_DOORBELL_VECTOR,
+				  UREG_DOORBELL_TO_ISR6_NMI_BIT);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_force_nmi);
 
@@ -485,10 +487,10 @@ int iwl_trans_write_mem(struct iwl_trans *trans, u32 addr,
 	const u32 *vals = buf;
 
 	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
+		iwl_trans_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
-			iwl_write32(trans, HBUS_TARG_MEM_WDAT,
-				    vals ? vals[offs] : 0);
+			iwl_trans_write32(trans, HBUS_TARG_MEM_WDAT,
+					  vals ? vals[offs] : 0);
 		iwl_trans_release_nic_access(trans);
 	} else {
 		ret = -EBUSY;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index c3cc1ea3ccc9..264423943b60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2019, 2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2019, 2025-2026 Intel Corporation
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
 #include <linux/leds.h>
@@ -38,8 +38,8 @@ static void iwl_mvm_led_set(struct iwl_mvm *mvm, bool on)
 		return;
 	}
 
-	iwl_write32(mvm->trans, CSR_LED_REG,
-		    on ? CSR_LED_REG_TURN_ON : CSR_LED_REG_TURN_OFF);
+	iwl_trans_write32(mvm->trans, CSR_LED_REG,
+			  on ? CSR_LED_REG_TURN_ON : CSR_LED_REG_TURN_OFF);
 }
 
 static void iwl_led_brightness_set(struct led_classdev *led_cdev,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index c57b17133772..917010a7d8ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -317,7 +317,7 @@ void iwl_pcie_ctxt_info_v2_kick(struct iwl_trans *trans)
 	/* kick FW self load */
 	iwl_pcie_write64(trans, CSR_CTXT_INFO_ADDR, trans_pcie->ctxt_info_dma_addr);
 	iwl_pcie_write64(trans, CSR_IML_DATA_ADDR, trans_pcie->iml_dma_addr);
-	iwl_write32(trans, CSR_IML_SIZE_ADDR, trans_pcie->iml_len);
+	iwl_trans_pcie_write32(trans, CSR_IML_SIZE_ADDR, trans_pcie->iml_len);
 
 	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
 		    CSR_AUTO_FUNC_BOOT_ENA);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 905482419a9a..24012005ccb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1252,7 +1252,7 @@ static int _iwl_pci_resume(struct device *device, bool restore)
 		 * For older devices, just try silently to grab the NIC.
 		 */
 		if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-			u32 scratch = iwl_read32(trans, CSR_FUNC_SCRATCH);
+			u32 scratch = iwl_trans_pcie_read32(trans, CSR_FUNC_SCRATCH);
 
 			if (!(scratch & CSR_FUNC_SCRATCH_POWER_OFF_MASK) ||
 			    scratch == ~0U) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 550c5c23a52e..96821850298f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -24,6 +24,13 @@
 #include "iwl-drv.h"
 #include "iwl-context-info.h"
 
+/* transport-specific register accessors (bus implementation) */
+void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val);
+void iwl_trans_pcie_write32(struct iwl_trans *trans, u32 ofs, u32 val);
+u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs);
+u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg);
+void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val);
+
 /*
  * RX related structures and functions
  */
@@ -593,7 +600,7 @@ static inline void iwl_pcie_clear_irq(struct iwl_trans *trans, int queue)
 	 * write 1 clear (W1C) register, meaning that it's being clear
 	 * by writing 1 to the bit.
 	 */
-	iwl_write32(trans, CSR_MSIX_AUTOMASK_ST_AD, BIT(queue));
+	iwl_trans_pcie_write32(trans, CSR_MSIX_AUTOMASK_ST_AD, BIT(queue));
 }
 
 static inline struct iwl_trans *
@@ -889,18 +896,18 @@ static inline void _iwl_disable_interrupts(struct iwl_trans *trans)
 	clear_bit(STATUS_INT_ENABLED, &trans->status);
 	if (!trans_pcie->msix_enabled) {
 		/* disable interrupts from uCode/NIC to host */
-		iwl_write32(trans, CSR_INT_MASK, 0x00000000);
+		iwl_trans_pcie_write32(trans, CSR_INT_MASK, 0x00000000);
 
 		/* acknowledge/clear/reset any interrupts still pending
 		 * from uCode or flow handler (Rx/Tx DMA) */
-		iwl_write32(trans, CSR_INT, 0xffffffff);
-		iwl_write32(trans, CSR_FH_INT_STATUS, 0xffffffff);
+		iwl_trans_pcie_write32(trans, CSR_INT, 0xffffffff);
+		iwl_trans_pcie_write32(trans, CSR_FH_INT_STATUS, 0xffffffff);
 	} else {
 		/* disable all the interrupt we might use */
-		iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
-			    trans_pcie->fh_init_mask);
-		iwl_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
-			    trans_pcie->hw_init_mask);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
+				       trans_pcie->fh_init_mask);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
+				       trans_pcie->hw_init_mask);
 		trans_pcie->fh_mask = 0;
 		trans_pcie->hw_mask = 0;
 	}
@@ -958,7 +965,7 @@ static inline void _iwl_enable_interrupts(struct iwl_trans *trans)
 	set_bit(STATUS_INT_ENABLED, &trans->status);
 	if (!trans_pcie->msix_enabled) {
 		trans_pcie->inta_mask = CSR_INI_SET_MASK;
-		iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
+		iwl_trans_pcie_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 	} else {
 		/*
 		 * fh/hw_mask keeps all the unmasked causes.
@@ -966,10 +973,10 @@ static inline void _iwl_enable_interrupts(struct iwl_trans *trans)
 		 */
 		trans_pcie->hw_mask = trans_pcie->hw_init_mask;
 		trans_pcie->fh_mask = trans_pcie->fh_init_mask;
-		iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
-			    ~trans_pcie->fh_mask);
-		iwl_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
-			    ~trans_pcie->hw_mask);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
+				       ~trans_pcie->fh_mask);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
+				       ~trans_pcie->hw_mask);
 	}
 }
 
@@ -985,7 +992,7 @@ static inline void iwl_enable_hw_int_msk_msix(struct iwl_trans *trans, u32 msk)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	iwl_write32(trans, CSR_MSIX_HW_INT_MASK_AD, ~msk);
+	iwl_trans_pcie_write32(trans, CSR_MSIX_HW_INT_MASK_AD, ~msk);
 	trans_pcie->hw_mask = msk;
 }
 
@@ -993,7 +1000,7 @@ static inline void iwl_enable_fh_int_msk_msix(struct iwl_trans *trans, u32 msk)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~msk);
+	iwl_trans_pcie_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~msk);
 	trans_pcie->fh_mask = msk;
 }
 
@@ -1004,10 +1011,10 @@ static inline void iwl_enable_fw_load_int(struct iwl_trans *trans)
 	IWL_DEBUG_ISR(trans, "Enabling FW load interrupt\n");
 	if (!trans_pcie->msix_enabled) {
 		trans_pcie->inta_mask = CSR_INT_BIT_FH_TX;
-		iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
+		iwl_trans_pcie_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 	} else {
-		iwl_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
-			    trans_pcie->hw_init_mask);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_HW_INT_MASK_AD,
+				       trans_pcie->hw_init_mask);
 		iwl_enable_fh_int_msk_msix(trans,
 					   MSIX_FH_INT_CAUSES_D2S_CH0_NUM);
 	}
@@ -1034,7 +1041,7 @@ static inline void iwl_enable_fw_load_int_ctx_info(struct iwl_trans *trans,
 		else
 			trans_pcie->inta_mask =  CSR_INT_BIT_ALIVE |
 						 CSR_INT_BIT_FH_RX;
-		iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
+		iwl_trans_pcie_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 	} else {
 		u32 val = top_reset ? MSIX_HW_INT_CAUSES_REG_RESET_DONE
 				    : MSIX_HW_INT_CAUSES_REG_ALIVE;
@@ -1081,10 +1088,10 @@ static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
 	if (!trans_pcie->msix_enabled) {
 		trans_pcie->inta_mask = CSR_INT_BIT_RF_KILL;
-		iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
+		iwl_trans_pcie_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 	} else {
-		iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
-			    trans_pcie->fh_init_mask);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_FH_INT_MASK_AD,
+				       trans_pcie->fh_init_mask);
 		trans_pcie->fh_mask = 0;
 		iwl_enable_hw_int_msk_msix(trans,
 					   MSIX_HW_INT_CAUSES_REG_RF_KILL);
@@ -1112,7 +1119,7 @@ static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
 	if (trans_pcie->debug_rfkill == 1)
 		return true;
 
-	return !(iwl_read32(trans, CSR_GP_CNTRL) &
+	return !(iwl_trans_pcie_read32(trans, CSR_GP_CNTRL) &
 		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 }
 
@@ -1136,11 +1143,6 @@ void iwl_trans_pcie_op_mode_enter(struct iwl_trans *trans);
 int _iwl_trans_pcie_start_hw(struct iwl_trans *trans);
 int iwl_trans_pcie_start_hw(struct iwl_trans *trans);
 void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans);
-void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val);
-void iwl_trans_pcie_write32(struct iwl_trans *trans, u32 ofs, u32 val);
-u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs);
-u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg);
-void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val);
 int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 			    void *buf, int dwords);
 int iwl_trans_pcie_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index fec3d6e0b146..cf6beba6041f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -179,7 +179,7 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	 */
 	if (!trans->mac_cfg->base->shadow_reg_enable &&
 	    test_bit(STATUS_TPOWER_PMI, &trans->status)) {
-		reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
+		reg = iwl_trans_pcie_read32(trans, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO(trans, "Rx queue requesting wakeup, GP1 = 0x%x\n",
@@ -193,13 +193,13 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 
 	rxq->write_actual = round_down(rxq->write, 8);
 	if (!trans->mac_cfg->mq_rx_supported)
-		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
+		iwl_trans_pcie_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
 	else if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
-		iwl_write32(trans, HBUS_TARG_WRPTR, rxq->write_actual |
-			    HBUS_TARG_WRPTR_RX_Q(rxq->id));
+		iwl_trans_pcie_write32(trans, HBUS_TARG_WRPTR, rxq->write_actual |
+				       HBUS_TARG_WRPTR_RX_Q(rxq->id));
 	else
-		iwl_write32(trans, RFH_Q_FRBDCB_WIDX_TRG(rxq->id),
-			    rxq->write_actual);
+		iwl_trans_pcie_write32(trans, RFH_Q_FRBDCB_WIDX_TRG(rxq->id),
+				       rxq->write_actual);
 }
 
 static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
@@ -855,22 +855,22 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 		return;
 
 	/* Stop Rx DMA */
-	iwl_write32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_trans_pcie_write32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 	/* reset and flush pointers */
-	iwl_write32(trans, FH_MEM_RCSR_CHNL0_RBDCB_WPTR, 0);
-	iwl_write32(trans, FH_MEM_RCSR_CHNL0_FLUSH_RB_REQ, 0);
-	iwl_write32(trans, FH_RSCSR_CHNL0_RDPTR, 0);
+	iwl_trans_pcie_write32(trans, FH_MEM_RCSR_CHNL0_RBDCB_WPTR, 0);
+	iwl_trans_pcie_write32(trans, FH_MEM_RCSR_CHNL0_FLUSH_RB_REQ, 0);
+	iwl_trans_pcie_write32(trans, FH_RSCSR_CHNL0_RDPTR, 0);
 
 	/* Reset driver's Rx queue write index */
-	iwl_write32(trans, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	iwl_trans_pcie_write32(trans, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write32(trans, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-		    (u32)(rxq->bd_dma >> 8));
+	iwl_trans_pcie_write32(trans, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+			       (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
-	iwl_write32(trans, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-		    rxq->rb_stts_dma >> 4);
+	iwl_trans_pcie_write32(trans, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+			       rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
 	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
@@ -880,13 +880,13 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
-	iwl_write32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-		    FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-		    FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
-		    FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-		    rb_size |
-		    (RX_RB_TIMEOUT << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS) |
-		    (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+	iwl_trans_pcie_write32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+			       FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			       FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
+			       FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			       rb_size |
+			       (RX_RB_TIMEOUT << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS) |
+			       (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
 	iwl_trans_release_nic_access(trans);
 
@@ -926,9 +926,9 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 		return;
 
 	/* Stop Rx DMA */
-	iwl_write_prph_no_grab(trans, RFH_RXF_DMA_CFG, 0);
+	iwl_pcie_write_prph_no_grab(trans, RFH_RXF_DMA_CFG, 0);
 	/* disable free amd used rx queue operation */
-	iwl_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, 0);
+	iwl_pcie_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, 0);
 
 	for (i = 0; i < trans->info.num_rxqs; i++) {
 		/* Tell device where to find RBD free table in DRAM */
@@ -944,9 +944,9 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 					      RFH_Q_URBD_STTS_WPTR_LSB(i),
 					      trans_pcie->rxq[i].rb_stts_dma);
 		/* Reset device indice tables */
-		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_WIDX(i), 0);
-		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_RIDX(i), 0);
-		iwl_write_prph_no_grab(trans, RFH_Q_URBDCB_WIDX(i), 0);
+		iwl_pcie_write_prph_no_grab(trans, RFH_Q_FRBDCB_WIDX(i), 0);
+		iwl_pcie_write_prph_no_grab(trans, RFH_Q_FRBDCB_RIDX(i), 0);
+		iwl_pcie_write_prph_no_grab(trans, RFH_Q_URBDCB_WIDX(i), 0);
 
 		enabled |= BIT(i) | BIT(i + 16);
 	}
@@ -958,27 +958,27 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 	 * Drop frames that exceed RB size
 	 * 512 RBDs
 	 */
-	iwl_write_prph_no_grab(trans, RFH_RXF_DMA_CFG,
-			       RFH_DMA_EN_ENABLE_VAL | rb_size |
-			       RFH_RXF_DMA_MIN_RB_4_8 |
-			       RFH_RXF_DMA_DROP_TOO_LARGE_MASK |
-			       RFH_RXF_DMA_RBDCB_SIZE_512);
+	iwl_pcie_write_prph_no_grab(trans, RFH_RXF_DMA_CFG,
+				    RFH_DMA_EN_ENABLE_VAL | rb_size |
+				    RFH_RXF_DMA_MIN_RB_4_8 |
+				    RFH_RXF_DMA_DROP_TOO_LARGE_MASK |
+				    RFH_RXF_DMA_RBDCB_SIZE_512);
 
 	/*
 	 * Activate DMA snooping.
 	 * Set RX DMA chunk size to 64B for IOSF and 128B for PCIe
 	 * Default queue is 0
 	 */
-	iwl_write_prph_no_grab(trans, RFH_GEN_CFG,
-			       RFH_GEN_CFG_RFH_DMA_SNOOP |
-			       RFH_GEN_CFG_VAL(DEFAULT_RXQ_NUM, 0) |
-			       RFH_GEN_CFG_SERVICE_DMA_SNOOP |
-			       RFH_GEN_CFG_VAL(RB_CHUNK_SIZE,
-					       trans->mac_cfg->integrated ?
-					       RFH_GEN_CFG_RB_CHUNK_SIZE_64 :
-					       RFH_GEN_CFG_RB_CHUNK_SIZE_128));
+	iwl_pcie_write_prph_no_grab(trans, RFH_GEN_CFG,
+				    RFH_GEN_CFG_RFH_DMA_SNOOP |
+				    RFH_GEN_CFG_VAL(DEFAULT_RXQ_NUM, 0) |
+				    RFH_GEN_CFG_SERVICE_DMA_SNOOP |
+				    RFH_GEN_CFG_VAL(RB_CHUNK_SIZE,
+						    trans->mac_cfg->integrated ?
+						    RFH_GEN_CFG_RB_CHUNK_SIZE_64 :
+						    RFH_GEN_CFG_RB_CHUNK_SIZE_128));
 	/* Enable the relevant rx queues */
-	iwl_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, enabled);
+	iwl_pcie_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, enabled);
 
 	iwl_trans_release_nic_access(trans);
 
@@ -1709,7 +1709,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	}
 
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_SC) {
-		u32 val = iwl_read32(trans, CSR_IPC_STATE);
+		u32 val = iwl_trans_pcie_read32(trans, CSR_IPC_STATE);
 
 		if (val & CSR_IPC_STATE_TOP_RESET_REQ) {
 			IWL_ERR(trans, "FW requested TOP reset for FSEQ\n");
@@ -1734,7 +1734,7 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 	trace_iwlwifi_dev_irq(trans->dev);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(trans, CSR_INT);
+	inta = iwl_trans_pcie_read32(trans, CSR_INT);
 
 	/* the thread will service interrupts and re-enable them */
 	return inta;
@@ -1851,7 +1851,7 @@ static void iwl_trans_pcie_handle_reset_interrupt(struct iwl_trans *trans)
 	u32 state;
 
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_SC) {
-		u32 val = iwl_read32(trans, CSR_IPC_STATE);
+		u32 val = iwl_trans_pcie_read32(trans, CSR_IPC_STATE);
 
 		state = u32_get_bits(val, CSR_IPC_STATE_RESET);
 		IWL_DEBUG_ISR(trans, "IPC state = 0x%x/%d\n", val, state);
@@ -1923,8 +1923,8 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans,
 			      "ISR inta 0x%08x, enabled 0x%08x(sw), enabled(hw) 0x%08x, fh 0x%08x\n",
 			      inta, trans_pcie->inta_mask,
-			      iwl_read32(trans, CSR_INT_MASK),
-			      iwl_read32(trans, CSR_FH_INT_STATUS));
+			      iwl_trans_pcie_read32(trans, CSR_INT_MASK),
+			      iwl_trans_pcie_read32(trans, CSR_FH_INT_STATUS));
 		if (inta & (~trans_pcie->inta_mask))
 			IWL_DEBUG_ISR(trans,
 				      "We got a masked interrupt (0x%08x)\n",
@@ -1972,11 +1972,11 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(trans, CSR_INT, inta | ~trans_pcie->inta_mask);
+	iwl_trans_pcie_write32(trans, CSR_INT, inta | ~trans_pcie->inta_mask);
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
-			      inta, iwl_read32(trans, CSR_INT_MASK));
+			      inta, iwl_trans_pcie_read32(trans, CSR_INT_MASK));
 
 	spin_unlock_bh(&trans_pcie->irq_lock);
 
@@ -2071,13 +2071,13 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-			iwl_write32(trans, CSR_FH_INT_STATUS,
-					CSR_FH_INT_RX_MASK);
+			iwl_trans_pcie_write32(trans, CSR_FH_INT_STATUS,
+					       CSR_FH_INT_RX_MASK);
 		}
 		if (inta & CSR_INT_BIT_RX_PERIODIC) {
 			handled |= CSR_INT_BIT_RX_PERIODIC;
-			iwl_write32(trans,
-				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
+			iwl_trans_pcie_write32(trans,
+					       CSR_INT, CSR_INT_BIT_RX_PERIODIC);
 		}
 		/* Sending RX interrupt require many steps to be done in the
 		 * device:
@@ -2117,7 +2117,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(trans, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
+		iwl_trans_pcie_write32(trans, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
 		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
@@ -2231,10 +2231,10 @@ void iwl_pcie_reset_ict(struct iwl_trans *trans)
 
 	IWL_DEBUG_ISR(trans, "CSR_DRAM_INT_TBL_REG =0x%x\n", val);
 
-	iwl_write32(trans, CSR_DRAM_INT_TBL_REG, val);
+	iwl_trans_pcie_write32(trans, CSR_DRAM_INT_TBL_REG, val);
 	trans_pcie->use_ict = true;
 	trans_pcie->ict_index = 0;
-	iwl_write32(trans, CSR_INT, trans_pcie->inta_mask);
+	iwl_trans_pcie_write32(trans, CSR_INT, trans_pcie->inta_mask);
 	_iwl_enable_interrupts(trans);
 	spin_unlock_bh(&trans_pcie->irq_lock);
 }
@@ -2261,7 +2261,7 @@ irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
+	iwl_trans_pcie_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	return IRQ_WAKE_THREAD;
 }
@@ -2291,13 +2291,13 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
 	spin_lock_bh(&trans_pcie->irq_lock);
-	inta_fh = iwl_read32(trans, CSR_MSIX_FH_INT_CAUSES_AD);
-	inta_hw = iwl_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD);
+	inta_fh = iwl_trans_pcie_read32(trans, CSR_MSIX_FH_INT_CAUSES_AD);
+	inta_hw = iwl_trans_pcie_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD);
 	/*
 	 * Clear causes registers to avoid being handling the same cause.
 	 */
-	iwl_write32(trans, CSR_MSIX_FH_INT_CAUSES_AD, inta_fh & inta_fh_msk);
-	iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD, inta_hw);
+	iwl_trans_pcie_write32(trans, CSR_MSIX_FH_INT_CAUSES_AD, inta_fh & inta_fh_msk);
+	iwl_trans_pcie_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD, inta_hw);
 	spin_unlock_bh(&trans_pcie->irq_lock);
 
 	trace_iwlwifi_dev_irq_msix(trans->dev, entry, true, inta_fh, inta_hw);
@@ -2312,7 +2312,7 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans,
 			      "ISR[%d] inta_fh 0x%08x, enabled (sw) 0x%08x (hw) 0x%08x\n",
 			      entry->entry, inta_fh, trans_pcie->fh_mask,
-			      iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD));
+			      iwl_trans_pcie_read32(trans, CSR_MSIX_FH_INT_MASK_AD));
 		if (inta_fh & ~trans_pcie->fh_mask)
 			IWL_DEBUG_ISR(trans,
 				      "We got a masked interrupt (0x%08x)\n",
@@ -2414,7 +2414,7 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans,
 			      "ISR[%d] inta_hw 0x%08x, enabled (sw) 0x%08x (hw) 0x%08x\n",
 			      entry->entry, inta_hw, trans_pcie->hw_mask,
-			      iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD));
+			      iwl_trans_pcie_read32(trans, CSR_MSIX_HW_INT_MASK_AD));
 		if (inta_hw & ~trans_pcie->hw_mask)
 			IWL_DEBUG_ISR(trans,
 				      "We got a masked interrupt 0x%08x\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 39dd963920b3..91d0b935fca6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -111,8 +111,8 @@ _iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans,
 		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
 				    UREG_DOORBELL_TO_ISR6_RESET_HANDSHAKE);
 	else
-		iwl_write32(trans, CSR_DOORBELL_VECTOR,
-			    UREG_DOORBELL_TO_ISR6_RESET_HANDSHAKE);
+		iwl_trans_pcie_write32(trans, CSR_DOORBELL_VECTOR,
+				       UREG_DOORBELL_TO_ISR6_RESET_HANDSHAKE);
 
 	/* wait 200ms */
 	ret = wait_event_timeout(trans_pcie->fw_reset_waitq,
@@ -123,11 +123,11 @@ _iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans,
 		u32 inta_hw;
 
 		if (trans_pcie->msix_enabled) {
-			inta_hw = iwl_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD);
+			inta_hw = iwl_trans_pcie_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD);
 			reset_done =
 				inta_hw & MSIX_HW_INT_CAUSES_REG_RESET_DONE;
 		} else {
-			inta_hw = iwl_read32(trans, CSR_INT);
+			inta_hw = iwl_trans_pcie_read32(trans, CSR_INT);
 			reset_done = inta_hw & CSR_INT_BIT_RESET_DONE;
 		}
 
@@ -434,7 +434,7 @@ static bool iwl_pcie_set_ltr(struct iwl_trans *trans)
 	if ((trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_AX210 ||
 	     trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_22000) &&
 	    !trans->mac_cfg->integrated) {
-		iwl_write32(trans, CSR_LTR_LONG_VAL_AD, ltr_val);
+		iwl_trans_pcie_write32(trans, CSR_LTR_LONG_VAL_AD, ltr_val);
 		return true;
 	}
 
@@ -447,8 +447,8 @@ static bool iwl_pcie_set_ltr(struct iwl_trans *trans)
 
 	if (trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_AX210) {
 		/* First clear the interrupt, just in case */
-		iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD,
-			    MSIX_HW_INT_CAUSES_REG_IML);
+		iwl_trans_pcie_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD,
+				       MSIX_HW_INT_CAUSES_REG_IML);
 		/* In this case, unfortunately the same ROM bug exists in the
 		 * device (not setting LTR correctly), but we don't have control
 		 * over the settings from the host due to some hardware security
@@ -475,18 +475,18 @@ static void iwl_pcie_spin_for_iml(struct iwl_trans *trans)
 	if (WARN_ON(!trans_pcie->iml))
 		return;
 
-	value = iwl_read32(trans, CSR_LTR_LAST_MSG);
+	value = iwl_trans_pcie_read32(trans, CSR_LTR_LAST_MSG);
 	IWL_DEBUG_INFO(trans, "Polling for IML load - CSR_LTR_LAST_MSG=0x%x\n",
 		       value);
 
 	while (time_before(jiffies, end_time)) {
-		if (iwl_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD) &
+		if (iwl_trans_pcie_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD) &
 				MSIX_HW_INT_CAUSES_REG_IML) {
 			irq = true;
 			break;
 		}
 		/* Keep the CPU and device busy. */
-		value = iwl_read32(trans, CSR_LTR_LAST_MSG);
+		value = iwl_trans_pcie_read32(trans, CSR_LTR_LAST_MSG);
 		loops++;
 	}
 
@@ -522,7 +522,7 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 
 	iwl_enable_rfkill_int(trans);
 
-	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+	iwl_trans_pcie_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	/*
 	 * We enabled the RF-Kill interrupt and the handler may very
@@ -550,12 +550,12 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+	iwl_trans_pcie_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_trans_pcie_write32(trans, CSR_UCODE_DRV_GP1_CLR,
+			       CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+	iwl_trans_pcie_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	ret = iwl_pcie_gen2_nic_init(trans);
 	if (ret) {
@@ -591,8 +591,8 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
 		IWL_DEBUG_POWER(trans, "function scratch register value is 0x%08x\n",
-				iwl_read32(trans, CSR_FUNC_SCRATCH));
-		iwl_write32(trans, CSR_FUNC_SCRATCH, CSR_FUNC_SCRATCH_INIT_VALUE);
+				iwl_trans_pcie_read32(trans, CSR_FUNC_SCRATCH));
+		iwl_trans_pcie_write32(trans, CSR_FUNC_SCRATCH, CSR_FUNC_SCRATCH_INIT_VALUE);
 		iwl_set_bit(trans, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_ROM_START);
 	} else if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b81dd7daca6c..8dc8924564e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -44,10 +44,10 @@ static void iwl_dump_host_monitor_block(struct iwl_trans *trans,
 	int i;
 
 	IWL_ERR(trans, "Host monitor block 0x%x vector 0x%x\n", block, vec);
-	iwl_write32(trans, CSR_MONITOR_CFG_REG, (block << 8) | vec);
+	iwl_trans_pcie_write32(trans, CSR_MONITOR_CFG_REG, (block << 8) | vec);
 	for (i = 0; i < iter; i++)
 		IWL_ERR(trans, "    value [iter %d]: 0x%08x\n",
-			i, iwl_read32(trans, CSR_MONITOR_STATUS_REG));
+			i, iwl_trans_pcie_read32(trans, CSR_MONITOR_STATUS_REG));
 }
 
 static void iwl_pcie_dump_host_monitor(struct iwl_trans *trans)
@@ -56,7 +56,7 @@ static void iwl_pcie_dump_host_monitor(struct iwl_trans *trans)
 	case IWL_DEVICE_FAMILY_22000:
 	case IWL_DEVICE_FAMILY_AX210:
 		IWL_ERR(trans, "CSR_RESET = 0x%x\n",
-			iwl_read32(trans, CSR_RESET));
+			iwl_trans_pcie_read32(trans, CSR_RESET));
 		iwl_dump_host_monitor_block(trans, IWL_HOST_MON_BLOCK_PEMON,
 					    IWL_HOST_MON_BLOCK_PEMON_VEC0, 15);
 		iwl_dump_host_monitor_block(trans, IWL_HOST_MON_BLOCK_PEMON,
@@ -170,16 +170,16 @@ void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
 
 static u32 iwl_trans_pcie_read_shr(struct iwl_trans *trans, u32 reg)
 {
-	iwl_write32(trans, HEEP_CTRL_WRD_PCIEX_CTRL_REG,
-		    ((reg & 0x0000ffff) | (2 << 28)));
-	return iwl_read32(trans, HEEP_CTRL_WRD_PCIEX_DATA_REG);
+	iwl_trans_pcie_write32(trans, HEEP_CTRL_WRD_PCIEX_CTRL_REG,
+			       ((reg & 0x0000ffff) | (2 << 28)));
+	return iwl_trans_pcie_read32(trans, HEEP_CTRL_WRD_PCIEX_DATA_REG);
 }
 
 static void iwl_trans_pcie_write_shr(struct iwl_trans *trans, u32 reg, u32 val)
 {
-	iwl_write32(trans, HEEP_CTRL_WRD_PCIEX_DATA_REG, val);
-	iwl_write32(trans, HEEP_CTRL_WRD_PCIEX_CTRL_REG,
-		    ((reg & 0x0000ffff) | (3 << 28)));
+	iwl_trans_pcie_write32(trans, HEEP_CTRL_WRD_PCIEX_DATA_REG, val);
+	iwl_trans_pcie_write32(trans, HEEP_CTRL_WRD_PCIEX_CTRL_REG,
+			       ((reg & 0x0000ffff) | (3 << 28)));
 }
 
 static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
@@ -603,28 +603,28 @@ static void iwl_pcie_load_firmware_chunk_fh(struct iwl_trans *trans,
 					    u32 dst_addr, dma_addr_t phy_addr,
 					    u32 byte_cnt)
 {
-	iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
+	iwl_trans_pcie_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+			       FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
 
-	iwl_write32(trans, FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL),
-		    dst_addr);
+	iwl_trans_pcie_write32(trans, FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL),
+			       dst_addr);
 
-	iwl_write32(trans, FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
-		    phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
+	iwl_trans_pcie_write32(trans, FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
+			       phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
-	iwl_write32(trans, FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-		    (iwl_get_dma_hi_addr(phy_addr)
-			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+	iwl_trans_pcie_write32(trans, FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
+			       (iwl_get_dma_hi_addr(phy_addr)
+				<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
-	iwl_write32(trans, FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
-		    BIT(FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM) |
-		    BIT(FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX) |
-		    FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
+	iwl_trans_pcie_write32(trans, FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
+			       BIT(FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM) |
+			       BIT(FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX) |
+			       FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
 
-	iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-		    FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE |
-		    FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+	iwl_trans_pcie_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+			       FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+			       FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE |
+			       FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 }
 
 static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans,
@@ -884,7 +884,7 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 
 		switch (dest->reg_ops[i].op) {
 		case CSR_ASSIGN:
-			iwl_write32(trans, addr, val);
+			iwl_trans_pcie_write32(trans, addr, val);
 			break;
 		case CSR_SETBIT:
 			iwl_set_bit(trans, addr, BIT(val));
@@ -964,7 +964,7 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	iwl_enable_interrupts(trans);
 
 	/* release CPU reset */
-	iwl_write32(trans, CSR_RESET, 0);
+	iwl_trans_pcie_write32(trans, CSR_RESET, 0);
 
 	return 0;
 }
@@ -1123,7 +1123,7 @@ static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
 				      MSIX_FH_INT_CAUSES_Q(idx - offset));
 		val |= BIT(MSIX_FH_INT_CAUSES_Q(idx));
 	}
-	iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~val);
+	iwl_trans_pcie_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~val);
 
 	val = MSIX_FH_INT_CAUSES_Q(0);
 	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_NON_RX)
@@ -1174,9 +1174,9 @@ static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
 	if (!trans_pcie->msix_enabled)
 		return;
 
-	trans_pcie->fh_init_mask = ~iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
+	trans_pcie->fh_init_mask = ~iwl_trans_pcie_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
 	trans_pcie->fh_mask = trans_pcie->fh_init_mask;
-	trans_pcie->hw_init_mask = ~iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD);
+	trans_pcie->hw_init_mask = ~iwl_trans_pcie_read32(trans, CSR_MSIX_HW_INT_MASK_AD);
 	trans_pcie->hw_mask = trans_pcie->hw_init_mask;
 }
 
@@ -1296,7 +1296,7 @@ int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 
 	iwl_enable_rfkill_int(trans);
 
-	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+	iwl_trans_pcie_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	/*
 	 * We enabled the RF-Kill interrupt and the handler may very
@@ -1326,12 +1326,12 @@ int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+	iwl_trans_pcie_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_trans_pcie_write32(trans, CSR_UCODE_DRV_GP1_CLR,
+			       CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+	iwl_trans_pcie_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	ret = iwl_pcie_nic_init(trans);
 	if (ret) {
@@ -1349,8 +1349,8 @@ int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	iwl_enable_fw_load_int(trans);
 
 	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_trans_pcie_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_trans_pcie_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Load the given image to the HW */
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_8000)
@@ -1482,9 +1482,9 @@ static int iwl_pcie_d3_handshake(struct iwl_trans *trans, bool suspend)
 				    suspend ? UREG_DOORBELL_TO_ISR6_SUSPEND :
 					      UREG_DOORBELL_TO_ISR6_RESUME);
 	else
-		iwl_write32(trans, CSR_IPC_SLEEP_CONTROL,
-			    suspend ? CSR_IPC_SLEEP_CONTROL_SUSPEND :
-				      CSR_IPC_SLEEP_CONTROL_RESUME);
+		iwl_trans_pcie_write32(trans, CSR_IPC_SLEEP_CONTROL,
+				       suspend ? CSR_IPC_SLEEP_CONTROL_SUSPEND :
+						 CSR_IPC_SLEEP_CONTROL_RESUME);
 
 	ret = wait_event_timeout(trans_pcie->sx_waitq,
 				 trans_pcie->sx_state != IWL_SX_WAITING,
@@ -1579,7 +1579,7 @@ int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	IWL_DEBUG_POWER(trans, "WFPM value upon resume = 0x%08X\n",
 			iwl_read_umac_prph(trans, WFPM_GP2));
 
-	val = iwl_read32(trans, CSR_RESET);
+	val = iwl_trans_pcie_read32(trans, CSR_RESET);
 	if (val & CSR_RESET_REG_FLAG_NEVO_RESET) {
 		IWL_INFO(trans, "Device was reset during suspend\n");
 		trans->state = IWL_TRANS_NO_FW;
@@ -1870,12 +1870,16 @@ void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 
 void iwl_trans_pcie_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
+	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val);
 	writel(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
 u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 {
-	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+	u32 val = readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+
+	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val);
+	return val;
 }
 
 static u32 iwl_trans_pcie_prph_msk(struct iwl_trans *trans)
@@ -1899,6 +1903,7 @@ void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val)
 {
 	u32 mask = iwl_trans_pcie_prph_msk(trans);
 
+	trace_iwlwifi_dev_iowrite_prph32(trans->dev, addr, val);
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WADDR,
 			       ((addr & mask) | (3 << 24)));
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
@@ -2377,7 +2382,7 @@ bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 	 */
 	ret = iwl_poll_bits_mask(trans, CSR_GP_CNTRL, poll, mask, 15000);
 	if (unlikely(ret)) {
-		u32 cntrl = iwl_read32(trans, CSR_GP_CNTRL);
+		u32 cntrl = iwl_trans_pcie_read32(trans, CSR_GP_CNTRL);
 
 		if (silent) {
 			spin_unlock(&trans_pcie->reg_lock);
@@ -2394,8 +2399,8 @@ bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 			iwl_trans_pcie_reset(trans,
 					     IWL_RESET_MODE_REMOVE_ONLY);
 		else
-			iwl_write32(trans, CSR_RESET,
-				    CSR_RESET_REG_FLAG_FORCE_NMI);
+			iwl_trans_pcie_write32(trans, CSR_RESET,
+					       CSR_RESET_REG_FLAG_FORCE_NMI);
 
 		spin_unlock(&trans_pcie->reg_lock);
 		return false;
@@ -2473,12 +2478,12 @@ int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 		bool resched = false;
 
 		if (iwl_trans_grab_nic_access(trans)) {
-			iwl_write32(trans, HBUS_TARG_MEM_RADDR,
-				    addr + 4 * offs);
+			iwl_trans_pcie_write32(trans, HBUS_TARG_MEM_RADDR,
+					       addr + 4 * offs);
 
 			while (offs < dwords) {
-				vals[offs] = iwl_read32(trans,
-							HBUS_TARG_MEM_RDAT);
+				vals[offs] = iwl_trans_pcie_read32(trans,
+								   HBUS_TARG_MEM_RDAT);
 
 				if (iwl_trans_is_hw_error_value(vals[offs]))
 					num_consec_hw_errors++;
@@ -2525,11 +2530,11 @@ int iwl_trans_pcie_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
 		unsigned long end = jiffies + HZ / 2;
 		bool resched = false;
 
-		iwl_write32(trans, HBUS_TARG_MEM_RADDR,
-			    addr + 4 * offs);
+		iwl_trans_pcie_write32(trans, HBUS_TARG_MEM_RADDR,
+				       addr + 4 * offs);
 
 		while (offs < dwords) {
-			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+			vals[offs] = iwl_trans_pcie_read32(trans, HBUS_TARG_MEM_RDAT);
 
 			if (iwl_trans_is_hw_error_value(vals[offs]))
 				num_consec_hw_errors++;
@@ -2746,7 +2751,7 @@ void iwl_pcie_dump_csr(struct iwl_trans *trans)
 	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
 		IWL_ERR(trans, "  %25s: 0X%08x\n",
 			get_csr_string(csr_tbl[i]),
-			iwl_read32(trans, csr_tbl[i]));
+			iwl_trans_pcie_read32(trans, csr_tbl[i]));
 	}
 }
 
@@ -3022,7 +3027,7 @@ static ssize_t iwl_dbgfs_rfkill_read(struct file *file,
 
 	pos = scnprintf(buf, sizeof(buf), "debug: %d\nhw: %d\n",
 			trans_pcie->debug_rfkill,
-			!(iwl_read32(trans, CSR_GP_CNTRL) &
+			!(iwl_trans_pcie_read32(trans, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW));
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
@@ -3593,12 +3598,12 @@ void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 
 	iwl_trans_force_nmi(trans);
 	while (time_after(timeout, jiffies)) {
-		u32 inta_hw = iwl_read32(trans, inta_addr);
+		u32 inta_hw = iwl_trans_pcie_read32(trans, inta_addr);
 
 		/* Error detected by uCode */
 		if (inta_hw & sw_err_bit) {
 			/* Clear causes register */
-			iwl_write32(trans, inta_addr, inta_hw & sw_err_bit);
+			iwl_trans_pcie_write32(trans, inta_addr, inta_hw & sw_err_bit);
 			break;
 		}
 
@@ -4044,7 +4049,7 @@ static void iwl_pcie_recheck_me_status(struct work_struct *wk)
 							 me_recheck_wk.work);
 	u32 val;
 
-	val = iwl_read32(trans_pcie->trans, CSR_HW_IF_CONFIG_REG);
+	val = iwl_trans_pcie_read32(trans_pcie->trans, CSR_HW_IF_CONFIG_REG);
 	trans_pcie->me_present = !!(val & CSR_HW_IF_CONFIG_REG_IAMT_UP);
 }
 
@@ -4062,14 +4067,14 @@ static void iwl_pcie_check_me_status(struct iwl_trans *trans)
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_BZ)
 		return;
 
-	val = iwl_read_prph(trans, CNVI_SCU_REG_FOR_ECO_1);
+	val = iwl_trans_pcie_read_prph(trans, CNVI_SCU_REG_FOR_ECO_1);
 	if (val & CNVI_SCU_REG_FOR_ECO_1_WIAMT_KNOWN) {
 		trans_pcie->me_present =
 			!!(val & CNVI_SCU_REG_FOR_ECO_1_WIAMT_PRESENT);
 		return;
 	}
 
-	val = iwl_read32(trans, CSR_HW_IF_CONFIG_REG);
+	val = iwl_trans_pcie_read32(trans, CSR_HW_IF_CONFIG_REG);
 	if (val & (CSR_HW_IF_CONFIG_REG_ME_OWN |
 		   CSR_HW_IF_CONFIG_REG_IAMT_UP)) {
 		trans_pcie->me_present = 1;
@@ -4127,7 +4132,7 @@ int _iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent,
 		}
 	}
 
-	info.hw_rf_id = iwl_read32(iwl_trans, CSR_HW_RF_ID);
+	info.hw_rf_id = iwl_trans_pcie_read32(iwl_trans, CSR_HW_RF_ID);
 
 	/*
 	 * The RF_ID is set to zero in blank OTP so read version to
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 27f4973791d0..abdb2548827f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020, 2023-2025 Intel Corporation
+ * Copyright (C) 2018-2020, 2023-2026 Intel Corporation
  */
 #include <net/tso.h>
 #include <linux/tcp.h>
@@ -711,7 +711,7 @@ static void iwl_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 	 * if not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx).
 	 */
-	iwl_write32(trans, HBUS_TARG_WRPTR, txq->write_ptr | (txq->id << 16));
+	iwl_trans_pcie_write32(trans, HBUS_TARG_WRPTR, txq->write_ptr | (txq->id << 16));
 }
 
 int iwl_txq_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index bdd330280689..f5aa456180d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -99,7 +99,7 @@ static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
 		 * uCode will wake up, and interrupt us again, so next
 		 * time we'll skip this part.
 		 */
-		reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
+		reg = iwl_trans_pcie_read32(trans, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO(trans, "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
@@ -117,8 +117,8 @@ static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
 	 */
 	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->write_ptr);
 	if (!txq->block)
-		iwl_write32(trans, HBUS_TARG_WRPTR,
-			    txq->write_ptr | (txq_id << 8));
+		iwl_trans_pcie_write32(trans, HBUS_TARG_WRPTR,
+				       txq->write_ptr | (txq_id << 8));
 }
 
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
@@ -586,7 +586,7 @@ static void iwl_pcie_tx_stop_fh(struct iwl_trans *trans)
 
 	/* Stop each Tx DMA channel */
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
-		iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		iwl_trans_pcie_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
 		mask |= FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch);
 	}
 
@@ -595,7 +595,7 @@ static void iwl_pcie_tx_stop_fh(struct iwl_trans *trans)
 	if (ret)
 		IWL_ERR(trans,
 			"Failing on timeout while stopping DMA channel %d [0x%08x]\n",
-			ch, iwl_read32(trans, FH_TSSR_TX_STATUS_REG));
+			ch, iwl_trans_pcie_read32(trans, FH_TSSR_TX_STATUS_REG));
 
 	iwl_trans_release_nic_access(trans);
 
@@ -1335,8 +1335,8 @@ static void iwl_trans_pcie_block_txq_ptrs(struct iwl_trans *trans, bool block)
 		if (!block && !(WARN_ON_ONCE(!txq->block))) {
 			txq->block--;
 			if (!txq->block) {
-				iwl_write32(trans, HBUS_TARG_WRPTR,
-					    txq->write_ptr | (i << 8));
+				iwl_trans_pcie_write32(trans, HBUS_TARG_WRPTR,
+						       txq->write_ptr | (i << 8));
 			}
 		} else if (block) {
 			txq->block++;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
index bace3e21989c..4365ffb0fd37 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
@@ -51,7 +51,7 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev)
 
 	IWL_ERR(trans, "iwlwifi device memory mapped registers:\n");
 	for (i = 0, ptr = buf; i < PCI_MEM_DUMP_SIZE; i += 4, ptr++)
-		*ptr = iwl_read32(trans, i);
+		*ptr = iwl_trans_pcie_read32(trans, i);
 	print_hex_dump(KERN_ERR, prefix, DUMP_PREFIX_OFFSET, 32, 4, buf, i, 0);
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
@@ -106,7 +106,7 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev)
 u32 iwl_pcie_read_direct32(struct iwl_trans *trans, u32 reg)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
-		u32 value = iwl_read32(trans, reg);
+		u32 value = iwl_trans_pcie_read32(trans, reg);
 
 		iwl_trans_release_nic_access(trans);
 		return value;
@@ -176,8 +176,8 @@ int iwl_pcie_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
 void iwl_pcie_write_prph64_no_grab(struct iwl_trans *trans, u32 ofs, u64 val)
 {
 	trace_iwlwifi_dev_iowrite_prph64(trans->dev, ofs, val);
-	iwl_write_prph_no_grab(trans, ofs, val & 0xffffffff);
-	iwl_write_prph_no_grab(trans, ofs + 4, val >> 32);
+	iwl_pcie_write_prph_no_grab(trans, ofs, val & 0xffffffff);
+	iwl_pcie_write_prph_no_grab(trans, ofs + 4, val >> 32);
 }
 
 void iwl_pcie_write_direct64(struct iwl_trans *trans, u64 reg, u64 value)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
index 341928cdb64b..2d92bff513df 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
@@ -7,6 +7,7 @@
 #define __iwl_pcie_utils_h__
 
 #include "iwl-io.h"
+#include "internal.h"
 
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev);
 
@@ -24,16 +25,15 @@ void iwl_pcie_write_direct64(struct iwl_trans *trans, u64 reg, u64 value);
 
 static inline void iwl_pcie_write64(struct iwl_trans *trans, u64 ofs, u64 val)
 {
-	trace_iwlwifi_dev_iowrite64(trans->dev, ofs, val);
-	iwl_trans_write32(trans, ofs, lower_32_bits(val));
-	iwl_trans_write32(trans, ofs + 4, upper_32_bits(val));
+	iwl_trans_pcie_write32(trans, ofs, lower_32_bits(val));
+	iwl_trans_pcie_write32(trans, ofs + 4, upper_32_bits(val));
 }
 
 static inline void iwl_pcie_write_umac_prph_no_grab(struct iwl_trans *trans,
 						    u32 ofs, u32 val)
 {
-	iwl_write_prph_no_grab(trans, ofs + trans->mac_cfg->umac_prph_offset,
-			       val);
+	iwl_pcie_write_prph_no_grab(trans, ofs + trans->mac_cfg->umac_prph_offset,
+				    val);
 }
 
 static inline void _iwl_trans_set_bits_mask(struct iwl_trans *trans,
@@ -45,10 +45,10 @@ static inline void _iwl_trans_set_bits_mask(struct iwl_trans *trans,
 	WARN_ON_ONCE(value & ~mask);
 #endif
 
-	v = iwl_read32(trans, reg);
+	v = iwl_trans_pcie_read32(trans, reg);
 	v &= ~mask;
 	v |= value;
-	iwl_write32(trans, reg, v);
+	iwl_trans_pcie_write32(trans, reg, v);
 }
 
 static inline void iwl_trans_clear_bit(struct iwl_trans *trans,
-- 
2.34.1

