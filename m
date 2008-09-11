Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYIKKzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 06:55:07 -0400
Subject: Re: sta_info->fail_avg
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <445f43ac0809102215w2637dff7sa2c60dd8c31ccf6@mail.gmail.com> (sfid-20080911_071515_093032_4655B850)
References: <1221091198.3804.55.camel@johannes.berg>
	 <445f43ac0809102215w2637dff7sa2c60dd8c31ccf6@mail.gmail.com>
	 (sfid-20080911_071515_093032_4655B850)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TrBhvBSf3zNjd8Nyuqhf"
Date: Thu, 11 Sep 2008 12:54:31 +0200
Message-Id: <1221130471.6986.15.camel@johannes.berg> (sfid-20080911_125513_326280_BA2DCE2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TrBhvBSf3zNjd8Nyuqhf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Javier,

> It is used to estimate the average retransmissions that will be
> required to send a nominal frame over a given peer link.
> That's one component of the airtime link metric.

Ok.

> > I do know that neither ath9k's nor Intel's rate
> > control algorithms ever set it so it'll always be zero.
>=20
> In that case transmission failures will not be taken into account and
> nodes with that hardware will report a lower (better) link metric than
> what they should.  In other words, those nodes will attract mesh
> traffic, which will provide a strong incentive for the driver
> maintainers to set that value correctly :)

Heh, ok. I've been trying to reduce the amount of stuff the rate control
algorithm needs to do, does this need to be in the rate control
algorithm? It seems that the we simply calculate

pf =3D spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;

and

fail_avg =3D ((pf + (spinfo->last_pf << 3)) / 9);
(in a fixed-point format that has more precision)

and we could do all that in the generic code if we get proper
information from the driver. Anyway, for now I'll leave it as-is.

johannes

--=-TrBhvBSf3zNjd8Nyuqhf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyPjkAAoJEKVg1VMiehFY/+YP/0EY/aNAcdEhScGPqOkqNpcW
3yOv9USGNHIpuipVqQz4eIwkFBClLtwIxyzgioCAXjhQLDryaPr8oth8v7ILxjzC
F8NkdKVt5Dz+3bZFTtdTdawVFwZJUzs4sXr3O7XP9VzK/QfDawhbViCuQccmC9BT
wyAVGh3F4cR9mrfzC5efqETKsrTwGYmSc5ZDT6fEWo6wilMEmdLJoiukHRg6+5my
xV2DqnrH1OXwYtUbmkO5I3Fx2Ez7LPq2Z2iS6PzcnbdG/hakxuBg2qbz80ghgCD0
CCdq/56XVtpv8BYN7eXI6N7j5WPPPHrdT3nu0lpsXziXVEjrNvWob0Wp52McPlJ/
k0ss1DX7nJL0QCCPaJpt/q+AjaIaZ3jkUyOyLQdWL5vPP0tegmWlu7RLOLpTA7Gp
bpVPqNM3eOjalUNdJ1uQpaE4xgRMzNIB3QZxE1y1zm9wAuPirr9AAfKhVtxniJsd
T242ViCU8lOhAYoTipdB7/TdL7hs1lJHlrqHBgrMWffos7cKL6woj7a5HXbgpt37
AskOoGmxrq/WqOlVUwiWzhYkg7VzKI5qcra01MW7RVVmY2psQLkyIan0mlp6TMj9
OjtJo+97PV0kldmG343oBZkML9M41i0Ozx18nE4XdqpkoTOvLh5jJVMHaGISbPO4
2IF086ebXznYYV0zdPaW
=Rugb
-----END PGP SIGNATURE-----

--=-TrBhvBSf3zNjd8Nyuqhf--

