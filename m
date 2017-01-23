Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751757AbdAWWSo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:44 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:38 +0200
Message-Id: <20170123220350.25305-14-luca@coelho.fi> (sfid-20170123_231846_804178_D58FD7AF)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: support version 2 of stored beacon notification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For 9000 devices withg upload, FW cannot send the entire phy
flags, and will send only the band - which is what we really
care about anyway. Change is backward compatible.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index ae12badc0c2a..567597c26115 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -2075,7 +2075,7 @@ struct iwl_mu_group_mgmt_notif {
  * @system_time: system time on air rise
  * @tsf: TSF on air rise
  * @beacon_timestamp: beacon on air rise
- * @phy_flags: general phy flags: band, modulation, etc.
+ * @band: band, matches &RX_RES_PHY_FLAGS_BAND_24 definition
  * @channel: channel this beacon was received on
  * @rates: rate in ucode internal format
  * @byte_count: frame's byte count
@@ -2084,12 +2084,12 @@ struct iwl_stored_beacon_notif {
 	__le32 system_time;
 	__le64 tsf;
 	__le32 beacon_timestamp;
-	__le16 phy_flags;
+	__le16 band;
 	__le16 channel;
 	__le32 rates;
 	__le32 byte_count;
 	u8 data[MAX_STORED_BEACON_SIZE];
-} __packed; /* WOWLAN_STROED_BEACON_INFO_S_VER_1 */
+} __packed; /* WOWLAN_STROED_BEACON_INFO_S_VER_2 */
 
 #define LQM_NUMBER_OF_STATIONS_IN_REPORT 16
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 4a0874e40731..ebf6c071eb36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1565,7 +1565,7 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	rx_status.flag |= RX_FLAG_MACTIME_PLCP_START;
 	rx_status.device_timestamp = le32_to_cpu(sb->system_time);
 	rx_status.band =
-		(sb->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_BAND_24)) ?
+		(sb->band & cpu_to_le16(RX_RES_PHY_FLAGS_BAND_24)) ?
 				NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 	rx_status.freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(sb->channel),
-- 
2.11.0
