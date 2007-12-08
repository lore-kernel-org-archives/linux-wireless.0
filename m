Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42518 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750963AbXLHLph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:45:37 -0500
Subject: Re: [PATCH 1/4] mac80211: Clean up rate selection
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197113812.4171.53.camel@johannes.berg>
References: <1197112439.7472.34.camel@localhost>
	 <1197112909.7472.49.camel@localhost>
	 (sfid-20071208_112222_400278_02DE29F9)  <1197113375.4171.50.camel@johannes.berg>
	 <1197113615.7472.56.camel@localhost>
	 (sfid-20071208_113407_806694_1684F565)  <1197113812.4171.53.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:45:34 +0100
Message-Id: <1197114334.7472.66.camel@localhost> (sfid-20071208_114541_133281_6DEF4D59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-12-08 at 12:36 +0100, Johannes Berg wrote:
> On Sat, 2007-12-08 at 12:33 +0100, Mattias Nissler wrote:
> > On Sat, 2007-12-08 at 12:29 +0100, Johannes Berg wrote:
> > > > +	/* Send management frames and broadcast/multicast data using lowest
> > > > +	 * rate. */
> > > > +	fc = le16_to_cpu(hdr->frame_control);
> > > > +	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
> > > > +	    (hdr->addr1[0] & 0x01))
> > > > +		sel->rate = rate_lowest(local, mode, sta);
> > > 
> > > I'm not sure but I don't think we want this. And you should use
> > > is_multicast_addr() or whatever it's called.
> > 
> > This piece comes directly from the old "simple" algo. You're right about
> > is_multicast_addr. I agree this is something we might to get rid of, but
> > I leave that decision to you.
> 
> Right, but I guess that Intel's algorithms do something different and
> this would break it. IMHO that decision should stay in the algorithm
> itself.

Actually, I carefully check the iwlwifi code and it copies this exact
code. Finding it in there as well actually convinced me to move it out
of the rate control.

> 
> > Yes. It's after the get_rate() call so the algorithm can override it.
> > But if it doesn't we compute it ourselves.
> 
> Hmm. Then the algorithm can't specify "no fallback rate", can it? 

Correct. But why would you want that to be possible?

Mattias

