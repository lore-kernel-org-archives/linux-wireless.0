Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYIKBRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 21:17:41 -0400
Subject: [PATCH 24/18] iwlwifi: don't access mac80211's AMPDU state machine
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 03:17:05 +0200
Message-Id: <1221095826.3804.78.camel@johannes.berg> (sfid-20080911_031750_429314_DCF71519)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There really is no need, at worst ieee80211_start_tx_ba_session
will log a message when debugging is enabled, and poking such
internals of mac80211 definitely doesn't belong into an RC
algorithm.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 03:12:48.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 03:12:58.000000000 +0200
@@ -359,15 +359,9 @@ static void rs_tl_turn_on_agg_for_tid(st
 				      struct iwl_lq_sta *lq_data, u8 tid,
 				      struct sta_info *sta)
 {
-	unsigned long state;
 	DECLARE_MAC_BUF(mac);
 
-	spin_lock_bh(&sta->lock);
-	state = sta->ampdu_mlme.tid_state_tx[tid];
-	spin_unlock_bh(&sta->lock);
-
-	if (state == HT_AGG_STATE_IDLE &&
-	    rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
+	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT("Starting Tx agg: STA: %s tid: %d\n",
 				print_mac(mac, sta->sta.addr), tid);
 		ieee80211_start_tx_ba_session(priv->hw, sta->sta.addr, tid);


