Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37365 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0EZMlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 08:41:16 -0400
Subject: Re: [PATCH] mac80211: Fix basic rates for created IBSS networks
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274877298.3658.6.camel@jlt3.sipsolutions.net>
References: <1274877272-22487-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274877298.3658.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 15:42:32 +0300
Message-ID: <1274877752.5277.1878.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 14:34 +0200, ext Johannes Berg wrote:
> On Wed, 2010-05-26 at 15:34 +0300, Juuso Oikarinen wrote:
> > Currently the mac80211 marks rates 1 and 2 mbps as basic rates for created
> > ad-hoc networks. To be certifiable, rates 1, 2, 5.5 and 12 need to be marked
> > basic.
> > 
> > Change this.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  net/mac80211/ibss.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> > index b2cc1fd..448cf57 100644
> > --- a/net/mac80211/ibss.c
> > +++ b/net/mac80211/ibss.c
> > @@ -529,7 +529,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
> >  		sdata->drop_unencrypted = 0;
> >  
> >  	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
> > -				  ifibss->channel, 3, /* first two are basic */
> > +				  ifibss->channel,
> > +				  15, /* 1, 2, 5.5 and 12 are basic */
> 
> 12?
> 
> In any case, this is incorrect in 5 GHz (at least the comment is).

Damn! The comment has a typo!

I must have a serious brain leak.

-Juuso

> johannes
> 


