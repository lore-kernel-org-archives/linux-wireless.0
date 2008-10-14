Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYJNIQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 04:16:07 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810140410.27397.chunkeey@web.de>
References: <48EE20FB.4060700@lwfinger.net>
	 <200810140215.47242.chunkeey@web.de>
	 <20081013212039.dy5fki5pck4g0cg4-cebfxv@webmail.spamcop.net>
	 <200810140410.27397.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fANvxR1MSPKPbMSMjzNQ"
Date: Tue, 14 Oct 2008 10:15:21 +0200
Message-Id: <1223972121.10113.17.camel@johannes.berg> (sfid-20081014_101616_004653_93D5D585)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fANvxR1MSPKPbMSMjzNQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 04:10 +0200, Christian Lamparter wrote:

> Alright, your eeprom says that your card is technically 802.11a capable.
> It has the right MAC (ISL3890 Duette) and a 5GHz Phy/Synth/RF (whatever i=
t's called).
> =20
> but unfortunatly, it doesn't provide any calibration data...
> And that's the problem here. Since without it, p54_set_freq can't put the=
 card into 802.11a
> and the card stays at the last selected channel (somewhere in the 2.4GHz =
spectrum!).
> However after p54_config returns with -EINVAL, mac80211 doesn't revert de=
v->conf.channel
> back to the original 2.4GHz setting...

Heh, so this actually helped catch a problem, nice.

> with your card still listening on 802.11bg channels, it could capture a b=
eacon, or something else
> that is transmitted with 1MBit (hdr->rate =3D 0) and crash.
> note: hdr->rate is a u8. so: 0 - 4 =3D 0xfc and (0xfc & 0xf) =3D 0xc =3D>=
 12
>=20
> so, I guess we have to do two things...
> 1. check if calibration data includes 5GHz channels AND if it has the Phy=
/Synth/RF.
> 2. cache dev->conf.channel locally in the driver.

Just (1) as your patch did seems fine to me, then mac80211 will not
attempt to go to the other channels.

johannes

--=-fANvxR1MSPKPbMSMjzNQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9FUVAAoJEKVg1VMiehFYBW4P+wdwRgtkpxtZuyL58he42fw6
PBSYe0PYgkrqhdo6sS/YoiQZlKgBTDZBFs9YLevFzQ+FLKNridMd4JUlH6ve+3/E
4/gX5O0sZgW1pxXcLqcz9d5yKwmELIu2QLtvkdLAHLy6CphkKaJIYXkbRILXtSzR
hbpKptgtIRKJweDb9dDNzbLB7SNmXTG6HTPHjcvNCVL7s3IAK6xG4SFUFFnknGYm
M7ahIgF1Noj0g2ug841cIPVmq8nYzoytz1+6BpBbAWhWFFZl/4ymrxSjP700jjqY
eBYcTAa5TF024HxmGIWY0M/KOIRxV6IVq2qKGFn35hOM9kmtpa0j0XDo2vct1MWl
9wQDMhl9zDMMlvntaWkTHM2lNknD2GQfV2uxt/WYHP+Tn8+633MEKs7TSZQTEFqR
1OPZtmklAwyC/6wqmoGvoULDGDs7XE1bpTC+5nhlZuCv84k2m85sShHmEPNkIloG
J9dJFu+njOuh3CyzFw3ONday47PlbY0JOEc/Ky5JNzy8AZk22K9FY6fIB0ty7T6i
DUArpVJFfmWIjNkdj4KKlINBu83rA8Bc4W6GhWz01r7gNDHpw3NPByVs0e5R6BJs
upkQkYb1U98QR5neX8EyysBWaLpkLRz1miSXJflYU3u6XE4DrmUe/pb3JAo9CPr/
v4ZezQhR3yVHmpizi4D2
=C8iE
-----END PGP SIGNATURE-----

--=-fANvxR1MSPKPbMSMjzNQ--

