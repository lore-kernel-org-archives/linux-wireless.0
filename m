Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2GXI4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 04:56:33 -0400
Message-ID: <1343120184.4415.16.camel@jlt3.sipsolutions.net> (sfid-20120724_105637_552793_5A489D76)
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jul 2012 10:56:24 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
	,<1343048772.4584.18.camel@jlt3.sipsolutions.net>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It would be really good if you could convince your email client to put >
in front of each quoted line ... this is really confusing as is.

> Also, I believe there are many more possibilities, since we count from
> the control channel -- ie. for HT HT40+ means secondary channel is above
> the control channel. For VHT 80, you're going to have 4 possibilities:
> 
> |-1-|-2-|-3-|-4-|
> 
> the control channel can be any one of these four I believe? So you'd
> have configurations like
> 
> VHT_CHAN_LAYOUT_0_3
> VHT_CHAN_LAYOUT_1_2
> VHT_CHAN_LAYOUT_2_1
> VHT_CHAN_LAYOUT_3_0
> 
> indicating the number of channels below/above control (for control
> channel 1,2,3,4 respectively). Similarly, for VHT160 you'd have 8
> possibilities:
> 
> |-1-|-2-|-3-|-4-|-5-|-6-|-7-|-8-|
> 
> (which one could again capture as VHT_CHAN_LAYOUT_0_7 etc.)
> 
> [MP] I see your point. But according to 11ac spec, AP will use primary
> chan as specified in HT operation IE chan num. Secondary channel is
> center freq specified in VHT Operation IE. So I am thinking secondary
> channel is not relative offset to primary channel. Hope I am not
> mistaken here.

Ok so HT has primary channel and secondary, and VHT has secondary VHT
which can again be above/below? That would make sense, but you wouldn't
be covering it.

> > +     /* This would happen when regulatory rules disallow VHT80 completely */
> > +     if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
> > +             return true;
> 
> Is that really right? Need to document what the return value of this
> function should be, I guess?
> 
> [MP] I guess, it's possible for a channel not allowed for 80Mhz operation.

Yeah but should it really check *all* the bits rather than any one of
them?

> > +     /*
> > +      * Please note that this assumes target bandwidth is 40 MHz,
> > +      * if that ever changes we also need to change the below logic
> > +      * to include that as well.
> > +      */
> 
> ???
> 
> [MP] Can you explain? This function doesn't make any sense?

The comment about 40 MHz doesn't make any sense.

johannes

