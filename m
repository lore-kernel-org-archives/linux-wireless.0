Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70892C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB8D20830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfDCJWo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:44 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49740 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726605AbfDCJWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:38 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6P-0007aR-2G; Wed, 03 Apr 2019 12:22:37 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:18 +0300
Message-Id: <20190403092224.815-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/13] iwlwifi: rs: consider LDPC capability in case of HE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

When building TLC configuration command, consider in case of HE,
if LDPC support is turned on in our capabilities.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 79f9eaf8dd1b..3ffdbfdb37c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -116,8 +116,9 @@ static u8 rs_fw_sgi_cw_support(struct ieee80211_sta *sta)
 	return supp;
 }
 
-static u16 rs_fw_set_config_flags(struct iwl_mvm *mvm,
-				  struct ieee80211_sta *sta)
+static u16 rs_fw_get_config_flags(struct iwl_mvm *mvm,
+				  struct ieee80211_sta *sta,
+				  struct ieee80211_supported_band *sband)
 {
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
@@ -147,6 +148,12 @@ static u16 rs_fw_set_config_flags(struct iwl_mvm *mvm,
 	     (vht_ena && (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))))
 		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
 
+	/* consider our LDPC support in case of HE */
+	if (sband->iftype_data && sband->iftype_data->he_cap.has_he &&
+	    !(sband->iftype_data->he_cap.he_cap_elem.phy_cap_info[1] &
+	     IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))
+		flags &= ~IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+
 	if (he_cap && he_cap->has_he &&
 	    (he_cap->he_cap_elem.phy_cap_info[3] &
 	     IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_MASK))
@@ -383,13 +390,13 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_lq_sta_rs_fw *lq_sta = &mvmsta->lq_sta.rs_fw;
 	u32 cmd_id = iwl_cmd_id(TLC_MNG_CONFIG_CMD, DATA_PATH_GROUP, 0);
-	struct ieee80211_supported_band *sband;
+	struct ieee80211_supported_band *sband = hw->wiphy->bands[band];
 	u16 max_amsdu_len = rs_fw_get_max_amsdu_len(sta);
 	struct iwl_tlc_config_cmd cfg_cmd = {
 		.sta_id = mvmsta->sta_id,
 		.max_ch_width = update ?
 			rs_fw_bw_from_sta_bw(sta) : RATE_MCS_CHAN_WIDTH_20,
-		.flags = cpu_to_le16(rs_fw_set_config_flags(mvm, sta)),
+		.flags = cpu_to_le16(rs_fw_get_config_flags(mvm, sta, sband)),
 		.chains = rs_fw_set_active_chains(iwl_mvm_get_valid_tx_ant(mvm)),
 		.sgi_ch_width_supp = rs_fw_sgi_cw_support(sta),
 		.max_mpdu_len = cpu_to_le16(max_amsdu_len),
@@ -402,7 +409,6 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_reset_frame_stats(mvm);
 #endif
-	sband = hw->wiphy->bands[band];
 	rs_fw_set_supp_rates(sta, sband, &cfg_cmd);
 
 	/*
-- 
2.20.1

