Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706F2C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46BEA20866
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfCIJWv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726337AbfCIJWu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:50 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBs-0000qV-Cp; Sat, 09 Mar 2019 11:22:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:36 +0200
Message-Id: <20190309092237.10294-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 7/8] iwlwifi: mvm: track changes in beacon count during channel switch
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

There are some buggy APs that keeps changing the count while forcing
us to block TX. This eventually results in queue hang, assert, and
disconnection. Detect such APs and disconnect gracefully in advance.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 15 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index af71e58bdd24..e18b57c84dd2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4662,6 +4662,9 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 			iwl_mvm_schedule_csa_period(mvm, vif,
 						    vif->bss_conf.beacon_int,
 						    apply_time);
+
+		mvmvif->csa_count = chsw->count;
+		mvmvif->csa_misbehave = false;
 		break;
 	default:
 		break;
@@ -4700,6 +4703,18 @@ static void iwl_mvm_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_CS_MODIFY))
 		return;
 
+	if (chsw->count >= mvmvif->csa_count && chsw->block_tx) {
+		if (mvmvif->csa_misbehave) {
+			/* Second time, give up on this AP*/
+			iwl_mvm_abort_channel_switch(hw, vif);
+			ieee80211_chswitch_done(vif, false);
+			mvmvif->csa_misbehave = false;
+			return;
+		}
+		mvmvif->csa_misbehave = true;
+	}
+	mvmvif->csa_count = chsw->count;
+
 	IWL_DEBUG_MAC80211(mvm, "Modify CSA on mac %d\n", mvmvif->id);
 
 	WARN_ON(iwl_mvm_send_cmd_pdu(mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 79d7fcb95b6f..4e179e69fd32 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -490,6 +490,8 @@ struct iwl_mvm_vif {
 	bool csa_countdown;
 	bool csa_failed;
 	u16 csa_target_freq;
+	u16 csa_count;
+	u16 csa_misbehave;
 	struct delayed_work csa_work;
 
 	/* Indicates that we are waiting for a beacon on a new channel */
-- 
2.20.1

