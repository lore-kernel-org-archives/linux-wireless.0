Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYIOQAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 12:00:21 -0400
Subject: Re: [RFC] Implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809151429.46638.hschaa@suse.de> (sfid-20080915_142954_498790_4E509226)
References: <200809151416.07552.hschaa@suse.de>
	 <200809151429.46638.hschaa@suse.de> (sfid-20080915_142954_498790_4E509226)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5rNWJxcofYPLKN6mtM0t"
Date: Mon, 15 Sep 2008 17:59:43 +0200
Message-Id: <1221494383.3700.52.camel@johannes.berg> (sfid-20080915_180025_157848_EABB3EC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5rNWJxcofYPLKN6mtM0t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 14:29 +0200, Helmut Schaa wrote:
> Basic implementation of software background scanning functionality.
>=20
> The patch basically enhances the scanning state machine by two further
> states (SCAN_DEFER, SCAN_OPERATION). In state SCAN_DEFER the driver is ad=
vised
> to switch back to the operating channel while SCAN_OPERATION tells the ac=
cess
> point about being back from power saving and restarts the tx queue. Just =
before
> SCAN_SET_CHANNEL sets the next channel to scan it notifies the access poi=
nt
> about going to power save state and stops the tx queue.
>=20
> However one (still unresolved) issue is that the code does not wait for t=
he
> appropriate ACK from the access point after notifying the new power state=
.
>=20
> Any thoughts or comments?

This doesn't play well at all with hardware assisted scan as far as I
can tell.

johannes

--=-5rNWJxcofYPLKN6mtM0t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzoZrAAoJEKVg1VMiehFYF6YP/3kKKH1SMj8EhJcZpiEhD5EE
+UouqKLqBqNNEBzkBxr2c0JoVU+1wO6M5X/5ePdLGdj2cpbYLgKXnuq26/T2WWRk
iBQUYLthrkn6ZyCIS8RLdKP9cU8hCklL1fJLr123nCOIg6ya8qD8RJ6O0/R9szqu
p7XKDJoBmclsomP6hB+mZo5Xr7waqcaxiBDWw09uzeKYIb4LgvPjuWlnECpp3bKd
uQADuWpCO2G1yOsxbFkBPHCwRBIGWgxoKjTHhL4Wtc5GLTOqtX1L8DaVizMx5CPy
I8w9D/wtIAORpzZeLZAZCqQJSIcB6GAtg9G6PFyKS7oWQrdfat2RF2Y207L84b/L
rouOWA2WaOF4yEZpiAOV7hOpKRHu8dX466E2qLJJrtLyVwKV8AOPDVkPVh8cS5eR
zYNkyett9ry8bMah7oH1tuywso7em+MD/ZjH5HgjhrmzMvgGfLGymQGWosNma0Jd
FZXl6NuyDrqfhmoMMHnSOXfLzidZAjezA0nV4oCp39krPvTHjUKOdwiUpLnzWOI/
I0qoNbM8sN47aqs3AJOOd2OMRnmvVDzgnDU10ureJH9LGyyl3a2wsOZL1f6ZDFT+
UfPefJyqg1JBuhHf9tBYB1IhiZ8tkRQNYDFWBzwJ9s7o57cDF6o66tZV6ySawaJm
23LFq1aUhstLoP929sTN
=c80p
-----END PGP SIGNATURE-----

--=-5rNWJxcofYPLKN6mtM0t--

