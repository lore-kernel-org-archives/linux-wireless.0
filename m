Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXLJMXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 07:23:21 -0500
Subject: Re: [PATCH] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Dave <kilroyd@googlemail.com>, Dan Williams <dcbw@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1197225300.9149.74.camel@localhost.localdomain> (sfid-20071210_002335_513389_B559D9A5)
References: <1197073366.4563.15.camel@localhost.localdomain>
	 <20071207.181221.09900510.davem@davemloft.net>
	 <1197221467.9149.31.camel@localhost.localdomain>
	 <475C3538.1070501@gmail.com>
	 <1197225300.9149.74.camel@localhost.localdomain>
	 (sfid-20071210_002335_513389_B559D9A5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ITz6SjrLCfoIvoASqgtK"
Date: Mon, 10 Dec 2007 13:23:14 +0100
Message-Id: <1197289394.6035.63.camel@johannes.berg> (sfid-20071210_122324_683415_A737E009)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ITz6SjrLCfoIvoASqgtK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[what happened here with all the gmane addresses??]

> > Since iw_range is not packed, there are a few locations where there
> is some padding. You could quite easily shoehorn an 8 bit bitmask into
> the existing structure without impacting backward compatibility
> (unless userspace is using the padding for something). For example:

Ouch. But possible since we cannot do this.

> Hmm; this could work as long as that part of the structure is guaranteed
> to be 0 if it wasn't touched by the driver.  If it could be filled with
> garbage bits at any point, then it's not going to work.  Interesting
> thought.

That depends how the driver allocates it. Some drivers leak stack data
in these fields which is bad per se, and it's something we need to fix
fix in the kernel anyway.

johannes

--=-ITz6SjrLCfoIvoASqgtK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR10vsaVg1VMiehFYAQKzXRAAt/m8Ln0+TQadD1hppprsgBrLBpMuL63B
7AgikyAnIP2tlTtmr9usgmdRZ2NVafrZTt3S+wnCyRvj7o9t8ljdJrRyAhXkaeXQ
ReySkWjL4yUwbAtpcSaFX7CdKnPTjTYJPZ4vIM1+98tfyuj4L4D61pjCw0AMyaNT
NrPEZw8JTzc3dqa3HLjRLX+OCLfRkU9fJ1qOO+gUm2WYcU/SasTI/xxClmpfyoxo
FyCnMCteX3xWbUfTXrU7H4s+uD84r4EXnySCa9H1rQFLnT0cmjlvOxLTn779udzn
7UYyqhZQ0v8tsrUJrNFtONcopahdITDcgoVyk9H1awFvR3aiRsEMwWWPOSaABuvc
BiVIdb8nwJwfIzwjC5iEZ7CxudV8LJ3XJgWLoUaOE51fpTUpy+L5IYYKzt9QBTkY
iwqZeKu1gO/w4VNU3OEwDurYu6GHnytI8XMepiIznQaitOa068fCtb2kvoP5fQLQ
5xY4MU3bTIAfb3BqPqA3Uwfno53DySyN66G+iiQ1MMjWNWRXtsdIRSjyOynPtEKj
UHAeJ937sMhQBWv6uuBp013aBjVwyFA9giEMHTPE9q2nXGpY6jgaKiucrY7MLFhJ
FBZYMW89UalLRiAf4SqfN8If4WQ57SWGHNhXn+yBN7CHhCCoIvKp++E9wf1comcK
JaGxmwRT3N8=
=TjOv
-----END PGP SIGNATURE-----

--=-ITz6SjrLCfoIvoASqgtK--

