Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbXJEOC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 10:02:59 -0400
Subject: Re: mac80211: What is get_sequence_counter?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710051556.27401.mb@bu3sch.de> (sfid-20071005_145719_660926_A6741074)
References: <200710051556.27401.mb@bu3sch.de>
	 (sfid-20071005_145719_660926_A6741074)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fQiO5FpZovlbpiWIoEOu"
Date: Fri, 05 Oct 2007 16:03:24 +0200
Message-Id: <1191593004.7367.32.camel@johannes.berg> (sfid-20071005_150304_138527_70DF26C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fQiO5FpZovlbpiWIoEOu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 15:56 +0200, Michael Buesch wrote:
> What is the get_sequence_counter callback for?
>=20
> 	/* For devices that have internal sequence counters, allow 802.11
> 	 * code to access the current value of a counter */
> 	int (*get_sequence_counter)(struct ieee80211_hw *hw,
> 				    u8* addr, u8 keyidx, u8 txrx,
> 				    u32* iv32, u16* iv16);
>=20
> It doesn't seem to be used in current mac80211 code.
> It seems that this is to fetch the current initial values.
> Is that correct?
> Who is supposed to use this callback? If it's unused, let's remove
> it please. The documentation for it sucks anyway. :)

No, it's actually used in a patch I'm about to post:
http://johannes.sipsolutions.net/patches/kernel/all/2007-09-28-22%3a38/017-=
mac80211-key-seq-nl80211.patch

Mind you, it could be renamed and described better; it's used for
getting the current sequence number of a hardware TKIP implementation.

johannes

--=-fQiO5FpZovlbpiWIoEOu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwZEK6Vg1VMiehFYAQKpOxAAuoOrCbszvbRFiTEUd58ipTQbD6rl+NRH
EY8ycBwwwEwrD22saGkj4Mg4dtYQtwlKgCISTLQjVxWnu59lxTbB9dRF2uWuX9sw
xnI+OA+DywV7brcUTPz4bP/eQZb8MwGxSxo1NgtU5k4SW1cAkZAOXjKU5bj++krp
5xE0q3GCm4YwBVB8JIeaXxzDBc9SbTIRis2iXZI5JhyW7qyE0tv4WVD2evaGS9uf
6VePOv0sCLlqqAVhveBAAGc+skFERiedPRqU7WgGIi/ImQEXxa+fHYsSbrr6uABd
5rlxWtuiYyQfpAPjQ0D0WCpLA221Y/+dKpfQ86GZ8F8m3945298y79icvRVrjPZw
LZm63rqKNkVdl4YoAuLbtSiZnGUyeONMxJbNUmwh9TrU7zoWm9kGhIUp3JkwIRTK
0uJ9adAgopweqANH3RrMYpeO+9qfNkvomNHrtI6sDDIEEdCqNSEVgUa3zfmY9rYz
vaavRszMnbQDQoDg5UPyLeqXPoa4rGSVd1Lp05m9glvUMmECLGeiQPbR4ftPi02Y
t7Ofit7qgYpQ7v619F+oMTj/AjbWobwS/ILHHum37HS7WIy2iPSXld8z6Lu4S1uo
1cDFzTtJE7eZWOyN43m3UuGFTyOr0jYk2fk5pzs1j0w0jiWgUeBNUADbr5diQsDO
wv/viP0h2x4=
=e7iA
-----END PGP SIGNATURE-----

--=-fQiO5FpZovlbpiWIoEOu--

