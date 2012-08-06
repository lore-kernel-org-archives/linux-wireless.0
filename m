Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48482 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948Ab2HFBBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 21:01:07 -0400
Message-ID: <1344214853.13142.81.camel@deadeye.wl.decadent.org.uk> (sfid-20120806_030140_635512_6DADE5F2)
Subject: Re: [PATCH stable] cfg80211: fix interface combinations check for
 ADHOC(IBSS)
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Liang Li <liang.li@windriver.com>, stable@vger.kernel.org
Date: Mon, 06 Aug 2012 02:00:53 +0100
In-Reply-To: <1343948141-25005-1-git-send-email-paul.gortmaker@windriver.com>
References: <20120801175816.GB13879@windriver.com>
	 <1343948141-25005-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dOIg92ATsmk4h7QCvGOG"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dOIg92ATsmk4h7QCvGOG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 18:55 -0400, Paul Gortmaker wrote:
> From: Liang Li <liang.li@windriver.com>
>=20
> partial of commit 8e8b41f9d8c8e63fc92f899ace8da91a490ac573 upstream.

Added to the queue for 3.2, thanks.

Ben.

> As part of commit 463454b5dbd8 ("cfg80211: fix interface
> combinations check"), this extra check was introduced:
>=20
>        if ((all_iftypes & used_iftypes) !=3D used_iftypes)
>                goto cont;
>=20
> However, most wireless NIC drivers did not advertise ADHOC in
> wiphy.iface_combinations[i].limits[] and hence we'll get -EBUSY
> when we bring up a ADHOC wlan with commands similar to:
>=20
>  # iwconfig wlan0 mode ad-hoc && ifconfig wlan0 up
>=20
> In commit 8e8b41f9d8c8e ("cfg80211: enforce lack of interface
> combinations"), the change below fixes the issue:
>=20
>        if (total =3D=3D 1)
>                return 0;
>=20
> But it also introduces other dependencies for stable. For example,
> a full cherry pick of 8e8b41f9d8c8e would introduce additional
> regressions unless we also start cherry picking driver specific
> fixes like the following:
>=20
>   9b4760e  ath5k: add possible wiphy interface combinations
>   1ae2fc2  mac80211_hwsim: advertise interface combinations
>   20c8e8d  ath9k: add possible wiphy interface combinations
>=20
> And the purpose of the 'if (total =3D=3D 1)' is to cover the specific
> use case (IBSS, adhoc) that was mentioned above. So we just pick
> the specific part out from 8e8b41f9d8c8e here.
>=20
> Doing so gives stable kernels a way to fix the change introduced
> by 463454b5dbd8, without having to make cherry picks specific to
> various NIC drivers.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Liang Li <liang.li@windriver.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>=20
> 3.0.35, 3.2.21 and 3.4.3 have CP of 463454b5dbd8 in them.
>=20
>  net/wireless/util.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index b5b6890..88bd89e 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -974,6 +974,9 @@ int cfg80211_can_change_interface(struct cfg80211_reg=
istered_device *rdev,
>  	}
>  	mutex_unlock(&rdev->devlist_mtx);
> =20
> +	if (total =3D=3D 1)
> +		return 0;
> +
>  	for (i =3D 0; i < rdev->wiphy.n_iface_combinations; i++) {
>  		const struct ieee80211_iface_combination *c;
>  		struct ieee80211_iface_limit *limits;

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-dOIg92ATsmk4h7QCvGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUB8XRue/yOyVhhEJAQqM6hAAtxR0MYgXLZRyE7s0BWpW3tU0vkYUMiTA
EGPEyC030MUnFMwhcYy+M6VdYwbFLOJB9/XoWklsBWLq7inGrkVNLkIrVrC84vj6
85j/ZA2QA5wcH3tUNoXbTej3froCDHg9GoAwXSkT8AY7mmS1p4CSkujOQ2tt+cft
D1xvTzBjvF5mDjs5Nqu7dwZmsIgX0JwnKpqTRJq6TXS3HZpO4nYo1AQM4LQq9EsY
db6H3k9b9eiFkn/6nLMabTGX5n4VYz3vWxaEjZ5o9KgrkLxcd+q2edBni9qm8e4G
h8ofahilqSWc8iw3vj/NOo6Fwe1fwCmyokkPpPGkyLITdv5ZWX8Nb0GmlY1hkyVW
/evkhp8CSoR8zY/m7OD7eKFL68nrGrQ0OSr900arUStkcNM79LnSVtUESnPpeQam
DspwvCHGJtFgKh0NaoCYo6FmycNq0fCJAE9Rcgq95MpggDKt+uwkC5TlFUhxn7va
DhbZUyygbAJjyZrXfAwD5PQJFzMqqiYDdnt+Y+YUwz7gEh5sLT+XK81dDD9KDU/l
GmWzuAvn7rHJWaG2UP0LGn+FpNORqFidPitIXVBHK4vcjEIhbQQf8TkAXSefpTw8
ag4wFE1qKanVQtaomTDKS4GM6X2S04bcm8mEsStYceMlHIC1dgfXIR/86mamsYEg
rdDqosAgliA=
=TDrI
-----END PGP SIGNATURE-----

--=-dOIg92ATsmk4h7QCvGOG--
