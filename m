Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D112C07EBF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D46712086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbfARTAT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48330 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728989AbfARTAS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:18 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNI-0004cj-9s; Fri, 18 Jan 2019 21:00:16 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:52 +0200
Message-Id: <20190118190004.22270-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/16] iwlwifi: mvm: rely on mac80211 to configure TWT support
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Mac80211 will check both the HE Capability IE and the
Extended Capability IE, so set the TWT support bit when
mac80211 tells us to.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 22 ++-----------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 7779951a9533..eb66269ddf73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -778,27 +778,9 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 
 	if (vif->bss_conf.assoc && vif->bss_conf.he_support &&
 	    !iwlwifi_mod_params.disable_11ax) {
-		struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-		u8 sta_id = mvmvif->ap_sta_id;
-
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_11AX);
-		if (sta_id != IWL_MVM_INVALID_STA) {
-			struct ieee80211_sta *sta;
-
-			sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-				lockdep_is_held(&mvm->mutex));
-
-			/*
-			 * TODO: we should check the ext cap IE but it is
-			 * unclear why the spec requires two bits (one in HE
-			 * cap IE, and one in the ext cap IE). In the meantime
-			 * rely on the HE cap IE only.
-			 */
-			if (sta && (sta->he_cap.he_cap_elem.mac_cap_info[0] &
-				    IEEE80211_HE_MAC_CAP0_TWT_RES))
-				ctxt_sta->data_policy |=
-					cpu_to_le32(TWT_SUPPORTED);
-		}
+		if (vif->bss_conf.twt_requester)
+			ctxt_sta->data_policy |= cpu_to_le32(TWT_SUPPORTED);
 	}
 
 
-- 
2.20.1

