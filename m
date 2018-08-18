Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42068 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726242AbeHRLeu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:34:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:36 +0300
Message-Id: <20180818082750.28717-3-luca@coelho.fi> (sfid-20180818_102812_471361_B8686433)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 02/16] iwlwifi: remove unused TLC debugging commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_dhc_tlc_cmd struct is not used, so remove it, including the
iwl_tcl_debug_flags enumeration.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rs.h    | 60 -------------------
 1 file changed, 60 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
index 087fae91baef..fe2763cfc3b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -217,66 +217,6 @@ struct iwl_tlc_update_notif {
 	__le32 amsdu_enabled;
 } __packed; /* TLC_MNG_UPDATE_NTFY_API_S_VER_2 */
 
-/**
- * enum iwl_tlc_debug_flags - debug options
- * @IWL_TLC_DEBUG_FIXED_RATE: set fixed rate for rate scaling
- * @IWL_TLC_DEBUG_STATS_TH: threshold for sending statistics to the driver, in
- *	frames
- * @IWL_TLC_DEBUG_STATS_TIME_TH: threshold for sending statistics to the
- *	driver, in msec
- * @IWL_TLC_DEBUG_AGG_TIME_LIM: time limit for a BA session
- * @IWL_TLC_DEBUG_AGG_DIS_START_TH: frame with try-count greater than this
- *	threshold should not start an aggregation session
- * @IWL_TLC_DEBUG_AGG_FRAME_CNT_LIM: set max number of frames in an aggregation
- * @IWL_TLC_DEBUG_RENEW_ADDBA_DELAY: delay between retries of ADD BA
- * @IWL_TLC_DEBUG_START_AC_RATE_IDX: frames per second to start a BA session
- * @IWL_TLC_DEBUG_NO_FAR_RANGE_TWEAK: disable BW scaling
- */
-enum iwl_tlc_debug_flags {
-	IWL_TLC_DEBUG_FIXED_RATE,
-	IWL_TLC_DEBUG_STATS_TH,
-	IWL_TLC_DEBUG_STATS_TIME_TH,
-	IWL_TLC_DEBUG_AGG_TIME_LIM,
-	IWL_TLC_DEBUG_AGG_DIS_START_TH,
-	IWL_TLC_DEBUG_AGG_FRAME_CNT_LIM,
-	IWL_TLC_DEBUG_RENEW_ADDBA_DELAY,
-	IWL_TLC_DEBUG_START_AC_RATE_IDX,
-	IWL_TLC_DEBUG_NO_FAR_RANGE_TWEAK,
-}; /* TLC_MNG_DEBUG_FLAGS_API_E_VER_1 */
-
-/**
- * struct iwl_dhc_tlc_dbg - fixed debug config
- * @sta_id: bit 0 - enable/disable, bits 1 - 7 hold station id
- * @reserved1: reserved
- * @flags: bitmap of %IWL_TLC_DEBUG_\*
- * @fixed_rate: rate value
- * @stats_threshold: if number of tx-ed frames is greater, send statistics
- * @time_threshold: statistics threshold in usec
- * @agg_time_lim: max agg time
- * @agg_dis_start_threshold: frames with try-cont greater than this count will
- *			     not be aggregated
- * @agg_frame_count_lim: agg size
- * @addba_retry_delay: delay between retries of ADD BA
- * @start_ac_rate_idx: frames per second to start a BA session
- * @no_far_range_tweak: disable BW scaling
- * @reserved2: reserved
- */
-struct iwl_dhc_tlc_cmd {
-	u8 sta_id;
-	u8 reserved1[3];
-	__le32 flags;
-	__le32 fixed_rate;
-	__le16 stats_threshold;
-	__le16 time_threshold;
-	__le16 agg_time_lim;
-	__le16 agg_dis_start_threshold;
-	__le16 agg_frame_count_lim;
-	__le16 addba_retry_delay;
-	u8 start_ac_rate_idx[IEEE80211_NUM_ACS];
-	u8 no_far_range_tweak;
-	u8 reserved2[3];
-} __packed;
-
 /*
  * These serve as indexes into
  * struct iwl_rate_info fw_rate_idx_to_plcp[IWL_RATE_COUNT];
-- 
2.18.0
