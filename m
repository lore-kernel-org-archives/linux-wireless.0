Return-Path: <SRS0=g1I5=CU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76143C433E2
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 17:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AA0622204
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 17:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgIKRzZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:55:25 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726050AbgIKRzU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Sep 2020 13:55:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kGn6L-0028eU-Cv; Fri, 11 Sep 2020 20:44:45 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 11 Sep 2020 20:44:32 +0300
Message-Id: <iwlwifi.20200911204056.a34626b2e6ba.I86ba17db16fc99bb094bef4d0cc40ee99d5ba233@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911174439.163225-1-luca@coelho.fi>
References: <20200911174439.163225-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/11] iwlwifi: mvm: set PROTECTED_TWT feature if supported by firmware
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9374c85c5caf..f9b261e36f2d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -753,6 +753,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		wiphy_ext_feature_set(hw->wiphy,
 				      NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER);
 
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_PROTECTED_TWT))
+		wiphy_ext_feature_set(hw->wiphy,
+				      NL80211_EXT_FEATURE_PROTECTED_TWT);
+
 	hw->wiphy->available_antennas_tx = iwl_mvm_get_valid_tx_ant(mvm);
 	hw->wiphy->available_antennas_rx = iwl_mvm_get_valid_rx_ant(mvm);
 
-- 
2.28.0

