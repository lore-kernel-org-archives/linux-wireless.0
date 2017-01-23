Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36098 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751136AbdAWWED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 24 Jan 2017 00:03:26 +0200
Message-Id: <20170123220350.25305-2-luca@coelho.fi> (sfid-20170123_230410_411614_40D9038C)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: expose device timestamp in radiotap
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Set the relevant fields to export the 32-bit device timestamp to
radiotap using the new mac80211 infrastructure. This will be useful
to allow synchronising monitor captures taken on different hardware
simultaneously.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 45122dafe922..039cb2ad2d3e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -463,6 +463,13 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 				    IEEE80211_RADIOTAP_MCS_HAVE_STBC;
 	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC |
 		IEEE80211_RADIOTAP_VHT_KNOWN_BEAMFORMED;
+
+	hw->radiotap_timestamp.units_pos =
+		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US |
+		IEEE80211_RADIOTAP_TIMESTAMP_SPOS_PLCP_SIG_ACQ;
+	/* this is the case for CCK frames, it's better (only 8) for OFDM */
+	hw->radiotap_timestamp.accuracy = 22;
+
 	hw->rate_control_algorithm = "iwl-mvm-rs";
 	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
-- 
2.11.0
