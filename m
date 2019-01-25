Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F55C282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C503218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfAYUVu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:21:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50900 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYUVu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:21:50 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qp-00010a-Vn; Fri, 25 Jan 2019 22:13:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:59 +0200
Message-Id: <20190125201305.5616-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/17] iwlwifi: move iwl_enable_{rx,tx}_ampdu to iwl-modparams.h
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

These inlines just check the module parameters, so they don't
need a configuration parameter and can move to a better place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c | 23 +++----------------
 .../wireless/intel/iwlwifi/iwl-modparams.h    | 18 +++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 22 ++----------------
 3 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 49b71dbf8490..54b759cec8b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -710,24 +711,6 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
-{
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
-		return false;
-	return true;
-}
-
-static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
-{
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
-		return false;
-	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
-		return true;
-
-	/* disabled by default */
-	return false;
-}
-
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_ampdu_params *params)
@@ -752,7 +735,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (!iwl_enable_rx_ampdu(priv->cfg))
+		if (!iwl_enable_rx_ampdu())
 			break;
 		IWL_DEBUG_HT(priv, "start Rx\n");
 		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
@@ -764,7 +747,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		if (!priv->trans->ops->txq_enable)
 			break;
-		if (!iwl_enable_tx_ampdu(priv->cfg))
+		if (!iwl_enable_tx_ampdu())
 			break;
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 73b1c46f1158..0cae2ef9b9df 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -152,4 +152,22 @@ struct iwl_mod_params {
 	bool enable_ini;
 };
 
+static inline bool iwl_enable_rx_ampdu(void)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(void)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
+		return true;
+
+	/* enabled by default */
+	return true;
+}
+
 #endif /* #__iwl_modparams_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ebb3814dd922..78b35c9595a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -943,24 +943,6 @@ static void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
 	schedule_work(&mvm->add_stream_wk);
 }
 
-static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
-{
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
-		return false;
-	return true;
-}
-
-static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
-{
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
-		return false;
-	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
-		return true;
-
-	/* enabled by default */
-	return true;
-}
-
 #define CHECK_BA_TRIGGER(_mvm, _trig, _tid_bm, _tid, _fmt...)		\
 	do {								\
 		if (!(le16_to_cpu(_tid_bm) & BIT(_tid)))		\
@@ -1073,7 +1055,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 			mvmvif = iwl_mvm_vif_from_mac80211(vif);
 			cancel_delayed_work(&mvmvif->uapsd_nonagg_detected_wk);
 		}
-		if (!iwl_enable_rx_ampdu(mvm->cfg)) {
+		if (!iwl_enable_rx_ampdu()) {
 			ret = -EINVAL;
 			break;
 		}
@@ -1085,7 +1067,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 					 timeout);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (!iwl_enable_tx_ampdu(mvm->cfg)) {
+		if (!iwl_enable_tx_ampdu()) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.20.1

