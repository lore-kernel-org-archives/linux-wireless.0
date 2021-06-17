Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDE8C48BE5
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jun 2021 07:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2BE6135C
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jun 2021 07:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFQHLG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jun 2021 03:11:06 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:47876 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230103AbhFQHLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jun 2021 03:11:05 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1ltm91-001XeC-9R; Thu, 17 Jun 2021 10:08:56 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Thu, 17 Jun 2021 10:08:42 +0300
Message-Id: <iwlwifi.20210617100544.d568df20e273.Id45ae38f9b16b3c56fa62266e3e89a1421ea07b0@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617070852.496985-1-luca@coelho.fi>
References: <20210617070852.496985-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/12] iwlwifi: mvm: don't request SMPS in AP mode
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is not valid (in the spec) and mac80211 will soon
warn on it, in addition to ignoring it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 99105272139d..e1e45eca09b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -621,7 +621,7 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			 enum ieee80211_smps_mode smps_request)
 {
 	struct iwl_mvm_vif *mvmvif;
-	enum ieee80211_smps_mode smps_mode;
+	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_AUTOMATIC;
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -630,10 +630,8 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return;
 
-	if (vif->type == NL80211_IFTYPE_AP)
-		smps_mode = IEEE80211_SMPS_OFF;
-	else
-		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
 
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	mvmvif->smps_requests[req_type] = smps_request;
-- 
2.32.0

