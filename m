Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD410C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91EAB21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfBHKsR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:48:17 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57124 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727722AbfBHKsR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:48:17 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gz-0002jg-0Y; Fri, 08 Feb 2019 12:47:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:09 +0200
Message-Id: <20190208104712.16210-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/20] iwlwifi: mvm: Don't warn on command failure during restart
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

When HW restart is requested but not started yet, commands would not
be sent to the FW, and some function calls return an error. Such cases
can trigger unneeded warning messages, e.g., in iwl_mvm_mac_sta_state()
and iwl_mvm_bss_info_changed_station().

Handle a couple of these cases by also checking in the WARN_ON()
condition that HW restart is not requested.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c02559766712..313de9de02fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2364,7 +2364,10 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			 * If update fails - SF might be running in associated
 			 * mode while disassociated - which is forbidden.
 			 */
-			WARN_ONCE(iwl_mvm_sf_update(mvm, vif, false),
+			ret = iwl_mvm_sf_update(mvm, vif, false);
+			WARN_ONCE(ret &&
+				  !test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
+					    &mvm->status),
 				  "Failed to update SF upon disassociation\n");
 
 			/*
@@ -3169,7 +3172,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		/* disable beacon filtering */
-		WARN_ON(iwl_mvm_disable_beacon_filter(mvm, vif, 0));
+		ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
+		WARN_ON(ret &&
+			!test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
+				  &mvm->status));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH) {
-- 
2.20.1

