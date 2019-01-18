Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA98C5AC81
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA7120883
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfARTAT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726524AbfARTAR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:17 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNH-0004cj-Iw; Fri, 18 Jan 2019 21:00:15 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:51 +0200
Message-Id: <20190118190004.22270-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/16] iwlwifi: mvm: advertise support for TWT in the Extended Capability IE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We want to advertise support for TWT in the Extended
Capability IE. Since we don't want to set the bits for all
the interface types, define an interface specific
configuration.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  3 +--
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 22 +++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d9afedc3d1d9..173ade96f119 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -569,8 +569,7 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 			.has_he = true,
 			.he_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_HE_MAC_CAP0_HTC_HE |
-					IEEE80211_HE_MAC_CAP0_TWT_RES,
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
 				.mac_cap_info[1] =
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 97dc464379d2..310a36dd33cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -395,6 +395,21 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 	return ret;
 }
 
+const static u8 he_if_types_ext_capa_sta[] = {
+	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
+	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
+	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
+};
+
+const static struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
+	{
+		.iftype = NL80211_IFTYPE_STATION,
+		.extended_capabilities = he_if_types_ext_capa_sta,
+		.extended_capabilities_mask = he_if_types_ext_capa_sta,
+		.extended_capabilities_len = sizeof(he_if_types_ext_capa_sta),
+	},
+};
+
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 {
 	struct ieee80211_hw *hw = mvm->hw;
@@ -673,6 +688,13 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE);
 	}
 
+	if (mvm->nvm_data->sku_cap_11ax_enable &&
+	    !iwlwifi_mod_params.disable_11ax) {
+		hw->wiphy->iftype_ext_capab = he_iftypes_ext_capa;
+		hw->wiphy->num_iftype_ext_capab =
+			ARRAY_SIZE(he_iftypes_ext_capa);
+	}
+
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.20.1

