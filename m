Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F8FC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09FB7218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfAaUWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:20 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53554 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726848AbfAaUWT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:19 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqn-0004pL-GJ; Thu, 31 Jan 2019 22:22:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:49 +0200
Message-Id: <20190131202206.15903-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/21] iwlwifi: mvm: config mac ctxt to HE before TLC
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

If we have a station connecting HE, make sure that the
MAC ctxt is updated with indication of this before
setting the TLC rates via the TLC manager command.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index c1eb07c08827..83711b555036 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -706,8 +706,7 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	if (vif->probe_req_reg && vif->bss_conf.assoc && vif->p2p)
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
 
-	if (vif->bss_conf.assoc && vif->bss_conf.he_support &&
-	    !iwlwifi_mod_params.disable_11ax) {
+	if (vif->bss_conf.he_support && !iwlwifi_mod_params.disable_11ax) {
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_11AX);
 		if (vif->bss_conf.twt_requester)
 			ctxt_sta->data_policy |= cpu_to_le32(TWT_SUPPORTED);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 92605aaca937..fc251cc47b7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3066,11 +3066,15 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		if (vif->type == NL80211_IFTYPE_AP) {
+			vif->bss_conf.he_support = sta->he_cap.has_he;
 			mvmvif->ap_assoc_sta_count++;
 			iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 			if (vif->bss_conf.he_support &&
 			    !iwlwifi_mod_params.disable_11ax)
 				iwl_mvm_cfg_he_sta(mvm, vif, mvm_sta->sta_id);
+		} else if (vif->type == NL80211_IFTYPE_STATION) {
+			vif->bss_conf.he_support = sta->he_cap.has_he;
+			iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 		}
 
 		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band,
-- 
2.20.1

