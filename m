Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYFCUdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 16:33:03 -0400
Subject: Re: [PATCH 01/11 v2] rt2x00: Calculate register offset during
	compile time
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200806032205.17071.IvDoorn@gmail.com> (sfid-20080603_215801_894462_AB9F039C)
References: <200806032024.52931.IvDoorn@gmail.com>
	 <200806032029.35662.IvDoorn@gmail.com>
	 <200806032205.17071.IvDoorn@gmail.com>
	 (sfid-20080603_215801_894462_AB9F039C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1uVIjH9GRu8Bsb/mIOc7"
Date: Tue, 03 Jun 2008 22:32:10 +0200
Message-Id: <1212525130.14371.0.camel@johannes.berg> (sfid-20080603_223307_583574_2199C50D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1uVIjH9GRu8Bsb/mIOc7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#define compile_ffs2(__x) \
> +	( ((__x) & 0x1) ? 0 : 1 )
> +
> +#define compile_ffs4(__x) \
> +	( ((__x) & 0x3) ? \
> +	    compile_ffs2(__x) : (compile_ffs2(__x >> 2) + 2) )

It seems you should also add parentheses around the __x used in the
recursive macro invocation, like this:

... : (compile_ffs2((__x) >> 2) + 2) )

or am I missing something?

johannes

--=-1uVIjH9GRu8Bsb/mIOc7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEWqSaVg1VMiehFYAQK3NA/9EWzlBP8mCwlGWxMU2MTp2jBCLqWqR99e
q+FmP+zvxk8mviyfS4lDSHJCC5qQIx6kUGcktwhGGtcUSsNbsS4IFC8InenY7HG1
257SHa0wznFdxyIFa0FI4UCs5XWLjFuXZ8l1cYSLqBrQj2k1Y3ry0cNb+TSjj0/9
6SRpUkjPCLJUY5++PNMiY5iOXLIyk/8+fwIioft8bYdvOQU4XZ4HY3alu4BVNhbc
u/QX2vqZaPbZ7JKBx088VJzKuB9+OXfKJ+htHtJgtc3ZPaMk5o7raDrqqg+DJXhx
ANiQpKY7lM1gwaf8L4eNioo3pzqxCUy87z5OFxi2x8AusFy4ewFGfH3fkojvPqBR
7drZuR/igsl/92ZI1l6xvfkxL2RRDqUXqE5SE5gQ2uJ9UgNrtgLmLRaut0/z0OrY
YeM1wk8Z2jXSlKK6yzwsxXQzEIOrTQZw8NKdVrAQBDN1u4fnBnp2/43HrsvvhjCT
yzhfga/bDInli8n4FLOdxRJJgFlwTYs1ZgL25a0gHXe1PBTMwxnukhmeUGi/Eqor
jGf9FUtuVmBzbVF7LFN7UBbSVBciOlCEHlzQTc7amlxWbeEQ3ITEmyxs6L3mw3lc
7uP9DgtZlG80/KMyAitAlQt/odExBSymKOwCAk2hsKriwrFCMWfDeQ3ZzdH2n+TM
2g3T08jyg+w=
=jJH6
-----END PGP SIGNATURE-----

--=-1uVIjH9GRu8Bsb/mIOc7--

