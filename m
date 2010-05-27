Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31964 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0E0Esf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 00:48:35 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274880434.3658.14.camel@jlt3.sipsolutions.net>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274878391.3658.9.camel@jlt3.sipsolutions.net>
	 <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
	 <1274880434.3658.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 07:50:05 +0300
Message-ID: <1274935805.5277.2859.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 15:27 +0200, ext Johannes Berg wrote:
> On Wed, 2010-05-26 at 16:13 +0300, Juuso Oikarinen wrote:
> 
> > > > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> > > > index b2cc1fd..0b8360c 100644
> > > > --- a/net/mac80211/ibss.c
> > > > +++ b/net/mac80211/ibss.c
> > > > @@ -529,7 +529,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
> > > >  		sdata->drop_unencrypted = 0;
> > > >  
> > > >  	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
> > > > -				  ifibss->channel, 3, /* first two are basic */
> > > > +				  ifibss->channel,
> > > > +				  15, /* 1, 2, 5.5 and 11 are basic */
> > > 
> > > It's still wrong for 5 GHz.
> > 
> > Yes, it is as wrong for 5GHz as it was before the change.
> 
> No it wasn't wrong before the change, and only the comment is now
> wrong ...
> 
> before the change, 6 and 9 mbps were basic for 5ghz, now it would be
> 5,9,12 and 18. Neither set actually overlaps with the mandatory rates,
> which is a bug I guess?

Ah, now I get it. So the rate bitmap changes - I had a confusion here.

> > > We've had this discussion before. Making more rates required will break
> > > compatibility with 11b devices.
> > 
> > I don't understand this. AFAIK also in 11b all these rates are
> > mandatory. How come this breaks 11b?
> 
> No, only 1mbit is really mandatory in 11b. So I guess our default should
> be just "1" rather than "3" or something like that.

That's weird. At least in certification PoV, AFAIK, a device would not
pass with just 1mbit even for 11b.

> > This change is for creating IBSS, not joining. In case of joining, we
> > still adhere to the basic rates set by the creator, or that is what I
> > understand based on the code.
> > 
> > > What should be done here is add a basic rates parameter to the IBSS join
> > > nl80211 command so that you can decide at runtime which rates to use as
> > > basic.
> > 
> > Yeah, this is a solution needed latest when 5GHz support is implemented.
> 
> Well this hopefully doesn't come as a surprise to you, but mac80211 does
> support 5 GHz operation :)

Yeah, I know there is support (even the wl1271 has preliminary) but
there are also some issues ;)

So it seems to me that if we want this fixed, we would have to go with
an interface update?

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


