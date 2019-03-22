Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A008C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B8B218D4
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfCVOAc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:32 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727630AbfCVOAc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:32 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khl-0000bK-Ux; Fri, 22 Mar 2019 15:59:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:59:00 +0200
Message-Id: <20190322135903.10631-22-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 21/24] iwlwifi: mvm: use correct GP2 register address for 22000 family
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

The device time register address has changed for 22000 devices.
Add a util function for getting the GP2 time and use the correct
register address depending on the device family.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c    |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  4 +---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c     |  7 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 12 +++++++++++-
 7 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 33c95663914d..e0db1988b6a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -194,7 +194,8 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	IWL_DEVICE_22000_COMMON,					\
 	.device_family = IWL_DEVICE_FAMILY_22000,			\
 	.base_params = &iwl_22000_base_params,				\
-	.csr = &iwl_csr_v1
+	.csr = &iwl_csr_v1,						\
+	.gp2_reg_addr = 0xa02c68
 
 #define IWL_DEVICE_22560						\
 	IWL_DEVICE_22000_COMMON,					\
@@ -207,7 +208,8 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.device_family = IWL_DEVICE_FAMILY_AX210,			\
 	.base_params = &iwl_22000_base_params,				\
 	.csr = &iwl_csr_v1,						\
-	.min_txq_size = 128
+	.min_txq_size = 128,						\
+	.gp2_reg_addr = 0xd02c68
 
 const struct iwl_cfg iwl22000_2ac_cfg_hr = {
 	.name = "Intel(R) Dual Band Wireless AC 22000",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 76c1e44b7bdc..bc929d6639bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -456,6 +456,7 @@ struct iwl_cfg {
 	u32 fw_mon_smem_write_ptr_msk;
 	u32 fw_mon_smem_cycle_cnt_ptr_addr;
 	u32 fw_mon_smem_cycle_cnt_ptr_msk;
+	u32 gp2_reg_addr;
 };
 
 extern const struct iwl_csr_params iwl_csr_v1;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 76bf7fbc0446..fcec25b7b679 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1113,9 +1113,7 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 				ieee80211_tu_to_usec(data.beacon_int * rand /
 						     100);
 		} else {
-			mvmvif->ap_beacon_time =
-				iwl_read_prph(mvm->trans,
-					      DEVICE_SYSTEM_TIME_REG);
+			mvmvif->ap_beacon_time = iwl_mvm_get_systime(mvm);
 		}
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ed866deddb5f..d55c7df813e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3730,7 +3730,7 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    int duration)
 {
-	int res, time_reg = DEVICE_SYSTEM_TIME_REG;
+	int res;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->hs_time_event_data;
 	static const u16 time_event_response[] = { HOT_SPOT_CMD };
@@ -3756,7 +3756,7 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 			      0);
 
 	/* Set the time and duration */
-	tail->apply_time = cpu_to_le32(iwl_read_prph(mvm->trans, time_reg));
+	tail->apply_time = cpu_to_le32(iwl_mvm_get_systime(mvm));
 
 	delay = AUX_ROC_MIN_DELAY;
 	req_dur = MSEC_TO_TU(duration);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 45d7a868e759..cdac510fd22b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1539,6 +1539,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
 void iwl_mvm_get_sync_time(struct iwl_mvm *mvm, u32 *gp2, u64 *boottime);
+u32 iwl_mvm_get_systime(struct iwl_mvm *mvm);
 
 /* Tx / Host Commands */
 int __must_check iwl_mvm_send_cmd(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index 859aa5a4e6b5..9df21a8d1fc1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(C) 2018 Intel Corporation
+ * Copyright(C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(C) 2018 Intel Corporation
+ * Copyright(C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -252,8 +252,7 @@ static void iwl_mvm_tdls_update_cs_state(struct iwl_mvm *mvm,
 
 	/* we only send requests to our switching peer - update sent time */
 	if (state == IWL_MVM_TDLS_SW_REQ_SENT)
-		mvm->tdls_cs.peer.sent_timestamp =
-			iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG);
+		mvm->tdls_cs.peer.sent_timestamp = iwl_mvm_get_systime(mvm);
 
 	if (state == IWL_MVM_TDLS_SW_IDLE)
 		mvm->tdls_cs.cur_sta_id = IWL_MVM_INVALID_STA;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 4649327abb45..b9914efc55c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1418,6 +1418,16 @@ void iwl_mvm_tcm_rm_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	cancel_delayed_work_sync(&mvmvif->uapsd_nonagg_detected_wk);
 }
 
+u32 iwl_mvm_get_systime(struct iwl_mvm *mvm)
+{
+	u32 reg_addr = DEVICE_SYSTEM_TIME_REG;
+
+	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000 &&
+	    mvm->trans->cfg->gp2_reg_addr)
+		reg_addr = mvm->trans->cfg->gp2_reg_addr;
+
+	return iwl_read_prph(mvm->trans, reg_addr);
+}
 
 void iwl_mvm_get_sync_time(struct iwl_mvm *mvm, u32 *gp2, u64 *boottime)
 {
@@ -1432,7 +1442,7 @@ void iwl_mvm_get_sync_time(struct iwl_mvm *mvm, u32 *gp2, u64 *boottime)
 		iwl_mvm_power_update_device(mvm);
 	}
 
-	*gp2 = iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG);
+	*gp2 = iwl_mvm_get_systime(mvm);
 	*boottime = ktime_get_boot_ns();
 
 	if (!ps_disabled) {
-- 
2.20.1

