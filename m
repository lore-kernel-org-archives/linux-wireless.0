Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:12001 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbXIZPsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:48:25 -0400
Received: by py-out-1112.google.com with SMTP id u77so4247559pyb
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2007 08:48:24 -0700 (PDT)
Message-ID: <43e72e890709260848h5a6a24c4o85d4d87f0ce284fb@mail.gmail.com>
Date: Wed, 26 Sep 2007 11:48:23 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 1/5] Move standard wireless defintions out of mac80211
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <1190818863.20955.4.camel@xo-3E-67-34.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070921210014.GE31768@pogo>
	 <1190409462.18521.160.camel@johannes.berg>
	 <43e72e890709211433hf6669f1y97d24663a97b21ff@mail.gmail.com>
	 <20070924094959.GY10493@thot.informatik.uni-kl.de>
	 <43e72e890709241049y63a88d6aoa6456d2f1465ee04@mail.gmail.com>
	 <1190818863.20955.4.camel@xo-3E-67-34.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/26/07, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2007-09-24 at 13:49 -0400, Luis R. Rodriguez wrote:
> > On 9/24/07, Joerg Mayer <jmayer@loplof.de> wrote:
> > > On Fri, Sep 21, 2007 at 05:33:42PM -0400, Luis R. Rodriguez wrote:
> > > > > > + * ieee80211_channel - internal structure definiton for an IEEE-802.11 channel
> > > > > > + *
> > > > > > + * This defines an ieee80211_channel. The IEEE-802.11 regulatory domain agent
> > > > > > + * is in charge of filling most of these fields out. The low-level driver
> > > > > > + * is expected to fill in, if needed, the val field. Note that val is already
> > > > > > + * set by the regulatory agent to the same channel as in chan.
> > > > >
> > > > > Shouldn't you also set chan and freq in the driver?
> > > [...]
> > > > Initially I wanted to move mac80211 to use a linked list of channels
> > > > instead of an array for each mode. As we discussed it over (you, me
> > > > and a few others) we determined it wasn't best to do this (I have a
> > > > patch that allows this just in case we later change our mind). But --
> > > > previous to doing this I had a wrapper on ieee80211_channel as I
> > > > wanted the central regdomain to have a linked list of reg domain
> > > > channels. If we don't want a wrapper we have to add this to the
> > > > ieee8021_channel struct. Otherwise I need to define my own channel
> > > > struct which wraps around ieee80211_channel.
> > > >
> > > > > > +struct ieee80211_channel {
> > > > > > +     /* XXX change to u8 */
> > > > > > +     short chan;
> > > > >
> > > > > Not sure, is a u8 always enough? I thought 802.11a had huge channel
> > > > > numbers?
> > > >
> > > > Not that huge :-) Highest I've heard is 220. u8 should suffice.
> > >
> > > What's the idea of working with channels? Channels are non-uniq numbers.
> > > Internally everything should work with center frequency and not with
> > > channels. If necessary, information should be converted from channels
> > > by the driver when reporting it into the stack. That way there also won't
> > > be any problems if there ever is a channel 417.
> >
> > I agree. I'm OK with just having center of freq. Right now WE supports
> > channel or freqs and the value is passed directly to the driver (for
> > FullMAC) or mac80211 (for SoftMAC). For nl80211 we can just support
> > channel passing onto the kernel, if the user supplies a channel we'll
> > do the conversion to freq in userspace. On step at a time.
>
> Definitely need to use freq and not channel.  Channels are not unique
> (they just _happen_ to be so right now).  Of course remember that we
> can't just pass channel really, we need to pass the tuple of (channel,
> band) or maybe even (channel, [A|B|G|N]) or something.

AFAICT channels are unique per 2GHz and 5GHz band. As far as the
regulatory code I have is concerned we have:

2GHz: 2412 - 2732 (ch 1 - 26)
5GHz: 5005 - 6100 (ch 1 - 220)

However, the problem really is with some channels which have its
center of frequency below this range. Only special hardware can go out
of this range. An example is the Atheros device's transceiver which
supports frequencies in the range of  4920 to 6100 MHz and 2312 to
2732 MHz. In this case 2312MHz would be channel -19... Regulatory-wise
I have read only about MKK allowing frequencies in the 4.8GHz range, I
am not 100% certain though and the current regulatory agency does
allow for its use, I'll ask. In the current regulatory work we don't
allow for those channels. If it is the case that some reg agencies
allow for it we'll need to need to figure out a way to map this lower
bound frequency range.

Kernel-wise I think we should stick to center of frequencies. If new
userspace wants to speak in terms of channels we should just have
userspace do the conversion to freq. The exception here would be old
Wireless-Extensions which already supports passing channel numbers.
For WE we can just not support the lower freqs as new userspace
utilities should use the new nl80211 interface.

  Luis
