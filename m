Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0AWStL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:49:11 -0500
Subject: Re: hwtkip hangs on b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B5B412B.7080502@lwfinger.net>
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
	 <4B5B2FCF.2000005@lwfinger.net> <1264268862.23766.0.camel@johannes.local>
	 <201001231919.32466.mb@bu3sch.de>  <4B5B412B.7080502@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UF/RvtmWcy7Mj535zfEh"
Date: Sat, 23 Jan 2010 19:48:32 +0100
Message-ID: <1264272512.23766.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UF/RvtmWcy7Mj535zfEh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-23 at 12:34 -0600, Larry Finger wrote:

> > Well, if mac80211 does a callback into the driver on behalf of a driver=
 call,
> > that is broken design. It would break for all locks, not just mutexes.
> > We should probably switch back to ieee80211_rx_irqsafe to workaround th=
ese
> > circular locking problems.

Yeah it's due to the switch.

> Michael, I'll let you fix this. I do confirm that the mutex is locked whe=
n the=20
> update_tkip_key callback is invoked.
>=20
> Was this problem introduced with the switch to interrupt threads? If so, =
then=20
> the fix needs to be applied to 2.6.32 and 2.6.33.

Which is due to that, indeed.

I'm open to changing mac80211 to delay that, but I don't really care too
much about that right now.

johannes

--=-UF/RvtmWcy7Mj535zfEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLW0R8AAoJEODzc/N7+Qma/gwP/iOiZ0SJEJPqTrAzJCLUGMki
XYdG/Mt6ZTbZPjuzSkVgJTbZEfjNEEkq8K1upwUnGMc385SbTE47ExkD1PuzhMdk
skIndAk5nSqq7CmjGoViDU8JEGflmJ8fztc/LqPUm87ZoyyK5AEDnyoZE83E+LSx
PnVynY101UKugK4tvNs9eSpnu+BJ5UsKfHgdEkYa6e/uU6HmMTaf3O261NuFTtkj
Pu71y597BQ3D+aXG4re4ILSvqUtQ7FP2BH6pzO9MtiXhnlE/EcSj8l6z5URjH5bX
FZuvflugZb89zYmlkr2XL2AM5uuPxJ6IoGEbOID33b/U1VsF+TsPE6vgxicW4eHb
Yi8yDqb+fDGAxDeUD15gDcuk6Z13eQMWd6NYy0Xxz+zgoB2EVyI22w849QiJ2+wQ
qNk9q26+e1K+aUSHn+LnQpkv4Cj5PCjEjoh9CR7vnJaSxiWiR7aUVNuyaikLeWFK
3FbMwfnI5JhfP5Q8PFjEv/9UX8NhnUCRNGpeXRmfJHslJzrjR41Ya+QJj1LdpzL2
vziqnEeSsAsVVg7mq1qW48LVgZoft0f6fKOU0ELM2PUOKXZ9pvY5BXduL0uvwvBG
KXXu/v6RBvZwlqQYV1e92U5aA7DZBjAMJAzptMF7n9HtUfN2NEbYJXBoiQrnqtC2
ptDNN2tnEOkpUek8d8Vs
=2OGj
-----END PGP SIGNATURE-----

--=-UF/RvtmWcy7Mj535zfEh--

