Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46277C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F04921929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfBOLuF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:50:05 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60544 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727717AbfBOLuF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:50:05 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzy-0008TN-Lw; Fri, 15 Feb 2019 13:49:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:19 +0200
Message-Id: <20190215114924.2545-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/20] iwlwifi: mvm: remove IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no point in this, we already do everything in a nested
fashion, and if we didn't we'd already crash in iwl_mvm_leds_exit()
etc. Just remove the bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 +----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 5 +----
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a585ee509987..24556a7cd29c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -803,12 +803,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret) {
 		iwl_mvm_leds_exit(mvm);
-		return ret;
 	}
 
-	mvm->init_status |= IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE;
-
-	return 0;
+	return ret;
 }
 
 static bool iwl_mvm_defer_tx(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c90dd98bdd99..e03591fe4d71 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1221,7 +1221,6 @@ enum iwl_mvm_status {
 enum iwl_mvm_init_status {
 	IWL_MVM_INIT_STATUS_THERMAL_INIT_COMPLETE = BIT(0),
 	IWL_MVM_INIT_STATUS_LEDS_INIT_COMPLETE = BIT(1),
-	IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE = BIT(2),
 };
 
 static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0996c97c4b94..ba27dce4c2bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -919,10 +919,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_thermal_exit(mvm);
 
-	if (mvm->init_status & IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE) {
-		ieee80211_unregister_hw(mvm->hw);
-		mvm->init_status &= ~IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE;
-	}
+	ieee80211_unregister_hw(mvm->hw);
 
 	kfree(mvm->scan_cmd);
 	kfree(mvm->mcast_filter_cmd);
-- 
2.20.1

