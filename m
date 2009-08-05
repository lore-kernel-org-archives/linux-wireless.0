Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbZHEFdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:33:41 -0400
Subject: Re: [PATCH 001/002] [MAC80211] Retry probe request few times
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1249450153.6083.4.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249056896.20593.3.camel@maxim-laptop>
	 <1249438947.3094.30.camel@localhost.localdomain>
	 <1249450153.6083.4.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3WEqf1VWIlhalB6iyeTJ"
Date: Wed, 05 Aug 2009 07:33:36 +0200
Message-Id: <1249450416.4168.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3WEqf1VWIlhalB6iyeTJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 08:29 +0300, Maxim Levitsky wrote:

> > [54632.657912] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 1
> > [54633.154560] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 2
> > [54873.231210] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 1
> > [55113.467840] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 1
> > [55113.964510] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 2
> > [55114.464516] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 3
> > [55114.967868] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 try 4
> > [55115.464511] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms,=
 disconnecting.
> >=20
> > Should we increase the value to 8 or something? Or just accept that
> > sometimes we get a disconnect?
> >=20
> I think a disconnect or two aren't a problem, they are always handled
> automatically, and can be caused by natural events.
>=20
> Even without these patches (I have WPA2, and disconnects were every 4
> five seconds), and still it was possible to use network.
>=20
> One disconnect in a day is really nothing to worry about (I have seen
> such here as well)
>=20
> You can increase try count, probably won't hurt much (each try is 0.5
> seconds, so even 10 tries gives total of 5 seconds, before disconnect on
> a really unaccessible AP, anyway)

Mind you, each try will end up sending a LOT of probe request frames,
iwlwifi sends like 12 frames for every try and never gets a response for
some reason, so I wouldn't really increase it much further since you'd
be spamming around a lot.

johannes

--=-3WEqf1VWIlhalB6iyeTJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeRmsAAoJEODzc/N7+QmaE+kQAJnOYAQF/5qExKjpIisfwD4F
19MLP3lcJ//a8AQYIcFH5ELokYNmWkD6UYAmfsVznr24wM+Z+xwZTMLXAeTDZ6Br
WaCj9IbVwvlTNSzRXmIFd1WlH+fMKBLZO75OZrkGoI4axqVkn8bJxJFAmZOqlJo1
OM+t+jypNlZuyuSexERIBsI/njd1teJPokuZMcSab6UWHgLjjCUSt58jOUR86ikt
OY22ZP5XipDNARi3WeBq0W5N6Z+dJmHatelG7x6FMcxidX36Tf8mdHpNRv3cxrUT
sf+Ljr3eTXomYd3q5Q4JfsaUaZ/3gxCfn2xISmtQY3mba4zXPfG2+SukCxvWsLDL
XPxyVK32v59+H01VEG4Q4c0pFmIdBtQgpiOdyHWlXh/UyIV3PkuLWXiMEoiMXqdi
7WCqMOtSOP4tzPy/yvF7aAunAxx8IlfmezApZCdv6AJUJRwn1edvUJi0bVlBj/2X
UN+Tfo/3M1ELSD6IVx2+0nGzAnkvC09Mn4F70+8UQMHoABxzcGGvpgGzoRrOGfvt
dk8dGv8ZbwnkskFPuYexXlHPUrFEsV/GVkLSzGPvqiPj4FbHD0bXF5Fzas79R+k1
zMqvm0qYTIFW4mDZrCQeSoIQpvU63hpUgNM9BqMaJEzQBF2Stnjc6UwR8f30poWl
LuJhrJpYSSnLS4l/I3DE
=6jry
-----END PGP SIGNATURE-----

--=-3WEqf1VWIlhalB6iyeTJ--

