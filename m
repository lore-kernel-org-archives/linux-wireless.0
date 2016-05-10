Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40854 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913AbcEJUax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:30 +0300
Message-Id: <1462910797-20303-34-git-send-email-luca@coelho.fi> (sfid-20160510_223057_539161_4353B4F4)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 34/41] iwlwifi: turn on SGI support for VHT 160MHz
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Devices supporting VHT 160MHz width are supporting also Short GI.
Turn on this capability in vht cap.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index e99624d..21653fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -377,8 +377,8 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
 	if (data->vht160_supported)
-		vht_cap->cap |=
-			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+		vht_cap->cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
+				IEEE80211_VHT_CAP_SHORT_GI_160;
 
 	if (cfg->vht_mu_mimo_supported)
 		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
-- 
2.8.1

