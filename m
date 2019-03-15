Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84004C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F2A2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfCOQgn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:43 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44222 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728271AbfCOQgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:43 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp3-0004qp-3M; Fri, 15 Mar 2019 18:36:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:19 +0200
Message-Id: <20190315163634.17315-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/16] iwlwifi: mvm: enable HT/VHT IBSS
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

For some reason we never enabled it, but it appears to work fine.
Enable it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index fd989c43df2a..dc4bff74c89c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -598,6 +598,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+	hw->wiphy->features |= NL80211_FEATURE_HT_IBSS;
+
 	hw->wiphy->regulatory_flags |= REGULATORY_ENABLE_RELAX_NO_IR;
 	if (iwl_mvm_is_lar_supported(mvm))
 		hw->wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
-- 
2.20.1

