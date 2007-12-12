Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXLLRsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:48:10 -0500
Subject: Re: mac80211 ethtool support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200712121148.48716.mb@bu3sch.de> (sfid-20071212_105038_901676_D5ECF8ED)
References: <1197361048.3170.381.camel@debian.sh.intel.com>
	 <200712111350.25522.mb@bu3sch.de>
	 <1197421988.3170.405.camel@debian.sh.intel.com>
	 <200712121148.48716.mb@bu3sch.de> (sfid-20071212_105038_901676_D5ECF8ED)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jBLQAGBLdAEH9TBcowNl"
Date: Wed, 12 Dec 2007 18:45:20 +0100
Message-Id: <1197481520.6558.140.camel@johannes.berg> (sfid-20071212_174831_398856_6D994507)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jBLQAGBLdAEH9TBcowNl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yeah, we can do this also. But the users want a standard way, especiall=
y
> > when there is already such kernel interface and user space tools ready
> > there. Any chance mac80211 supports ethtool or something similar?
>=20
> You could write a patch.
> Add a callback to mac80211 that mac80211 uses to register the eeprom
> ethtool interface.

NACK. Which virtual interface should get this? wmaster sounds like the
"obvious" candidate but we want to get rid of it ASAP. And the others
ones are pretty wrong because you can, technically, have a wiphy without
any virtual interfaces on it.

Maybe it should live in cfg80211's sysfs...

johannes

--=-jBLQAGBLdAEH9TBcowNl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2AeL6Vg1VMiehFYAQKi3g//bfPhKzzRb2Mrggw48G0nnVxP+Rhr0trK
Xa5elEK5ys6k8f4+SY/RfTs3i0UDvQMPSfQayPCdh5E7ucLaFjljdYHkpdPiHzht
3Sd3U76dfoD6ov4YJ0XfcrUqAb8ndHhiFukMlaPgBQUYP0Wrqn7CV+EZykditmBm
ShTEOj4MmTb+250+k5WA+dFCgH6Z+016NdlAfSVP1/QTVpL/WCzrI4w9R8WnDiMQ
gJe9UkDS06JAShBJ7eQRWZR+tY2PRwhd2O34AfCyYqrIYzGUND+iWVRFi1BACLeY
6zMC/VACPyiCRFTM6RrJXZMlkld6POECmTelpagnSyeNUBycDJ4ERStyFd9KCNnm
NIMaYSUO8iwCZWxhmX4TYxGAL2l0sbnwiIYJlcTI5PERMWY+skZ8xykRAk00RNxh
wKg01DorRS6kDe2keNhMhJJZOhAyxwgVglfco8EvJppjbhPyV8IVmqdBJBb7qyge
FM/22I0zyc7+7dLOSQltaOSXT950HsY3ca2z21JOqSlM5TVgrNSOUTS2WfK8AcGK
C1zga7kzTOObV08JmbYRXpgbunkaQOj2Iv54Sl5g8M70JgcKqYVahYHbcG8/9irz
bGqfjZgnAqNYwj5PmolNAsaeIQlrZH3WlCLFCQIK7hQzRcfyfOHtyPjPdcEU0AyP
btDqTQvFBM4=
=dcx9
-----END PGP SIGNATURE-----

--=-jBLQAGBLdAEH9TBcowNl--

