Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:38853 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbaDMTVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:03 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so7345448wes.16
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_SCHED_SCAN flag
Date: Sun, 13 Apr 2014 22:19:50 +0300
Message-Id: <1397416802-32403-35-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_193190_3D1B0B7C)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |  2 --
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index fbfdba7..90d69a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -83,7 +83,6 @@
  *	from the probe request template.
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
- * @IWL_UCODE_TLV_FLAGS_SCHED_SCAN: this uCode image supports scheduled scan.
  * @IWL_UCODE_TLV_FLAGS_STA_KEY_CMD: new ADD_STA and ADD_STA_KEY command API
  * @IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD: support device wide power command
  *	containing CAM (Continuous Active Mode) indication.
@@ -107,7 +106,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
-	IWL_UCODE_TLV_FLAGS_SCHED_SCAN		= BIT(17),
 	IWL_UCODE_TLV_FLAGS_STA_KEY_CMD		= BIT(19),
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
 	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c455722..8312c03 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -362,14 +362,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
-		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-		hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
-		hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
-		/* we create the 802.11 header and zero length SSID IE. */
-		hw->wiphy->max_sched_scan_ie_len =
-					SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
-	}
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+	hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
+	hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
+	/* we create the 802.11 header and zero length SSID IE. */
+	hw->wiphy->max_sched_scan_ie_len = SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
 			       NL80211_FEATURE_P2P_GO_OPPPS;
-- 
1.8.3.2

