Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890D2C282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60578206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfDWJK6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:10:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58988 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726586AbfDWJKz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:10:55 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS1-0000FN-MK; Tue, 23 Apr 2019 12:10:53 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 07/16] iwlwifi: mvm: limit TLC according to our HE capabilities
Date:   Tue, 23 Apr 2019 12:10:34 +0300
Message-Id: <20190423091043.7156-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

Instead of setting the TLC config command according to the
rates the peer supports, make sure that we aren't also
limited by our own rates, so take the minimum between the
peer's supported RX rates and our supported TX rates.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 34 ++++++++++++++++---
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 3ffdbfdb37c0..659e21b2d4e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -230,19 +230,43 @@ static u16 rs_fw_he_ieee80211_mcs_to_rs_mcs(u16 mcs)
 
 static void
 rs_fw_he_set_enabled_rates(const struct ieee80211_sta *sta,
-			   const struct ieee80211_sta_he_cap *he_cap,
+			   struct ieee80211_supported_band *sband,
 			   struct iwl_tlc_config_cmd *cmd)
 {
-	u16 mcs_160 = le16_to_cpu(sta->he_cap.he_mcs_nss_supp.rx_mcs_160);
-	u16 mcs_80 = le16_to_cpu(sta->he_cap.he_mcs_nss_supp.rx_mcs_80);
+	const struct ieee80211_sta_he_cap *he_cap = &sta->he_cap;
+	u16 mcs_160 = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_160);
+	u16 mcs_80 = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_80);
+	u16 tx_mcs_80 =
+		le16_to_cpu(sband->iftype_data->he_cap.he_mcs_nss_supp.tx_mcs_80);
+	u16 tx_mcs_160 =
+		le16_to_cpu(sband->iftype_data->he_cap.he_mcs_nss_supp.tx_mcs_160);
 	int i;
 
 	for (i = 0; i < sta->rx_nss && i < MAX_NSS; i++) {
 		u16 _mcs_160 = (mcs_160 >> (2 * i)) & 0x3;
 		u16 _mcs_80 = (mcs_80 >> (2 * i)) & 0x3;
-
+		u16 _tx_mcs_160 = (tx_mcs_160 >> (2 * i)) & 0x3;
+		u16 _tx_mcs_80 = (tx_mcs_80 >> (2 * i)) & 0x3;
+
+		/* If one side doesn't support - mark both as not supporting */
+		if (_mcs_80 == IEEE80211_HE_MCS_NOT_SUPPORTED ||
+		    _tx_mcs_80 == IEEE80211_HE_MCS_NOT_SUPPORTED) {
+			_mcs_80 = IEEE80211_HE_MCS_NOT_SUPPORTED;
+			_tx_mcs_80 = IEEE80211_HE_MCS_NOT_SUPPORTED;
+		}
+		if (_mcs_80 > _tx_mcs_80)
+			_mcs_80 = _tx_mcs_80;
 		cmd->ht_rates[i][0] =
 			cpu_to_le16(rs_fw_he_ieee80211_mcs_to_rs_mcs(_mcs_80));
+
+		/* If one side doesn't support - mark both as not supporting */
+		if (_mcs_160 == IEEE80211_HE_MCS_NOT_SUPPORTED ||
+		    _tx_mcs_160 == IEEE80211_HE_MCS_NOT_SUPPORTED) {
+			_mcs_160 = IEEE80211_HE_MCS_NOT_SUPPORTED;
+			_tx_mcs_160 = IEEE80211_HE_MCS_NOT_SUPPORTED;
+		}
+		if (_mcs_160 > _tx_mcs_160)
+			_mcs_160 = _tx_mcs_160;
 		cmd->ht_rates[i][1] =
 			cpu_to_le16(rs_fw_he_ieee80211_mcs_to_rs_mcs(_mcs_160));
 	}
@@ -271,7 +295,7 @@ static void rs_fw_set_supp_rates(struct ieee80211_sta *sta,
 	/* HT/VHT rates */
 	if (he_cap && he_cap->has_he) {
 		cmd->mode = IWL_TLC_MNG_MODE_HE;
-		rs_fw_he_set_enabled_rates(sta, he_cap, cmd);
+		rs_fw_he_set_enabled_rates(sta, sband, cmd);
 	} else if (vht_cap && vht_cap->vht_supported) {
 		cmd->mode = IWL_TLC_MNG_MODE_VHT;
 		rs_fw_vht_set_enabled_rates(sta, vht_cap, cmd);
-- 
2.20.1

