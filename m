Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXHOKqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:46:23 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200708082324.17186.linux@baker-net.org.uk>
References: <200708082324.17186.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7iTYzVQy7K8LnaEXtTW9"
Date: Wed, 15 Aug 2007 11:50:43 +0200
Message-Id: <1187171443.3960.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7iTYzVQy7K8LnaEXtTW9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-08 at 23:24 +0100, Adam Baker wrote:

> a) If anyone can see anything obvious wrong in the trace
> b) If anyone has recently tested ad-hoc mode with another driver and can=20
> confirm it works.

Neither.

> The sequence of events that leads to the crash is
> iwconfig wlan1 mode ad-hoc
> ifconfig wlan1 192.168.0.230
> iwconfig wlan1 channel 11
> iwconfig wlan1 essid test
>=20
> then attempt a scan from another device.=20

Very weird. Can you please enable verbose debugging and also add a few
printks to various lines of the code in ieee80211_tx_h_multicast_ps_buf
and ieee80211_tx_h_unicast_ps_buf? Both ought to be fine as far as I can
tell and the STA scanning shouldn't be in powersave mode either so this
is a bit strange.

johannes

--=-7iTYzVQy7K8LnaEXtTW9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwsxz/ETPhpq3jKURAvfFAJ9KXDLSUIOUyvg/g/GEflNINPvdSwCeP5wa
pkVvfg1tAzYZv9MM0noipvA=
=vtU2
-----END PGP SIGNATURE-----

--=-7iTYzVQy7K8LnaEXtTW9--

