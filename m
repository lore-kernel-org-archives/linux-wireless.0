Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F48C3E8C5
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Nov 2020 13:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E73920705
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Nov 2020 13:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgK2NPh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 29 Nov 2020 08:15:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:33436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727894AbgK2NPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Nov 2020 08:15:37 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kjMXR-0035gF-RD; Sun, 29 Nov 2020 15:14:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 29 Nov 2020 15:14:37 +0200
Message-Id: <iwlwifi.20201129151117.403342c39159.I8c7372e6f72279e22966a2d0a9066521f9d2f1a0@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129131442.1857561-1-luca@coelho.fi>
References: <20201129131442.1857561-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/12] iwlwifi: d3: do not send the WOWLAN_CONFIGURATION command for netdetect
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

This command should be used only when there's a real client station.
Currently it works, but since soon the driver will stop actually having
an auxiliary station by default, and this command requires _some_ valid
station, it needs to be removed from this flow.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d21143495e70..09a5c770961d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -955,7 +955,6 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 			 struct cfg80211_sched_scan_request *nd_config,
 			 struct ieee80211_vif *vif)
 {
-	struct iwl_wowlan_config_cmd wowlan_config_cmd = {};
 	int ret;
 	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
 					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
@@ -975,19 +974,6 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 			return ret;
 	}
 
-	/* rfkill release can be either for wowlan or netdetect */
-	if (wowlan->rfkill_release)
-		wowlan_config_cmd.wakeup_filter |=
-			cpu_to_le32(IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT);
-
-	wowlan_config_cmd.sta_id = mvm->aux_sta.sta_id;
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, 0,
-				   sizeof(wowlan_config_cmd),
-				   &wowlan_config_cmd);
-	if (ret)
-		return ret;
-
 	ret = iwl_mvm_sched_scan_start(mvm, vif, nd_config, &mvm->nd_ies,
 				       IWL_MVM_SCAN_NETDETECT);
 	if (ret)
-- 
2.29.2

