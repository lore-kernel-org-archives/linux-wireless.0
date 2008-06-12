Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYFLIno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 04:43:44 -0400
Subject: Re: [RFC] First CRDA integration work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080611040402.GE17936@ruslug.rutgers.edu>
References: <20080611040402.GE17936@ruslug.rutgers.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jJdRmCLOG9ltgsGgq7/r"
Date: Thu, 12 Jun 2008 10:41:46 +0200
Message-Id: <1213260106.19369.15.camel@johannes.berg> (sfid-20080612_104349_331115_EB092D23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jJdRmCLOG9ltgsGgq7/r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * @NL80211_CMD_GET_REG: Get current regulatory domain, this is a query=20
> + * 	to the kernel wireless core, the wireless core returns currently
> + * 	set alpha2 by %NL80211_ATTR_REG_ALPHA2,.

Please specify what command it comes in, probably _NEW_REG that you
haven't added.

> + * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sets this a=
fter
                                                                sends

> + * 	being queried by the kernel.

How?

>  CRDA replies by sending a regulatory domain
> + * 	structure which consists of %NL80211_ATTR_REG_ALPHA set to our curre=
nt alpha2
> + * 	if it found a match.

Why set the alpha2 again? I thought the kernel queried for that?

>  It also provides %NL80211_ATTR_REG_NUM,

What is that for?

> + * 	%NL80211_ATTR_REG_PGP_SIGNATURE_CHECK,

It's not PGP either way, and why is that required in the kernel?

>  and a regulatory rule. The regulatory
> + * 	rule consists of set of frequency ranges given by
> + * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] with an attached power rule =
given
> + * 	by %NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
> + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. Each regulatory rule also has=
=20
> + * 	an attached %NL80211_ATTR_REG_RULE_FLAGS.

How are these attributes used? Nested in some array?

> + * @NL80211_ATTR_REG_ALPHA2: an ISO-3166-alpha2 country code for which t=
he
> + * 	current regulatory domain should be set to or is already set to.
> + * 	For example, 'CR', for Costa Rica.

Heh :)

>  This attribute is used by the kernel
> + * 	to query the CRDA userspace agent to retrieve one regulatory domain.
> + * 	This attribute can also be used by userspace to query the kernel for
> + * 	the currently set regulatory domain.

???

> + * @NL80211_ATTR_REG_NUM_RULES: number of regulatory rules passed

Not necessary.

> + * @NL80211_ATTR_REG_PGP_SIGNATURE_CHECK: whether or not CRDA has blesse=
d
> + * 	this information through a PGP signature check. If its not blessed
> + * 	we go ahead and regulatory-taint the kernel. This is obviously
> + * 	hackable but the purpose is to allow distributions to be able to use
> + * 	a CRDA with a regulatory database signed off by the community
> + * 	and get the communities' blessing on this. Vendors can also
> + * 	support their own custom databases for custom solutions (AP, militar=
y).
> + * 	Start to shift liablity to the user, where it should be.

Not PGP. It's just an RSA signature. If liability is at the user, why do
we need to know this in the kernel?

> + * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
> + * 	considerations for a given frequency range. These are the
> + * 	&enum nl80211_reg_rule_flags.

Should we use flag attributes here nested into something? That would be
more netlink-like and allow easier expansion above 32 should it become
necessary.

> + * @NL80211_ATTR_REG_RULE_FREQ_START: starting frequencry for the regula=
tory
> + * 	rule in KHz. This is not a center of frequency but an actual regulat=
ory
                                            ^^ remove
> + * 	band edge.
> + * @NL80211_ATTR_REG_RULE_FREQ_END: ending frequency for the regulatory =
rule
> + * 	in KHz. This is not a center a frequency but an actual regulatory
                                       ^^ remove
> + * 	band edge.
> + * @NL80211_ATTR_REG_RULE_FREQ_MAX_BW: maximum allowed bandwidth for thi=
s
> + * 	frequency range, in KHz.
> + * @NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN: the maximum allowed antenn=
a gain
> + * 	for a given frequency range. The value is in mBi (100 * dBi).

Can be left out.

> +/* Central wireless core regulatory domains, we only need two,
> + * the current one and a world regulatory domain in case we have no
> + * information to give us an alpha2 */
> +const struct ieee80211_regdomain *cfg80211_regdomain;

const?

