Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbXIJMW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 08:22:28 -0400
Subject: Re: COMMON symbol warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20070910121410.GA5948@infradead.org>
References: <1189100314.28781.112.camel@johannes.berg>
	 <20070908130118.GA11648@infradead.org>
	 <1189422492.4506.54.camel@johannes.berg>
	 <20070910121410.GA5948@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hRk9iSxYNXYaeeT5JwQP"
Date: Mon, 10 Sep 2007 14:23:53 +0200
Message-Id: <1189427033.4506.95.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hRk9iSxYNXYaeeT5JwQP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 13:14 +0100, Christoph Hellwig wrote:

> No.  Say you have the following case:
>=20
> ----------- foo.h ------------
> int foo;
> ----------- foo1.c -----------
> #include "foo.h"
> ----------- foo2.c -----------
> #include "foo.h"
> --------- Makefile -----------
> obj-m +=3D foo.o
> foo-y +=3D foo1.o foo2.o
>=20
>=20
> This gives you a foo COMMON symbol.

Ah, ok. I'm not familiar with these drivers though so I have no idea why
this happened, and then only with -D__CHECK_ENDIAN__.

> But at least on i386 the kernel
> is compiled with -fno-common so you get a warning like:

I'm building on powerpc. It has -fno-common as well.

> I wonder how the driver build managed to override our global -fno-common
> setting.

No idea. I guess the driver authors should look into it :)

johannes

--=-hRk9iSxYNXYaeeT5JwQP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5TdZ/ETPhpq3jKURAjtRAJ9fpLZn9NROf0Jh26JlBS8TD/9F0ACgjOe/
vLnT2aJh6rUBAsnToEj8Duc=
=RImc
-----END PGP SIGNATURE-----

--=-hRk9iSxYNXYaeeT5JwQP--

