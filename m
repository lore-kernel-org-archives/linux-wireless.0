Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52768 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2AJSmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 13:42:31 -0500
Date: Tue, 10 Jan 2012 19:42:29 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv2 2/2] mac80211: add support for mcs masks
Message-ID: <20120110184229.GE19790@pandem0nium> (sfid-20120110_194234_937386_8726F539)
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1325793490-21501-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1326114294.3451.25.camel@jlt3.sipsolutions.net>
 <20120110172832.GA19790@pandem0nium>
 <1326216911.3438.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
In-Reply-To: <1326216911.3438.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2012 at 06:35:11PM +0100, Johannes Berg wrote:
> On Tue, 2012-01-10 at 18:28 +0100, Simon Wunderlich wrote:
> > Hello Johannes,
>=20
> > > All this logic is pretty complex, maybe we could translate the bitmap=
 to
> > > an array of unsigned longs and use test_bit() instead of open-coding =
it
> > > for 8-bit words?
> >=20
> > Mhm, I would rather not add further copies into this fast path function=
, and
> > simply casting will result in bad behaviour (alignment, endianess).=20
>=20
> Well you don't want to copy it, you want to maintain the data that way,
> I think? Ok I think I see -- you're concerned about the masking etc.
> Dunno. Maybe at least there's a way to abstract out all the
> calculations?
>=20

I have looked into bitmap.h which offers a great set of functions for
unsigned long arrays, but unfortunately I couldn't find anything equivalent
for u8. Writing our own u8 bitmap function set would be overkill here (IMHO=
),
and abstracting/hiding these functions into defines or changing everything =
to
unsigned long to be consistent (including ht_caps.mcs.rx_mask) would be ugly
as well.

I also don't consider this piece of code to be beautiful, but would suggest
to keep it for now - or maybe someone else has a better idea.

> > Generally
> > changing the mcs_mask to u32 is possible,
>=20
> No, u64 might work today but maybe somebody will want to use higher
> MCSes in the future?

Yeah, u64 is possible on some architectures too - most of my routers are
32 bit however. :)

Cheers,
	Simon

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8MhpUACgkQrzg/fFk7axbuDQCffP5z4dmjDTv+DmZilJw1oaWR
KwcAn28oUe+pRA7Jyp2QRSfP2KTudYk7
=MW95
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
