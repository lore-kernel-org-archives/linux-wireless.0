Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52843 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0DIJWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 05:22:04 -0400
Subject: Re: [PATCH] mac80211: Prevent dynamic ps for rx broadcast frames
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270804355.3870.16.camel@jlt3.sipsolutions.net>
References: <1270802794-6869-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1270804355.3870.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 12:17:45 +0300
Message-ID: <1270804665.10120.1152.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-09 at 11:12 +0200, ext Johannes Berg wrote:
> On Fri, 2010-04-09 at 11:46 +0300, Juuso Oikarinen wrote:
> > Currently the dynamic ps timer is restarted for all non-multicast rx data
> > frames. Congested networks have lots of broadcast traffic, which will cause
> > the power save to remain disabled for much of the time, which causes trouble
> > for battery-powered devices.
> > 
> > Fix this by preventing rx broadcast data frames from restarting the
> > dynamic ps timer.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  net/mac80211/rx.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index c0ad7e8..8cdcc4f 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -1786,6 +1786,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
> >  
> >  	if (ieee80211_is_data(hdr->frame_control) &&
> >  	    !is_multicast_ether_addr(hdr->addr1) &&
> > +	    !is_broadcast_ether_addr(hdr->addr1) &&
> >  	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
> 
> Huh? I'm starting to doubt my own sanity now!
> 
> Formal logic:
> 
>     (bcast => mcast)
> <=> (!mcast => !bcast)
> 
> Thus
> 
>     (!mcast && !bcast)
> <=> (!mcast)
> 
> right?

Heh, don't doubt your sanity. It's me who has lost his. 

You're obviously right. I don't even try to explain what I just thought.
Everyone, pretend you never saw this ;)

-Juuso

> johannes
> 


