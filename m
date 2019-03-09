Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869D4C10F0E
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EA2720866
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfCIJWw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41836 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725764AbfCIJWv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:51 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBt-0000qV-7n; Sat, 09 Mar 2019 11:22:49 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:37 +0200
Message-Id: <20190309092237.10294-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 8/8] iwlwifi: mvm: support multiple BSSID
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Set the capabilities flags and inform firmware

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e18b57c84dd2..fd989c43df2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -420,6 +420,7 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 
 const static u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
+	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
@@ -732,6 +733,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->iftype_ext_capab = he_iftypes_ext_capa;
 		hw->wiphy->num_iftype_ext_capab =
 			ARRAY_SIZE(he_iftypes_ext_capa);
+
+		ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
+		ieee80211_hw_set(hw, SUPPORTS_ONLY_HE_MULTI_BSSID);
 	}
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
@@ -2395,7 +2399,11 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 			(vif->bss_conf.uora_ocw_range >> 3) & 0x7;
 	}
 
-	/* TODO: support Multi BSSID IE */
+	if (vif->bss_conf.nontransmitted) {
+		flags |= STA_CTXT_HE_REF_BSSID_VALID;
+		ether_addr_copy(sta_ctxt_cmd.ref_bssid_addr,
+				vif->bss_conf.transmitter_bssid);
+	}
 
 	sta_ctxt_cmd.flags = cpu_to_le32(flags);
 
-- 
2.20.1

