Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52942 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754081AbdCFWIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:08:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: remove ieee80211_tx_rate_control.max_rate_idx
Date: Mon,  6 Mar 2017 23:07:13 +0100
Message-Id: <20170306220713.14499-3-johannes@sipsolutions.net> (sfid-20170306_230817_062648_EEF6C079)
In-Reply-To: <20170306220713.14499-1-johannes@sipsolutions.net>
References: <20170306220713.14499-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As promised a little more than 7 years ago, remove it now
since nothing uses it anymore.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 4 ----
 net/mac80211/tx.c      | 8 --------
 2 files changed, 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1a26a375feb8..b1ac872dc88a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5444,9 +5444,6 @@ void ieee80211_stop_rx_ba_session_offl(struct ieee80211_vif *vif,
  *	RTS threshold
  * @short_preamble: whether mac80211 will request short-preamble transmission
  *	if the selected rate supports it
- * @max_rate_idx: user-requested maximum (legacy) rate
- *	(deprecated; this will be removed once drivers get updated to use
- *	rate_idx_mask)
  * @rate_idx_mask: user-requested (legacy) rate mask
  * @rate_idx_mcs_mask: user-requested MCS rate mask (NULL if not in use)
  * @bss: whether this frame is sent out in AP or IBSS mode
@@ -5458,7 +5455,6 @@ struct ieee80211_tx_rate_control {
 	struct sk_buff *skb;
 	struct ieee80211_tx_rate reported_rate;
 	bool rts, short_preamble;
-	u8 max_rate_idx;
 	u32 rate_idx_mask;
 	u8 *rate_idx_mcs_mask;
 	bool bss;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ba8d7db0a071..f27719eeeed7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -682,10 +682,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[info->band];
-	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
-		txrc.max_rate_idx = -1;
-	else
-		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
 
 	if (tx->sdata->rc_has_mcs_mask[info->band])
 		txrc.rate_idx_mcs_mask =
@@ -4249,10 +4245,6 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 	txrc.skb = skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = sdata->rc_rateidx_mask[band];
-	if (txrc.rate_idx_mask == (1 << txrc.sband->n_bitrates) - 1)
-		txrc.max_rate_idx = -1;
-	else
-		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
 	txrc.bss = true;
 	rate_control_get_rate(sdata, NULL, &txrc);
 
-- 
2.11.0
