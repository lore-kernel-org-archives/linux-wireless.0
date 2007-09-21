Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:27227 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762993AbXIUW5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 18:57:34 -0400
Received: by py-out-1112.google.com with SMTP id u77so1811468pyb
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 15:57:33 -0700 (PDT)
Message-ID: <43e72e890709211557q2aed1c6ai9e487eff731bebb3@mail.gmail.com>
Date: Fri, 21 Sep 2007 18:57:32 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/5] Wireless: add IEEE-802.11 regualtory domain module
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <1190411890.18521.179.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070921210437.GG31768@pogo>
	 <1190410242.18521.171.camel@johannes.berg>
	 <43e72e890709211452j743fedfcyab6b981a0a3fce09@mail.gmail.com>
	 <1190411890.18521.179.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/21/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-21 at 17:52 -0400, Luis R. Rodriguez wrote:
>
> > > Then we can use "enum ieee80211_band" below in the structs and get type
> > > checking. Generally, no new stuff has anything to do with
> > > include/net/ieee80211.h, that's just for the old "stack".
> >
> > Sure, I just wanted to point out the band def existed in another
> > header. My hopes is we can address all common header stuff once in for
> > all. I guess it'll have to wait a bit more.
>
> Oh ok. But I think we should start using sane values (these bits look
> awfully like you could OR them which is totally bogus) and convert the
> other stack over.

ACK -- we can define any value we want into this. Point taken though.

> > > > + * @name: name for this subband.
> > >
> > > Why does it need a name?
> >
> > Well to distinguish it.
>
> But why do we need to distinguish subbands by name? What do we use them
> for anyway?

We use it in:

u16 regdomain_ieee2mhz(u16 chan, u8 band)

freq_band_id() returns it

print_regdomain() uses it to distinguish the band the subband is in.

static int __alloc_band_channels(u32 regdomain_id,
        struct ieee80211_regdomain *reg, u8 band,
        u32 sb_chan_domain)

uses it internally to determine from what what regmap array it should
use to build channels from. That is, it either uses reg_2ghz_channels
or reg_5ghz_channels.

> > > > + * @min_freq: minimum frequency for this subband, in MHz. This represents the
> > > > + *   center of frequency of a channel.
> > > > + * @max_freq: maximum frequency for this subband, in MHz. This represents the
> > > > + *   center of frequency of a channel.
> > >
> > > How can both be center freq?
> >
> > min_freq is the center of frequency for the minimum channel on the
> > subband. max_freq is the center of frequency for the max channel on
> > the subband. I guess I should clear that up a little more huh.
>
> Uh ok, no, I just need to read better :)

:-P

> > > > +/**
> > > > + * struct ieee80211_regdomain - defines a regulatory domain
> > > > + *
> > > > + * @regdomain_id: ID of this regulatory domain. Some come from
> > > > + *   http://standards.ieee.org/getieee802/download/802.11b-1999_Cor1-2001.pdf
> > > > + * @regdomain_name: name of this regulatory domain.
> > > > + * @list: node, part of band_restrictions_list
> > > > + *
> > > > + * This structure defines a regulatory domain, which consists of channel and
> > > > + * power restrictions. Some regulatory domains come from
> > > > + * 802.11b-1999_Cor1-2001, the rest are based on Reyk Floeter's ar5k. If
> > > > + * there is need to add more values here, please add one that is either
> > > > + * defined in a standard or that many hardware devices have adopted. Also
> > > > + * note that multiple countries can map to the same @regdomain_id
> > >
> > > There's no table here where you could add values, is there?.
> >
> > There is a lot of them.. but we can add few to show as an example.
>
> Then again. Why do we have this struct in a header file?

cfg80211 uses it. This is how we create a central regulatory domain.
cfg80211 creates its own struct based on this.

> > I should have explained that too. Well, if you may recall in my last
> > implementation of this I actually used a linked list. I then decided
> > we weren't going to add new 2.4GHz or 5GHz subbands unless a big
> > IEEE-802.11 change occurs. That doesn't happen so often to either use
> > linked list or a variable length array.
>
> Ok I just don't understand why you have this information in a struct.
> Shouldn't all of this information be essentially internal to the
> regulatory code, and people who use it simply query it and get back a
> pointer to the subband that applies to their query?

In order to build things and make things concretely. cfg80211 will
have a ieee80211_regdomain, but well this ieee80211_regdomain has some
structs we might as well define to make it easier to build from a map.

> I don't see why
> everybody needs to see this huge array.

Well you are welcome to provide an alternative solution. I first
started with a linked list, but then that seemed silly as this remains
constant.. so I think a static array of subbands is easier. Hmm, I
think I had even tried a variable length array too..

  Luis
