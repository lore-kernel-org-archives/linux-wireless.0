Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33587 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3DOM5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 08:57:42 -0400
Received: by mail-wg0-f41.google.com with SMTP id e11so101161wgh.4
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 05:57:40 -0700 (PDT)
Date: Mon, 15 Apr 2013 14:53:25 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: vht off-by-one nss
Message-ID: <20130415125325.GB13843@magnum.frso.rivierawaves.com> (sfid-20130415_145745_731197_CFC875EE)
References: <20130415100909.GA29924@magnum.frso.rivierawaves.com>
 <1366021975.8361.10.camel@jlt4.sipsolutions.net>
 <20130415123358.GA13843@magnum.frso.rivierawaves.com>
 <1366030075.8361.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366030075.8361.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 02:47:55PM +0200, Johannes Berg wrote:
> On Mon, 2013-04-15 at 14:33 +0200, Karl Beldan wrote:
> 
> > > > +++ b/net/mac80211/cfg.c
> > > > @@ -389,7 +389,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
> > > >  	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
> > > >  		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
> > > >  		rinfo->mcs = ieee80211_rate_get_vht_mcs(rate);
> > > > -		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
> > > > +		rinfo->nss = ieee80211_rate_get_vht_nss(rate) + 1;
> > > >  	} else {
> > > >  		struct ieee80211_supported_band *sband;
> > > >  		sband = sta->local->hw.wiphy->bands[
> > > > }
> > > 
> > > 
> > > Wouldn't this one also require an update for VHT radiotap in
> > > net/mac80211/rx.c around line 320 (RX_FLAG_VHT)?
> > > 
> > The radiotap field is set with ieee80211_rx_status.vht_nss, so no need.
> 
> And that's properly 1-based, rather than 0-based like in TX info? I
> guess I forgot all of this already, heh.
> 
ieee80211_rx_status.vht_nss asks for a 1-based field but it is set by
drivers .. and since no driver report any (yet) .. anyways, I'll send a
patch along with it for mac80211_hwsim .. that can serve as a reminder ;).

 
Karl
