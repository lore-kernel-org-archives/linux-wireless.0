Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:36295 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab3BTKb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:31:28 -0500
Date: Wed, 20 Feb 2013 11:31:20 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
Message-ID: <20130220103120.GA431@pandem0nium> (sfid-20130220_113134_066277_2D6CFA2E)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
 <20130219134028.GA26332@pandem0nium>
 <alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
 <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
In-Reply-To: <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Adrian,

On Tue, Feb 19, 2013 at 08:31:25AM -0800, Adrian Chadd wrote:
> Well, ANI does adjust some of its parameters based on the beacon
> signal level. It uses that as an estimate for how "strong" the signal
> is likely to be and tunes the baseband to either be highly sensitive
> or slightly on the deafer side.
>=20
> If you have many sources of beacons (read: ibss, mesh, TDMA in my
> case) then that particular feature of ANI can't be used and it should
> be disabled. The code should be special casing it.
>=20
> I suggest someone writes a bunch of test functions:
>=20
> * whether we see no beacons (ie, AP mode)
> * whether we see one set of beacons (ie, STA mode)
> * whether we see multiple sets of beacons (ie ,everything else)

this sounds useful - and easier to maintain than checking each
IFTYPE seperately (we add iftypes after all ...).

Maybe Felix knows more about this? He has ported ANI as far as I know. :)

Cheers,
	Simon

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEkpfgACgkQrzg/fFk7axZblgCcD+oUJ8IS0Oi2FxO7Cn6lDA+F
knsAn1aM0ggOVO5TfmMsFzb+qXzn4xKj
=pSRD
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
