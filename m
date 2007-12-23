Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXLWVyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 16:54:13 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200712232250.12962.IvDoorn@gmail.com> (sfid-20071223_214951_081999_3FC5E533)
References: <1197412922.7030.11.camel@localhost>
	 <200712232217.18941.IvDoorn@gmail.com>
	 <1198445352.4103.0.camel@johannes.berg>
	 <200712232250.12962.IvDoorn@gmail.com>
	 (sfid-20071223_214951_081999_3FC5E533)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-smj3Arrif7WkZIdWpTVh"
Date: Sun, 23 Dec 2007 22:54:04 +0100
Message-Id: <1198446844.4103.3.camel@johannes.berg> (sfid-20071223_215420_282025_D032B217)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-smj3Arrif7WkZIdWpTVh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

> I just checked, only rt2x00 and b43 call the rts/cts functions for ieee80=
211.
> For b43 seems to report the tx status for the rts/cts frames as well.

b43 definitely doesn't, it embeds the rts/cts frame in the TX descriptor
of the data packet and only gets a tx status notification for the data
packet from the hardware.

> I have found the 2 emails that introduced and later reverted the behavior=
 from rt2x00:
> [PATCH 16/26] rt2x00: Correctly handle RTS frames
> [PATCH 7/24] RT2x00: Add RTS frame creation
> They are dated from July 2006, so they were quite old actually :S

:)

> Anyway, I have no objects against not report those frames to mac80211,
> so if mac80211 doesn't want those frames reported rt2x00 can filter them =
out. :)

I think it'd be best since most hw is not even capable of doing it, rate
control algorithms don't care and we don't really want to have them
anyway.

johannes

--=-smj3Arrif7WkZIdWpTVh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR27Y+6Vg1VMiehFYAQIzAxAAk6VuF1CN7jLrp99UhwD9QfsrHa+R1ZXA
IquSuCkTCkSgjhB/cWVRSRwZk9XgdyXflXrYL8BkxqyYldnPLxqsyJ47O6VLOBkp
MNBfOTpxHq2qAlA3PmSkPX7v0w67aRdWBMFlxhE04/mZNRAiZEYNzKh39ShfmR9Y
tbDDRvcXkHgtWSOiyII2ufDD1qFPF8a1pnGs1jxPRee3fHwAGmP9BCrr5LBN98nc
G7Ju2/CcqS6lC6FLDOQBC+uTCua6B12jMgzqkk/+za1sFrBiDpjRhvZYak2tBCb9
ZR+uo7gaB+cp+pxpDX9AHPmFtAHCB2JhVjvMCnisHpHsl8wWn4loyYqvZq7SUBlW
7zfd4Bh0B6bQMkA/aMfSIob9gfK9twfXHllX5XvYvLXaF6muG4/ZspnBC0rGYhLa
gZM7y9Y99WjFztBZQo63Z8ljb7gn9KcDvDaFzYWxeQbAQFXSbtde8YJ48mOEc6gl
HVy4GzSjIypT6kKxAf42RA2UyJPp4lwhEkGF+PDqocpZ/bfQkB5fJI6lK/bdbrVL
YbW1nevvcCSjK59MkjTYMLi2jWzxGVCCDVj+KL5QEW6MQOLmRpalYs5par4XZl+a
JHQKevV/XzqL0bDptvRvEXhIF6+LI3T5rBTWjFDcWCuLIgkxD1XQe9UFW+gGsqX+
Ak5AIG2PjlY=
=+1LY
-----END PGP SIGNATURE-----

--=-smj3Arrif7WkZIdWpTVh--

