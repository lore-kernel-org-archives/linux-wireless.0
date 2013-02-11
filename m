Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab3BKObe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 09:31:34 -0500
Message-ID: <1360593088.8738.31.camel@jlt4.sipsolutions.net> (sfid-20130211_153137_874325_E0E4C347)
Subject: Re: [PATCH v2 3/3] mac80211/minstrel_ht: add support for using CCK
 rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 15:31:28 +0100
In-Reply-To: <5118FBC9.7000801@openwrt.org>
References: <1360589765-58642-1-git-send-email-nbd@openwrt.org>
	 <1360589765-58642-2-git-send-email-nbd@openwrt.org>
	 <1360589765-58642-3-git-send-email-nbd@openwrt.org>
	 <201302111457.28452.chunkeey@googlemail.com> <5118FBC9.7000801@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 15:10 +0100, Felix Fietkau wrote:
> On 2013-02-11 2:57 PM, Christian Lamparter wrote:
> > On Monday, February 11, 2013 02:36:05 PM Felix Fietkau wrote:
> >> When MCS rates start to get bad in 2.4 GHz because of long range or
> >> strong interference, CCK rates can be a lot more robust.
> >> 
> >> This patch adds a pseudo MCS group containing CCK rates (long preamble
> >> in the lower 4 slots, short preamble in the upper slots).
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> ---
> >>  static void
> >> +minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
> >> +		       struct ieee80211_supported_band *sband,
> >> +		       struct ieee80211_sta *sta)
> >> +{
> >> +	int i;
> >> +
> >> +	if (sband->band != IEEE80211_BAND_2GHZ)
> >> +		return;
> >> +
> >> +	mi->cck_supported = 0;
> >> +	mi->cck_supported_short = 0;
> >> +	for (i = 0; i < 4; i++) {
> >> +		if (!rate_supported(sta, sband->band, mp->cck_rates[i]))
> >> +			continue;
> > 
> > Don't we need to check if the receiver (and the minstrel_ht sender)
> > supports IEEE80211_HT_CAP_DSSSCCK40 when the phy is in HT40+/- mode?
> I don't think this should be handled in the rate control modules, when
> mac80211 can easily handle that through the supported rates set (which
> seems to be the intention behind this flag in the standard as well).

Patches welcome.  This corner of the spec doesn't seem to be implemented
at all :)

johannes

