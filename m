Return-Path: <SRS0=u4Rx=5I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C353C54FCF
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CFC520722
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgCWNTj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:19:39 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728357AbgCWNTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Mar 2020 09:19:39 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jGMzR-00023f-3O; Mon, 23 Mar 2020 15:19:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 23 Mar 2020 15:19:15 +0200
Message-Id: <iwlwifi.20200323151304.67f6594ec0ac.Iaeff50716e783f5c0bcea86ca1c93ada1560525e@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323131925.208376-1-luca@coelho.fi>
References: <20200323131925.208376-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/14] iwlwifi: pass trans and NVM data to HE capability parsing
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We'll need this data in the future, pass the values.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index bab0999f002c..9e9810d2b262 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -684,7 +684,9 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 	},
 };
 
-static void iwl_init_he_hw_capab(struct ieee80211_supported_band *sband,
+static void iwl_init_he_hw_capab(struct iwl_trans *trans,
+				 struct iwl_nvm_data *data,
+				 struct ieee80211_supported_band *sband,
 				 u8 tx_chains, u8 rx_chains)
 {
 	sband->iftype_data = iwl_he_capa;
@@ -728,7 +730,7 @@ static void iwl_init_sbands(struct iwl_trans *trans,
 			     tx_chains, rx_chains);
 
 	if (data->sku_cap_11ax_enable && !iwlwifi_mod_params.disable_11ax)
-		iwl_init_he_hw_capab(sband, tx_chains, rx_chains);
+		iwl_init_he_hw_capab(trans, data, sband, tx_chains, rx_chains);
 
 	sband = &data->bands[NL80211_BAND_5GHZ];
 	sband->band = NL80211_BAND_5GHZ;
@@ -743,7 +745,7 @@ static void iwl_init_sbands(struct iwl_trans *trans,
 				      tx_chains, rx_chains);
 
 	if (data->sku_cap_11ax_enable && !iwlwifi_mod_params.disable_11ax)
-		iwl_init_he_hw_capab(sband, tx_chains, rx_chains);
+		iwl_init_he_hw_capab(trans, data, sband, tx_chains, rx_chains);
 
 	if (n_channels != n_used)
 		IWL_ERR_DEV(dev, "NVM: used only %d of %d channels\n",
-- 
2.25.1

