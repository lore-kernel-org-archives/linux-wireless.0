Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbXIAKDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 06:03:21 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1188597785.7585.50.camel@johannes.berg>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188597785.7585.50.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QRkVjoc1+CgsrVGAgtR9"
Date: Sat, 01 Sep 2007 12:04:33 +0200
Message-Id: <1188641073.7585.139.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QRkVjoc1+CgsrVGAgtR9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Here's another thing:

iwlwifi tries to guess the state of the associate state machine in the
stack by looking at what frames it sends. This will sooner or later
break, please fix it by adding notification calls to the stack about the
things iwlwifi cares about (I think it's mostly powersave mode).

Also, it drops frames to not associated stations. This is something
mac80211 already does.

Then there's some code manipulating the QoS field: that's something you
should be contributing to the stack instead of hiding in iwlwifi. It
also seems to do aggregation. Why the hell are you adding deaggregation
to the stack while having aggregation here. Hate.

Also, there are some comments I don't understand related to
fragmentation ("copy frags header").

Clearly, there's lots of work to do.

johannes

--=-QRkVjoc1+CgsrVGAgtR9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2Tkx/ETPhpq3jKURAl8VAJ9nZVg6Pwq8JGSyjsNvzU2RwCCbTgCcCnUy
takSqV4AMfz+cB/K3V2H3w0=
=ORTP
-----END PGP SIGNATURE-----

--=-QRkVjoc1+CgsrVGAgtR9--

