Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC735C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C57F52077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfCOQhL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:37:11 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44336 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729541AbfCOQhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:37:10 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ppC-0004qp-1X; Fri, 15 Mar 2019 18:36:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:29 +0200
Message-Id: <20190315163634.17315-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/16] iwlwifi: mvm: set max amsdu for TLC offload
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

mac80211 sets max amsdu to min supported ht vs vht but TLC only works
with one mode so we can set to the exact mode used (vht/ht)
and enable larger amsdu sizes for vht.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 44 +++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index a28283ff7295..79f9eaf8dd1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -27,7 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -345,6 +345,37 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
 	rcu_read_unlock();
 }
 
+static u16 rs_fw_get_max_amsdu_len(struct ieee80211_sta *sta)
+{
+	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	const struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
+
+	if (vht_cap && vht_cap->vht_supported) {
+		switch (vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK) {
+		case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
+			return IEEE80211_MAX_MPDU_LEN_VHT_11454;
+		case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
+			return IEEE80211_MAX_MPDU_LEN_VHT_7991;
+		default:
+			return IEEE80211_MAX_MPDU_LEN_VHT_3895;
+	}
+
+	} else if (ht_cap && ht_cap->ht_supported) {
+		if (ht_cap->cap & IEEE80211_HT_CAP_MAX_AMSDU)
+			/*
+			 * agg is offloaded so we need to assume that agg
+			 * are enabled and max mpdu in ampdu is 4095
+			 * (spec 802.11-2016 9.3.2.1)
+			 */
+			return IEEE80211_MAX_MPDU_LEN_HT_BA;
+		else
+			return IEEE80211_MAX_MPDU_LEN_HT_3839;
+	}
+
+	/* in legacy mode no amsdu is enabled so return zero */
+	return 0;
+}
+
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		     enum nl80211_band band, bool update)
 {
@@ -353,14 +384,15 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	struct iwl_lq_sta_rs_fw *lq_sta = &mvmsta->lq_sta.rs_fw;
 	u32 cmd_id = iwl_cmd_id(TLC_MNG_CONFIG_CMD, DATA_PATH_GROUP, 0);
 	struct ieee80211_supported_band *sband;
+	u16 max_amsdu_len = rs_fw_get_max_amsdu_len(sta);
 	struct iwl_tlc_config_cmd cfg_cmd = {
 		.sta_id = mvmsta->sta_id,
 		.max_ch_width = update ?
 			rs_fw_bw_from_sta_bw(sta) : RATE_MCS_CHAN_WIDTH_20,
 		.flags = cpu_to_le16(rs_fw_set_config_flags(mvm, sta)),
 		.chains = rs_fw_set_active_chains(iwl_mvm_get_valid_tx_ant(mvm)),
-		.max_mpdu_len = cpu_to_le16(sta->max_amsdu_len),
 		.sgi_ch_width_supp = rs_fw_sgi_cw_support(sta),
+		.max_mpdu_len = cpu_to_le16(max_amsdu_len),
 		.amsdu = iwl_mvm_is_csum_supported(mvm),
 	};
 	int ret;
@@ -373,6 +405,12 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	sband = hw->wiphy->bands[band];
 	rs_fw_set_supp_rates(sta, sband, &cfg_cmd);
 
+	/*
+	 * since TLC offload works with one mode we can assume
+	 * that only vht/ht is used and also set it as station max amsdu
+	 */
+	sta->max_amsdu_len = max_amsdu_len;
+
 	ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(cfg_cmd), &cfg_cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send rate scale config (%d)\n", ret);
-- 
2.20.1

