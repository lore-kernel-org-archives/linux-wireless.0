Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab0L1Iig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:38:36 -0500
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for
 802.11j
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com
In-Reply-To: <201012281431.46536.br1@einfach.org>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
	 <1293447459.3544.1.camel@jlt3.sipsolutions.net>
	 <201012281431.46536.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 09:38:33 +0100
Message-ID: <1293525513.3526.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 14:31 +0900, Bruno Randolf wrote:

> > > -	if (freq == ieee80211_channel_to_frequency(12) ||
> > > -	    freq == ieee80211_channel_to_frequency(13) ||
> > > -	    freq == ieee80211_channel_to_frequency(14))
> > > +	if (freq == ieee80211_channel_to_frequency(12, IEEE80211_BAND_2GHZ) ||
> > > +	    freq == ieee80211_channel_to_frequency(13, IEEE80211_BAND_2GHZ) ||
> > > +	    freq == ieee80211_channel_to_frequency(14, IEEE80211_BAND_2GHZ))
> > > 
> > >  		return true;
> > 
> > This seems strange ... why not just hardcode the values??
> 
> True, but this is not my code, I just did the change for the new function 
> parameter. It's in net/wireless/reg.c, so I'll CC: Luis.

Right. It seems rather complicated though, especially with this change.


> Any other comments on the code or purpose of this patch?

Not really. I guess it seems fine. Do you know if there are ever any
starting values used other than 4900 and 5000?

johannes

