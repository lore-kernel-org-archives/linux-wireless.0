Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41580 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3DOQcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 12:32:36 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so355391wgh.15
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 09:32:34 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: fix rate control tx handler for VHT rates
Date: Mon, 15 Apr 2013 18:28:21 +0200
Message-Id: <1366043301-6681-1-git-send-email-karl.beldan@gmail.com> (sfid-20130415_183241_816873_BA42B517)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Handle VHT rates like HT ones, otherwise we easily trigger the pre-HT
rates WARN_ON(rc_rate->idx >= sband->n_bitrates) which will set
rc_rate->idx to -1.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
I dared some reformatting to fit the WARN_ON for the VHT idx.

 net/mac80211/tx.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c93483f..cf522a2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -742,16 +742,17 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	}
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+		struct ieee80211_tx_rate *rc_rate = &info->control.rates[i];
 		/*
 		 * make sure there's no valid rate following
 		 * an invalid one, just in case drivers don't
 		 * take the API seriously to stop at -1.
 		 */
 		if (inval) {
-			info->control.rates[i].idx = -1;
+			rc_rate->idx = -1;
 			continue;
 		}
-		if (info->control.rates[i].idx < 0) {
+		if (rc_rate->idx < 0) {
 			inval = true;
 			continue;
 		}
@@ -760,36 +761,37 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		 * For now assume MCS is already set up correctly, this
 		 * needs to be fixed.
 		 */
-		if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS) {
-			WARN_ON(info->control.rates[i].idx > 76);
+		if (rc_rate->flags & IEEE80211_TX_RC_MCS) {
+			WARN_ON(rc_rate->idx > 76);
+			continue;
+		}
+
+		if (rc_rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+			WARN_ON(ieee80211_rate_get_vht_mcs(rc_rate) > 9);
 			continue;
 		}
 
 		/* set up RTS protection if desired */
 		if (rts)
-			info->control.rates[i].flags |=
-				IEEE80211_TX_RC_USE_RTS_CTS;
+			rc_rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 
 		/* RC is busted */
-		if (WARN_ON_ONCE(info->control.rates[i].idx >=
-				 sband->n_bitrates)) {
-			info->control.rates[i].idx = -1;
+		if (WARN_ON_ONCE(rc_rate->idx >= sband->n_bitrates)) {
+			rc_rate->idx = -1;
 			continue;
 		}
 
-		rate = &sband->bitrates[info->control.rates[i].idx];
+		rate = &sband->bitrates[rc_rate->idx];
 
 		/* set up short preamble */
 		if (short_preamble &&
 		    rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-			info->control.rates[i].flags |=
-				IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+			rc_rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
 
 		/* set up G protection */
 		if (!rts && tx->sdata->vif.bss_conf.use_cts_prot &&
 		    rate->flags & IEEE80211_RATE_ERP_G)
-			info->control.rates[i].flags |=
-				IEEE80211_TX_RC_USE_CTS_PROTECT;
+			rc_rate->flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
 	}
 
 	return TX_CONTINUE;
-- 
1.8.2

