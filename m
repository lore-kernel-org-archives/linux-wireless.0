Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYBYVbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 16:31:01 -0500
Subject: Re: multiple scan request handling (was: <empty>)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203974559.22949.19.camel@localhost.localdomain> (sfid-20080225_212448_530739_B0BC8ACF)
References: <1203974559.22949.19.camel@localhost.localdomain>
	 (sfid-20080225_212448_530739_B0BC8ACF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4LE5EHgU+p2ekkmU/Cei"
Date: Mon, 25 Feb 2008 22:30:52 +0100
Message-Id: <1203975052.13162.179.camel@johannes.berg> (sfid-20080225_213132_180831_D237C07C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4LE5EHgU+p2ekkmU/Cei
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> In the ideal case, the driver would add each separate scan request to a
> queue, execute each request in turn (respecting each requests options
> like active/passive, dwell time, SSID/BSSID, channel list, etc).  Each
> request would trigger a corresponding scan completion event. =20

I'm not sure that each separate scan request should be added, if they
just differ a bit wrt. dwell time, especially if the second requested
dwell time is larger, I think they shouldn't necessarily be batched.

> Perhaps
> multiple identical scan requests (ie, a few 'iwlist <iface> scan') could
> be batched together for efficiency. =20

Yeah at least when they're identical.

> With nl80211/cfg80211, perhaps each
> individual scan request would have a UID to match it up with a specific
> scan response (but the response would still be broadcast too).

That would certainly be doable although it seems that including the scan
config in the response might be better?

It seems reasonable to require some sort of queuing especially when it
is possible that, like you experienced, automatically triggered scans
don't allow manual ones to go through.

Maybe that should ultimately be done at the cfg80211 level already?

johannes

--=-4LE5EHgU+p2ekkmU/Cei
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Mzi6Vg1VMiehFYAQKZYhAAhtRUOFcRK6SGvtNwcFDG1pA2id7207ts
0nu4fjpH45zmoMPwOBsTn5yki9RfiAtFwFRBSDYdbRFTV21EW/bbjJZ3tjDEw2jz
RbUjkPGD6V5vBkxASZIJXTjbsvapzfF8iac1weT4EHtvtGfvL8rQDuNYl2UWwy97
G+Hden1dDRRSmsUjeCc6HVIb6jqAycxf6VvH0/VTF0R7LCd4jdcJtvg4Uw0Qz/2z
u3/kSTGCKSGQxD9P+IfreuU3q4pCDdulrGalDH1qQMa/dudOBzKMKhGMt2R9cZCO
MdHOuFV2RKaliVSAjb6avrXkBfJ9vtXDi3HUziMx3W0zF32npEL/UGD+IhP+4lkp
PCqlfiokPuioTBv8xG+42oCdCc8Fi00uG55+CbIYym+d6eTGIuQ16Vjxj1CY+Jff
k7pbLTDvseElAsyw6F11wg0ZR8drNJVtWKDhtgZ95vjpwGE7qejh6y7MwLXD5ODR
Nnu11N5lGgoRg+2y2t6wCmfMiZdAbjLZaKBXVI3lU/kiq/cOBwKH5PZSUCi7wc/3
1UdNCixf/n12yyCmJvPXpGAtA85Nin4qO4HNJixqe3RiIzmG2GL9UiW4z4wIbQP9
XWJtUIRj5SNXeT5H1rSMIvDikbcHaDiaTaFdHcJ2Lk1MWrODcvqKgCgnwBg/KRvi
yauAmvHH70M=
=TOtR
-----END PGP SIGNATURE-----

--=-4LE5EHgU+p2ekkmU/Cei--

