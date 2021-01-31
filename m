Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E05CC433DB
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Jan 2021 20:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4053B64D9E
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Jan 2021 20:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhAaU10 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Jan 2021 15:27:26 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:43182 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232116AbhAaUYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Jan 2021 15:24:11 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l6HMW-0041H2-2J; Sun, 31 Jan 2021 20:22:16 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 31 Jan 2021 20:22:02 +0200
Message-Id: <iwlwifi.20210131201907.fa62d6770dd1.I5b2ea2e5316ebed94ed77ff0a31d78a9672e4016@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210131182212.929755-1-luca@coelho.fi>
References: <20210131182212.929755-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/12] iwlwifi: mvm: add triggers for MLME events
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

For debug we add auth/assoc failed event and disconnect event.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a529404d416c..ec43601d410a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4988,6 +4988,34 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_event_mlme_callback_ini(struct iwl_mvm *mvm,
+					    struct ieee80211_vif *vif,
+					    const  struct ieee80211_mlme_event *mlme)
+{
+	if (mlme->data == ASSOC_EVENT && (mlme->status == MLME_DENIED ||
+					  mlme->status == MLME_TIMEOUT)) {
+		iwl_dbg_tlv_time_point(&mvm->fwrt,
+				       IWL_FW_INI_TIME_POINT_ASSOC_FAILED,
+				       NULL);
+		return;
+	}
+
+	if (mlme->data == AUTH_EVENT && (mlme->status == MLME_DENIED ||
+					 mlme->status == MLME_TIMEOUT)) {
+		iwl_dbg_tlv_time_point(&mvm->fwrt,
+				       IWL_FW_INI_TIME_POINT_EAPOL_FAILED,
+				       NULL);
+		return;
+	}
+
+	if (mlme->data == DEAUTH_RX_EVENT || mlme->data == DEAUTH_TX_EVENT) {
+		iwl_dbg_tlv_time_point(&mvm->fwrt,
+				       IWL_FW_INI_TIME_POINT_DEASSOC,
+				       NULL);
+		return;
+	}
+}
+
 static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					const struct ieee80211_event *event)
@@ -5002,6 +5030,11 @@ static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
 
+	if (iwl_trans_dbg_ini_valid(mvm->trans)) {
+		iwl_mvm_event_mlme_callback_ini(mvm, vif, &event->u.mlme);
+		return;
+	}
+
 	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
 				     FW_DBG_TRIGGER_MLME);
 	if (!trig)
-- 
2.29.2

