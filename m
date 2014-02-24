Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:42509 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaBXIjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 03:39:25 -0500
Message-ID: <1393231159.18879.16.camel@porter.coelho.fi> (sfid-20140224_093935_535862_BF1CEDB9)
Subject: Re: [PATCH v3 5/7] cfg80211/mac80211: refactor
 cfg80211_chandef_dfs_required()
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Mon, 24 Feb 2014 10:39:19 +0200
In-Reply-To: <1392972028.4346.28.camel@jlt4.sipsolutions.net>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-6-git-send-email-luca@coelho.fi>
	 <1392972028.4346.28.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 09:40 +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> 
> > +	radar_required = !!(err);
> 
> That's going a bit overboard - you really need only ... = err; for bool
> variables :) 

There's nothing not right with using double-negation!! :P

I like to make it explicit that we're converting an integer to a boolean
and it happens in other parts of the code too.

Anyway, I have removed the double-negations for the next version.


> >  	int width;
> > -	int r;
> > +	int ret;
> >  
> >  	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> >  		return -EINVAL;
> >  
> > -	width = cfg80211_chandef_get_width(chandef);
> > -	if (width < 0)
> > -		return -EINVAL;
> > +	switch (iftype) {
> > +	case NL80211_IFTYPE_UNSPECIFIED:
> > +	case NL80211_IFTYPE_ADHOC:
> > +	case NL80211_IFTYPE_AP:
> > +	case NL80211_IFTYPE_P2P_GO:
> > +	case NL80211_IFTYPE_MESH_POINT:
> > +		width = cfg80211_chandef_get_width(chandef);
> > +		if (width < 0)
> > +			return -EINVAL;
> >  
> > -	r = cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
> > -					    width);
> > -	if (r)
> > -		return r;
> > +		ret = cfg80211_get_chans_dfs_required(wiphy,
> > +						      chandef->center_freq1,
> > +						      width);
> > +		if (ret < 0)
> > +			return ret;
> > +		else if (ret > 0)
> > +			return BIT(chandef->width);
> 
> What's with the width vs. chandef->width?

width is an integer; chandef->width is the enumeration.  This is how the
existing functions work.  Do you want me to change something?

--
Luca.

