Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIKKhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 06:37:03 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com> (sfid-20080911_100535_000722_EE099914)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 (sfid-20080911_100535_000722_EE099914)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PhMp4Sat3cQvsjTjlAqG"
Date: Thu, 11 Sep 2008 12:36:22 +0200
Message-Id: <1221129382.6986.0.camel@johannes.berg> (sfid-20080911_123708_508365_E72921FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PhMp4Sat3cQvsjTjlAqG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 10:04 +0200, Marcel Holtmann wrote:
> Hi guys,
>=20
> so since a few 2.6.27 kernels I haven an issue when using my 4965 =20
> wireless card. So the machine in question is an X61 and when enabling =20
> WiFi and Bluetooth at the same time it will freeze hard after a few =20
> minutes. It seems activating Bluetooth has something to do with it, =20
> but I have been using the machine for Bluetooth qualification testing =20
> (with WiFi disabled) and everything works fine.
>=20
> However I tried to reproduce it without Bluetooth enabled, it didn't =20
> show or I didn't wait long enough. Once I started bluetoothd it showed =20
> within a few minutes.
>=20
> So the best I got was the attached screenshot of an oops. It is =20
> clearly the iwlwifi driver crashing here and killing the machine, but =20
> I have no idea why.

That looks like the use-after-free BUG_ON I've been getting with a 5k
card, do you have sl*b debugging enabled?

johannes

--=-PhMp4Sat3cQvsjTjlAqG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyPSjAAoJEKVg1VMiehFYJWUP+gMXhBbBdNIVAbppiVg9xdzH
8ZjBuh4jGkLwv4uSfwqK3oYoUGfFkOgc83XRYsAmFghulM6sWB4yZTNz2WISE+oi
53KRycpSFIwSJzq0Jd7rv+VOovTnmDOpr1n5KAFdmmd4kcyzKvf8YoB+mznapQz5
OUlJFNpQDDRCx3N11KvieYSAV11kG4kKEjAZF75ufx5JTBJRDK/OfwUmT9mFwmaY
LP63p+lLOzdyH5y2gLP1aZzBqaAPZ7oEjAhPlfSpwkrViVkZAcjrW1yDpwXmKPTu
ovS22k48Lm0An58wI2LnjDJplOxh3usxZ8pL9H0uoIOiJt57pt2udWdVLK4ZoqlV
Vf0kuE8K86KfFDB8RW3yqZ+XCzZAeJ0Ihq1VEwtdvNN9IMnRnBWnNoz61c7ljMSs
Zp3M8bZz8IgseR/rc8gAqwE2PUPRXSKCyzxrZRqhjASjbZoKWvWMk6I5V/Ju0XeI
InCjD0pzn3wGEoQs89CaafzK5aTX7g+huvgsTnA3sqXuEtgdMp0Kkzrbp7s6ptTy
S4WkoK4DVQChIrhSqJF6QxMeMRumIEQF2npKhtsfrPS7xshOHh5h1/Xay227Sqse
6maXc0YVWxZQXfd7GmuvnaI0a8KfXxQ4thc2/HPg6D5DRKqNT5eCskN+eKGf2hvh
zGJE0YlbAWgSGuhVmW4b
=6tcm
-----END PGP SIGNATURE-----

--=-PhMp4Sat3cQvsjTjlAqG--

