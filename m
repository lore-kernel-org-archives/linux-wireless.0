Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYKHLKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 06:10:19 -0500
Subject: Re: iwconfig power timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87prl6wk73.fsf@nokia.com>
References: <87tzaiwn3z.fsf@nokia.com>
	 <1226140536.3610.2.camel@johannes.berg>  <87prl6wk73.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bUKNvcUNu9Z5O546kpkV"
Date: Sat, 08 Nov 2008 12:10:20 +0100
Message-Id: <1226142620.3610.6.camel@johannes.berg> (sfid-20081108_121023_792431_16B2129E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bUKNvcUNu9Z5O546kpkV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-08 at 13:06 +0200, Kalle Valo wrote:

> I don't think so. If mac80211 responds with -EINVAL the error would be
> something like this:
>=20
> $ iwconfig wlan0 power 5m
> Error for wireless request "Set Power Management" (8B2C) :
>     SET failed on device wlan0 ; Operation not permitted.

That looks like -EPERM. But then iwconfig always had messed up error
handling.

> So the error seems to happen happen during argument parsing. Oh yeah,
> and I even had a printk in mac80211 and it wasn't printed.=20

Ok I'm convinced then :)

> I'm going
> to investigate this with gdb and try to understand how iwconfig really
> parses the arguments.

Well there is source code too ;)

johannes

--=-bUKNvcUNu9Z5O546kpkV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFXOZAAoJEKVg1VMiehFYykgP/iEms4bs8uVlXIU5QP4EJF7a
uMGQYtqBPGr3c2hzzeOE7LLIxlckqTvJseHQKKCC5hn3zrfvmdR8ObdT10M6txDI
CjSGejCH6RPSZ9FAk4z7JNBVZIzxlXRPQS6gHeTwFUY5XK/oADkBaHIJulTj8EOL
NngN47ferixSX3MtrlHGTFnpU5vYsr/ZZS4WDo0gtCqczSiNFtelRU+5GWySvg/p
/CauLkzZjVG8RgAZrPtwV/53LyovkfiEWEfJcRgBb0vAt9unMnLeYJm7kgjb6at2
pkwLc+wbL9XIAK63tEBXl/aK1Zyjph9GTdB7ZhlGR2NVnhbZCBPIlrz++XNqumQi
QU68WBLsHg3xIG1ncZOcK1S5k7h7ge/cWBu7AIl3zyd5/Oq5dV/cCJbd23yYDIQS
4JR5TgxUylNh5qo3eF2qEOve9NJAaMg+PNZCHSkvfR03TIPrev9KqPHwFMk/+Oni
acNBTncz3LKUExZ50o81T0sfysL/3N5dMLT2H8nkADN3rWs3myaZW5ZMmxdmePe3
yzoOcX8r2Q/UHpnIGsJwxLiL3BpBKdVAMh2NMO52PG/SW50ngUqv4zkECy9vroRx
SCuoTw6s7vyNoyHVdzOrEJ+ipzIQcHR9Sx30/4vRcmqiKySk4zLFA7Niyyr7/p9L
yE4155RJXm+KioYVhv5W
=YpUA
-----END PGP SIGNATURE-----

--=-bUKNvcUNu9Z5O546kpkV--

