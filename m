Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZLCJoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 04:44:09 -0500
Subject: Re: [PATCH 32/33] input: add KEY_WIRELESS_CYCLE
From: Johannes Berg <johannes@sipsolutions.net>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-input@vger.kernel.org, networkmanager-list@gnome.org,
	linux-wireless@vger.kernel.org, kde-hardware-devel@kde.org,
	dbus@lists.freedesktop.org, hal@lists.freedesktop.org
In-Reply-To: <71cd59b00912030122n3d94236ajfa5e55c3b5a9efcd@mail.gmail.com>
References: <1259826317-18809-28-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-30-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-31-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-32-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-33-git-send-email-corentincj@iksaif.net>
	 <20091203075404.GK9121@core.coreip.homeip.net>
	 <71cd59b00912030012r2f45f474u37c494ad281230cb@mail.gmail.com>
	 <20091203082120.GL9121@core.coreip.homeip.net>
	 <71cd59b00912030051w6bf54abfv726f288c2eae1d33@mail.gmail.com>
	 <20091203085717.GO9121@core.coreip.homeip.net>
	 <71cd59b00912030122n3d94236ajfa5e55c3b5a9efcd@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Voe8s4HviLIwaKbAhdXv"
Date: Thu, 03 Dec 2009 10:43:32 +0100
Message-ID: <1259833412.12843.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Voe8s4HviLIwaKbAhdXv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-03 at 10:22 +0100, Corentin Chary wrote:

> >> > I understand this. I guess the question is whether people working on
> >> > system infrastructure (dbus, Networkmanager, etc) care about having =
such
> >> > functionality on Linux? The reason I am asking is that we added all
> >> > KEY_WIMAX and so on defines but I am not usre if anyone wants them.
> >>
> >> KEY_WIMAX may not be used a lot because there is not a lot of device
> >> with such a key,
> >> I think this is not the case for KEY_WIRELESS_CYCLE.
> >>
> >> The bad thing is that we will need to patch X11 (and Qt, for
> >> kde/solid) to make it works.
> >>
> >> Maybe we should Cc dbus/network manager/solid/linux-wireless ?
> >>
> >
> > That would be a good idea.
>=20
> Here it is.
>=20
> Dear system infrastructure people,
> Do you think a KEY_WIRELESS_CYCLE key would have any application ?

Not really.

The naming of the key ultimately will not matter one bit, because it'll
be misnamed on most platforms anyway, unless we want to do DMI matching
or something to name the key. And even then, if there's a wifi key but
no bluetooth key, users may prefer to have the wifi key act as a cycle
key instead.

Therefore, this ought to all be policy in the rfkill daemon.
rfkill-input will be going away as soon as somebody writes a simple
daemon that allows doing such things, I really don't see us adding
support for a cycle key to the kernel code, and for the userspace code
it doesn't matter since users will configure it independent of the key
code anyway.

johannes

--=-Voe8s4HviLIwaKbAhdXv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLF4hAAAoJEODzc/N7+Qma9sUQAMRJ6Izik2Ab6oPaZx6VA5sw
su8ggWrcebIhs/Zbiy4i96BvnF0UyhCmdqmK4Le0PQjdlJ7fVMHE83kp48tfoQgt
HYWcKr4x095rftfnTymBJcuX6nrH8X7hg2t/dR9ZmSJV2HMHRlV52KDHyf90KhEU
FYaNgoKQAllS/83QqZ90XUMbH7tfMZB5BapQwr5uR8DTpRCRpw0juYQK3pAx5xVn
WXmTcN4GFT9wOlayZEw2KQc63DLRDvMF8CwV0xFP8VYuFWKEoOtHZW8Zu5+I4j00
PK/zkZpRC9NexBylJef15vy4mjUSw64y9PiRhzRZio1n9yfDm3+MYKAllatbEkAs
EONREsQNb4YmBX589YBIK51opOjbW9YMXH2tsZdj9CUha2gwnc3oqHxgciG4hR26
21Rj2vMblTWE0RcoIZOcgfXeLOOulckEoW4ssG0u64DqdREh49eqpNQ/n3lI6OyJ
PBztYLJkjqlBvPA88+PDztSGyh00SHPlwzg7UiivO6hhfkVtz1r9wPgyUyVGnqz0
Kp+Pa01bqZkuPpak4QhVT9drk4HUqw3t2uyiXCUaYbcaVLpHr0RVO8iRt6UhoGYo
ge604Zy84n29E9AHJsgbdZzdPa+OiAn9YvDzpGYxHMQw70KtRRICHTQOTPA+ABZk
LE7JT92EcrjP2wWZww9X
=XC29
-----END PGP SIGNATURE-----

--=-Voe8s4HviLIwaKbAhdXv--

