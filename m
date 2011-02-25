Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1BYL0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 06:26:53 -0500
Message-Id: <20110225112620.262596927@sipsolutions.net>
Date: Fri, 25 Feb 2011 12:24:10 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Swati Rallapalli <swati@cs.utexas.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] mac80211: copy peer MCS TX parameters
References: <20110225112409.977212647@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We need to copy this to allow drivers to look
at the information where needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ht.c	2011-02-25 11:07:00.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2011-02-25 12:20:22.000000000 +0100
@@ -66,6 +66,9 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 	/* own MCS TX capabilities */
 	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
 
+	/* Copy peer MCS TX capabilities, the driver might need them. */
+	ht_cap->mcs.tx_params = ht_cap_ie->mcs.tx_params;
+
 	/* can we TX with MCS rates? */
 	if (!(tx_mcs_set_cap & IEEE80211_HT_MCS_TX_DEFINED))
 		return;
@@ -79,7 +82,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 		max_tx_streams = IEEE80211_HT_MCS_TX_MAX_STREAMS;
 
 	/*
-	 * 802.11n D5.0 20.3.5 / 20.6 says:
+	 * 802.11n-2009 20.3.5 / 20.6 says:
 	 * - indices 0 to 7 and 32 are single spatial stream
 	 * - 8 to 31 are multiple spatial streams using equal modulation
 	 *   [8..15 for two streams, 16..23 for three and 24..31 for four]


