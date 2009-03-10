Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZCJVaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: check IEEE80211_TX_STAT_AMPDU for agg pkt
Date: Tue, 10 Mar 2009 14:35:11 -0700
Message-Id: <1236720912-6502-6-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223023_185318_C0415A7A)
In-Reply-To: <1236720912-6502-5-git-send-email-reinette.chatre@intel.com>
References: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-2-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-3-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-4-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

when perform rate scaling, in tx status function, checking for
IEEE80211_TX_STAT_AMPDU flag instead of IEEE_TX_CTL_AMPDU flag to perform
AMPDU rate scaling operation.

IEEE80211_TX_CTL_AMPDU was set by mac80211 for aggregation pkt. But when
iwlwifi receive the tx status reply, it reset the flag to following
	info->flags = IEEE80211_TX_STAT_ACK;
	info->flags |= IEEE80211_TX_STAT_AMPDU;
it causes the rate-scaling to not work for aggregation pkt if we checking
for IEEE80211_TX_CTL_AMPDU flag.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 0929f31..43c796b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -916,7 +916,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 			tpt = search_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (info->flags & IEEE80211_TX_STAT_AMPDU)
 			rs_collect_tx_data(search_win, rs_index, tpt,
 					   info->status.ampdu_ack_len,
 					   info->status.ampdu_ack_map);
@@ -932,7 +932,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 			tpt = curr_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (info->flags & IEEE80211_TX_STAT_AMPDU)
 			rs_collect_tx_data(window, rs_index, tpt,
 					   info->status.ampdu_ack_len,
 					   info->status.ampdu_ack_map);
@@ -944,7 +944,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	/* If not searching for new mode, increment success/failed counter
 	 * ... these help determine when to start searching again */
 	if (lq_sta->stay_in_tbl) {
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if (info->flags & IEEE80211_TX_STAT_AMPDU) {
 			lq_sta->total_success += info->status.ampdu_ack_map;
 			lq_sta->total_failed +=
 			     (info->status.ampdu_ack_len - info->status.ampdu_ack_map);
-- 
1.5.6.3

