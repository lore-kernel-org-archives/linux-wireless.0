Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751768AbdAWWTq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:19:46 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:44 +0200
Message-Id: <20170123220350.25305-20-luca@coelho.fi> (sfid-20170123_231948_443409_E692FE5E)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 19/25] iwlwifi: dvm: make rs_tl_get_load() return void
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The return value from this function is never used, so make it return
void to avoid getting the following warning when compiling wiht W=1:

/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/dvm/rs.c: In function ‘rs_tl_turn_on_agg_for_tid’:
/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/dvm/rs.c:400:6: warning: variable ‘load’ set but not used [-Wunused-but-set-variable]
  u32 load;
      ^

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index b95c2d76db33..710dbbefd551 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -364,7 +364,7 @@ static void rs_program_fix_rate(struct iwl_priv *priv,
 /*
 	get the traffic load value for tid
 */
-static u32 rs_tl_get_load(struct iwl_lq_sta *lq_data, u8 tid)
+static void rs_tl_get_load(struct iwl_lq_sta *lq_data, u8 tid)
 {
 	u32 curr_time = jiffies_to_msecs(jiffies);
 	u32 time_diff;
@@ -372,14 +372,14 @@ static u32 rs_tl_get_load(struct iwl_lq_sta *lq_data, u8 tid)
 	struct iwl_traffic_load *tl = NULL;
 
 	if (tid >= IWL_MAX_TID_COUNT)
-		return 0;
+		return;
 
 	tl = &(lq_data->load[tid]);
 
 	curr_time -= curr_time % TID_ROUND_VALUE;
 
 	if (!(tl->queue_count))
-		return 0;
+		return;
 
 	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
 	index = time_diff / TID_QUEUE_CELL_SPACING;
@@ -388,8 +388,6 @@ static u32 rs_tl_get_load(struct iwl_lq_sta *lq_data, u8 tid)
 	/* TID_MAX_TIME_DIFF */
 	if (index >= TID_QUEUE_MAX_SIZE)
 		rs_tl_rm_old_stats(tl, curr_time);
-
-	return tl->total;
 }
 
 static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
@@ -397,7 +395,6 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct ieee80211_sta *sta)
 {
 	int ret = -EAGAIN;
-	u32 load;
 
 	/*
 	 * Don't create TX aggregation sessions when in high
@@ -410,7 +407,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 		return ret;
 	}
 
-	load = rs_tl_get_load(lq_data, tid);
+	rs_tl_get_load(lq_data, tid);
 
 	IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 			sta->addr, tid);
-- 
2.11.0
