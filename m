Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251CFC10F02
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D0821929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436598AbfBOLtg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60410 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436494AbfBOLtg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:36 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzq-0008TN-4x; Fri, 15 Feb 2019 13:49:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:10 +0200
Message-Id: <20190215114924.2545-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/20] iwlwifi: mvm: fix error path in iwl_mvm_mac_setup_register()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE bit shouldn't be set,
and realistically we should complete all setup before we call the
ieee80211_register_hw() function. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a3bbf2ce571f..a585ee509987 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -796,16 +796,19 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			hw->netdev_features |= IWL_TX_CSUM_NETIF_FLAGS;
 	}
 
-	ret = ieee80211_register_hw(mvm->hw);
-	if (ret)
-		iwl_mvm_leds_exit(mvm);
-	mvm->init_status |= IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE;
-
 	if (mvm->cfg->vht_mu_mimo_supported)
 		wiphy_ext_feature_set(hw->wiphy,
 				      NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER);
 
-	return ret;
+	ret = ieee80211_register_hw(mvm->hw);
+	if (ret) {
+		iwl_mvm_leds_exit(mvm);
+		return ret;
+	}
+
+	mvm->init_status |= IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE;
+
+	return 0;
 }
 
 static bool iwl_mvm_defer_tx(struct iwl_mvm *mvm,
-- 
2.20.1

