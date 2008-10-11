Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYJKNQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:16:22 -0400
Subject: Re: [RFT] mac80211/drivers: rewrite the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1223682964.29811.13.camel@johannes.berg> (sfid-20081011_015617_239108_FC7ED5DA)
References: <1223682964.29811.13.camel@johannes.berg>
	 (sfid-20081011_015617_239108_FC7ED5DA)
Content-Type: text/plain
Date: Sat, 11 Oct 2008 15:16:14 +0200
Message-Id: <1223730974.29811.39.camel@johannes.berg> (sfid-20081011_151628_164456_09760CFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-10-11 at 01:56 +0200, Johannes Berg wrote:
> So after the previous changes we were still unhappy with how
> convoluted the API is and decided to make things simpler for
> everybody. This completely changes the rate control API, now
> taking into account 802.11n with MCS rates and more control,
> most drivers don't support that though.

This was missing the RTS/CTS rate setting, which this patch adds, I'll
fold that in later, comments?

--- everything.orig/net/mac80211/tx.c	2008-10-11 15:01:51.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-10-11 15:14:53.000000000 +0200
@@ -507,6 +507,33 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		return TX_CONTINUE;
 	}
 
+	/*
+	 * set up the RTS/CTS rate as the fastest basic rate
+	 * that is not faster than the data rate
+	 *
+	 * XXX: Should this check all retry rates?
+	 */
+	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+		s8 baserate = 0;
+
+		rate = &sband->bitrates[info->control.rates[0].idx];
+
+		for (i = 0; i < sband->n_bitrates; i++) {
+			/* must be a basic rate */
+			if (!(tx->sdata->vif.bss_conf.basic_rates & BIT(i)))
+				continue;
+			/* must not be faster than the data rate */
+			if (sband->bitrates[i].bitrate > rate->bitrate)
+				continue;
+			/* maximum */
+			if (sband->bitrates[baserate].bitrate <
+			     sband->bitrates[i].bitrate)
+				baserate = i;
+		}
+
+		info->control.rts_cts_rate_idx = baserate;
+	}
+
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		/*
 		 * make sure there's no valid rate following
@@ -532,11 +559,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		}
 
 		/* set up RTS protection if desired */
-		if (rts) {
+		if (rts)
 			info->control.rates[i].flags |=
 				IEEE80211_TX_RC_USE_RTS_CTS;
-			rts = true;
-		}
 
 		/* RC is busted */
 		if (WARN_ON(info->control.rates[i].idx >=


