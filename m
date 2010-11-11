Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56857 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469Ab0KKOHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:07:36 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: add support for setting the ad-hoc multicast rate
Date: Thu, 11 Nov 2010 15:07:23 +0100
Message-Id: <1289484443-96326-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
References: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h |    6 ++++--
 net/mac80211/ibss.c    |    1 +
 net/mac80211/rate.c    |   19 +++++++++++++++----
 net/mac80211/tx.c      |    5 +++--
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..e4d173e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -205,6 +205,7 @@ enum ieee80211_bss_change {
  * @basic_rates: bitmap of basic rates, each bit stands for an
  *	index into the rate table configured by the driver in
  *	the current band.
+ * @mcast_rate: multicast rate for AP and Ad-Hoc (in 100 kbps)
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
  * @channel_type: Channel type for this BSS -- the hardware might be
@@ -244,6 +245,7 @@ struct ieee80211_bss_conf {
 	u16 assoc_capability;
 	u64 timestamp;
 	u32 basic_rates;
+	u32 mcast_rate;
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
@@ -2640,7 +2642,7 @@ enum rate_control_changed {
  * @rate_idx_mask: user-requested rate mask (not MCS for now)
  * @skb: the skb that will be transmitted, the control information in it needs
  *	to be filled in
- * @ap: whether this frame is sent out in AP mode
+ * @bss: whether this frame is sent out in AP or IBSS mode
  */
 struct ieee80211_tx_rate_control {
 	struct ieee80211_hw *hw;
@@ -2651,7 +2653,7 @@ struct ieee80211_tx_rate_control {
 	bool rts, short_preamble;
 	u8 max_rate_idx;
 	u32 rate_idx_mask;
-	bool ap;
+	bool bss;
 };
 
 struct rate_control_ops {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 239c483..6fe6837 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -915,6 +915,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+	sdata->vif.bss_conf.mcast_rate = params->mcast_rate;
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 33f7699..76de4f8 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -211,10 +211,20 @@ static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 	return (info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc);
 }
 
-static void rc_send_low_broadcast(s8 *idx, u32 basic_rates, u8 max_rate_idx)
+static void rc_send_low_broadcast(s8 *idx, u32 basic_rates, u32 mcast_rate,
+				  struct ieee80211_supported_band *sband)
 {
 	u8 i;
 
+	if (mcast_rate) {
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == mcast_rate) {
+				*idx = i;
+				return;
+			}
+		}
+	}
+
 	if (basic_rates == 0)
 		return; /* assume basic rates unknown and accept rate */
 	if (*idx < 0)
@@ -222,7 +232,7 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates, u8 max_rate_idx)
 	if (basic_rates & (1 << *idx))
 		return; /* selected rate is a basic rate */
 
-	for (i = *idx + 1; i <= max_rate_idx; i++) {
+	for (i = *idx + 1; i <= sband->n_bitrates; i++) {
 		if (basic_rates & (1 << i)) {
 			*idx = i;
 			return;
@@ -243,10 +253,11 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 		info->control.rates[0].count =
 			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 			1 : txrc->hw->max_rate_tries;
-		if (!sta && txrc->ap)
+		if (!sta && txrc->bss)
 			rc_send_low_broadcast(&info->control.rates[0].idx,
 					      txrc->bss_conf->basic_rates,
-					      txrc->sband->n_bitrates);
+					      txrc->bss_conf->mcast_rate,
+					      txrc->sband);
 		return true;
 	}
 	return false;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 96c5943..87ba4ef 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -622,7 +622,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
-	txrc.ap = tx->sdata->vif.type == NL80211_IFTYPE_AP;
+	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
+		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
 
 	/* set up RTS protection if desired */
 	if (len > tx->local->hw.wiphy->rts_threshold) {
@@ -2301,7 +2302,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
-	txrc.ap = true;
+	txrc.bss = true;
 	rate_control_get_rate(sdata, NULL, &txrc);
 
 	info->control.vif = vif;
-- 
1.7.2.2

