Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:8542 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbXIXRtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:49:20 -0400
Received: by an-out-0708.google.com with SMTP id d31so237990and
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 10:49:19 -0700 (PDT)
Message-ID: <43e72e890709241049y63a88d6aoa6456d2f1465ee04@mail.gmail.com>
Date: Mon, 24 Sep 2007 13:49:19 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/5] Move standard wireless defintions out of mac80211
In-Reply-To: <20070924094959.GY10493@thot.informatik.uni-kl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070921210014.GE31768@pogo>
	 <1190409462.18521.160.camel@johannes.berg>
	 <43e72e890709211433hf6669f1y97d24663a97b21ff@mail.gmail.com>
	 <20070924094959.GY10493@thot.informatik.uni-kl.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Joerg Mayer <jmayer@loplof.de> wrote:
> On Fri, Sep 21, 2007 at 05:33:42PM -0400, Luis R. Rodriguez wrote:
> > > > + * ieee80211_channel - internal structure definiton for an IEEE-802.11 channel
> > > > + *
> > > > + * This defines an ieee80211_channel. The IEEE-802.11 regulatory domain agent
> > > > + * is in charge of filling most of these fields out. The low-level driver
> > > > + * is expected to fill in, if needed, the val field. Note that val is already
> > > > + * set by the regulatory agent to the same channel as in chan.
> > >
> > > Shouldn't you also set chan and freq in the driver?
> [...]
> > Initially I wanted to move mac80211 to use a linked list of channels
> > instead of an array for each mode. As we discussed it over (you, me
> > and a few others) we determined it wasn't best to do this (I have a
> > patch that allows this just in case we later change our mind). But --
> > previous to doing this I had a wrapper on ieee80211_channel as I
> > wanted the central regdomain to have a linked list of reg domain
> > channels. If we don't want a wrapper we have to add this to the
> > ieee8021_channel struct. Otherwise I need to define my own channel
> > struct which wraps around ieee80211_channel.
> >
> > > > +struct ieee80211_channel {
> > > > +     /* XXX change to u8 */
> > > > +     short chan;
> > >
> > > Not sure, is a u8 always enough? I thought 802.11a had huge channel
> > > numbers?
> >
> > Not that huge :-) Highest I've heard is 220. u8 should suffice.
>
> What's the idea of working with channels? Channels are non-uniq numbers.
> Internally everything should work with center frequency and not with
> channels. If necessary, information should be converted from channels
> by the driver when reporting it into the stack. That way there also won't
> be any problems if there ever is a channel 417.

I agree. I'm OK with just having center of freq. Right now WE supports
channel or freqs and the value is passed directly to the driver (for
FullMAC) or mac80211 (for SoftMAC). For nl80211 we can just support
channel passing onto the kernel, if the user supplies a channel we'll
do the conversion to freq in userspace. On step at a time.

  Luis
