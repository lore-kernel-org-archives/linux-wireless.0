Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:51175 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3LQUoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:54 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so3146019eek.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/36] iwlwifi: publish Tx STBC support in VHT
Date: Tue, 17 Dec 2013 22:44:09 +0200
Message-Id: <1387313079-28123-6-git-send-email-egrumbach@gmail.com> (sfid-20131217_214503_634532_6AF99069)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

If the device is MIMO and VHT capable it supports Tx STBC.
Unlike HT, any chip that supports VHT also support STBC so
no need for a config parameter.
Using num_of_ants multiple times warranted caching it.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index e366f12..ebf629b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -263,7 +263,8 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 				  struct iwl_nvm_data *data,
 				  struct ieee80211_sta_vht_cap *vht_cap)
 {
-	int bf_sts_cap = num_of_ant(data->valid_rx_ant) - 1;
+	int num_ants = num_of_ant(data->valid_rx_ant);
+	int bf_sts_cap = num_ants - 1;
 
 	vht_cap->vht_supported = true;
 
@@ -273,6 +274,9 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       bf_sts_cap << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
 		       7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
+	if (num_ants > 1)
+		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
+
 	if (iwlwifi_mod_params.amsdu_size_8K)
 		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991;
 
@@ -286,7 +290,7 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 14);
 
-	if (num_of_ant(data->valid_rx_ant) == 1 ||
+	if (num_ants == 1 ||
 	    cfg->rx_with_siso_diversity) {
 		vht_cap->cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
 				IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
-- 
1.7.9.5

