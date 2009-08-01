Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZHAI2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:28:38 -0400
Subject: Re: [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, proski@gnu.org
In-Reply-To: <4A73FBBD.3070507@gmail.com>
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis>
	 <4A73FA8D.5030804@gmail.com> <1249114918.26584.18.camel@johannes.local>
	 <4A73FBBD.3070507@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-b4RBZgJMeX6ZANoNAMQ2"
Date: Sat, 01 Aug 2009 10:28:36 +0200
Message-Id: <1249115316.2007.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b4RBZgJMeX6ZANoNAMQ2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-01 at 10:24 +0200, Jiri Slaby wrote:
> On 08/01/2009 10:21 AM, Johannes Berg wrote:
> > Actually, jiffies are unsigned long
>=20
> Yeah, this is what I meant. I agree I messed it up when I didn't write
> the unsigned explicitly. It might have been confusing, thanks for
> pointing out.

And, in addition to what you said, the code shouldn't divide jiffies, it
should multiply the timeout, add it to the start time, and then use
time_is_after_jiffies() or so.

johannes

--=-b4RBZgJMeX6ZANoNAMQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKc/yxAAoJEODzc/N7+QmaI/8P/0NF2y8i6YJ8D5aJwAWhDqs5
pYthE81046oUNQbiUGqxjX5zgRFqU7i2AAqny5RFRMbdQW8X72DPoygu4f88G1BL
TmBogdqPJfixk5ZPEF0kgG39kv1Y17IgMwnnUBNF8NGoR6Cl44KNklUwmFm0MKgH
NY5Dosl0ad9byr9IrzvIkM4I4nUfDy9JrdIIe60kOMMxp9DG3P4BujXqWQC+tlHi
jrvA5KBVjY2uREip9nIPLAYvUyz/6lvESSjia8nrqOhH11ZP7E2ig5WYfEpDNuOi
rAWQccdXJW7yHIVV2SPu6Y1Hy8WrmQYKse5ecueAlh5GytzaD/4JraooeIsF6QSp
3yvc59/OiZpBPKVFc7sE+CGw10XYF5bR7Zux8O/73uJElYnmaOMU6xU1f6iu1kJH
+BSOlIslKoQrtRJBARP0TWMY+LPx0yKrVjeoQADTriKoug+i6qvqBcLI3crYpRfm
sb97oOPTYv2iE7n1WVlyVpl/2fwUFjefmaU47SBldW9apQzHk3f8RiLw8OmQo1Vz
zilO3khl5FLMciVrQxvoCdseMER9LqJkO+rhMvsBV4MrCofXE8clG5KHgE2EMTwK
KIgdN7eBL79SQJPezYHn3hLIwBWzwlI2bMVl3UBxI5ilKqeWfSkjeouPGJm1dF7Y
P4SgujbKu/UQUx37OLWW
=Acoh
-----END PGP SIGNATURE-----

--=-b4RBZgJMeX6ZANoNAMQ2--

