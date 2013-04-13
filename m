Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40918 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab3DMWDu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 18:03:50 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/5] mac80211: fix and optimize MCS mask handling
Date: Sun, 14 Apr 2013 00:03:42 +0200
Message-Id: <1365890626-86895-1-git-send-email-nbd@openwrt.org> (sfid-20130414_000402_432801_E78CA1D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the code always copies the configured MCS mask (even if it is
set to default), but only uses it if legacy rates were also masked out.
Fix this by adding a flag that tracks whether the configured MCS mask is
set to default or not.
Optimize the code further by storing a pointer to the configured rate
mask in txrc instead of using memcpy.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h     |  4 ++--
 net/mac80211/cfg.c         | 13 +++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/rate.c        |  9 ++++++---
 net/mac80211/tx.c          | 10 +++++-----
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 64faf01..96cb507 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4107,7 +4107,7 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
  *	(deprecated; this will be removed once drivers get updated to use
  *	rate_idx_mask)
  * @rate_idx_mask: user-requested (legacy) rate mask
- * @rate_idx_mcs_mask: user-requested MCS rate mask
+ * @rate_idx_mcs_mask: user-requested MCS rate mask (NULL if not in use)
  * @bss: whether this frame is sent out in AP or IBSS mode
  */
 struct ieee80211_tx_rate_control {
@@ -4119,7 +4119,7 @@ struct ieee80211_tx_rate_control {
 	bool rts, short_preamble;
 	u8 max_rate_idx;
 	u32 rate_idx_mask;
-	u8 rate_idx_mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
+	u8 *rate_idx_mcs_mask;
 	bool bss;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 764dd9a..1d8c66c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2416,9 +2416,22 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		struct ieee80211_supported_band *sband = wiphy->bands[i];
+		int j;
+
 		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
 		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].mcs,
 		       sizeof(mask->control[i].mcs));
+
+		sdata->rc_has_mcs_mask[i] = false;
+		if (!sband)
+			continue;
+
+		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++)
+			if (~sdata->rc_rateidx_mcs_mask[i][j]) {
+				sdata->rc_has_mcs_mask[i] = true;
+				break;
+			}
 	}
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 135ab46..4f4a40e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -740,6 +740,8 @@ struct ieee80211_sub_if_data {
 
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
+
+	bool rc_has_mcs_mask[IEEE80211_NUM_BANDS];
 	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
 	union {
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index dd88381..5d545dd 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -460,9 +460,12 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * the common case.
 	 */
 	mask = sdata->rc_rateidx_mask[info->band];
-	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
-	       sizeof(mcs_mask));
-	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
+	if (mask != (1 << txrc->sband->n_bitrates) - 1 || txrc->rate_idx_mcs_mask) {
+		if (txrc->rate_idx_mcs_mask)
+			memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
+		else
+			memset(mcs_mask, 0xff, sizeof(mcs_mask));
+
 		if (sta) {
 			/* Filter out rates that the STA does not support */
 			mask &= sta->sta.supp_rates[info->band];
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index aad0bf5..c3f3ff6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -642,9 +642,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
-	memcpy(txrc.rate_idx_mcs_mask,
-	       tx->sdata->rc_rateidx_mcs_mask[info->band],
-	       sizeof(txrc.rate_idx_mcs_mask));
+
+	if (tx->sdata->rc_has_mcs_mask[info->band])
+		txrc.rate_idx_mcs_mask =
+			tx->sdata->rc_rateidx_mcs_mask[info->band];
+
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
@@ -2502,8 +2504,6 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
-	memcpy(txrc.rate_idx_mcs_mask, sdata->rc_rateidx_mcs_mask[band],
-	       sizeof(txrc.rate_idx_mcs_mask));
 	txrc.bss = true;
 	rate_control_get_rate(sdata, NULL, &txrc);
 
-- 
1.8.0.2

