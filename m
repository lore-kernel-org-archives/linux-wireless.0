Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0EZN1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 09:27:19 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274878391.3658.9.camel@jlt3.sipsolutions.net>
	 <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 15:27:14 +0200
Message-ID: <1274880434.3658.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 16:13 +0300, Juuso Oikarinen wrote:

> > > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> > > index b2cc1fd..0b8360c 100644
> > > --- a/net/mac80211/ibss.c
> > > +++ b/net/mac80211/ibss.c
> > > @@ -529,7 +529,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
> > >  		sdata->drop_unencrypted = 0;
> > >  
> > >  	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
> > > -				  ifibss->channel, 3, /* first two are basic */
> > > +				  ifibss->channel,
> > > +				  15, /* 1, 2, 5.5 and 11 are basic */
> > 
> > It's still wrong for 5 GHz.
> 
> Yes, it is as wrong for 5GHz as it was before the change.

No it wasn't wrong before the change, and only the comment is now
wrong ...

before the change, 6 and 9 mbps were basic for 5ghz, now it would be
5,9,12 and 18. Neither set actually overlaps with the mandatory rates,
which is a bug I guess?

> > We've had this discussion before. Making more rates required will break
> > compatibility with 11b devices.
> 
> I don't understand this. AFAIK also in 11b all these rates are
> mandatory. How come this breaks 11b?

No, only 1mbit is really mandatory in 11b. So I guess our default should
be just "1" rather than "3" or something like that.

> This change is for creating IBSS, not joining. In case of joining, we
> still adhere to the basic rates set by the creator, or that is what I
> understand based on the code.
> 
> > What should be done here is add a basic rates parameter to the IBSS join
> > nl80211 command so that you can decide at runtime which rates to use as
> > basic.
> 
> Yeah, this is a solution needed latest when 5GHz support is implemented.

Well this hopefully doesn't come as a surprise to you, but mac80211 does
support 5 GHz operation :)

johannes

