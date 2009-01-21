Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbZAUFb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 00:31:28 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwlwifi: allow user to set max rate
Date: Tue, 20 Jan 2009 21:33:52 -0800
Message-Id: <1232516035-25524-3-git-send-email-reinette.chatre@intel.com> (sfid-20090121_063137_642198_6AD91399)
In-Reply-To: <1232516035-25524-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232516035-25524-1-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

allow user to set max rate through #iwconfig <inteface> rate XXX.
mac80211 will try to force this if user set it, but driver is not
in sync which cause mac80211 to report wrong current rate. This
patch will check if max rate is set and force it in rate scaling

Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   27 +++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 25b4356..044abf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -651,6 +651,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	u16 fc;
 	u16 rate_mask = 0;
+	s8 max_rate_idx = -1;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
@@ -675,6 +676,13 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		return;
 	}
 
+	/* get user max rate if set */
+	max_rate_idx = txrc->max_rate_idx;
+	if ((sband->band == IEEE80211_BAND_5GHZ) && (max_rate_idx != -1))
+		max_rate_idx += IWL_FIRST_OFDM_RATE;
+	if ((max_rate_idx < 0) || (max_rate_idx >= IWL_RATE_COUNT))
+		max_rate_idx = -1;
+
 	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT_3945 - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
@@ -706,6 +714,12 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		rs_sta->start_rate = IWL_RATE_INVALID;
 	}
 
+	/* force user max rate if set by user */
+	if ((max_rate_idx != -1) && (max_rate_idx < index)) {
+		if (rate_mask & (1 << max_rate_idx))
+			index = max_rate_idx;
+	}
+
 	window = &(rs_sta->win[index]);
 
 	fail_count = window->counter - window->success_counter;
@@ -732,6 +746,10 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
+	/* If user set max rate, dont allow higher than user constrain */
+	if ((max_rate_idx != -1) && (max_rate_idx < high))
+		high = IWL_RATE_INVALID;
+
 	if (low != IWL_RATE_INVALID)
 		low_tpt = rs_sta->win[low].average_tpt;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a82cce5..12c5e5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -148,6 +148,7 @@ struct iwl_lq_sta {
 	u16 active_mimo2_rate;
 	u16 active_mimo3_rate;
 	u16 active_rate_basic;
+	s8 max_rate_idx;     /* Max rate set by user */
 
 	struct iwl_link_quality_cmd lq;
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
@@ -1759,6 +1760,15 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		return;
 	}
 
+	/* force user max rate if set by user */
+	if ((lq_sta->max_rate_idx != -1) &&
+	    (lq_sta->max_rate_idx < index)) {
+		index = lq_sta->max_rate_idx;
+		update_lq = 1;
+		window = &(tbl->win[index]);
+		goto lq_update;
+	}
+
 	window = &(tbl->win[index]);
 
 	/*
@@ -1850,6 +1860,11 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
+	/* If user set max rate, dont allow higher than user constrain */
+	if ((lq_sta->max_rate_idx != -1) &&
+	    (lq_sta->max_rate_idx < high))
+		high = IWL_RATE_INVALID;
+
 	sr = window->success_ratio;
 
 	/* Collect measured throughputs for current and adjacent rates */
@@ -2110,6 +2125,17 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
+	/* Get max rate if user set max rate */
+	if (lq_sta) {
+		lq_sta->max_rate_idx = txrc->max_rate_idx;
+		if ((sband->band == IEEE80211_BAND_5GHZ) &&
+		    (lq_sta->max_rate_idx != -1))
+			lq_sta->max_rate_idx += IWL_FIRST_OFDM_RATE;
+		if ((lq_sta->max_rate_idx < 0) ||
+		    (lq_sta->max_rate_idx >= IWL_RATE_COUNT))
+			lq_sta->max_rate_idx = -1;
+	}
+
 	if (sta)
 		mask_bit = sta->supp_rates[sband->band];
 
@@ -2220,6 +2246,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	}
 
 	lq_sta->is_dup = 0;
+	lq_sta->max_rate_idx = -1;
 	lq_sta->is_green = rs_use_green(priv, conf);
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
 	lq_sta->active_rate_basic = priv->active_rate_basic;
-- 
1.5.4.3

