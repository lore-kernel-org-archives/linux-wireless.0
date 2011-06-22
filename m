Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVO1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 10:27:02 -0400
Subject: [PATCH] mac80211: use configured rates for assoc request
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 16:26:57 +0200
Message-ID: <1308752817.29571.13.camel@jlt3.sipsolutions.net> (sfid-20110622_162707_029166_FBF40142)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When mac80211 connects to an AP, it will advertise
all rates that it supports, but only the subset that
the AP also supports. Userspace can, however, ask
that only a subset of rates be used, so advertise
only that subset. The rates that the user asked for
must all be supported by the hardware, and the set
that we advertise to the AP will also be restricted
to rates the the AP also supports.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/work.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/net/mac80211/work.c	2011-06-22 15:51:39.000000000 +0200
+++ b/net/mac80211/work.c	2011-06-22 16:19:35.000000000 +0200
@@ -70,25 +70,25 @@ void free_work(struct ieee80211_work *wk
 	kfree_rcu(wk, rcu_head);
 }
 
-static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
+static u32 ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 				      struct ieee80211_supported_band *sband,
-				      u32 *rates)
+				      u32 rate_mask)
 {
-	int i, j, count;
-	*rates = 0;
-	count = 0;
+	unsigned long rates = rate_mask;
+	u32 result = 0;
+	int i, j;
+
 	for (i = 0; i < supp_rates_len; i++) {
 		int rate = (supp_rates[i] & 0x7F) * 5;
 
-		for (j = 0; j < sband->n_bitrates; j++)
+		for_each_set_bit(j, &rates, BITS_PER_LONG)
 			if (sband->bitrates[j].bitrate == rate) {
-				*rates |= BIT(j);
-				count++;
+				result |= BIT(j);
 				break;
 			}
 	}
 
-	return count;
+	return result;
 }
 
 /* frame sending functions */
@@ -194,10 +194,17 @@ static void ieee80211_send_assoc(struct
 	int i, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
-	u32 rates = 0;
+	u32 rates, rate_mask;
 
 	sband = local->hw.wiphy->bands[wk->chan->band];
 
+	/*
+	 * Userspace may restrict the locally supported rates
+	 * by setting up this; the default will be all rates
+	 * that the HW supports.
+	 */
+	rate_mask = sdata->rc_rateidx_mask[wk->chan->band];
+
 	if (wk->assoc.supp_rates_len) {
 		/*
 		 * Get all rates supported by the device and the AP as
@@ -205,19 +212,20 @@ static void ieee80211_send_assoc(struct
 		 * in the association request (e.g. D-Link DAP 1353 in
 		 * b-only mode)...
 		 */
-		rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
-						       wk->assoc.supp_rates_len,
-						       sband, &rates);
+		rates = ieee80211_compatible_rates(wk->assoc.supp_rates,
+						   wk->assoc.supp_rates_len,
+						   sband, rate_mask);
 	} else {
 		/*
 		 * In case AP not provide any supported rates information
 		 * before association, we send information element(s) with
 		 * all rates that we support.
 		 */
-		rates = ~0;
-		rates_len = sband->n_bitrates;
+		rates = rate_mask;
 	}
 
+	rates_len = hweight32(rates);
+
 	skb = alloc_skb(local->hw.extra_tx_headroom +
 			sizeof(*mgmt) + /* bit too much but doesn't matter */
 			2 + wk->assoc.ssid_len + /* SSID */


