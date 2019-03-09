Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C118C4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39C792086A
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfCIJWs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:48 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41798 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726296AbfCIJWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:47 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBp-0000qV-Pm; Sat, 09 Mar 2019 11:22:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:33 +0200
Message-Id: <20190309092237.10294-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/8] iwlwifi: mvm: track CSA beacons
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Send to FW modify command for every beacon we receive during channel
switch. FW will track the count, and make sure the event is scheduled
in time even if AP changed count.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  2 ++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 30 +++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 641c95d03b15..04ad6b96a28b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -350,6 +350,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD: firmware supports CSA command
  * @IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS: firmware supports ultra high band
  *	(6 GHz).
+ * @IWL_UCODE_TLV_CAPA_CS_MODIFY: firmware supports modify action CSA command
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
@@ -420,6 +421,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD		= (__force iwl_ucode_tlv_capa_t)46,
 	IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS		= (__force iwl_ucode_tlv_capa_t)48,
 	IWL_UCODE_TLV_CAPA_FTM_CALIBRATED		= (__force iwl_ucode_tlv_capa_t)47,
+	IWL_UCODE_TLV_CAPA_CS_MODIFY			= (__force iwl_ucode_tlv_capa_t)49,
 
 	/* set 2 */
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b5a9e83cc034..d5f627621593 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -4631,6 +4631,31 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void iwl_mvm_channel_switch_rx_beacon(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_channel_switch *chsw)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_chan_switch_te_cmd cmd = {
+		.mac_id = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							  mvmvif->color)),
+		.action = cpu_to_le32(FW_CTXT_ACTION_MODIFY),
+		.tsf = cpu_to_le32(chsw->timestamp),
+		.cs_count = chsw->count,
+	};
+
+	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_CS_MODIFY))
+		return;
+
+	IWL_DEBUG_MAC80211(mvm, "Modify CSA on mac %d\n", mvmvif->id);
+
+	WARN_ON(iwl_mvm_send_cmd_pdu(mvm,
+				     WIDE_ID(MAC_CONF_GROUP,
+					     CHANNEL_SWITCH_TIME_EVENT_CMD),
+				     CMD_ASYNC, sizeof(cmd), &cmd));
+}
+
 static void iwl_mvm_abort_channel_switch(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif)
 {
@@ -5111,6 +5136,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.pre_channel_switch = iwl_mvm_pre_channel_switch,
 	.post_channel_switch = iwl_mvm_post_channel_switch,
 	.abort_channel_switch = iwl_mvm_abort_channel_switch,
+	.channel_switch_rx_beacon = iwl_mvm_channel_switch_rx_beacon,
 
 	.tdls_channel_switch = iwl_mvm_tdls_channel_switch,
 	.tdls_cancel_channel_switch = iwl_mvm_tdls_cancel_channel_switch,
-- 
2.20.1

