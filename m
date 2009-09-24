Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZIXOHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 10:07:33 -0400
Subject: Re: rfkill hard state after booting
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: linux-wireless@vger.kernel.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Mattia Dongili <malattia@linux.it>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
In-Reply-To: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xwyiAyq7OjcPlKJCrv/R"
Date: Thu, 24 Sep 2009 16:07:32 +0200
Message-Id: <1253801252.3868.108.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xwyiAyq7OjcPlKJCrv/R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 15:02 +0200, Norbert Preining wrote:

> I recently (on a flight) I found out that when I boot with the hard-switc=
h
> activated, so turning off all wireless activity on my laptop, the state
> is not correctly announced in /dev/rfkill (reading it with rfkill command=
,
> or my own gnome applet). All the devices seem to be in normal state but
> one.

Very strange.

> Here some outputs:
> $ cd /sys/class/rfkill
> $ ls
> rfkill0@  rfkill1@  rfkill2@  rfkill3@	rfkill4@  rfkill5@
> $ cat rfkill?/name
> sony-wifi
> sony-bluetooth
> sony-wwan
> hso-0
> hci0
> phy0
> $
>=20
> and the three sony-* are the ones for actually turning on/off the devices=
,
> but they showed all soft 0 hard 0 at initial startup. Only phy0 (AFAIR)
> had hard 1.

Makes sense. I mean, that phy0 was hard blocked.

> After turning off and on again the hard-switch the events were right.

I can't decide where this bug is. I suspect it's in the sony code.
Anyone feel responsible for that code?

johannes

--=-xwyiAyq7OjcPlKJCrv/R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu30hAAoJEODzc/N7+QmanZwP/0xqt8qpbSh/S/1a+dmsCQ51
ZDem/HlmB6E5DJnk9zImVzbV2GHhqnP1uON6I+Lk5T/ivabEltwe0Rp5KclMNHkx
+k1zWpMXccjEaLcm5m7Ge6Evsyoov4+kyAmUe9M5eVe95TQ0OcT60Jxo1WeotwpI
rqYXkav9Kr5mXQyaxPNCaqmml8HRfX1ne4geW7c08KIZ3VXNGPYAIF6HHDGeFBCz
q1g+eDMwVBbh/vgQuejyoOtHsNF3qzQJaM5ehRtBFHMzekKnbDyPHmpn1SMgyyO3
xsiZIihxUY3F1SbolEbSoM9nVuVBh5UI/OD1d2usfrbPk4QRmnn0f/GKa1CSSK/U
WsWl/m6vD0kwlq/jqELqDmbrtXMjebgubIPqTstpszyWWqZ80fgauWItHDwos7Ei
0aYBlo3YX4hOds98kQrgt9rTGzqZuZ9e68IMwcOQN2Z0NDZQdgfIW4APXzSJ5nb3
xBlar2uul+i1+Z8SOkCY5a7f7+FuRY8ldRdUrUsGxtw/bDsTpws46nflwRR1hQOM
L71VOI4skZa4HxI/o2VEpHVS0s8Lzdq7kWKC0SPMdYOjhaD4upSes4jgXrZkQuRj
PAbgZ6RmnCqmEx6tL81JJXnagTd/NduBMkk840IJSg3gOPlLeB/9kAyR8au7etwH
9aMbsI7s9v+P65LeQ8aS
=CpKQ
-----END PGP SIGNATURE-----

--=-xwyiAyq7OjcPlKJCrv/R--

