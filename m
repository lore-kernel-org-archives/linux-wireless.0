Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41020 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752092AbdG1O0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:34 +0300
Message-Id: <20170728142337.19183-22-luca@coelho.fi> (sfid-20170728_162639_341215_6961304C)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 21/24] iwlwifi: mvm: simplify bufferable MMPDU check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to spell out the cases when we can just
use ieee80211_is_bufferable_mmpdu().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a2e0acc23adc..b8373923cfa9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -816,9 +816,7 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	/* treat non-bufferable MMPDUs as broadcast if sta is sleeping */
 	if (unlikely(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER &&
 		     ieee80211_is_mgmt(hdr->frame_control) &&
-		     !ieee80211_is_deauth(hdr->frame_control) &&
-		     !ieee80211_is_disassoc(hdr->frame_control) &&
-		     !ieee80211_is_action(hdr->frame_control)))
+		     !ieee80211_is_bufferable_mmpdu(hdr->frame_control)))
 		sta = NULL;
 
 	if (sta) {
-- 
2.13.2
