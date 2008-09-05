Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbYIESqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 14:46:42 -0400
Subject: Re: [PATCH 1/2 v4] cfg80211: Add new wireless regulatory
	infrastructure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1220636669-8153-1-git-send-email-lrodriguez@atheros.com> (sfid-20080905_194500_513265_30B190C5)
References: <1220636669-8153-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20080905_194500_513265_30B190C5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cOnEYqzo6OnVuUHnmmug"
Date: Fri, 05 Sep 2008 20:46:29 +0200
Message-Id: <1220640389.11109.15.camel@johannes.berg> (sfid-20080905_204656_898473_947C48C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cOnEYqzo6OnVuUHnmmug
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +enum nl80211_reg_rule_flags {
> +	NL80211_RRF_NO_OFDM		=3D 1<<0,
> +	NL80211_RRF_NO_CCK		=3D 1<<1,
> +	NL80211_RRF_NO_INDOOR		=3D 1<<2,
> +	NL80211_RRF_NO_OUTDOOR		=3D 1<<3,

> +	NL80211_RRF_DFS			=3D 1<<4,
> +	NL80211_RRF_PTP_ONLY		=3D 1<<4,
> +	NL80211_RRF_PTMP_ONLY		=3D 1<<4,
> +	NL80211_RRF_PASSIVE_SCAN	=3D 1<<4,

That seems a bit wrong?

> +	NL80211_RRF_NO_IBSS		=3D 1<<8,
> +	/* hole at 9, used to be NO_HT20  */
> +	NL80211_RRF_NO_HT40		=3D 1<<10,

and I'm still not sure we should be using the same bit assignments as in
the userspace part, that'll just make people think we have to do that,
while we don't really, I'd rather see a clean set here and have the
userspace code contain an internal mapping from its values to the kernel
values.


> +struct ieee80211_freq_range {
> +	u32 start_freq;
> +	u32 end_freq;
> +	u32 max_bandwidth;

u32 seems excessive for the bandwidth, no?

> +struct ieee80211_reg_rule {
> +	struct ieee80211_freq_range freq_range;
> +	struct ieee80211_power_rule power_rule;
> +	u32 flags;

a note what those flags are would probably be good.

>  	u16 center_freq;
> +	u8 max_bandwidth;

and here you're using u8 anyway :)

> +extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by=
,
> +		const char *alpha2, struct ieee80211_regdomain *rd);

generally extern is left out at least in code I did, but I don't care
much; however, why is this one exported in the global header file?

> +		/* IEEE 802.11b/g, channels 1..11 */
> +		REG_RULE(2412-40, 2462+40, 40, 6, 27, 0),

that's wrong, should be -20/+20, same for all the others. Also, doesn't
it have to be in KHz? I can't really tell right now.

> + * In addition to all this we provide an extra layer of regulatory
> + * comformance. For drivers which do not have any regulatory

typo, conformance

> + * Note: When number of rules --> infinity we will not be able to
> + * index on alpha2 any more, instead we'll probably have to
> + * rely on some SHA1 checksum of the regdomain for example.

don't understand?

> +	/* ASCII 0 */
> +	if (alpha2[0] =3D=3D 48 && alpha2[1] =3D=3D 48)

You could use '0' instead of 48 and save the comment :)


> +				if (alpha2_equal(alpha2,
> +						cfg80211_regdomain->alpha2))
> +					return -EALREADY;
> +				/* Driver should not be trying to hint
> +				 * different regulatory domains! */
> +				BUG_ON(!alpha2_equal(alpha2,
> +						cfg80211_regdomain->alpha2));

Huh? Doesn't that like always trigger due to the if above?

> +EXPORT_SYMBOL(__regulatory_hint);

For whom does that need to be exported?

johannes

--=-cOnEYqzo6OnVuUHnmmug
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwX6CAAoJEKVg1VMiehFY2kkP/35jpHgyB/eip8J/kFwura0o
b/NefM4OP45tBANzPP4rQV+dUT3q62i6pisT3DeTwRAgZJDmnuiZM2I4zpAfGMbC
ynEjnPkzcIiyKsEGsZDFlMbW4j9xKcofy7LYLKLfMGx8RE0nzH6UTGfN9y1UX3yR
6okLk0X4qKgJqnJrEacCn5dzWrlYtS4ECVkv/7oIdVp6q8sMwTw9hAMJVcN+D59p
FmS8Pf+Yvfe6XLsHAL82tkTz9wG1ywKrrCw5sjEUa46ix8oNKbohsM6yq0dv6wEU
QLB3cPyDWNxE6ByvBP3WVMjLX73VdlPaochKDtxkJBE/APrqLExzsD3uiLkxeqqp
m0OmaMlyrteN7icOUAXKnqH8WmzmQl3b6jQn+CWsxp9OvU0WzVC8HMMIAkdvjvEd
F5c5Jvj2Bgy9Wi+ZUEwWbLZIT9CqcECvvXFTObsndXuVxRPX1HZNnx4EHzxI9qSl
CC4KdCh1jTCT5TGcf90T0cA2k6c8F0loW5eq2xhGScUGWn4/DemELMjYTSNlqGnm
TNFqqFeslsvyAUhO09Z0TOzfzDzbyWAxVQcdqf0oM1PYdHyTvrw6/L5aLe0XLt/b
NuvnjnU1dRH6SufOrbl8n6mTWc9LB4jWGqn5jYKYfyTCGB7CR22zzTkrwoeMFXs7
utRCebCRjpyLvTzX+xws
=7ZM+
-----END PGP SIGNATURE-----

--=-cOnEYqzo6OnVuUHnmmug--

