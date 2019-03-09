Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA3AC4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DADB20866
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfCIJWp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:45 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41780 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725764AbfCIJWp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:45 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBn-0000qV-J8; Sat, 09 Mar 2019 11:22:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:31 +0200
Message-Id: <20190309092237.10294-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/8] iwlwifi: mvm: implement CSA abort
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In case we receive abort operation for CSA, clean up
our state.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1bdc27d07d74..b5a9e83cc034 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4631,6 +4631,29 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void iwl_mvm_abort_channel_switch(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_chan_switch_te_cmd cmd = {
+		.mac_id = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							  mvmvif->color)),
+		.action = cpu_to_le32(FW_CTXT_ACTION_REMOVE),
+	};
+
+	IWL_DEBUG_MAC80211(mvm, "Abort CSA on mac %d\n", mvmvif->id);
+
+	mutex_lock(&mvm->mutex);
+	WARN_ON(iwl_mvm_send_cmd_pdu(mvm,
+				     WIDE_ID(MAC_CONF_GROUP,
+					     CHANNEL_SWITCH_TIME_EVENT_CMD),
+				     0, sizeof(cmd), &cmd));
+	mutex_unlock(&mvm->mutex);
+
+	WARN_ON(iwl_mvm_post_channel_switch(hw, vif));
+}
+
 static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 {
 	int i;
@@ -5087,6 +5110,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.channel_switch = iwl_mvm_channel_switch,
 	.pre_channel_switch = iwl_mvm_pre_channel_switch,
 	.post_channel_switch = iwl_mvm_post_channel_switch,
+	.abort_channel_switch = iwl_mvm_abort_channel_switch,
 
 	.tdls_channel_switch = iwl_mvm_tdls_channel_switch,
 	.tdls_cancel_channel_switch = iwl_mvm_tdls_cancel_channel_switch,
-- 
2.20.1

