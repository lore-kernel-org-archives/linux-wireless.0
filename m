Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZBXHEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 02:04:10 -0500
Subject: Re: Lockdep rtnl_mutex and genl_mutex circular dependency
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1235457352.4455.94.camel@johannes.local> (sfid-20090224_073621_026588_C3A80F8E)
References: <20090220023144.GE4740@tesla>
	 (sfid-20090220_033236_226088_BAC87115)  <1235457352.4455.94.camel@johannes.local>
	 (sfid-20090224_073621_026588_C3A80F8E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lor/0D2Q18Ocx1OeS045"
Date: Mon, 23 Feb 2009 23:03:32 -0800
Message-Id: <1235459012.4320.0.camel@johannes.local> (sfid-20090224_080413_374143_74E1EAE2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lor/0D2Q18Ocx1OeS045
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 22:35 -0800, Johannes Berg wrote:

> pre_dumpit does rtnl_lock(), and netlink_dump_start() will re-do
> genl_lock(), so here we end up with a dependency of rtnl -> genl. But
> in the non-dump path, we do the pre_doit() with genl held, getting
> genl -> rtnl. We thus have to change the genetlink change, patch coming
> in a minute.

It's actually harder than I thought -- I need to try to understand the
genl locking more, but not today.

johannes

--=-lor/0D2Q18Ocx1OeS045
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo5vBAAoJEKVg1VMiehFYREYQAItRYvTRKnsmmBRgxXxPuWLM
sEscNH294w3Gbay7hCG7KxZp+sImM2Aqw+peNu+7VR3l1De5GAAivre5cXnVJw6W
pTciuR3JEv/bHOUpdRcuLXf9x+iqwBkWNAXaPIYOFWbojjH9YymriDgT6Z9pl3fD
ffnVOVNNSQryaa9K+Bye7XG/4SMXi+hl5JBwQaoIPa5YjSvnsfSj0xutmTzd8USY
SnK0tCbcX17pPsDsOCGReuL1sYvClXdSUImIaDLXtze+1YO6cozvm3/uY34Fmsl8
gNuD4qPir7Tq0jh4kVjeYYojDGuDYyL8EYb7tcY+oBQEd6q67Y0ZOkJyL8dxluRM
iy+6tySNwIT1HuiOpqyyVtGGC5QV7vX9j+yXDX6qm/ECSVFMvssMwZez4/mBewQ4
CQ4sgC0jU2UzEu6QymvEJ3ZQPcADrQdTqZxccr/0V0oVXllJIfJYqfnZ4egxiI91
QGujH6A+bLHtuGIKyKJ//NakSAq2ftdLe2KSxnN4is9zH3NEWvjDoxDq8pKn02MP
44QQbTd391N5lJBUfkAL0bmmBoE9n/fxNg0Cje1EwIY9vD1GmTIQE8a0E4c2tGWv
fdv65mT17mw3adiYHcpK8Bazs3tCLwvlbTRUAtL3tJUL8teCwoW4N8yo4x1R2Wsl
BOPBvCMMCeaKEtMKJ0sy
=SLkB
-----END PGP SIGNATURE-----

--=-lor/0D2Q18Ocx1OeS045--

