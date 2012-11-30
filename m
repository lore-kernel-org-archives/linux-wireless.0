Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:42566 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2K3NnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 08:43:22 -0500
Date: Fri, 30 Nov 2012 14:43:11 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from
 outside
Message-ID: <20121130134311.GA19037@pandem0nium> (sfid-20121130_144326_668177_C2684689)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354111295.9345.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
In-Reply-To: <1354111295.9345.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 03:01:35PM +0100, Johannes Berg wrote:
> On Tue, 2012-11-27 at 19:50 +0100, Simon Wunderlich wrote:
> > It can be useful to set own WMM parameters from outside, otherwise there
> > is no way to change this in Ad-Hoc networks.
>=20
> Having proper WMM support for IBSS doesn't seem this simple.
>=20
> What about IBSS merging? What about adding WMM IEs? etc.

I couldn't find anything on this in the IEEE standard - it only talks
about infrastructure mode, and that EDCA Parameter IEs should be adopted.=
=20
(Although I doubt that's a good idea).

All we want here is to locally change the parameters. Seems we are not the
first ones who want to do that [1]. The WMM specification only says that no
WMM IEs is in the beacon and distribution of parameters is missing, and
therefore defaults are to be used.

Therefore, I'd like to go for the local changes only and skip WMM IEs, adop=
tion,
etc.

You have a point regarding IBSS merging - with this change, we would lose t=
he
local configuration with the merge. This could be changed for mac80211,
not sure about other drivers (or if anyone actually cares).

Cheers,
	Simon

[1] http://www.uniroma2.it/didattica/TPI2/deposito/wmm.pdf [page 7, bottom]

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC4t+8ACgkQrzg/fFk7axZcCgCgkVblXOzzgFYaYcM/2giObuBD
8c8AoLQEgOy2C7K+CvbaA1hTC22tK/iw
=cfXA
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
