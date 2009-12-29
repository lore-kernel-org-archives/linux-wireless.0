Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59176 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbZL2K7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 05:59:30 -0500
Date: Tue, 29 Dec 2009 12:59:19 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/3] mac80211: Select lowest rate based on basic rate set
 in AP mode
Message-ID: <20091229105919.GB18493@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the basic rate set is configured to not include the lowest rate
(e.g., basic rate set = 6, 12, 24 Mbps in IEEE 802.11g mode), the AP
should not send out broadcast frames at 1 Mbps. This type of
configuration can be used to optimize channel usage in cases where
there is no need for backwards compatibility with IEEE 802.11b-only
devices.

In AP mode, mac80211 was unconditionally using the lowest rate for
Beacon frames and similarly, with all rate control algorithms that use
rate_control_send_low(), the lowest rate ended up being used for all
broadcast frames (and all unicast frames that are sent before
association). Change this to take into account the basic rate
configuration in AP mode, i.e., use the lowest rate in the basic rate
set instead of the lowest supported rate when selecting the rate.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/net/mac80211.h |    2 ++
 net/mac80211/rate.c    |   25 +++++++++++++++++++++++++
 net/mac80211/tx.c      |   24 +++++++++++++-----------
 3 files changed, 40 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/mac80211/rate.c	2009-12-29 10:49:34.000000000 +0200
+++ wireless-testing/net/mac80211/rate.c	2009-12-29 10:53:59.000000000 +0200
@@ -207,6 +207,27 @@ static bool rc_no_data_or_no_ack(struct 
 	return ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc));
 }
 
+static void rc_send_low_broadcast(s8 *idx, u32 basic_rates, u8 max_rate_idx)
+{
+	u8 i;
+
+	if (basic_rates == 0)
+		return; /* assume basic rates unknown and accept rate */
+	if (*idx < 0)
+		return;
+	if (basic_rates & (1 << *idx))
+		return; /* selected rate is a basic rate */
+
+	for (i = *idx + 1; i <= max_rate_idx; i++) {
+		if (basic_rates & (1 << i)) {
+			*idx = i;
+			return;
+		}
+	}
+
+	/* could not find a basic rate; use original selection */
+}
+
 bool rate_control_send_low(struct ieee80211_sta *sta,
 			   void *priv_sta,
 			   struct ieee80211_tx_rate_control *txrc)
@@ -218,6 +239,10 @@ bool rate_control_send_low(struct ieee80
 		info->control.rates[0].count =
 			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 			1 : txrc->hw->max_rate_tries;
+		if (!sta && txrc->ap)
+			rc_send_low_broadcast(&info->control.rates[0].idx,
+					      txrc->bss_conf->basic_rates,
+					      txrc->sband->n_bitrates);
 		return true;
 	}
 	return false;
--- wireless-testing.orig/net/mac80211/tx.c	2009-12-29 10:50:57.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-12-29 10:53:59.000000000 +0200
@@ -520,6 +520,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
 	txrc.max_rate_idx = tx->sdata->max_ratectrl_rateidx;
+	txrc.ap = tx->sdata->vif.type == NL80211_IFTYPE_AP;
 
 	/* set up RTS protection if desired */
 	if (len > tx->local->hw.wiphy->rts_threshold) {
@@ -2060,6 +2061,7 @@ struct sk_buff *ieee80211_beacon_get_tim
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band = local->hw.conf.channel->band;
+	struct ieee80211_tx_rate_control txrc;
 
 	sband = local->hw.wiphy->bands[band];
 
@@ -2167,21 +2169,21 @@ struct sk_buff *ieee80211_beacon_get_tim
 	info = IEEE80211_SKB_CB(skb);
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	info->band = band;
-	/*
-	 * XXX: For now, always use the lowest rate
-	 */
-	info->control.rates[0].idx = 0;
-	info->control.rates[0].count = 1;
-	info->control.rates[1].idx = -1;
-	info->control.rates[2].idx = -1;
-	info->control.rates[3].idx = -1;
-	info->control.rates[4].idx = -1;
-	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES != 5);
+
+	memset(&txrc, 0, sizeof(txrc));
+	txrc.hw = hw;
+	txrc.sband = sband;
+	txrc.bss_conf = &sdata->vif.bss_conf;
+	txrc.skb = skb;
+	txrc.reported_rate.idx = -1;
+	txrc.max_rate_idx = sdata->max_ratectrl_rateidx;
+	txrc.ap = true;
+	rate_control_get_rate(sdata, NULL, &txrc);
 
 	info->control.vif = vif;
 
-	info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
  out:
--- wireless-testing.orig/include/net/mac80211.h	2009-12-29 10:50:57.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-12-29 10:53:59.000000000 +0200
@@ -2294,6 +2294,7 @@ enum rate_control_changed {
  * @max_rate_idx: user-requested maximum rate (not MCS for now)
  * @skb: the skb that will be transmitted, the control information in it needs
  *	to be filled in
+ * @ap: whether this frame is sent out in AP mode
  */
 struct ieee80211_tx_rate_control {
 	struct ieee80211_hw *hw;
@@ -2303,6 +2304,7 @@ struct ieee80211_tx_rate_control {
 	struct ieee80211_tx_rate reported_rate;
 	bool rts, short_preamble;
 	u8 max_rate_idx;
+	bool ap;
 };
 
 struct rate_control_ops {

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
