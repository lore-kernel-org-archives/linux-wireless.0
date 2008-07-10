Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:53167 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYGJTeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 15:34:08 -0400
Date: Thu, 10 Jul 2008 15:34:02 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
Message-ID: <20080710193402.GL17936@ruslug.rutgers.edu> (sfid-20080710_213412_233785_E706B291)
References: <20080710152415.GK17936@ruslug.rutgers.edu> <1215706960.3483.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1215706960.3483.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 06:22:40PM +0200, Johannes Berg wrote:
> Hi,
>=20
> Just a quick first pass.
>=20
> > + * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends=
 this command
> > + *	after being queried by the kernel. CRDA replies by sending a re=
gulatory
> > + *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set =
to our
> > + *	current alpha2 if it found a match. It also provides %NL80211_A=
TTR_REG_NUM,
> > + * 	NL80211_ATTR_REG_RULE_FLAGS, and a set of regulatory rules. Ea=
ch
> > + * 	regulatory rule is a nested set of attributes  given by
> > + * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] and
> > + * 	%NL80211_ATTR_FREQ_RANGE_MAX_BW with an attached power rule gi=
ven by
> > + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
> > + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. We provide CRDA with a =
receipt,
> > + * 	%NL80211_ATTR_REG_UUID, which CRDA sends us back to ensure the=
 request
> > + * 	command is valid and came from us.
>=20
> The UUID thing confuses me. Why is this necessary?

Its just a random number we use as a receipt. I was thinking of
having it to provide uniqueness on requests and to provide a cookie
to ensure it comes from the kernel but now that I think about this
a bit more its really unnecessary.=20

> And if that's there,
> why does crda provide a country code back to the kernel? It shouldn't
> ever reply with something different...

If we keep UUID we can remove the alpha2, you're right. But it seems
we may rather keep the alpha2 and just nuke the UUID.

> > + * @NL80211_ATTR_NUM_REG_RULES: the number of regulatory rules nes=
ted in
> > + * 	%NL80211_ATTR_REG_RULES, we pass this to not abuse the stack
> > + * 	and to gracefully use only one memory area in nl80211_set_reg(=
).
> > + * 	This value shall never exceed NL80211_MAX_SUPP_REG_RULES. We c=
an
> > + * 	increase this value as regulatory rules becomes more complex.
>=20
> That isn't needed. You can just count the number of nested attributes
> in =EF=BB=BFNL80211_ATTR_REG_RULES.

I'll loop twice then. OK I'll fix this.

> > + * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed ante=
nna gain
> > + * 	for a given frequency range. The value is in mBi (100 * dBi).
> > + * 	If you set this to 0 it means there is no available known limi=
t.
>=20
> No way. If there's no known limit, just leave out the attribute
> completel.

Sure.

> > +/**
> > + * enum nl80211_reg_rule_flags - regulatory rule flags. These shou=
ld match
> > + * 	the latest regdb.h regulatory rule flags from CRDA.
>=20
> I don't think such a comment belongs in the kernel, it's a detail of =
the
> userspace implementation and not part of the kernel API. Hence, we ca=
n
> do whatever we want here and have userspace follow, not the other way
> around.

OK.

> >  struct ieee80211_channel {
> >  	enum ieee80211_band band;
> >  	u16 center_freq;
> > +	u8 max_bandwidth;
> >  	u16 hw_value;
> >  	u32 flags;
> >  	int max_antenna_gain;
>=20
> reorder please so the struct is smaller.

Will do.

> > +struct list_head regulatory_requests;
> > +
> > +/* Central wireless core regulatory domains, we only need two,
> > + * the current one and a world regulatory domain in case we have n=
o
> > + * information to give us an alpha2 */
> > +struct ieee80211_regdomain *cfg80211_regdomain;
> > +
> > +/* CRDA can provide a dynamic world regulatory domain, we keep
> > + * this static one updated as often as we can in case of the absen=
se
>=20
> absence, but the sentence is a bit confused anyway :)

I'll try to clarify.

> > +	[NL80211_ATTR_REG_UUID] =3D { .type =3D NLA_BINARY, .len =3D 16 }=
,
> > +	[NL80211_ATTR_REG_ALPHA2] =3D { .type =3D NLA_STRING, .len =3D 2 =
},
>=20
> shouldn't alpha2 be considered binary as well?

Nah, its always a valid char.

> > +	reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] =3D {
> > +	[NL80211_ATTR_REG_RULE_FLAGS]		=3D { .type =3D NLA_U32 },
>=20
> I thought we agreed to use actual NLA flags for the flags, in a neste=
d
> attribute, instead of using bitmaps.

I forgot if we did. If we keep them as they are we can actually end
up using them to replace the channel flags themselves with these
though. What do you think? Also if we do use a nested attribut for
the flags what would be the benefit?

> > +	uuid		=3D nla_data(info->attrs[NL80211_ATTR_REG_UUID]);
> > +	alpha2		=3D nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
> > +	num_rules	=3D nla_get_u32(info->attrs[NL80211_ATTR_NUM_REG_RULES]=
);
>=20
> please don't indent like that, it makes grepping unnecessarily hard.

Sure.

> > +	printk("nl80211: incorectly formatted regulatory domain\n");
>=20
> why bother printing something?

I'll kill it.

> > +	unsigned char uuid_arg[16];
>=20
> > +	sprintf(uuid_arg,
> > +		"%02x%02x%02x%02x"
> > +		"%02x%02x%02x%02x"
> > +		"%02x%02x%02x%02x"
> > +		"%02x%02x%02x%02x",
> > +		uuid[0], uuid[1], uuid[2], uuid[3],
> > +		uuid[4], uuid[5], uuid[6], uuid[7],
> > +		uuid[8], uuid[9], uuid[10], uuid[11],
> > +		uuid[12], uuid[13], uuid[14], uuid[15]);
> =EF=BB=BF
> buffer overflow.

Doh.

> > +/**
> > + * regulatory_hint - hint to wireless core a regulatory domain
> > + * @alpha2: the ISO-3166 alpha2 the driver thinks we're on
> > + * @wiphy: the driver's very own &struct wiphy
> > + *
> > + * Wireles drivers can use this function to hint to the wireles co=
re
>=20
> type in both instances :)

Hm? I don't get it.

> > +static int is_alpha_upper(char letter)
> > +{
> > +	/* ASCII A - Z */
> > +	if (letter >=3D 65 && letter <=3D 90)
> > +		return 1;
> > +	return 0;
> > +}
>=20
> > +static int is_an_alpha2(char *alpha2)
> > +{
> > +	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
> > +		return 1;
> > +	return 0;
>=20
> Why's that so important?

Its not, but we should want to pick one or the other to use. I
picked alpha_upper. Have some other ideas?

> > +	printk("Country: %c%c\n", rd->alpha2[0], rd->alpha2[1]);
>=20
> most of your printks are unnecessary, and most of them are lacking le=
vel
> annotations.

Will fix, thanks.

  Luis

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
