Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbXHFIMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 04:12:40 -0400
Subject: Re: [PATCH] mac80211: allow drivers to indicate failed FCS/PLCP  checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <200708041425.29112.IvDoorn@gmail.com>
References: <1186177475.13315.10.camel@johannes.berg>
	 <200708041425.29112.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M3bf+oEL00ON9DH6t930"
Date: Mon, 06 Aug 2007 10:07:20 +0200
Message-Id: <1186387640.28655.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M3bf+oEL00ON9DH6t930
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-04 at 14:25 +0200, Ivo van Doorn wrote:

> The package descriptor knows 3 kind of errors for a received frame:
>=20
> 	CRC error
> 	Physical error
> 	Cipher error
>=20
> For the CRC error I don't know if that is the FCS or PLCP error..

CRC is most likely FCS. And Physical ist most likely the PLCP CRC.

> For the cipher error it could perhaps be possible to send it to mac80211
> without the RX_FLAG_DECRYPTED bit set. (At the moment rt2x00 doesn't
> see this error yet, because hardware encryption is not yet implemented).

Not sure what mac80211 does for crypto errors, I expect you want to send
them up without having it decrypted, it'll attempt it and then do the
appropriate actions. Seems it should be possible to short-circuit that
somehow, but I don't know if it is right now.

johannes

--=-M3bf+oEL00ON9DH6t930
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtta4/ETPhpq3jKURAvTJAJ0d3EsjbnrkbsYpECeFrk7JMJUixgCePmhn
0QmxKR0kYNGV5yzMI19TYY0=
=BEBw
-----END PGP SIGNATURE-----

--=-M3bf+oEL00ON9DH6t930--

