Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2GZRmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 13:42:51 -0400
Message-ID: <1343324564.4477.5.camel@jlt3.sipsolutions.net> (sfid-20120726_194254_092775_37C700C6)
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jul 2012 19:42:44 +0200
In-Reply-To: <5010E413.9010502@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
	   ,<1343048772.4584.18.camel@jlt3.sipsolutions.net>
	    <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>
	   <1343120184.4415.16.camel@jlt3.sipsolutions.net>
	   <500E7D76.9010205@posedge.com>
	  <1343128638.4415.17.camel@jlt3.sipsolutions.net>
	  <500F6F94.3070400@posedge.com>
	 <1343209816.4463.28.camel@jlt3.sipsolutions.net>
	 <5010E413.9010502@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-26 at 12:00 +0530, Mahesh Palivela wrote:

> >> 11ac Draft3.0 section 22.3.14 says VHT channel is specified by
> >> dot11CurrentChannelBandwidth, dot11CurrentChannelCenterFrequencyIndex0,
> >> dot11CurrentChannelCenterFrequencyIndex1 and dot11CurrentPrimaryChannel
> >>
> >> primary channel comes from HT Op IE.
> >> chanBW, chanCenterFreq0, chanCenterFreq1 comes from VHT Op IE.
> >> So multiple secondary channels doesn't seem to be a valid?
> >
> > Hmm. But that means we have to specify the channel completely
> > differently? I think we should stick to our scheme of center freq of a
> > 20 MHz channel + surrounding bandwidth,
> 
> ok. Let's stick to old way of channel config. Basically freq value and 
> channel type which kind of specifies channel widths. so how about for 
> VHT channel types as below. Its similar to what you proposed.
> 
> For 80 MHz:
> 
> VHT80_3PLUS
> VHT80_MINUS_2PLUS
> VHT80_2MINUS_PLUS
> VHT80_3MINUS
> 
> For 160 MHz:
> 
> VHT160_7PLUS
> VHT160_MINUS_6PLUS
> VHT160_2MINUS_5PLUS
> VHT160_3MINUS_4PLUS
> VHT160_4MINUS_3PLUS
> VHT160_5MINUS_2PLUS
> VHT160_6MINUS_PLUS
> VHT160_7MINUS

Yeah, that would work. Lots of channel types ...

>  > though it obviously won't work for 80+80. The question will be where 
>  > we deviate from our previous scheme. I tend to think that HT80+80
>  > should deviate, I have a feeling it won't be implemented soon
>  > (or ever?) anyway.
>  >
> 
> Yea, even I feel the channel config representation what we are proposing 
> is not really extendable to discrete bands. That's my only worry...

? What do you mean?

> >> CHAN_NO_VHT80 is actually 2 bits. NO_VHT80MINUS & NO_VHT80PLUS.
> >> Is that ok?
> >>
> >> +	IEEE80211_CHAN_NO_VHT80PLUS	= 1<<6,
> >> +	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,
> >>
> >> +#define IEEE80211_CHAN_NO_VHT80 \
> >> +	(IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)
> >
> > Right. But did you mean to check that all of them are set? What if one
> > of them is set but the other isn't?
> >
> 
> If one of them is set, then we accept VHT80 for that channel.

Yes, but is that really correct?

johannes

