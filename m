Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbYIIM2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 08:28:49 -0400
Subject: Re: [RFC] mac80211: make BA session handling independent of STA
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220959762.31304.156.camel@johannes.berg> (sfid-20080909_132937_322957_7D7DFA14)
References: <1220883730.31304.60.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 <1220954146.31304.127.camel@johannes.berg>
	 <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com>
	 <1220955934.31304.133.camel@johannes.berg>
	 <1220956032.31304.135.camel@johannes.berg>
	 <1ba2fa240809090353o1ab1340ck82a9208dd364587a@mail.gmail.com>
	 (sfid-20080909_125320_013382_134F778C)  <1220958109.31304.153.camel@johannes.berg>
	 (sfid-20080909_130159_755464_34E4D68B)  <1220959762.31304.156.camel@johannes.berg>
	 (sfid-20080909_132937_322957_7D7DFA14)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CyVFpFTbHGLtRHa1DXYi"
Date: Tue, 09 Sep 2008 14:28:40 +0200
Message-Id: <1220963320.31304.159.camel@johannes.berg> (sfid-20080909_142907_060859_3EC03653)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CyVFpFTbHGLtRHa1DXYi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 13:29 +0200, Johannes Berg wrote:
> This is what I have in mind, thoughts?
>=20
> Subject: mac80211: make BA session handling independent of STA mode
> From: Johannes Berg <johannes@sipsolutions.net>
>=20
> An AP has to be able to handle aggregation sessions as well, and
> I guess there's nothing strictly preventing WDS interfaces from
> having aggregation sessions.

Ok I think this is a win in terms of code quality, so I'll post this
patch with a slight adjustment to process BA frames only in STA/IBSS
modes as currently (MESH doesn't use 11n yet at all).

johannes

--=-CyVFpFTbHGLtRHa1DXYi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxmvzAAoJEKVg1VMiehFYVMEQALMnt5v1yeiY4LiJGEZv0UvF
7UNu8y8eL7xQmBzZdcbFqilQ84PsIdfszndxUfv4hRknI92RgRW9JN/TDgQwHkXt
IsYvr1dJDH8RFA48jSPprGm79JmxJ478IDRiiqrvqWoAlZN5oMG4JIDhgkplFVvS
lZn+Lrn5XKtZ7UnH8spCvu/PDRQkCsU41KLEHlI9Oc+ooetPN+/XDUHRpONuZmUz
YqKrCPpQckiSgMFjdNpRLdp+7sEDWqP9SXcnyw7Eyvn0Rmm0gKhsUFt1KyaEQ7Zk
7m49eyOkWLpXeOITYZXxSrGFD3b8zPKKJM6aPtyutky2kgw8pJTSHHX0YsbpswuY
q/tCid8S8jXagwRQdQOAtnl9byI6no4gWlL8nCzQ1qjlPwt+4Vq2v4BDD4YzQL++
zrTmO0b4U0WA8gWeW6iYSctWTqxRwYTIZpmDb0v7rHYzykwtBKdOiDydq+nfluGA
rInqfQI/C8Np4ClBok/NvbPIiVcJjanR+CfA0+sEGeGBQqYZafuq+dXC2UXh+nju
LWifNXq9JFCUBgLJadk1NAHCTAgsMknPdjTP8YwyIEkeqcFceAA4nxSCsF7ZSwLy
b98TgZpXgv0WRCHrUS/2W+fup+jwjjxWMppX5hM/H9iIiF2xW1PzT1+Qw+8psqiW
zQYotTRZIE8Ns+heCSkU
=Pz7K
-----END PGP SIGNATURE-----

--=-CyVFpFTbHGLtRHa1DXYi--

