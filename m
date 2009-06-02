Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZFBUL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:11:28 -0400
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200906022208.46288.mb@bu3sch.de>
References: <20090602111027.460530075@sipsolutions.net>
	 <200906021641.11019.mb@bu3sch.de> <1243973079.6461.3.camel@johannes.local>
	 <200906022208.46288.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7RpFrH/L85jNyu60ILJQ"
Date: Tue, 02 Jun 2009 22:11:27 +0200
Message-Id: <1243973487.7176.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7RpFrH/L85jNyu60ILJQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 22:08 +0200, Michael Buesch wrote:

> > Well, rfkill isn't always present but the APIs are always present.
>=20
> Ok, makes sense, so I guess you rewrote the API. ;)
>=20
> I'll ack this, if somebody with rfkill device tests it.
> Unfortunately I don't have such a device.

Me neither, so I really need somebody to test this... I suspect there
will be problems when the device is set down because of rfkill, and then
we can no longer poll the rfkill hw state? But that might have been a
problem before too, since if my suspicion is right we could never do:
 * hw rfkill
 * set if down
 * hw un-rfkill
 * set if up

and have it show the events to userspace as expected, or something...

johannes

--=-7RpFrH/L85jNyu60ILJQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJYdsAAoJEODzc/N7+QmaWDoP/jbASQsesEmg4gQpBIOwwjUv
QFAehJkydx0AvSlxymQBfGhX0LtGNyxd33DqKEpKUU/ioH5KZ8HIPFbO2v0oOTB4
EpznTMyqE5Cmn+3lJWPIk09P3Rb1YxJ2828nsiiB6S1/0QKWaIxtAFn6CZw/c94u
yghmIStBo/3S9Ybn/9lRF2/dAFb3NjnK5bhkHBziS1mp6YHp8LFKjOiICT2iFBCn
JDH52RzHHRn2ikKBNt1MEIDvszlKU3G5kMAcWI/0xD7FcHL9d3jBiD3PMKArhvMZ
zgrlRSNYHjxJo6+MI2u97fGJzNOoYua2aXuMPGxpfkGpb8Q1rLpb9wg/fz49U0by
vu4+uEOXQHmUY8BUQNQMpztTQRw7+R6x3y4/Qh+qbXTxppSqoX53YRWTUghnZ9rN
G5T/kOiExbZojVNoK7XOrnwyBDKAD9+0aVqA/q9YhNc9jbuCuUDUmH6eRr0pQojO
fRieakIFpklwYJEX4A/4RrkIAs2ZwfXC2peytc9pLVHEO/aS/JrJb9wGe2+yXpMn
iYeuVbyArSPO0koK/rnfzn4fvSoDK+0pHsar9E+VFOip0qGRdig+SID4QC3wLeRT
tzEXDXg6qIYJvRUmVeekHfXnlLb4k2dqoQbbEa/oSF05F1kLvFTNAhaKejbu5TjQ
XF53M+zi7KmZivgheiRD
=ptsd
-----END PGP SIGNATURE-----

--=-7RpFrH/L85jNyu60ILJQ--

