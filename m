Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35778 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3DEKKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 06:10:10 -0400
Received: by mail-wg0-f44.google.com with SMTP id z12so3537045wgg.23
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 03:10:08 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates
Date: Fri,  5 Apr 2013 12:06:24 +0200
Message-Id: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com> (sfid-20130405_121014_778390_615D6AC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When the 1st rate control entry is a pre-HT rate we want to set
rts_cts_rate_idx "as the fastest basic rate that is not faster than the
data rate"(code comments).
But in case some bss allowed rate indexes are lower than the lowest bss
basic rate, if the rate control selects a rate among the formers for its
1st rate control entry, rts_cts_rate_idx remains 0 and is not a basic
rate index.
This commit sets rts_cts_rate_idx to the lowest bss basic rate index in
this situation.

Note that the code assumes that lowest indexes == lowest bitrates.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/tx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index aad0bf5..c93483f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -712,19 +712,22 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	}
 
 	/*
-	 * set up the RTS/CTS rate as the fastest basic rate
-	 * that is not faster than the data rate
+	 * Set up the RTS/CTS rate as the fastest basic rate
+	 * that is not faster than the data rate unless there
+	 * is no basic rate slower than the data rate, in which
+	 * case we pick the slowest basic rate
 	 *
 	 * XXX: Should this check all retry rates?
 	 */
 	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
-		s8 baserate = 0;
+		u32 basic_rates = tx->sdata->vif.bss_conf.basic_rates;
+		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
 
 		rate = &sband->bitrates[info->control.rates[0].idx];
 
 		for (i = 0; i < sband->n_bitrates; i++) {
 			/* must be a basic rate */
-			if (!(tx->sdata->vif.bss_conf.basic_rates & BIT(i)))
+			if (!(basic_rates & BIT(i)))
 				continue;
 			/* must not be faster than the data rate */
 			if (sband->bitrates[i].bitrate > rate->bitrate)
-- 
1.8.2

