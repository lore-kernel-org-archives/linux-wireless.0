Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXLQRsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:48:04 -0500
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
References: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OBwKGu49XRmIa8opO27R"
Date: Mon, 17 Dec 2007 18:46:15 +0100
Message-Id: <1197913576.4885.57.camel@johannes.berg> (sfid-20071217_174813_405474_7E486BBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OBwKGu49XRmIa8opO27R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ron, sorry, totally forgot about this patch after asking about the macro
that doesn't seem to exist after all.

On Mon, 2007-12-10 at 11:16 +0200, Ron Rindjunsky wrote:
> This patch fixes should_drop_frame function to pass in ps poll control
> frames required for power save functioanlity. Interface types that do not
> have interest for PS POLL frames now drop it in handler.

Taking a closer look...

> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
> +		return TXRX_DROP;

Should we maybe do the test explicitly for when we want it, i.e.
AP/VLAN/IBSS cases? Just thinking of the mesh networking stuff etc.
that's being added...

Other than that, looks fine.

johannes

--=-OBwKGu49XRmIa8opO27R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a15qVg1VMiehFYAQKbsQ//bgcTgdRfSfzOhyq2ZPwDvqWv9gM1798b
OJwryeewtpDTsJtvbWHZzqkPOSlX0K1NpkdoPMTYC61xNg58n32YrbCB3JgpsA25
YvCowhKT/hsOlD3PTUP0lphIf2PIGyKg2AQBJEEVWs3H7gIM/e+p8NoMO/aRWaQX
Bdd/chGg9d0FcBrxn3cKWlh5wjQZoy+VPA28rul3Lu3l3wFXtacaBn8UZ6MOhqrz
YsfwVHaGITQ9i6+AfZ6dwpkdmkF/WCfeyrpo1ib+Qt/5FQ/xgG16VHSM19/6PhVX
YKRFFZZtffOKZD7OG4MHZSui95Fm5QiARDfM9bxPqgoNZz37hrCPHEG3WSue6qWh
rRB9drQ5jAILtf5FlldR+TsbXiO3iVllk6aY/H9mgGU3w+YhizCzwGlFpGXECjNZ
BrYkKd/e5oI1+uDfcGMJU56MOhTQOwqGIKh+DSj81I1tA26qxfcjbDRArDYvLvb8
O9k91JzrOm5Ash0N20ZVFXFA/11KP+E2c8MmpSbjtfaGN46avAuN69P7P6r6ILrm
xPH9MBZgqt+h7pkGd69KUpgdhamj96xVpLKTrJA8x5WM2LzdiGLUmQKsZX8IBXI8
inR+raq3utuHJssQKkhylq4L+OJmTYT7iIAZTTCGeLbtI75V/fdMMxSDVj8uF592
HOUeHWJlkTc=
=zjpj
-----END PGP SIGNATURE-----

--=-OBwKGu49XRmIa8opO27R--

