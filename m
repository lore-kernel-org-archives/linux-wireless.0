Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030866AbXDUNvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 09:51:23 -0400
Subject: Re: [PATCH V2] ieee80211: Output frequency rather than channel in  scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Mayer <jmayer@loplof.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <20070421134210.GA15350@thot.informatik.uni-kl.de>
References: <46299244.Q+HmhPpbYVGidoy1%Larry.Finger@lwfinger.net>
	 <20070421134210.GA15350@thot.informatik.uni-kl.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6uMCpfaWQXZA0I+21MPy"
Date: Sat, 21 Apr 2007 15:54:00 +0200
Message-Id: <1177163640.5941.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6uMCpfaWQXZA0I+21MPy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-04-21 at 15:42 +0200, Joerg Mayer wrote:
> On Fri, Apr 20, 2007 at 11:25:40PM -0500, Larry Finger wrote:
> > +	if (network->channel < 15)
> > +		iwe.u.freq.m =3D 2407 + 5 * network->channel;
> > +	else
> > +		iwe.u.freq.m =3D 5000 + 5 * network->channel;
> > +	if (network->channel =3D=3D 14)
> > +		iwe.u.freq.m =3D 2484;    /* special case for Japan */
>=20
> As you are taking japanese channels into account: How about handling the
>  >=3D 4.9 GHz case for Japan as well?
> See 802.11j-2004.pdf 17.3.8.3.2, 17.3.8.3.3 and table J.3 for details.

How about just adding some sort of table in other common code and using
that. Then you can submit a patch for that table :P

johannes

--=-6uMCpfaWQXZA0I+21MPy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGKhd4/ETPhpq3jKURAvgbAJ9xV//sqkRxenBAXWpEPFTdfD0YdQCfbuyX
jdxUnIZ7w9DGxXF8IfbQ4XE=
=3GU/
-----END PGP SIGNATURE-----

--=-6uMCpfaWQXZA0I+21MPy--

