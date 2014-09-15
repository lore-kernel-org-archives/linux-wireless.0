Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40462 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaIOFKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:10:54 -0400
Received: by mail-wg0-f52.google.com with SMTP id x13so3268861wgg.23
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:10:53 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/12] iwlwifi: mvm: enable scheduled scan on newest firmware
Date: Mon, 15 Sep 2014 08:10:37 +0300
Message-Id: <1410757848-1827-1-git-send-email-egrumbach@gmail.com> (sfid-20140915_071057_623462_14EFD450)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Scheduled scan was disabled because of a bug in the firmware.
The firmware reported support for this feature, but enabling
it led to assertions.
The bugs have been fixes in latest firmware versions, so that
we can re-enable the feature on latest firmwares only.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7c87965..c4000a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -396,12 +396,14 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	/* TODO: enable that only for firmwares that don't crash */
-	/* hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN; */
-	hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
-	hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
-	/* we create the 802.11 header and zero length SSID IE. */
-	hw->wiphy->max_sched_scan_ie_len = SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
+	if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10) {
+		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+		hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
+		hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
+		/* we create the 802.11 header and zero length SSID IE. */
+		hw->wiphy->max_sched_scan_ie_len =
+			SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
+	}
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
 			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
1.9.1

