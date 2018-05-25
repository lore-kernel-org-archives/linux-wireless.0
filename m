Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46222 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S967823AbeEYTwG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 15:52:06 -0400
Message-ID: <37100d5380fcea97bfc83b92d4e1d89dbf52d674.camel@coelho.fi> (sfid-20180525_215228_501819_159A2D77)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Date: Fri, 25 May 2018 22:51:59 +0300
In-Reply-To: <b1d344f5f5fa2797fa5b931f019bb7f3bd18b904.camel@coelho.fi>
References: <20180518140543.13620-1-luca@coelho.fi>
         <20180518140543.13620-2-luca@coelho.fi> <5B032249.2020900@broadcom.com>
         <b1d344f5f5fa2797fa5b931f019bb7f3bd18b904.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC 1/3] cfg80211: Add support for HE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

On Fri, 2018-05-25 at 13:11 +0300, Luca Coelho wrote:
> On Mon, 2018-05-21 at 21:47 +0200, Arend van Spriel wrote:
> > On 5/18/2018 4:05 PM, Luca Coelho wrote:
> > > @@ -781,6 +783,23 @@ int wiphy_register(struct wiphy *wiphy)
> > >   			sband->channels[i].band = band;
> > >   		}
> > > 
> > > +		for (i = 0; i < sband->n_iftype_data; i++) {
> > > +			const struct ieee80211_sband_iftype_data
> > > *iftd;
> > > +
> > > +			iftd = &sband->iftype_data[i];
> > > +
> > > +			if (WARN_ON(!iftd->types))
> > > +				return -EINVAL;
> > > +			if (WARN_ON(types & iftd->types))
> > > +				return -EINVAL;
> > 
> > I suspected the types mask was not allowed to overlap for the 
> > iftype_data entries, but may be worth documenting that in struct 
> > ieee80211_sband_iftype_data kerneldoc.
> 
> Sure, I'll add it.

Actually, looking into this again, I'm not sure I understand your
comment.  AFAICT this prevents the same type from appearing twice,
right? I don't get the "not allowed to overlap"... Can you clarify?

--
Cheers,
Luca.
