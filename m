Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40816 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755886AbcH2TkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 15:40:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 29 Aug 2016 22:39:54 +0300
Message-Id: <1472499594-3369-4-git-send-email-luca@coelho.fi> (sfid-20160829_214015_020536_06730768)
In-Reply-To: <1472499594-3369-1-git-send-email-luca@coelho.fi>
References: <1472499451.27868.31.camel@coelho.fi>
 <1472499594-3369-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 4/4] iwlwifi: mvm: Advertise support for AP channel width change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Peer, Ilan" <ilan.peer@intel.com>

The iwlmvm driver supports channel width change in AP mode.  Add the
proper flag.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6d60645..5dd77e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -624,6 +624,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
 			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
 			       NL80211_FEATURE_P2P_GO_OPPPS |
+			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
 			       NL80211_FEATURE_DYNAMIC_SMPS |
 			       NL80211_FEATURE_STATIC_SMPS |
 			       NL80211_FEATURE_SUPPORTS_WMM_ADMISSION;
-- 
2.8.1
