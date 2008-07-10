Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYGJQXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 12:23:30 -0400
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <20080710152415.GK17936@ruslug.rutgers.edu>
References: <20080710152415.GK17936@ruslug.rutgers.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4RpD5sxwR56awgMzA6zj"
Date: Thu, 10 Jul 2008 18:22:40 +0200
Message-Id: <1215706960.3483.37.camel@johannes.berg> (sfid-20080710_182349_677710_82FF9095)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4RpD5sxwR56awgMzA6zj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Just a quick first pass.

> + * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this =
command
> + *	after being queried by the kernel. CRDA replies by sending a regulato=
ry
> + *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
> + *	current alpha2 if it found a match. It also provides %NL80211_ATTR_RE=
G_NUM,
> + * 	NL80211_ATTR_REG_RULE_FLAGS, and a set of regulatory rules. Each
> + * 	regulatory rule is a nested set of attributes  given by
> + * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] and
> + * 	%NL80211_ATTR_FREQ_RANGE_MAX_BW with an attached power rule given by
> + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
> + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. We provide CRDA with a receip=
t,
> + * 	%NL80211_ATTR_REG_UUID, which CRDA sends us back to ensure the reque=
st
> + * 	command is valid and came from us.

The UUID thing confuses me. Why is this necessary? And if that's there,
why does crda provide a country code back to the kernel? It shouldn't
ever reply with something different...

> + * @NL80211_ATTR_NUM_REG_RULES: the number of regulatory rules nested in
> + * 	%NL80211_ATTR_REG_RULES, we pass this to not abuse the stack
> + * 	and to gracefully use only one memory area in nl80211_set_reg().
> + * 	This value shall never exceed NL80211_MAX_SUPP_REG_RULES. We can
> + * 	increase this value as regulatory rules becomes more complex.

That isn't needed. You can just count the number of nested attributes
in =EF=BB=BFNL80211_ATTR_REG_RULES.

> + * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed antenna ga=
in
> + * 	for a given frequency range. The value is in mBi (100 * dBi).
> + * 	If you set this to 0 it means there is no available known limit.

No way. If there's no known limit, just leave out the attribute
completel.

> +/**
> + * enum nl80211_reg_rule_flags - regulatory rule flags. These should mat=
ch
> + * 	the latest regdb.h regulatory rule flags from CRDA.

I don't think such a comment belongs in the kernel, it's a detail of the
userspace implementation and not part of the kernel API. Hence, we can
do whatever we want here and have userspace follow, not the other way
around.

> +/**
> + * enum reg_set_by - Indicates who is trying to set the regulatory domai=
n
> + * @REGDOM_SET_BY_INIT: regultory domain was set by initialization. We w=
ill be
                           ^^^^^^^^^
typo

> + * @REGDOM_SET_BY_80211D: the wireless core has received an 802.11 count=
ry
> + *	information element with regulotory information it thinks we
                                   ^^^^^^^^^^
typo

>  struct ieee80211_channel {
>  	enum ieee80211_band band;
>  	u16 center_freq;
> +	u8 max_bandwidth;
>  	u16 hw_value;
>  	u32 flags;
>  	int max_antenna_gain;

reorder please so the struct is smaller.

> +struct list_head regulatory_requests;
> +
> +/* Central wireless core regulatory domains, we only need two,
> + * the current one and a world regulatory domain in case we have no
> + * information to give us an alpha2 */
> +struct ieee80211_regdomain *cfg80211_regdomain;
> +
> +/* CRDA can provide a dynamic world regulatory domain, we keep
> + * this static one updated as often as we can in case of the absense

absence, but the sentence is a bit confused anyway :)

> +	[NL80211_ATTR_REG_UUID] =3D { .type =3D NLA_BINARY, .len =3D 16 },
> +	[NL80211_ATTR_REG_ALPHA2] =3D { .type =3D NLA_STRING, .len =3D 2 },

shouldn't alpha2 be considered binary as well?

> +	reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] =3D {
> +	[NL80211_ATTR_REG_RULE_FLAGS]		=3D { .type =3D NLA_U32 },

I thought we agreed to use actual NLA flags for the flags, in a nested
attribute, instead of using bitmaps.

> +	uuid		=3D nla_data(info->attrs[NL80211_ATTR_REG_UUID]);
> +	alpha2		=3D nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
> +	num_rules	=3D nla_get_u32(info->attrs[NL80211_ATTR_NUM_REG_RULES]);

please don't indent like that, it makes grepping unnecessarily hard.

> +	printk("nl80211: incorectly formatted regulatory domain\n");

why bother printing something?

> +	unsigned char uuid_arg[16];

> +	sprintf(uuid_arg,
> +		"%02x%02x%02x%02x"
> +		"%02x%02x%02x%02x"
> +		"%02x%02x%02x%02x"
> +		"%02x%02x%02x%02x",
> +		uuid[0], uuid[1], uuid[2], uuid[3],
> +		uuid[4], uuid[5], uuid[6], uuid[7],
> +		uuid[8], uuid[9], uuid[10], uuid[11],
> +		uuid[12], uuid[13], uuid[14], uuid[15]);
=EF=BB=BF
buffer overflow.

> +/**
> + * regulatory_hint - hint to wireless core a regulatory domain
> + * @alpha2: the ISO-3166 alpha2 the driver thinks we're on
> + * @wiphy: the driver's very own &struct wiphy
> + *
> + * Wireles drivers can use this function to hint to the wireles core

type in both instances :)

> +static int is_alpha_upper(char letter)
> +{
> +	/* ASCII A - Z */
> +	if (letter >=3D 65 && letter <=3D 90)
> +		return 1;
> +	return 0;
> +}

