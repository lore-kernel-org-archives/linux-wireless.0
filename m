Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZC3SBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 14:01:33 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dirk Opfer <Dirk@opfer-online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <200903301954.07008.IvDoorn@gmail.com> (sfid-20090330_195439_260176_1774BB4C)
References: <1238349195.24972.5.camel@johannes.local>
	 <200903301039.52153.inaky@linux.intel.com>
	 <1238435143.5970.21.camel@johannes.local>
	 <200903301954.07008.IvDoorn@gmail.com>
	 (sfid-20090330_195439_260176_1774BB4C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/EycPs5LrXfJRxXsbg3X"
Date: Mon, 30 Mar 2009 20:00:58 +0200
Message-Id: <1238436058.5970.24.camel@johannes.local> (sfid-20090330_200211_457742_654EB4C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/EycPs5LrXfJRxXsbg3X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 19:54 +0200, Ivo van Doorn wrote:

> > > wimax_report_rfkill_hw() -- device driver report to stack
> > >  =20
> > >    device reports a change in the hw rfkill key; switch the radio to
> > >    whichever state AND report a key event through the input layer
> >=20
> > But reporting the key through the input layer is wrong, afaict.
>=20
> Why because it combines it with switching the radio?
> In rt2x00 all key events are going through the input layer as well,
> because it has no influence on the radio state of the device.
> (In other words, you can still happily send and receive all
> the data you want regardless of the key state).

Yes, but my understanding is (and I've just rewritten the code, heh)
that if the button switches the hardware kill directly then we don't
report an input event.

Except in very limited circumstances (like the thinkpad-acpi platform
driver Henrique explained) I think doing _both_
rfkill_force_state(hard-blocked) [in new API terms:
rfkill_set_hw_block(true)] _and_ input_report() is incorrect.

johannes

--=-/EycPs5LrXfJRxXsbg3X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0QjXAAoJEKVg1VMiehFYR5IQAMQPVmi4UH7+mlRcBmVkhQ/n
m6EKguAWSgjmxLoYxHpAfWjcG7xOlD1lcUSKVJHF5R5evnIv7zajkzdvsB8YsRi5
SZddLY3iOBjLV/baBFl3qWOJLlk+Zrb+ZKndN2+tne9G6U8sqRAUaU8Aj7PwTd0K
wZt/swDbtpwUXQTb3bqxRBp6b4hfJjlCGm+gyupy+jQkcY9KB9i3glX95FfMfLNS
5CHCl3jkPaHO9RZ/dX74+LOy8+MaIxcEq7ufLzerLWPV+1hvrc/TswDB+9Mu+FDA
ufUEjZX9WPPvw3YP8Av8aQkZRXCbEMylKilODD7IAE29xuDARqKg2SnIwB0+V7C4
pL7RTTKLRk7pbYwLz0t+Y/TuYHOtTlKmcU1g8+EZ17zpB0NEk9zLEOFMGkidgM7r
Soqb8HgiyDVdRKx4YCZhdmEd9vnvcsrRJtNLkkxWAVcOEp4LwD24EgxWHIOE0byL
OW8FCLliZdrrWSCdOj7wvf4hsP5myYvgkQLlxaDLI6a4yQlGW92Q54pQ18TVtifv
U6gigLby5FSII+HBCPWsWylm/ilavSvUFwAOlq1WZ/Ir8e5sjQ+A04E9ZZJ/vR82
1XAydO303rVnep9bhE9j2hoVw3wgH6D5zSraBa2yEl4G0mGcY8Z9WcPQLc5rzTuq
5ZlW/WeD4Ml93l4p3ivs
=dA3K
-----END PGP SIGNATURE-----

--=-/EycPs5LrXfJRxXsbg3X--

