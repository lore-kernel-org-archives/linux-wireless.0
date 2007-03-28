Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbXC1Js7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:48:59 -0400
Subject: Re: WPA/RSN information in cfg80211?
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Powell <Mark.Powell@csr.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <460A3665.5090906@csr.com>
References: <1175034846.5151.20.camel@johannes.berg>
	 <460A3665.5090906@csr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ePqGCI/z8Fnuzel3P+op"
Date: Wed, 28 Mar 2007 11:47:43 +0200
Message-Id: <1175075263.5151.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ePqGCI/z8Fnuzel3P+op
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 10:33 +0100, Mark Powell wrote:

> FWIW we currently use the value of IW_AUTH_WPA_VERSION to generate the
> correct cipher suite selector when forming the set-key request for our
> hard MAC device. We use other IW_AUTH settings too.

Ok so that means we definitely need the individual settings. I thought
so, but wanted to make sure.

> We certainly need the individual settings. It is nice that
> wpa_supplicant generates the IE - it saved me writing the code - but
> that's just being lazy. We still have to modify the IE anyway to add WMM
> stuff.

Do I read that as "I don't care if we get the IE"?

Putting the IE there has the advantage that you can easily play with new
things for cards that use the IE by sticking a few more IEs into the
attribute. But it has the disadvantage that cards behave differently if
you give them contradictory settings. Maybe we need a way to ask a card
which one it wants.

johannes

--=-ePqGCI/z8Fnuzel3P+op
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCjm//ETPhpq3jKURAuPEAJ41J62uHX1anGv13jmH9t2frqbISACeKPkz
nFTtIh/fE8DXf2nAJUD0eRo=
=AsoE
-----END PGP SIGNATURE-----

--=-ePqGCI/z8Fnuzel3P+op--