> +static int is_an_alpha2(char *alpha2)
> +{
> +	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
> +		return 1;
> +	return 0;

Why's that so important?

> +	printk("Country: %c%c\n", rd->alpha2[0], rd->alpha2[1]);

most of your printks are unnecessary, and most of them are lacking level
annotations.

johannes

--=-4RpD5sxwR56awgMzA6zj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdjdMAAoJEKVg1VMiehFYHIYP/RgLOVVgYQ4yaP5YGJlCR7Et
/fM+yGhOctgo2Z6xZJ/gW14TunjZK6vb6WqbMdKRffqjbrcwjWOXlEVxbEVEwUJP
tTi+yzOKCAGTjydfmf7j5V0KwENCvir0/b079voWb8YSaQdNb5otTTifjiDLFnp9
5RbrbTUNOlfUefmgJPIPlWeO4J4pA0XRJ749Gq6k960baOZ2F6+xY74lgJqaJyBe
MTOKko29aREB4/CHiz/7WK7hKxFRRaSumaWoHoVUG1rYK3eRNFtd39Lkch3Z2fXm
2d6hCmEV538suoAYi7gxnymPCs7TBJjUfmsY3YrVdm1IvMcOH/LtoeVE1RGaW8r2
9akTgKacrDMmYj3Yw9vS9PYyaF0X9P39IkwpQEJE8337O0ZsLd42o4cLVhu6jFug
DOVRq0pDZt2Iq7EOXPhA+/l7erekzxSlVRb5BAQrbiVjJGNldNkyLuimvohJ+s9J
DjbmyU3C+pMIMtqDe7L7rxfCATYmRXkPL0PKfHCYaBX3jryHrUwg+i9Qs/ZxsA02
4LMfTFUT63La87WBw6Q37olViZKoNPqQCquFc3pvDC6VKJhgaUt8WhZiYfb9+6If
NiAIZ2o3kJYzLVFY7VFSrxWe6syxYunpMwu5CjCfbJRQbnWMy52gigx9qapgRMBd
Kx45nBWPk985FYSK1KEW
=UGqt
-----END PGP SIGNATURE-----

--=-4RpD5sxwR56awgMzA6zj--

