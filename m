Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbXILIQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 04:16:31 -0400
Subject: iwlist and network-manager bug report
From: Johannes Berg <johannes@sipsolutions.net>
To: Jean Tourrilhes <jt@hpl.hp.com>, Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1QFNhQRPUzJbiS/8+mK0"
Date: Tue, 11 Sep 2007 18:07:53 +0200
Message-Id: <1189526874.6161.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1QFNhQRPUzJbiS/8+mK0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Jean,

I have no idea where to send bug reports for iwlist so I'm mailing you
directly with CC to wireless-dev so others are aware.

Dan, for NM I suppose the right bug tracker would be redhats? I'm
offline as I'm writing this so I can't check.

Anyhow, the problem is that my landlord has an AP that broadcasts an
SSID with a 0xFC byte in it (supposedly an "=C3=BC" in windows). iwlist,
however, just prints

		ESSID:"B

and nothing more (the SSID is B\xFC...). wpa_supplicant converts it to
an underscore in its output (B_...), and network-manager also seems to
not like it, though it doesn't display any networks right now. Might or
might not be related.

I think it shouldn't be displayed truncated, although it is probably not
possible to display it in a fashion that all shells will properly parse
and convert to the right binary before invoking iwconfig or such.

johannes

--=-1QFNhQRPUzJbiS/8+mK0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5r1Z/ETPhpq3jKURAtcsAJ0UzaiHfCYYz8iN8bMsqG1spj+iPACeMh85
ztJ8xoB/47l0BnkZQpW1xHA=
=xFz0
-----END PGP SIGNATURE-----

--=-1QFNhQRPUzJbiS/8+mK0--

