Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab3DOMsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 08:48:01 -0400
Message-ID: <1366030075.8361.16.camel@jlt4.sipsolutions.net> (sfid-20130415_144806_490247_2D2A410E)
Subject: Re: vht off-by-one nss
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 15 Apr 2013 14:47:55 +0200
In-Reply-To: <20130415123358.GA13843@magnum.frso.rivierawaves.com> (sfid-20130415_143825_436346_0083300D)
References: <20130415100909.GA29924@magnum.frso.rivierawaves.com>
	 <1366021975.8361.10.camel@jlt4.sipsolutions.net>
	 <20130415123358.GA13843@magnum.frso.rivierawaves.com>
	 (sfid-20130415_143825_436346_0083300D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 14:33 +0200, Karl Beldan wrote:

> > > +++ b/net/mac80211/cfg.c
> > > @@ -389,7 +389,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
> > >  	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
> > >  		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
> > >  		rinfo->mcs = ieee80211_rate_get_vht_mcs(rate);
> > > -		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
> > > +		rinfo->nss = ieee80211_rate_get_vht_nss(rate) + 1;
> > >  	} else {
> > >  		struct ieee80211_supported_band *sband;
> > >  		sband = sta->local->hw.wiphy->bands[
> > > }
> > 
> > 
> > Wouldn't this one also require an update for VHT radiotap in
> > net/mac80211/rx.c around line 320 (RX_FLAG_VHT)?
> > 
> The radiotap field is set with ieee80211_rx_status.vht_nss, so no need.

And that's properly 1-based, rather than 0-based like in TX info? I
guess I forgot all of this already, heh.

johannes

