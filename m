Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A1CC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB8912070D
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbfCVMrz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:47:55 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387782AbfCVMrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 08:47:52 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7JaQ-0000ZZ-Ew; Fri, 22 Mar 2019 14:47:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 14:47:43 +0200
Message-Id: <20190322124744.17924-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322124744.17924-1-luca@coelho.fi>
References: <20190322124744.17924-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/3] iwlwifi: mvm: update offloaded rate control on changes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

With offloaded rate control, if the station parameters (rates, NSS,
bandwidth) change (sta_rc_update method), call iwl_mvm_rs_rate_init()
to propagate those change to the firmware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index eeaeb8475666..6a3b11dd2edf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3258,6 +3258,13 @@ static void iwl_mvm_sta_rc_update(struct ieee80211_hw *hw,
 				  struct ieee80211_sta *sta, u32 changed)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (changed & (IEEE80211_RC_BW_CHANGED |
+		       IEEE80211_RC_SUPP_RATES_CHANGED |
+		       IEEE80211_RC_NSS_CHANGED))
+		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band,
+				     true);
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
 	    changed & IEEE80211_RC_NSS_CHANGED)
-- 
2.20.1

