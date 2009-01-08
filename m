Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZAHQwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 11:52:49 -0500
Subject: Re: [PATCH v2 1/3] libertas: Fix alignment issues in libertas core
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin McCabe <colin@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, dcbw <dcbw@redhat.com>
In-Reply-To: <1230951623-26998-2-git-send-email-colin@cozybit.com> (sfid-20090103_040451_022232_D73555CB)
References: <1230951623-26998-1-git-send-email-colin@cozybit.com>
	 <1230951623-26998-2-git-send-email-colin@cozybit.com>
	 (sfid-20090103_040451_022232_D73555CB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i+F9yd9rFv1enzSRGPzw"
Date: Thu, 08 Jan 2009 17:53:17 +0100
Message-Id: <1231433597.8398.3.camel@johannes> (sfid-20090108_175253_557694_88A302CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i+F9yd9rFv1enzSRGPzw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-02 at 19:00 -0800, Colin McCabe wrote:
> When loading fields from packed structs, use get_unaligned_le16 and
> get_unaligned_le32 instead of le16_to_cpu and le32_to_cpu.
> This doesn't matter on x86, but it is important for some other CPUs.
>=20
> Also, mark all packed structs as packed. Generally, any data structure
> that comes over the wire from the WLAN firmware should be a packed struct=
.

Just marking the structs packed should be sufficient, since then the
compiler must assume they are potentially unaligned.

johannes

--=-i+F9yd9rFv1enzSRGPzw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZi97AAoJEKVg1VMiehFYwSgQALDrvy7pgQedloWpLlLZkKJw
JdRTVHUviLuda2e4OA1z5sP79u+Y/Gxa9elgczB4JW0oYgJVpYgwtFf7zELrU4ii
+UYunWh+LHsV7AWRJHawJCMrTMSNU1J4PuXr4jhb+OlmhLbVyY1fNvhKy1wsGbwP
VuXtFjrnP3QNZlvoIajsTLFz++qQHB878G3SR1xMUF16+KgAYDYRPIYzmTFyid/h
JnpYfR4ycrnDviSiXTRgTktfmnXJ+uo3FDZ7fZYy4m5ZvevQn4h2FrnTAE/pRfDV
QdNLwJdIRu4aF+eSZIoFUHTtL0W78v2XWdUc59lYk7WXBYPthb6kZHC7favs+qPg
kGj/PiKp13+JeelfFrzkrQ6s4Rv7LrzbMqg+wOMuMx7jQn5y1SlnRCsD6uY8nbrD
oY6z0sVBk0S2yuNkdrfb2BrapgXheZvzAOJON8X9RbYmhBsqJnX+Ma2Yd+F+u9q1
IZfwGqc5Y7q634hIakd4GCFo8fngqkNMZD3RwRgFkvCJGRRW7ldXoGK+O5EPmHIB
Zjv2mioinBEzTO1VW+FQrmPMFqi2fX8xmhtPKC0qX4d854EYAKCSIYK2ZhMVDEMH
kD9zkRkV8sYyNQZEvohJusyDy0sso7yE91nq2fuI4RlB5A++2RMyCYdqnj/vKDeP
yFStUYWJSVO+IwEn97kM
=UXPb
-----END PGP SIGNATURE-----

--=-i+F9yd9rFv1enzSRGPzw--

