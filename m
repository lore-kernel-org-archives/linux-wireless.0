Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769E4C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52001218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfAaUWm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53654 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUWm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:42 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqt-0004pL-Fe; Thu, 31 Jan 2019 22:22:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avigail Grinstein <avigail.grinstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:56 +0200
Message-Id: <20190131202206.15903-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/21] iwlwifi: mvm: support absolute thresholds in bf configuration
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avigail Grinstein <avigail.grinstein@intel.com>

Update iwl_beacon_filter_cmd to support
BEACON_FILTER_CONFIG_API_S_VER_4.

Currently driver configs them to be zero
(i.e. disable them, so no change is applied).

Signed-off-by: Avigail Grinstein <avigail.grinstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/power.h | 11 +++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 +++
 .../net/wireless/intel/iwlwifi/mvm/power.c    | 20 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 286a22da232d..5844898ee92c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -470,6 +470,13 @@ struct iwl_geo_tx_power_profiles_resp {
  * @ba_escape_timer: Fully receive and parse beacon if no beacons were passed
  *      for a longer period of time then this escape-timeout. Units: Beacons.
  * @ba_enable_beacon_abort: 1, beacon abort is enabled; 0, disabled.
+ * @bf_threshold_absolute_low: See below.
+ * @bf_threshold_absolute_high: Send Beacon to driver if Energy value calculated
+ *      for this beacon crossed this absolute threshold. For the 'Increase'
+ *      direction the bf_energy_absolute_low[i] is used. For the 'Decrease'
+ *      direction the bf_energy_absolute_high[i] is used. Zero value means
+ *      that this specific threshold is ignored for beacon filtering, and
+ *      beacon will not be forced to be sent to driver due to this setting.
  */
 struct iwl_beacon_filter_cmd {
 	__le32 bf_energy_delta;
@@ -483,7 +490,9 @@ struct iwl_beacon_filter_cmd {
 	__le32 bf_escape_timer;
 	__le32 ba_escape_timer;
 	__le32 ba_enable_beacon_abort;
-} __packed;
+	__le32 bf_threshold_absolute_low[2];
+	__le32 bf_threshold_absolute_high[2];
+} __packed; /* BEACON_FILTER_CONFIG_API_S_VER_4 */
 
 /* Beacon filtering and beacon abort */
 #define IWL_BF_ENERGY_DELTA_DEFAULT 5
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index a6dd27fbe4aa..8c6ce4142204 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -265,6 +265,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	the REDUCE_TX_POWER_CMD.
  * @IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF: This ucode supports the short
  *	version of the beacon notification.
+ * @IWL_UCODE_TLV_API_BEACON_FILTER_V4: This ucode supports v4 of
+ *	BEACON_FILTER_CONFIG_API_S_VER_4.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -290,6 +292,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FRAG_EBS		= (__force iwl_ucode_tlv_api_t)44,
 	IWL_UCODE_TLV_API_REDUCE_TX_POWER	= (__force iwl_ucode_tlv_api_t)45,
 	IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF	= (__force iwl_ucode_tlv_api_t)46,
+	IWL_UCODE_TLV_API_BEACON_FILTER_V4      = (__force iwl_ucode_tlv_api_t)47,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 5a0a28fd762d..df9f1d6cdf78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -79,6 +81,8 @@ int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 				   struct iwl_beacon_filter_cmd *cmd,
 				   u32 flags)
 {
+	u16 len;
+
 	IWL_DEBUG_POWER(mvm, "ba_enable_beacon_abort is: %d\n",
 			le32_to_cpu(cmd->ba_enable_beacon_abort));
 	IWL_DEBUG_POWER(mvm, "ba_escape_timer is: %d\n",
@@ -101,9 +105,23 @@ int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 			le32_to_cpu(cmd->bf_temp_fast_filter));
 	IWL_DEBUG_POWER(mvm, "bf_temp_slow_filter is: %d\n",
 			le32_to_cpu(cmd->bf_temp_slow_filter));
+	IWL_DEBUG_POWER(mvm, "bf_threshold_absolute_low is: %d, %d\n",
+			le32_to_cpu(cmd->bf_threshold_absolute_low[0]),
+			le32_to_cpu(cmd->bf_threshold_absolute_low[1]));
+
+	IWL_DEBUG_POWER(mvm, "bf_threshold_absolute_high is: %d, %d\n",
+			le32_to_cpu(cmd->bf_threshold_absolute_high[0]),
+			le32_to_cpu(cmd->bf_threshold_absolute_high[1]));
+
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_BEACON_FILTER_V4))
+		len = sizeof(struct iwl_beacon_filter_cmd);
+	else
+		len = offsetof(struct iwl_beacon_filter_cmd,
+			       bf_threshold_absolute_low);
 
 	return iwl_mvm_send_cmd_pdu(mvm, REPLY_BEACON_FILTERING_CMD, flags,
-				    sizeof(struct iwl_beacon_filter_cmd), cmd);
+				    len, cmd);
 }
 
 static
-- 
2.20.1

