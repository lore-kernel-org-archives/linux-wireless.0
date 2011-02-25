Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1BYL0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 06:26:53 -0500
Message-Id: <20110225112620.515442527@sipsolutions.net>
Date: Fri, 25 Feb 2011 12:24:11 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Swati Rallapalli <swati@cs.utexas.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: fix iwlagn_check_needed_chains
References: <20110225112409.977212647@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function was intended to calculate the
number of RX chains needed, but could only
work where the AP's streams were asymmetric,
i.e. 2 TX and 3 RX or similar. In the case
where IEEE80211_HT_MCS_TX_RX_DIFF was not
set, this function would calculate the wrong
information.

Additionally, mac80211 didn't pass through
the required values at all, so it couldn't
work anyway.

Rewrite the logic in this function and add
appropriate comments to make it readable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   58 +++++++++++++++++++---------
 1 file changed, 41 insertions(+), 17 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c	2011-02-25 11:03:37.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c	2011-02-25 12:21:18.000000000 +0100
@@ -471,6 +471,7 @@ static void iwlagn_check_needed_chains(s
 	struct iwl_rxon_context *tmp;
 	struct ieee80211_sta *sta;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	struct ieee80211_sta_ht_cap *ht_cap;
 	bool need_multiple;
 
 	lockdep_assert_held(&priv->mutex);
@@ -479,23 +480,7 @@ static void iwlagn_check_needed_chains(s
 	case NL80211_IFTYPE_STATION:
 		rcu_read_lock();
 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
-		if (sta) {
-			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-			int maxstreams;
-
-			maxstreams = (ht_cap->mcs.tx_params &
-				      IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
-					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
-			maxstreams += 1;
-
-			need_multiple = true;
-
-			if ((ht_cap->mcs.rx_mask[1] == 0) &&
-			    (ht_cap->mcs.rx_mask[2] == 0))
-				need_multiple = false;
-			if (maxstreams <= 1)
-				need_multiple = false;
-		} else {
+		if (!sta) {
 			/*
 			 * If at all, this can only happen through a race
 			 * when the AP disconnects us while we're still
@@ -503,7 +488,46 @@ static void iwlagn_check_needed_chains(s
 			 * will soon tell us about that.
 			 */
 			need_multiple = false;
+			rcu_read_unlock();
+			break;
+		}
+
+		ht_cap = &sta->ht_cap;
+
+		need_multiple = true;
+
+		/*
+		 * If the peer advertises no support for receiving 2 and 3
+		 * stream MCS rates, it can't be transmitting them either.
+		 */
+		if (ht_cap->mcs.rx_mask[1] == 0 &&
+		    ht_cap->mcs.rx_mask[2] == 0) {
+			need_multiple = false;
+		} else if (!(ht_cap->mcs.tx_params &
+						IEEE80211_HT_MCS_TX_DEFINED)) {
+			/* If it can't TX MCS at all ... */
+			need_multiple = false;
+		} else if (ht_cap->mcs.tx_params &
+						IEEE80211_HT_MCS_TX_RX_DIFF) {
+			int maxstreams;
+
+			/*
+			 * But if it can receive them, it might still not
+			 * be able to transmit them, which is what we need
+			 * to check here -- so check the number of streams
+			 * it advertises for TX (if different from RX).
+			 */
+
+			maxstreams = (ht_cap->mcs.tx_params &
+				 IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK);
+			maxstreams >>=
+				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
+			maxstreams += 1;
+
+			if (maxstreams <= 1)
+				need_multiple = false;
 		}
+
 		rcu_read_unlock();
 		break;
 	case NL80211_IFTYPE_ADHOC:


