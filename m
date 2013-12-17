Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51062 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3LQUox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:53 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so3165920eaj.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:52 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/36] iwlwifi: set VHT beamformee STS cap correctly
Date: Tue, 17 Dec 2013 22:44:08 +0200
Message-Id: <1387313079-28123-5-git-send-email-egrumbach@gmail.com> (sfid-20131217_214458_858140_10351E05)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

It was set to zero which reflects support of a single STS.
Set according to the number of Rx antennas which correctly
reflects the number of STSs the STA can receive in a VHT NDP.
This improves beamforming and has been tested to improve Rx
throughput.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 94aef22..e366f12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -263,11 +263,14 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 				  struct iwl_nvm_data *data,
 				  struct ieee80211_sta_vht_cap *vht_cap)
 {
+	int bf_sts_cap = num_of_ant(data->valid_rx_ant) - 1;
+
 	vht_cap->vht_supported = true;
 
 	vht_cap->cap = IEEE80211_VHT_CAP_SHORT_GI_80 |
 		       IEEE80211_VHT_CAP_RXSTBC_1 |
 		       IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+		       bf_sts_cap << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
 		       7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
 	if (iwlwifi_mod_params.amsdu_size_8K)
-- 
1.7.9.5

