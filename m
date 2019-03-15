Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D957C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593D02077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfCOQgp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:45 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44226 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728277AbfCOQgo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:44 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp3-0004qp-PY; Fri, 15 Mar 2019 18:36:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:20 +0200
Message-Id: <20190315163634.17315-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/16] iwlwifi: mvm: be more forgiving if num of channels is too big
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

If number of channels in the driver is greater than
number of scan channels given by firmware TLV, do not
fail scan config, but adjust to firmware's number of channels.
This is helpful for supporting in driver new channels before
it being supported by firmware scan.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 78694bc38e76..d9ddf9ff6428 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1082,21 +1082,23 @@ static void iwl_mvm_fill_scan_dwell(struct iwl_mvm *mvm,
 	dwell->extended = IWL_SCAN_DWELL_EXTENDED;
 }
 
-static void iwl_mvm_fill_channels(struct iwl_mvm *mvm, u8 *channels)
+static void iwl_mvm_fill_channels(struct iwl_mvm *mvm, u8 *channels,
+				  u32 max_channels)
 {
 	struct ieee80211_supported_band *band;
 	int i, j = 0;
 
 	band = &mvm->nvm_data->bands[NL80211_BAND_2GHZ];
-	for (i = 0; i < band->n_channels; i++, j++)
+	for (i = 0; i < band->n_channels && j < max_channels; i++, j++)
 		channels[j] = band->channels[i].hw_value;
 	band = &mvm->nvm_data->bands[NL80211_BAND_5GHZ];
-	for (i = 0; i < band->n_channels; i++, j++)
+	for (i = 0; i < band->n_channels && j < max_channels; i++, j++)
 		channels[j] = band->channels[i].hw_value;
 }
 
 static void iwl_mvm_fill_scan_config_v1(struct iwl_mvm *mvm, void *config,
-					u32 flags, u8 channel_flags)
+					u32 flags, u8 channel_flags,
+					u32 max_channels)
 {
 	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, NULL);
 	struct iwl_scan_config_v1 *cfg = config;
@@ -1115,11 +1117,12 @@ static void iwl_mvm_fill_scan_config_v1(struct iwl_mvm *mvm, void *config,
 	cfg->bcast_sta_id = mvm->aux_sta.sta_id;
 	cfg->channel_flags = channel_flags;
 
-	iwl_mvm_fill_channels(mvm, cfg->channel_array);
+	iwl_mvm_fill_channels(mvm, cfg->channel_array, max_channels);
 }
 
 static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
-				     u32 flags, u8 channel_flags)
+				     u32 flags, u8 channel_flags,
+				     u32 max_channels)
 {
 	struct iwl_scan_config *cfg = config;
 
@@ -1162,7 +1165,7 @@ static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
 	cfg->bcast_sta_id = mvm->aux_sta.sta_id;
 	cfg->channel_flags = channel_flags;
 
-	iwl_mvm_fill_channels(mvm, cfg->channel_array);
+	iwl_mvm_fill_channels(mvm, cfg->channel_array, max_channels);
 }
 
 int iwl_mvm_config_scan(struct iwl_mvm *mvm)
@@ -1181,7 +1184,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	u8 channel_flags;
 
 	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
-		return -ENOBUFS;
+		num_channels = mvm->fw->ucode_capa.n_scan_channels;
 
 	if (iwl_mvm_is_cdb_supported(mvm)) {
 		type = iwl_mvm_get_scan_type_band(mvm, NULL,
@@ -1234,9 +1237,11 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 			flags |= (iwl_mvm_is_scan_fragmented(hb_type)) ?
 				 SCAN_CONFIG_FLAG_SET_LMAC2_FRAGMENTED :
 				 SCAN_CONFIG_FLAG_CLEAR_LMAC2_FRAGMENTED;
-		iwl_mvm_fill_scan_config(mvm, cfg, flags, channel_flags);
+		iwl_mvm_fill_scan_config(mvm, cfg, flags, channel_flags,
+					 num_channels);
 	} else {
-		iwl_mvm_fill_scan_config_v1(mvm, cfg, flags, channel_flags);
+		iwl_mvm_fill_scan_config_v1(mvm, cfg, flags, channel_flags,
+					    num_channels);
 	}
 
 	cmd.data[0] = cfg;
-- 
2.20.1

