Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:36108 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbXIUVwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:52:14 -0400
Received: by py-out-1112.google.com with SMTP id u77so1788744pyb
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 14:52:13 -0700 (PDT)
Message-ID: <43e72e890709211452j743fedfcyab6b981a0a3fce09@mail.gmail.com>
Date: Fri, 21 Sep 2007 17:52:12 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/5] Wireless: add IEEE-802.11 regualtory domain module
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <1190410242.18521.171.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070921210437.GG31768@pogo>
	 <1190410242.18521.171.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/21/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-21 at 17:04 -0400, Luis R. Rodriguez wrote:
>
> > +/* XXX: <net/ieee80211.h> has two band defs bellow */
> > +#ifndef IEEE80211_24GHZ_BAND
> > +#define IEEE80211_24GHZ_BAND     (1<<0)
> > +#define IEEE80211_52GHZ_BAND     (1<<1)
> > +#endif
>
> Hmm. Could we make a new definition with just an enum?
>
> enum ieee80211_band {
>         IEEE80211_BAND_24GHZ,
>         IEEE80211_BAND_52GHZ,
> };
>
> Then we can use "enum ieee80211_band" below in the structs and get type
> checking. Generally, no new stuff has anything to do with
> include/net/ieee80211.h, that's just for the old "stack".

Sure, I just wanted to point out the band def existed in another
header. My hopes is we can address all common header stuff once in for
all. I guess it'll have to wait a bit more.

> > +/**
> > + * struct ieee80211_subband_restrictions - defines a regulatory domain
> > + *   subband restrictions list
>
> I think the docs should include where this structure is used.

Point taken.

> > + * @name: name for this subband.
>
> Why does it need a name?

Well to distinguish it.

> > + * @min_freq: minimum frequency for this subband, in MHz. This represents the
> > + *   center of frequency of a channel.
> > + * @max_freq: maximum frequency for this subband, in MHz. This represents the
> > + *   center of frequency of a channel.
>
> How can both be center freq?

min_freq is the center of frequency for the minimum channel on the
subband. max_freq is the center of frequency for the max channel on
the subband. I guess I should clear that up a little more huh.

> > +struct ieee80211_subband_restrictions {
> > +     u8 band;
> > +     char name[REGSBNAMSIZ];
> > +     u16 min_freq;
> > +     u16 max_freq;
> > +     u32 modulation_cap;
> > +     u8 max_antenna_gain;
> > +     u8 max_ir_ptmp;
> > +     u8 max_ir_ptp;
> > +#define REG_DIPOLE_ANTENNA_GAIN 2
> > +     u8 max_eirp_ptmp;
> > +     u8 max_eirp_ptp;
> > +#define REG_CAP_INDOOR       'I'
> > +#define REG_CAP_OUTDOOR      'O'
> > +#define REG_CAP_INOUT        ' '
>
> Did you actually run kernel-doc? it's rather unhappy with such things :)

Nope, sorry.

> > +/**
> > + * struct ieee80211_regdomain - defines a regulatory domain
> > + *
> > + * @regdomain_id: ID of this regulatory domain. Some come from
> > + *   http://standards.ieee.org/getieee802/download/802.11b-1999_Cor1-2001.pdf
> > + * @regdomain_name: name of this regulatory domain.
> > + * @list: node, part of band_restrictions_list
> > + *
> > + * This structure defines a regulatory domain, which consists of channel and
> > + * power restrictions. Some regulatory domains come from
> > + * 802.11b-1999_Cor1-2001, the rest are based on Reyk Floeter's ar5k. If
> > + * there is need to add more values here, please add one that is either
> > + * defined in a standard or that many hardware devices have adopted. Also
> > + * note that multiple countries can map to the same @regdomain_id
>
> There's no table here where you could add values, is there?.

There is a lot of them.. but we can add few to show as an example.

> > + */
> > +struct ieee80211_regdomain {
> > +     u32 regdomain_id;
> > +     char regdomain_name[REGNAMSIZ];
> > +     struct ieee80211_subband_restrictions subbands[REG_NUM_SUBBANDS];
>
> Why is that not a variable length array with the number of items given
> in an extra var?

I should have explained that too. Well, if you may recall in my last
implementation of this I actually used a linked list. I then decided
we weren't going to add new 2.4GHz or 5GHz subbands unless a big
IEEE-802.11 change occurs. That doesn't happen so often to either use
linked list or a variable length array.

> > + * This structure holds the mapping of the country to a specific regulatory
> > + * domain. Keep in mind more than one country can map to the same regulatory
> > + * domain. The ISO-3166-1 alpha2 country code also happens to be used in the
> > + * 802.11d Country Information Element on the string for the country. It
> > + * should be noted, however, that in that the size of this string, is
> > + * three octects while our string is only 2. The third octet is used to
> > + * indicate Indoor/outdoor capabilities which we set in
> > + * @ieee80211_subband_restrictions environment_cap.
> > + */
> > +struct ieee80211_iso3166_reg_map {
> > +     char alpha2[ISOCOUNTRYSIZ2];
> > +     u32 regdomain_id; /* stack-aware value */
> > +     /* XXX: shall we just use an array? */
> > +     struct list_head list; /* node, part of iso3166_reg_map_list */
> > +};
>
> Why does this need a list if it's a static mapping? Why does it need to
> be visible outside of net/wireless/?

As you can notice I also considered this. This *should* only change in
case of an ISO-3166 change or a new regulatory agency rule enforcement
change. Neither of which are really that common, I think so you're
right, we can leave this static.

> > +/**
> > + * regdomain_mhz2ieee - convert a frequency to an IEEE-80211 channel number
> > + * @freq: center of frequency in MHz. We support a range:
> > + *   2412 - 2732 MHz (Channel 1 - 26) in the 2GHz band and
> > + *   5005 - 6100 MHz (Channel 1 - 220) in the 5GHz band.
> > + *
> > + * Given a frequency in MHz returns the respective IEEE-80211 channel
> > + * number. You are expected to provide the center of freqency in MHz.
> > + */
> > +u16 regdomain_mhz2ieee(u16 freq);
>
> Ok this I can see being necessary for drivers/stacks.
>
> > +u16 regdomain_ieee2mhz(u16 chan, u8 band);
>
> Same here.
>
> > +void print_regdomain(struct ieee80211_regdomain *);
>
> Ssame.
>
> > +void print_iso3166_reg_map(void);
>
> But why does this need to be exported?

Point taken.

> > +int get_ieee80211_regname(u32, char *);
>
> What are the arguments?

This can be removed.

  Luis
