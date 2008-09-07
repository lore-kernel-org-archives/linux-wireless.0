Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYIGHRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 03:17:13 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <1220749216.6714.122.camel@californication>
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
	 <1220721347.6714.114.camel@californication>
	 (sfid-20080906_191538_728310_1EC0FE5D)  <1220721572.10102.0.camel@johannes.berg>
	 (sfid-20080906_192003_595621_9791F144)  <1220721788.10102.3.camel@johannes.berg>
	 <1220749216.6714.122.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-831E8SyoDXDeZ+FtRyFu"
Date: Sun, 07 Sep 2008 09:17:04 +0200
Message-Id: <1220771824.31304.2.camel@johannes.berg> (sfid-20080907_091716_981119_4368F818)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-831E8SyoDXDeZ+FtRyFu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> so what overhead is it to have RFKILL just enabled all the time. It is a
> small subsystem and the extra code inside the drivers is also not that
> much. So what are we really trying to save here?
>=20
> I can see your router point, but does it really matter? I don't think so
> and some routers allow to switch WiFi off and then they want the RFKILL
> switch again. Also what about the LEDS subsystem. The same would apply
> and we are not bothering in just enabling it.

Yeah I mostly agree with you, but those things do add up. Two kb .text
saved means we can handle a few more stations ;)

> > Although I don't like all the select business, can't we just have this
> > be an invisible option and make it depend on RFKILL? That way, when
> > RFKILL isn't selected, ath9k-rfkill won't be compiled, but if it is, it
> > will be, and RFKILL can be "default y" and "if EMBEDDED"
>=20
> that would be a good compromise. I hate all these extra options that are
> basically useless since we enable them anyway. There have already been
> various complains about useless options. So at least hide them inside
> CONFIG_EMBEDDED if you really think it is worth it. My personal opinion
> is that RFKILL support should not be optional. If the hardware supports
> it then it should be enabled.

Then we'd be back at select, but I don't really care much either way. I
agree that this particular option and other driver options for this are
fairly useless.

On the other hand, if rfkill isn't optional but selected, I lose, udev
has been so buggy that I've had to disable rfkill to avoid having it go
into an endless loop on some rfkill (re-/de-?)registrations.

johannes

--=-831E8SyoDXDeZ+FtRyFu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIw3/sAAoJEKVg1VMiehFYReMP/3HgQIdBDov2KAtGxu02TCt3
FtOBJ5j1kfDyv9EppPe3YNdWHo5FJWL9j9KIBUAAEXzHk7YvQyiGCgtG0s+huOo8
ILJlBYc5Q6IQHWpQpVdfM/zafy0hZcM4bmHDfFrnpMETOeiU9UmEoFtx+ib1YO/+
VIjpZ2+mSWj5TUj/ElJXXF52rW29J6+9cx0PjNXgtcbKJhD8rpRJRibXZ0AkL8Sb
H/xdVkA2ICTgZWMRNEHk6SpqihXaZ4P4mQ92QVkxEiun4Bu1ooZsbTngYC2W4dJc
kld5SU0f9xZVL3TjOKPxgldZeReid4Im5B+q5Tn1CrAnNaAHwbUCrprpxBNS3b2O
EajQ97TH9+zINFMzFnbyw9vRV21Yplrhdv5ilHnYCzVEEZfIm5JsqYc5q5KzUci4
jOYb2Et2qmJPQaW0cIVPHXTXsybbUVPNUv9hqymzqUxsrltUjwHH2Qe3aZu0PYqC
T4ELHQu+jvzfjab08SUrp/INY1k5ka+B6xA/Zm0XS1YDP8s8Ume2HrVM8fEktiL6
hCPZ6MwGT1/pwlcN/hDVLn+6BsCAjL5a0IydH/vx0+PqJKCjqOEclGe8Clgdt5VT
FCLUw84i/oKWDIQoYaN8od+GgpycyCgGp9G4EuLljRDXzSDKzAtJf/Fh/J1DerdF
4PH+mNPB6PfjwYIosKbX
=G7vC
-----END PGP SIGNATURE-----

--=-831E8SyoDXDeZ+FtRyFu--

