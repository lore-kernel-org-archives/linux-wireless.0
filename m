Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2GXLRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 07:17:24 -0400
Message-ID: <1343128638.4415.17.camel@jlt3.sipsolutions.net> (sfid-20120724_131728_673070_D607250E)
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jul 2012 13:17:18 +0200
In-Reply-To: <500E7D76.9010205@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
	 ,<1343048772.4584.18.camel@jlt3.sipsolutions.net>
	  <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>
	 <1343120184.4415.16.camel@jlt3.sipsolutions.net>
	 <500E7D76.9010205@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-24 at 16:18 +0530, Mahesh Palivela wrote:

> >> indicating the number of channels below/above control (for control
> >> channel 1,2,3,4 respectively). Similarly, for VHT160 you'd have 8
> >> possibilities:
> >>
> >> |-1-|-2-|-3-|-4-|-5-|-6-|-7-|-8-|
> >>
> >> (which one could again capture as VHT_CHAN_LAYOUT_0_7 etc.)
> >>
> >> [MP] I see your point. But according to 11ac spec, AP will use primary
> >> chan as specified in HT operation IE chan num. Secondary channel is
> >> center freq specified in VHT Operation IE. So I am thinking secondary
> >> channel is not relative offset to primary channel. Hope I am not
> >> mistaken here.
> >
> > Ok so HT has primary channel and secondary, and VHT has secondary VHT
> > which can again be above/below? That would make sense, but you wouldn't
> > be covering it.
> >
> 
> I am thinking no need of above/below convention as the center frequency 
> value itself we know.

But we don't use the center frequency of the overall Ht40/80/160
channel, we always use the center frequency of the control channel.

> >>> +     /* This would happen when regulatory rules disallow VHT80 completely */
> >>> +     if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
> >>> +             return true;
> >>
> >> Is that really right? Need to document what the return value of this
> >> function should be, I guess?
> >>
> >> [MP] I guess, it's possible for a channel not allowed for 80Mhz operation.
> >
> > Yeah but should it really check *all* the bits rather than any one of
> > them?
> >
> 
> You mean to say other bits like HT40MINUS, HT40PLUS or even DFS?

No, I mean all the bits that are part of CHAN_NO_VHT80.

johannes