> +const struct ieee80211_regdomain *cfg80211_world_regdom;
> +DEFINE_MUTEX(cfg80211_reg_mutex);
> +
>  /* RCU might be appropriate here since we usually
>   * only read the list, and that can happen quite
>   * often because we need to do it for each command */
> @@ -402,9 +410,30 @@ static struct notifier_block cfg80211_netdev_notifie=
r =3D {
>  	.notifier_call =3D cfg80211_netdev_notifier_call,
>  };
> =20
> +
>  static int cfg80211_init(void)
>  {
> -	int err =3D wiphy_sysfs_init();
> +#define	PASSIVE_AND_NO_IBSS	RRF_PASSIVE_SCAN | RRF_NO_IBSS
> +	int err;
> +	static const struct ieee80211_regdomain world_regdom =3D {
> +		.n_reg_rules =3D 7, /* I hope we can count */

ARRAY_SIZE() helps you count.

> +		.pgp_signature_check =3D 1, /* Duh, we're already here */
> +		.alpha2 =3D  { '0', '0' }, /* Got any better ideas? */

"\0\0" so we can't actually ever use this manually?

> +		.reg_rules =3D {
> +			REG_RULE(2402, 2472, 40, 0, 20,	RRF_PASSIVE_SCAN),
> +			REG_RULE(2474, 2494, 40, 0, 20,	PASSIVE_AND_NO_IBSS),
> +			REG_RULE(5160, 5240, 40, 0, 30,	PASSIVE_AND_NO_IBSS),
> +			REG_RULE(5250, 5330, 40, 0, 30, PASSIVE_AND_NO_IBSS),
> +			REG_RULE(5735, 5835, 40, 0, 30, PASSIVE_AND_NO_IBSS),
> +			REG_RULE(5490, 5710, 40, 0, 30, PASSIVE_AND_NO_IBSS),
> +			REG_RULE(5490, 5710, 40, 0, 30, PASSIVE_AND_NO_IBSS)
> +		}
> +	};

#undef PASSIVE_AND_NOIBSS

why not declare this statically in the file rather than statically in
the init function?

> +	cfg80211_regdomain =3D NULL;
> +	cfg80211_world_regdom =3D (struct ieee80211_regdomain *) &world_regdom;

What's with the cast?

> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -11,6 +11,7 @@
>  #include <net/genetlink.h>
>  #include <net/wireless.h>
>  #include <net/cfg80211.h>
> +#include "reg.h"

Hmm?
=20
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -18,6 +18,7 @@
>  #include <net/cfg80211.h>
>  #include "core.h"
>  #include "nl80211.h"
> +#include "reg.h"
> =20
>  /* the netlink family */
>  static struct genl_family nl80211_fam =3D {
> @@ -87,6 +88,16 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_M=
AX+1] __read_mostly =3D {
>  	[NL80211_ATTR_MESH_ID] =3D { .type =3D NLA_BINARY,
>  				.len =3D IEEE80211_MAX_MESH_ID_LEN },
>  	[NL80211_ATTR_MPATH_NEXT_HOP] =3D { .type =3D NLA_U32 },
> +
> +	[NL80211_ATTR_REG_RULE_ALPHA2] =3D { .type =3D NLA_NUL_STRING, .len =3D=
 3 },

Why does it have to be a NUL-string? It is always only two bytes, so
please just do that. No need to null-terminate.

> +static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	return -EOPNOTSUPP;
> +}

-ECODEMISSING :P

> @@ -9,137 +10,93 @@
>   */
> =20
>  /*
> - * This regulatory domain control implementation is highly incomplete, i=
t
> - * only exists for the purpose of not regressing mac80211.
> - *
> - * For now, drivers can restrict the set of allowed channels by either
> - * not registering those channels or setting the IEEE80211_CHAN_DISABLED
> - * flag; that flag will only be *set* by this code, never *cleared.
> - *
>   * The usual implementation is for a driver to read a device EEPROM to
>   * determine which regulatory domain it should be operating under, then
>   * looking up the allowable channels in a driver-local table and finally
>   * registering those channels in the wiphy structure.
>   *
> - * Alternatively, drivers that trust the regulatory domain control here
> - * will register a complete set of capabilities and the control code
> - * will restrict the set by setting the IEEE80211_CHAN_* flags.

I think you shouldn't remove that but just rewrite it to make the driver
trust crda instead of this code.

> + * Another set of compliance enforcement is for drivers to use their
> + * own compliance limits which can be stored on the EEPROM. The host
> + * driver or firmware may ensure these are used.
> + *
> + * In addition to all this we provide an extra layer of regulatory
> + * compliance, however, that of what is provided by CRDA. This tries
> + * to ensure we remain complaint by not letting the user up front try
                          ^^^^^^^^^ heh

> + * to set their wireless device to settings we know we shouldn't be
> + * setting to. We also disable channels on the driver which we know we
> + * shouldn't be using in current regulatory domain. This is because
> + * some drivers may have outdated EEPROMs or no regulatory control at al=
l.


> +static int freq_in_range(const struct ieee80211_freq_range *freq_range, =
u32 freq)
> +{
> +	if (freq >=3D freq_range->start_freq &&
> +		freq <=3D freq_range->end_freq)
> +		return 1;
> +	return 0;
>  }

That needs a bandwidth check I think.
=20
> +++ b/net/wireless/reg.h
> @@ -0,0 +1,56 @@
> +#ifndef __NET_WIRELESS_REG_H
> +#define __NET_WIRELESS_REG_H
> +
> +extern const struct ieee80211_regdomain *cfg80211_regdomain;
> +extern const struct ieee80211_regdomain *cfg80211_world_regdom;
> +
> +struct ieee80211_freq_range {
> +	u32 start_freq;
> +	u32 end_freq;
> +	u32 max_bandwidth;
> +};
> +
> +struct ieee80211_power_rule {
> +	u32 max_antenna_gain;
> +	u32 max_eirp;
> +};
> +
> +/* These must match CRDA regdb.h reg_rule_flags. nl80211
> + * must also be synced. */

I think we should use the internal flags directly in nl80211 and have
nl80211 use flag-attributes in a nested flags attribute (see how monitor
flags work) and not rely on any shared bit meanings with userspace.

> +struct ieee80211_reg_rule {
> +	struct ieee80211_freq_range freq_range;
> +	struct ieee80211_power_rule power_rule;
> +	u32 flags;
> +};
> +
> +struct ieee80211_regdomain {
> +	u32 n_reg_rules;
> +	int pgp_signature_check;
> +	char alpha2[2];
> +	struct ieee80211_reg_rule reg_rules[];

Make that a pointer instead so we can declare the array and point to it
and use ARRAY_SIZE().

johannes

--=-jJdRmCLOG9ltgsGgq7/r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUOFGAAoJEKVg1VMiehFYUrMP/1mDM9e0VbJXLO+0RTzBjoDZ
8eq6N7k+Bherd2Le9xD/oyv5QqHvhy8sjFg+uW57BuDfISHNil8j06DEzOPgqbk6
i94inWf66kz00+d4h74tm+hxHuvwt/+o4plNUiQx5ybYrQLqElAYHmIv26HuJbUk
7toCY5UO5hdUsJv8inKOOu9CrvBGDZYB3LEpYKtDi9wscF1EeLDhJhR0l/qq3eal
kzQipYhoygNJDAMOBfNTl9MNm/UV6cI41n3edQ0CSFb3TyE0Xh3UlF3oEQWomLdA
8isA7u7h3FpVs4tEFfezUjp1oUJEJc+3ywvFC57rZxtf6G6TeKmq/z84HI95fi+2
SxRQBvgw7pn+XFmlUA/fY2vcFghLWA2+OphYOA8Lg11ewK1YkhDee/HF6eaFjIj7
4AWCKLqit9izZ0fca/Drva/n2Ht2It7vJ1wY1LIpVL2foerw66pxXvUqpHoLRB7R
zatXzruNTJuPz6DpxXFT4//tbDbtOgh/hDU4wDoFuJO/68JUM47BgXWjtI7NbjxO
Zd7qJYdjr+Ks6/XQbSg++3tO7+l4dCE2ghP+kwsG5ssamCiW5mi7Y6SVn1Ws6g5q
hOQ0k/uzwgaME2KfMdmi5Ejqr1FWO1kI+SMIBOHb7LkNSXDeUbJZTHCILwXXjumD
6EHITMNyR4MhveGePKhh
=8GTJ
-----END PGP SIGNATURE-----

--=-jJdRmCLOG9ltgsGgq7/r--

