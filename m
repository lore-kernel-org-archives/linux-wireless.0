Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbbECTch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/42] iwlwifi: mvm: allow scheduled scan for all the firmwares
Date: Sun,  3 May 2015 22:31:27 +0300
Message-Id: <1430681513-7838-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213419_081583_D474C5B2)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't support -9.ucode so, all the released firmwares
support scheduled scan properly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c136fe0..249d020 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -539,14 +539,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10) {
-		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-		hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
-		hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
-		/* we create the 802.11 header and zero length SSID IE. */
-		hw->wiphy->max_sched_scan_ie_len =
-			SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
-	}
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+	hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
+	hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
+	/* we create the 802.11 header and zero length SSID IE. */
+	hw->wiphy->max_sched_scan_ie_len =
+		SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
 			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
2.1.0

