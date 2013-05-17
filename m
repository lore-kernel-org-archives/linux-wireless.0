Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47864 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3EQJ6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 05:58:34 -0400
Date: Fri, 17 May 2013 11:58:25 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv2 00/18] Add support for 5 and 10 MHz channels
Message-ID: <20130517095825.GA1555@pandem0nium> (sfid-20130517_115837_832828_897E22A8)
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAJ-VmonrfSx6KLjNdPwtV_8q=Jmjz9KRSYmoLSXt7yocU=y35A@mail.gmail.com>
 <20130516114028.GA27887@pandem0nium>
 <CAJ-Vmo=39cS38UCDeQrdJ7x-t=cyr8cnsf3G2opxyeY3KzWLUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
In-Reply-To: <CAJ-Vmo=39cS38UCDeQrdJ7x-t=cyr8cnsf3G2opxyeY3KzWLUg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Adrian,

On Thu, May 16, 2013 at 08:34:39AM -0700, Adrian Chadd wrote:
> How about I setup a couple of FreeBSD devices with 5/10MHz operating
> modes and dump the beacon IEs, probe request/response and assoc
> request/response?
>=20
> That way you can see what the rate table entries look like.

yeah, that would be cool to compare the IEs and see if this looks similar.

Maybe I can do the same for the Linux IEs too, just for reference.
We basically enable it only if 802.11a or g is supported (802.11b is not
supported), and announce OFDM only rates. The rates are divided by two or
four (for 10 and 5 MHz), and rounded up. That's pretty much the only
thing which is changed to 20 MHz.

BTW, how is HT handled for narrow channels in FreeBSD? Do you just send
HT IEs as they are in 20 MHz? Also, do you disable secondary channels?
(I would probably do that, using two adjacent 5 MHz channels should be
replaceable by one 10 MHz channel ...)

Thanks,
	Simon

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGV/0EACgkQrzg/fFk7axbLvwCg6lSKwLZG2vZBV1CjJ2/5vSuL
Q1AAnRQV1SBvXEtr58j320NTLBshpzWE
=9904
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
