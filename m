Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2GYJuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 05:50:22 -0400
Message-ID: <1343209816.4463.28.camel@jlt3.sipsolutions.net> (sfid-20120725_115026_162542_C3378C9B)
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 25 Jul 2012 11:50:16 +0200
In-Reply-To: <500F6F94.3070400@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
	  ,<1343048772.4584.18.camel@jlt3.sipsolutions.net>
	   <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>
	  <1343120184.4415.16.camel@jlt3.sipsolutions.net>
	  <500E7D76.9010205@posedge.com>
	 <1343128638.4415.17.camel@jlt3.sipsolutions.net>
	 <500F6F94.3070400@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 09:31 +0530, Mahesh Palivela wrote:

> >>> Ok so HT has primary channel and secondary, and VHT has secondary VHT
> >>> which can again be above/below? That would make sense, but you wouldn't
> >>> be covering it.
> >>>
> >>
> >> I am thinking no need of above/below convention as the center frequency
> >> value itself we know.
> >
> > But we don't use the center frequency of the overall Ht40/80/160
> > channel, we always use the center frequency of the control channel.
> >
> 
> 11ac Draft3.0 section 22.3.14 says VHT channel is specified by
> dot11CurrentChannelBandwidth, dot11CurrentChannelCenterFrequencyIndex0,
> dot11CurrentChannelCenterFrequencyIndex1 and dot11CurrentPrimaryChannel
> 
> primary channel comes from HT Op IE.
> chanBW, chanCenterFreq0, chanCenterFreq1 comes from VHT Op IE.
> So multiple secondary channels doesn't seem to be a valid?

Hmm. But that means we have to specify the channel completely
differently? I think we should stick to our scheme of center freq of a
20 MHz channel + surrounding bandwidth, though it obviously won't work
for 80+80. The question will be where we deviate from our previous
scheme. I tend to think that HT80+80 should deviate, I have a feeling it
won't be implemented soon (or ever?) anyway.

> > No, I mean all the bits that are part of CHAN_NO_VHT80.
> >
> 
> 
> CHAN_NO_VHT80 is actually 2 bits. NO_VHT80MINUS & NO_VHT80PLUS.
> Is that ok?
> 
> +	IEEE80211_CHAN_NO_VHT80PLUS	= 1<<6,
> +	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,
> 
> +#define IEEE80211_CHAN_NO_VHT80 \
> +	(IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)

Right. But did you mean to check that all of them are set? What if one
of them is set but the other isn't?

johannes

