Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZASI4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 03:56:32 -0500
Subject: Re: [PATCH] mac80211: Reconfigure beacons after a merge run
	in	IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
In-Reply-To: <18804.16004.937429.850079@gargle.gargle.HOWL>
References: <18804.11602.400684.88722@gargle.gargle.HOWL>
	 <1232353772.3799.1.camel@johannes>
	 <18804.16004.937429.850079@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BPAWLQLy4l6dsKYUGGDI"
Date: Mon, 19 Jan 2009 09:56:28 +0100
Message-Id: <1232355388.3799.12.camel@johannes> (sfid-20090119_095634_992669_FCF7C32A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BPAWLQLy4l6dsKYUGGDI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-19 at 14:19 +0530, Sujith wrote:
> Johannes Berg wrote:
> > I think instead we should have an enable-beacon flag that we disable
> > before scanning, and then re-enable after scanning like here. That way,
> > we also don't need any extra code in the driver to stop beaconing befor=
e
> > scanning, and it generally helps too when userspace deletes the beacon
> > we stop beaconing in a controlled fashion.
>=20
> Yep, I did remember the earlier discussion, this seemed like a quick fix
> for my IBSS troubles :)

:)
How do you disable beaconing to start with though?

> > The best way is probably to add a conf flag like CONF_PS and a change
> > flag for this, what do you think?
>=20
> This has to be a per-interface flag, so it would be part of ieee80211_if_=
conf ?

Right, of course, sorry. And I don't care whether you add a flags field
or a bool beacon_enabled ;)

johannes

--=-BPAWLQLy4l6dsKYUGGDI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdEA0AAoJEKVg1VMiehFYTdkP/1O5p22F1/ZT/16R95Dz/93O
uo7e2223mDAJQol7arBhC2ycDn9ob3S530xyzbgDniCy0qR7eIcCPJabI1svW/ci
eOBgb3tf/HvisQ9EecyTt2J7PSrb6wRo1lenyclB4xZzmE4GxLfG8LAGU5VKshBh
YKYfbgSO4gz2T0tDZ6UxVKQms5+gZe7Web/3AIYnF5OuazNZFQqMJY1kJShlkuVk
+tgKlvqF2kYmyrT5n1ebnMljQI8ZmEGYGx8mywlFKYhG0/3K77D7DXaO0FDuce0Y
ryGTKaf8Z4uRfsiYyu0S1U4z5B9j5x+cc/tXtk/t+VaHjwIzZyaAM6+zBwOrhcOQ
0RQmuhy5m+uQklX0XM+sURd+Z/gJfCVHVCaMX/JHhxq84VfGgvi1w+2DlLRMxaCv
m7pq3tsP1D7YsoQPBde70WfzNOpS3tWsyXWCrj2xGKVTlxBBmT0bOu77om1wasBR
URFwT6OW/DxTOATjuuSgVhLA9YFag/2CZIcZy2cLY9vDyf5A1gi6H3WmF8qsngZG
1+fPWvBEQ2tW4tbgcLPj3pW3F+RZC60EJAY2524dfxhlULEQsL+ShWC3r9u/p/SR
Ht67mtxCfdvH+UWP+BgDw8a/Xa8deftPvlbidQ6mPMcYA/9vLuYlIfpJh9l7Fuof
41OsGiqv0rD3Ghib4U+C
=QAll
-----END PGP SIGNATURE-----

--=-BPAWLQLy4l6dsKYUGGDI--

