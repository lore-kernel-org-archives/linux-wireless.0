Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934910AbZDBJ5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 05:57:22 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D44635.80306@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rimg6oFCG1GyxV/IYnT1"
Date: Thu, 02 Apr 2009 11:56:46 +0200
Message-Id: <1238666206.4141.12.camel@johannes.local> (sfid-20090402_115729_728008_F51B1AED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rimg6oFCG1GyxV/IYnT1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> I'm having trouble getting the radio LED to work on b43legacy. When the L=
ED's
> are registered, I get LED index 0 registered with names of "b43legacy-phy=
0::tx"
> and "b43legacy-phy0::rx", and LED index 1 with a name as of
> "b43legacy-phy0::radio". I placed printk's at the entrance to
> b43legacy_led_brightness_set(), which is the callback routine. I see a nu=
mber of
> calls to modify LED index 0, which I assume are due to RX/TX activity, bu=
t only
> a single call for LED index 1 when the LED's are still being registered. =
There
> are no such calls generated when the radio switch is moved.
>=20
> I don't see where/how a particular LED is attached to the rfkill event. C=
ould
> you point me to some code that does that?

In theory, that is here:

                snprintf(name, sizeof(name),
                         "b43legacy-%s::radio", wiphy_name(hw->wiphy));
                b43legacy_register_led(dev, &dev->led_radio, name,
                                 b43legacy_rfkill_led_name(dev),
                                 led_index, activelow);

I actually thought this was attached, by default, to the mac80211 radio
trigger, not the rfkill radio trigger.

Can you check the contents of
	/sys/class/leds/b43legacy-...::radio/trigger
please?

johannes

--=-rimg6oFCG1GyxV/IYnT1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1IvbAAoJEKVg1VMiehFYZlwP/ReXKJaoi67e8V74DD43nLxk
OXB84EgWZVR3yBBbhg3a20Cc8FcopsLqUifdpxgm1yLIoS/BT84p3c03Dik4nnym
tAMu/v+2ejudyy9n0SJxYlc7LfQrLtMc8BYe7/PBttFVYhG4NFxRTQ2+jf0U7k2a
n9g/LwsN6RsdKQ76pRnio4O8KeVBdNwT/CiRj90fxMN09gTUGeuuEranph2zY43x
BwjBWqGcLe0i/FsAMMtV0HDbCunU9HDIhRVF938q2jpku7AzeSTJBu6WBTge2+j4
oUzELVQY/4eY5yaO48WhFpD+fVoHJnWfpbsrv+dlgDBDR7o/ORjnfsKAam3e5uwr
asH7PB+9IHSj7sExd2uIPNqyJ1/uL7+rcqPlKfcnAJseISiTpxwVvu74OOWBFLED
Z+u4v0lllQjFpuNZctT9rbNrtzFUoH86W3xWTVGTLZA65+YBcN9GJ4sTrTy71L6M
soTXkKvbC577Ymw+r4W5M9kbsJWpg44QuCYdY0zia47XBmjmGj8Clq8OK5UN3J5s
divtJ9RyfNi/nSc4fZyU6Lq8a/XSc9ScR7kqokYDhY8bHbIVTClUeo9CFi77zTuD
0fDrEJlZLXW5YjxgSLNhaOht8E2dJwniktS1VTWzi7retD2dcsBPkFjwUrxYO4H7
CEudDkwF9nGE2oThG9rX
=SMtn
-----END PGP SIGNATURE-----

--=-rimg6oFCG1GyxV/IYnT1--

