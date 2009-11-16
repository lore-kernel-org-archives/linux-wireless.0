Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZKPV4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 16:56:04 -0500
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0911161353p5ea44472s8e6f146929ff6c65@mail.gmail.com>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
	 <1250927141.23605.3.camel@johannes.local>
	 <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
	 <1257621757.29454.48.camel@johannes.local>
	 <83a869cd0911161353p5ea44472s8e6f146929ff6c65@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HUl2d+RiV4XuosTQNNy0"
Date: Mon, 16 Nov 2009 22:56:05 +0100
Message-ID: <1258408565.32159.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HUl2d+RiV4XuosTQNNy0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 22:53 +0100, gregor kowski wrote:
> The mac80211 tkip code won't call update_tkip_key, if rx packets
> are received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
> first packet because the hardware key stuff is called asynchronously with
> todo workqueue.

> -	ctx->initialized =3D 1;
> +	ctx->initialized =3D TKIP_STATE_PHASE1_DONE;

Now you just need to rename the variable holding it to "state" too...

johannes

--=-HUl2d+RiV4XuosTQNNy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAcpyAAoJEODzc/N7+QmaMl8QAIy4y+V/RZ2X3E4VpA8gzhm+
J19xSFDS6E8k75z9gzJb2ml3Vsq3Zfi7mZkv/sB/ug/LCsmsViHWIRa75/2dVE3t
mAKlvgCPcW3inlQ2FSyt5GTCh0UMRf6k7+3E9HvjL4FamQvcH9hrhLhWHRLs+6cr
Ir3jveJ+2NMtZNeQz0h2Vd/QxzY+OrUDkKHXNQFEvFbPuxaR1Flf0j8d+vuV4zGx
8uDfsFdtQvGtEG8jpLGodqg8c4Noca1E7dC3jv30omLG5f4rNvQF2Or5qA/wWaqR
XMr9nXXCRLprOFyju1djj6pCzPvERjWRAmas53WsL1FsM8LwRVmwmyEzWTTBzhhN
VAx7WSEtq2FXu30MtoKJ4mbRErfDPqB1AtMULL62wSaWT/vaCc0J1EYzeJi2zkZi
ROOVvN6ACdOllrbbSPudEPX23mH8Kz3FD78EB3RnBVvLxMWZZAOz7td2j0yKm+rL
bZ69my+nHgJeX2ubjZaue5TXY4CiNR45caZjrhJb9nwDFlOj9iLg4lQqYXOPElOs
OVLa17xN4S5Apa5m8zbtFh8LEzXTF1u/vhtxMZxEWuZNqQzsfWxaV9panzdSLmV8
aoUqCOsHPFPKN4Lqi5cE4rLkEDOzjg5pD//qDghRqT9D9MifQaf9FjwMKTL/dxLZ
tS+t0JOkmoROMhNGbb7/
=tcHl
-----END PGP SIGNATURE-----

--=-HUl2d+RiV4XuosTQNNy0--

