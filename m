Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F3DC43610
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03EBD206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03EBD206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409643AbeKWWKh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38284 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394366AbeKWWKg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:36 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9be-0008GU-9A; Fri, 23 Nov 2018 13:26:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:23 +0200
Message-Id: <20181123112631.29360-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/15] iwlwifi: move iwl_nvm_check_version() into dvm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

This function is only half-used by mvm (i.e. only the nvm_version part
matters, since the calibration version is irrelevant), so it's
pointless to export it from iwlwifi.  If mvm uses this function, it
has the additional complexity of setting the calib version to a bogus
value on all cfg structs.

To avoid this, move the function to dvm and make a simple comparison
of the nvm_version in mvm instead.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 17 +++++++++++++++++
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c | 19 -------------------
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.h |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  4 +++-
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 1088ff036e13..c219bca5cff4 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1224,6 +1224,23 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
+static int iwl_nvm_check_version(struct iwl_nvm_data *data,
+				 struct iwl_trans *trans)
+{
+	if (data->nvm_version >= trans->cfg->nvm_ver ||
+	    data->calib_version >= trans->cfg->nvm_calib_ver) {
+		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+			       data->nvm_version, data->calib_version);
+		return 0;
+	}
+
+	IWL_ERR(trans,
+		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		data->nvm_version, trans->cfg->nvm_ver,
+		data->calib_version,  trans->cfg->nvm_calib_ver);
+	return -EINVAL;
+}
+
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 						 const struct iwl_cfg *cfg,
 						 const struct iwl_fw *fw,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index 4e3422a1c7bb..75940ac406b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -927,22 +927,3 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 	return NULL;
 }
 IWL_EXPORT_SYMBOL(iwl_parse_eeprom_data);
-
-/* helper functions */
-int iwl_nvm_check_version(struct iwl_nvm_data *data,
-			     struct iwl_trans *trans)
-{
-	if (data->nvm_version >= trans->cfg->nvm_ver ||
-	    data->calib_version >= trans->cfg->nvm_calib_ver) {
-		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
-			       data->nvm_version, data->calib_version);
-		return 0;
-	}
-
-	IWL_ERR(trans,
-		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-		data->nvm_version, trans->cfg->nvm_ver,
-		data->calib_version,  trans->cfg->nvm_calib_ver);
-	return -EINVAL;
-}
-IWL_EXPORT_SYMBOL(iwl_nvm_check_version);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index d910bda087f7..2375d300a7cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,6 +29,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -117,9 +119,6 @@ struct iwl_nvm_data *
 iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 		      const u8 *eeprom, size_t eeprom_size);
 
-int iwl_nvm_check_version(struct iwl_nvm_data *data,
-			  struct iwl_trans *trans);
-
 int iwl_init_sband_channels(struct iwl_nvm_data *data,
 			    struct ieee80211_supported_band *sband,
 			    int n_channels, enum nl80211_band band);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index dcb739fb7c35..717924136d5b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -547,7 +547,9 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (mvm->nvm_file_name)
 		iwl_mvm_load_nvm_to_nic(mvm);
 
-	WARN_ON(iwl_nvm_check_version(mvm->nvm_data, mvm->trans));
+	WARN_ONCE(mvm->nvm_data->nvm_version < mvm->trans->cfg->nvm_ver,
+		  "Too old NVM version (0x%0x, required = 0x%0x)",
+		  mvm->nvm_data->nvm_version, mvm->trans->cfg->nvm_ver);
 
 	/*
 	 * abort after reading the nvm in case RF Kill is on, we will complete
-- 
2.19.1

