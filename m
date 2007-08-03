Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763123AbXHCW3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 18:29:19 -0400
Received: from [84.135.224.6] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IH5e1-00070X-5O
	for linux-wireless@vger.kernel.org; Fri, 03 Aug 2007 23:29:18 +0100
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1186178959.13315.30.camel@johannes.berg>
References: <1186178959.13315.30.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0E5lDmv1YlCbxNaLappA"
Date: Sat, 04 Aug 2007 00:30:53 +0200
Message-Id: <1186180253.20275.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0E5lDmv1YlCbxNaLappA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-04 at 00:09 +0200, Johannes Berg wrote:

> 4)
> Change the "int flags" argument to the set_multicast_list callback to
> "int *flags" so drivers can indicate whether they supported a flag or
> not by clearing all flags they did not honour. Additional advantage:
> drivers break and people will be forced to re-examine their code to use
> the new flags.

Hmm. I think this is confusing because set_multicast_list is also a
netdev callback. Maybe we should do the flags in another callback after
all? Just so people who've written a regular net driver won't be
confused.

johannes

--=-0E5lDmv1YlCbxNaLappA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs6yd/ETPhpq3jKURAgclAJ92SF9j/JkSsEYRuiNc8099OleWugCeJ6zI
Kb3mSOkGVkLtqGvj4RboqqQ=
=+rBF
-----END PGP SIGNATURE-----

--=-0E5lDmv1YlCbxNaLappA--

