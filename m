Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYKLVNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:48 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8] iwlwifi: rs: remove fc variable and other cleanups
Date: Wed, 12 Nov 2008 13:14:06 -0800
Message-Id: <1226524451-3417-4-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221355_573752_708F4EDA)
In-Reply-To: <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch
1. Removes use once use only fc variables, they are useless after refactoring
ieee80211 frame control handlers
2. Other trivial cleanups

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   48 +++++++++++-----------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index af68709..224c0b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -281,10 +281,9 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 	u32 time_diff;
 	s32 index;
 	struct iwl_traffic_load *tl = NULL;
-	__le16 fc = hdr->frame_control;
 	u8 tid;
 
-	if (ieee80211_is_data_qos(fc)) {
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 	} else
@@ -775,7 +774,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	int status;
 	u8 retries;
 	int rs_index, index = 0;
-	struct iwl_lq_sta *lq_sta;
+	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_link_quality_cmd *table;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
@@ -787,12 +786,12 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	struct iwl_scale_tbl_info tbl_type;
 	struct iwl_scale_tbl_info *curr_tbl, *search_tbl;
 	u8 active_index = 0;
-	__le16 fc = hdr->frame_control;
 	s32 tpt = 0;
 
 	IWL_DEBUG_RATE_LIMIT("get frame ack response, update rate scale window\n");
 
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		return;
 
 	/* This packet was aggregated but doesn't carry rate scale info */
@@ -805,8 +804,6 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	if (retries > 15)
 		retries = 15;
 
-	lq_sta = (struct iwl_lq_sta *)priv_sta;
-
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added)
 		goto out;
@@ -1677,7 +1674,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	int high_tpt = IWL_INVALID_VALUE;
 	u32 fail_count;
 	s8 scale_action = 0;
-	__le16 fc;
 	u16 rate_mask;
 	u8 update_lq = 0;
 	struct iwl_scale_tbl_info *tbl, *tbl1;
@@ -1692,13 +1688,12 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
 
-	fc = hdr->frame_control;
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
-		/* Send management frames and broadcast/multicast data using
-		 * lowest rate. */
-		/* TODO: this could probably be improved.. */
+	/* Send management frames and broadcast/multicast data using
+	 * lowest rate. */
+	/* TODO: this could probably be improved.. */
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		return;
-	}
 
 	if (!sta || !lq_sta)
 		return;
@@ -2097,29 +2092,26 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 			struct ieee80211_tx_rate_control *txrc)
 {
 
-	int i;
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_supported_band *sband = txrc->sband;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	__le16 fc;
-	struct iwl_lq_sta *lq_sta;
+	struct iwl_lq_sta *lq_sta = priv_sta;
+	int rate_idx;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
-	fc = hdr->frame_control;
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
-	    !sta || !priv_sta) {
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1) || !sta || !lq_sta) {
 		info->control.rates[0].idx = rate_lowest_index(sband, sta);
 		return;
 	}
 
-	lq_sta = (struct iwl_lq_sta *)priv_sta;
-	i = lq_sta->last_txrate_idx;
+	rate_idx  = lq_sta->last_txrate_idx;
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added) {
@@ -2140,14 +2132,12 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 		}
 	}
 
-	if ((i < 0) || (i > IWL_RATE_COUNT)) {
-		info->control.rates[0].idx = rate_lowest_index(sband, sta);
-		return;
-	}
+	if (rate_idx < 0 || rate_idx > IWL_RATE_COUNT)
+		rate_idx = rate_lowest_index(sband, sta);
+	else if (sband->band == IEEE80211_BAND_5GHZ)
+		rate_idx -= IWL_FIRST_OFDM_RATE;
 
-	if (sband->band == IEEE80211_BAND_5GHZ)
-		i -= IWL_FIRST_OFDM_RATE;
-	info->control.rates[0].idx = i;
+	info->control.rates[0].idx = rate_idx;
 }
 
 static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
-- 
1.5.4.3

