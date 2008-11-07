Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYKGVGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 16:06:03 -0500
Subject: Re: [PATCH v2 2/3] cfg80211: mark regdomains with >
	NL80211_MAX_SUPP_REG_RULES invalid
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1226004327-10290-3-git-send-email-lrodriguez@atheros.com>
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
	 <1226004327-10290-2-git-send-email-lrodriguez@atheros.com>
	 <1226004327-10290-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hb33147q3hvAV/MUa4Jy"
Date: Fri, 07 Nov 2008 22:06:02 +0100
Message-Id: <1226091963.11203.12.camel@johannes.berg> (sfid-20081107_220608_206929_1216091A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hb33147q3hvAV/MUa4Jy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 12:45 -0800, Luis R. Rodriguez wrote:
> Lets remain consistent and mark rds with > NL80211_MAX_SUPP_REG_RULES
> number of reg rules as invalid in is_valid_rd().
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Seems fine, if that's not userspace triggerable, but it isn't, right?

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f8e7beb..f0ff3d1 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -352,6 +352,9 @@ static bool is_valid_rd(const struct ieee80211_regdom=
ain *rd)
>  	if (!rd->n_reg_rules)
>  		return false;
> =20
> +	if (WARN_ON(rd->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
> +		return false;
> +
>  	for (i =3D 0; i < rd->n_reg_rules; i++) {
>  		reg_rule =3D &rd->reg_rules[i];
>  		if (!is_valid_reg_rule(reg_rule))

--=-hb33147q3hvAV/MUa4Jy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFK23AAoJEKVg1VMiehFY9d8QAJLhhb9IrrwhJbg4F1tkF7/+
iMzxod93MO3LFqor44jKZjCwUjTBPpjrcfiLYUoqFd6mLqwdYjyXmipPc+sV45zK
wDD09l5GmGLnRPyxk8a1swJdLbiZyuus94QwjrXU+6kD4idpPO/YzFJF/MWvpJq+
c6s0yvg7UzVsRtvlxSoASPWTStx7i9lzeWmnRZmSrUmp6mm7Z4RLVoSNyttzVIiG
4fBXzdPC9L0TDO2wrxKL95FXr8C4QMkS8Cs2Hn5NnbjhB9p5QV5BMRf23Hl5KgFE
yChIvZuBBmOme3DiQEaDKnZi1k1zOcMrIRtjkqBpoNB/8W8adndqf06H/rSOWbL+
2Zgg+zFH97vTXYmcREjsuo6bVGcdfQj8b/j0VPYVoKTJF5tKdgwz3iLDmLZkqvuh
TNZl1/wxWWBvhRIpZCLFYBrTFt1j8RTpKJpxP0Q401MPo1Ti8cK5CJxDMpNTPPep
9Uz1MTClhPTvB1VwIW3VLcY0Mkbw4smtRSOOhKKLIHvYPAaKrdz7LZogj4kkGEPf
Qf3CdqSFea3SSyiRnHEap1wH2uRTGY+Wa4qGeQKI0ItI1MCS9csky2bViue5Wem+
Qc4E0IjoXd1AGEfmfgzHRRlod0i+g0g5871rCU9ywpynqyhb8y3wJSSUiiMxBLMA
NNihyiaHOVQxch/P3JQi
=Sve0
-----END PGP SIGNATURE-----

--=-hb33147q3hvAV/MUa4Jy--

