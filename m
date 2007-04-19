Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030943AbXDSKMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 06:12:52 -0400
Subject: Re: [PATCH] wext: allow wext users without rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: shemminger@linux-foundation.org, linville@tuxdriver.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
In-Reply-To: <20070418.140956.116355415.davem@davemloft.net>
References: <1176825010.3902.28.camel@johannes.berg>
	 <20070418140451.075370fc@freekitty>
	 <20070418.140956.116355415.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-snyHhy2GCkyz442SrozA"
Date: Thu, 19 Apr 2007 12:12:16 +0200
Message-Id: <1176977537.6141.75.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-snyHhy2GCkyz442SrozA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-18 at 14:09 -0700, David Miller wrote:

> > NACK Conditional locking is bad design.
> > Either lock or not, make up your mind and fix the devices.

That was because I don't think we can go fixing all current wext users
which might even be out of tree.

> It is also wrong because all entities in the kernel assume
> that network configuration changes all occur under the RTNL
> therefore it must be held consistently everywhere.

So you're saying that cfg80211 should hold rtnl too? I don't see any
point in holding rtnl (for example) for setting the SSID of a wireless
device.

johannes

--=-snyHhy2GCkyz442SrozA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGJ0CA/ETPhpq3jKURAt9xAJ47z1uDJB3dO/NndWVQxhfG8QTg2ACfQpuo
ZdEj2MXGtCAqzr9x7ITLtYU=
=WQmT
-----END PGP SIGNATURE-----

--=-snyHhy2GCkyz442SrozA--

