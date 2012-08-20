Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2HTQio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 12:38:44 -0400
Message-ID: <1345480718.4459.37.camel@jlt3.sipsolutions.net> (sfid-20120820_183848_764550_9CDD9668)
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Mon, 20 Aug 2012 18:38:38 +0200
In-Reply-To: <502E85D9.5050301@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>
	 <20120816102211.GD17659@redhat.com> <502CF2D5.6020704@posedge.com>
	 <20120817140657.GA1645@redhat.com> <502E85D9.5050301@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-17 at 23:26 +0530, Mahesh Palivela wrote:

> >> oh, you mean my implementation is ugly? Not a problem. Give me some
> >> clue, I will work on it.
> >
> > We can not extend channel, if regulatory disallow to use some
> > nearby channels or disallow HT at all.
> >
> > So it's not possible that for particular channel that we can extend it
> > to let say -160|0+ and -0|160+, but can not extend it to -40|120+. So
> > we do not need zilion flags, but just specify left and right borders,
> > inside which we can extend channel.
> >
> > For example: channel 36 (5180 MHz) is prohibited and all channels
> > above are allowed. For channel 52 (5260 MHz) left border will be
> > -60 and right border +160 (max). That will allow to support
> > VHT160: -60|100+, -40|120+, -20|140+, -0|160+ ;
> > VHT80: -60|20+, -40|40+, -20|60+, -0|80+ ;
> > HT40 :-40|0+, -0|40+

> Thanks for the description. I will get back to you soon.

I guess the question is how we specify the channel. If we want to
continue using the current scheme of encoding the bandwidth in the
channel type, then we will need one channel type for each of the VHT
possibilities:

80 MHz:
 * +3
 * +2/-1
 * +1/-2
 * -3

160 MHz:
 * +7
 * -1/+6
 * -2/+5
 * -3/+4
 * -4/+3
 * -5/+2
 * -6/+1
 * -7

That's 4 different 80 MHz channel types and 8 different 160 MHz channel
types, all while disregarding 80+80 completely. Then we'd need all the
different flags because structurally we want to be able to answer each
channel type with a single bit.

If we keep this then it would probably be worthwhile to rework this to
use permitted (rather than prohibited) bits and use BIT(channel_type)
instead of CHAN_NO_... flags. There are currently relatively few users
of these flags, so such a change would be pretty easy.

On the other hand, maybe for VHT we want to completely change channel
specifications? Maybe it would be better to allow specifying the
*global* center frequency of the entire channel, and the width, and the
control channel offset instead of encoding everything into the single
channel type value? I don't know.

Discuss ;-)

johannes

