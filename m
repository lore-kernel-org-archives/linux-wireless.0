Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1A1Odz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 09:33:55 -0500
Subject: Re: Fwd: mac80211+iwlwifi bug with HT rates?
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTind_8HzraBGxyA90ymQ_e3uJV+iykMNKzekRLA9@mail.gmail.com>
References: <AANLkTi=w+EEdROx5NCBEe2fLv6RM-7fGSoNEpQ-tBZYo@mail.gmail.com>
	 <AANLkTind_8HzraBGxyA90ymQ_e3uJV+iykMNKzekRLA9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 15:33:43 +0100
Message-ID: <1296225223.5118.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan,

I apologise for the late reply.

> I'm trying to track down an anomaly with a 3-stream 802.11n AP.
> iwlwifi is saying that a single antenna should be sufficient even when
> the AP supports 3 streams.  Here's what I've tracked down:
> Code in iwl-agn-rxon.c uses the ht_cap TX MCS parameters to determine
> how many streams the other side supports:
> <http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-agn-rxon.c;h=d33e4db7e56cab88abc3281d04adf32162b8020e;hb=HEAD#l470>
> Yet, it looks like mac80211 doesn't actually set those variables at
> all!  In net/mac80211/ht.c, when converting the IE to the Station HT
> cap:
> <http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=net/mac80211/ht.c;h=75d679d75e63e92143d55a47601a1dfc1377ba03;hb=HEAD#l21>
> we first zero out the HT CAP (line 30) and then never actually set the
> ht_cap->mcs.tx_params variables at all.  Grep says that's the only use
> of mcs.tx_params in that directory, so I'm pretty confident mac80211
> just never does that.  Thus iwlwifi thinks it only needs to have 1 RX
> antenna enabled (though it defaults to a minimum of 2 when possible)
> and basically fails to receive 3 stream packets.
> Is this a bug in iwlwifi or mac80211?

Did you ever try to set it in mac80211, like say the below change? I
think that'd be the minimal fix that can be backported easily too.

johannes

--- wireless-testing.orig/net/mac80211/ht.c	2011-01-28 15:03:29.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2011-01-28 15:32:14.000000000 +0100
@@ -66,6 +66,14 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 	/* own MCS TX capabilities */
 	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
 
+	/*
+	 * peer MCS TX capabilities
+	 *
+	 * TODO: - restrict # of streams to our RX?
+	 *       - clear uneq modulation if we can't RX it?
+	 */
+	ht_cap->mcs.tx_params = ht_cap_ie->mcs.tx_params;
+
 	/* can we TX with MCS rates? */
 	if (!(tx_mcs_set_cap & IEEE80211_HT_MCS_TX_DEFINED))
 		return;
@@ -79,7 +87,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 		max_tx_streams = IEEE80211_HT_MCS_TX_MAX_STREAMS;
 
 	/*
-	 * 802.11n D5.0 20.3.5 / 20.6 says:
+	 * 802.11n-2009 20.3.5 / 20.6 says:
 	 * - indices 0 to 7 and 32 are single spatial stream
 	 * - 8 to 31 are multiple spatial streams using equal modulation
 	 *   [8..15 for two streams, 16..23 for three and 24..31 for four]


