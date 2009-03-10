Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbZCJVaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlwifi: remove un-necessary rs_tl_turn_on_agg() after agg enabled
Date: Tue, 10 Mar 2009 14:35:09 -0700
Message-Id: <1236720912-6502-4-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223019_803501_78FFA757)
In-Reply-To: <1236720912-6502-3-git-send-email-reinette.chatre@intel.com>
References: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-2-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

After the MLME handshaking complete and tx aggregation started for the
tid. Do not send unnecessary turn on aggregation request to mac80211.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 9bcebf2..a6f4c74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1700,6 +1700,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	u16 high_low;
 	s32 sr;
 	u8 tid = MAX_TID_COUNT;
+	struct iwl_tid_data *tid_data;
 
 	IWL_DEBUG_RATE(priv, "rate scale calculate new rate for skb\n");
 
@@ -2035,8 +2036,15 @@ lq_update:
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != MAX_TID_COUNT)) {
-				IWL_DEBUG_RATE(priv, "try to aggregate tid %d\n", tid);
-				rs_tl_turn_on_agg(priv, tid, lq_sta, sta);
+				tid_data =
+				   &priv->stations[lq_sta->lq.sta_id].tid[tid];
+				if (tid_data->agg.state == IWL_AGG_OFF) {
+					IWL_DEBUG_RATE(priv,
+						       "try to aggregate tid %d\n",
+						       tid);
+					rs_tl_turn_on_agg(priv, tid,
+							  lq_sta, sta);
+				}
 			}
 			lq_sta->action_counter = 0;
 			rs_set_stay_in_table(priv, 0, lq_sta);
-- 
1.5.6.3

