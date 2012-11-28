Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48816 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2K1QMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 11:12:32 -0500
Date: Wed, 28 Nov 2012 17:12:19 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"mathias.kretschmer@fokus.fraunhofer.de"
	<mathias.kretschmer@fokus.fraunhofer.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>
Subject: Re: [ath9k-devel] [RFC 1/3] nl80211: add spec scan flag
Message-ID: <20121128161219.GA6642@pandem0nium> (sfid-20121128_171235_392695_5C40C5B4)
References: <20121128151916.GA6175@pandem0nium>
 <8887AA04B7EC49479420AE48C5F94A930172CD48@NASANEXD02D.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
In-Reply-To: <8887AA04B7EC49479420AE48C5F94A930172CD48@NASANEXD02D.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jouni,

On Wed, Nov 28, 2012 at 03:29:36PM +0000, Malinen, Jouni wrote:
>=20
>=20
> On 11/28/12 7:19 AM, "Simon Wunderlich"
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
>=20
> >The main reason why I wanted to use this function is that it can be used
> >while operation, that is sending power save, forbidding payload tx, etc.
>=20
> Have you looked at the remain-on-channel commands?
>=20

TBH, today was the first time I've had a more close look. :)

> >It seems there is no way to trigger a scan from within ath9k/debugfs,
> >right?
>=20
> I don't think there is nor that there should be.. Do you really need scan
> operating for this? I would use remain-on-channel commands from a user
> space app to go through the channels you want to analyze.
>=20

Hmm, that would be possible as well ... Using the scan function is very
convenient as I don't have to think about cycling, channel lists, etc.
But putting more control to userspace is also possible, if we can ask the
driver to just have a "quick spectral peek" on another channel.

Anyway, you'd suggest to use the NL80211 remain on channel command for that?
Or add a new "spectral scan" nl80211 command to do a spectral scan on this
(or multiple) channels, and use the various functions from mac80211/offchan=
nel.c?

BTW, is there any limitation to remain on channel commands, like will they
work on AP ifaces, Ad-Hoc ifaces, MultiSSID in general, etc?

> >I could also cycle channels within ath9k, but the main problem I see is
> >that
> >I can't turn off TX/go into power save mode from the driver, or would you
> >see
> >anything feasible?
>=20
> Remain-on-channel should take care of that, but yes, that would not be
> triggered from ath9k, but from user space.

That sounds good. :)

Thanks for the hint!
	Simon

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC2N+MACgkQrzg/fFk7axY1QwCdG4Ud4vc7wsSNba+K3Xt8hUAl
iLkAoJH8+Mx50qrCIY1L2EfOX8yZD+/D
=YgfX
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
