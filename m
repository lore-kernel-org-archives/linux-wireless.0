Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689Ab2HBCyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 22:54:16 -0400
Message-ID: <1343876035.4642.92.camel@deadeye.wl.decadent.org.uk> (sfid-20120802_045431_840309_4D4CB25C)
Subject: Re: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	liang.li@windriver.com
Date: Thu, 02 Aug 2012 03:53:55 +0100
In-Reply-To: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
References: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wZV5t44Yh5dRbix83po3"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wZV5t44Yh5dRbix83po3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-08-01 at 12:14 -0400, Paul Gortmaker wrote:
> Normally a single patch doesn't warrant a 0/1, but Liang did some
> digging on this problem and came up with important background, and
> several possible solutions, so I wanted to capture what he'd learned.
>=20
> The issues with creating an ad-hoc network started in 3.4.3 with the
> cherry pick of 463454b5dbd ("cfg80211: fix interface combinations check")
> on intel hardware (iwl-mac80211.c) that doesn't support multi-function
> or virtual interfaces.  Specifically, it adds this:
>=20
> +               if ((all_iftypes & used_iftypes) !=3D used_iftypes)
> +                       goto cont;
>=20
> and we have the case for Intel cards that all_iftypes equal to 0b1100
> but used_iftypes equal to 0b0010 hence we hit 'goto cont' to miss the
> 'return 0' and now get EBUSY.
>=20
> Liang identified f8cdddb8d61d ("cfg80211: check iface combinations
> only when iface is running") as part of the fix (now in 3.4.6)

3.2.y also has the above two changes, so presumably also has this
regression.

Ben.

> However, things still weren't right unless he also cherry picked the
> 8e8b41f9d8c8e6 ("cfg80211: enforce lack of interface combinations")
> to get the later mentioned "total =3D=3D 1" check within, so that we
> avoid the EBUSY above.  But this commit causes other regressions
> (as described in the commit log of the attached patch) so we didn't
> think it best to go that route for 3.4.x.
>=20
> So, the options we considered (to fix 3.4.x stable) were:
>=20
> 1) cherry pick 8e8b41f9d, and all the driver specific changes it requires
>=20
> 2) make a sub-commit for stable that just takes the total=3D=3D1 from #1.
>=20
> 3) patch iwlwifi/iwl-mac80211.c and add ".types =3D BIT(NL80211_IFTYPE_AD=
HOC)"
>=20
> 4) treat ADHOC as a universal feature that everyone has.
>=20
> The following patch does #4, and in theory it could be used in mainline
> and then cherry picked back to stable.  But we weren't 100% sure if that
> was the best solution, since neither of us are really wireless people,
> hence all the detail here.
>=20
> Thanks,
> Paul.
> ---
>=20
> Liang Li (1):
>   cfg80211: fix combination check for ADHOC
>=20
>  net/wireless/util.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-wZV5t44Yh5dRbix83po3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBnrw+e/yOyVhhEJAQoA1g//TIwnN0V/40DkvlanQa4hqKGSry/bWYh3
MOoQPWBEkzjhUsqtT+nrgNgjS4vruQZJ0MYPhDFdrjoS4zJr6qdJSwV5JqhQ6VcH
fwhFXtSQ16ocdnneQgPwE7pqh1NvLW8DgqU0PnUiPP0wGtkk60w5PWR1YdZ6fF6Y
K151/PvN7P1vIvMoYlcVUT/lpyGh1lzCA4mmrJbzhrqOO2crpWpaQl1cRSUnajVX
ZOBpzCCtvSl1SCcAO0KJ4kqCHFAl5hDbYDGw/GYzHCDuRo3Aps7PZ8fh2oOOCKWV
6Q62Iv2C2zDYHrEWiShB77cJ+y1j3A4TVaDuxAzW38P+aYjzdJnpev6SwP1DMU+G
DT3xWyobOzsmlNzWwpOdjHU+IVik5V5KAbMTtWXVQL32OaGABZodLfDig82ERwcs
XViSwfj2X1/7CetbEHjzGijmesYsODqGqftfZk2cRVcwU7rjFhpH3s5s9gK008pe
ufC2zfBqp08KyPSP4VcI/q1WFoBjfIyCemmXvDQhnsZt7RgQ25/hU0gLc7CgwBKy
491G5+p1QXSOmClxOt1nv5HkSRGZ5JunDNOTO1MvywxPTzckNu91lpZZa4gxSbCr
J3LccXjvqVYHSsk817s82bRJGosYbwrPZDNgxGspaRX3LVsM59nYL0vEauVDCy6P
uT+s0OLOdQA=
=kcfs
-----END PGP SIGNATURE-----

--=-wZV5t44Yh5dRbix83po3--
