Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2KTIlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:41:00 -0500
Message-ID: <1353400890.9399.3.camel@jlt4.sipsolutions.net> (sfid-20121120_094103_819884_8535CF9F)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 Nov 2012 09:41:30 +0100
In-Reply-To: <50AB3EE1.8060101@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	 <50AB3EE1.8060101@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 13:57 +0530, Mahesh Palivela wrote:

> > +	for (freq = center_freq - bw/2 + 10;
> > +	     freq <= center_freq + bw/2 - 10;
> > +	     freq += 20) {
> > +		c = ieee80211_get_channel(wiphy, freq);
> > +		if (!c || c->flags & (IEEE80211_CHAN_DISABLED |
> > +				      IEEE80211_CHAN_PASSIVE_SCAN |
> > +				      IEEE80211_CHAN_NO_IBSS |
> > +				      IEEE80211_CHAN_RADAR))
> > +			return false;


> > +	for (freq = center_freq - bw/2 + 10;
> > +	     freq <= center_freq + bw/2 - 10;
> > +	     freq += 20) {
> > +		c = ieee80211_get_channel(&rdev->wiphy, freq);
> > +		if (!c || c->flags & IEEE80211_CHAN_DISABLED)
> > +			return -EINVAL;


> For loops in both functions seems to be similar. One return false, other 
> return -EINVAL. Can we remove duplication?

True, but they check different flags. I suppose we could have a common
function where the checked flags are passed in, I can try that.

johannes

