Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762193AbXH3Ou2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:50:28 -0400
Subject: Re: mac80211, iwlwifi and packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Dan Williams <dcbw@redhat.com>, ian <ischram@telenet.be>,
	Robert =?ISO-8859-1?Q?F=FChricht?=
	<the_master_of_disaster@gmx.at>, linux-wireless@vger.kernel.org
In-Reply-To: <46D6D759.2050600@warmcat.com>
References: <20070829161655.7f68542c@doppelhertz>
	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>
	 <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
	 <46D6D18F.2080108@warmcat.com> <1188483950.3978.15.camel@johannes.berg>
	 <46D6D759.2050600@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UVM+Dz1UksRt0vOtKqQo"
Date: Thu, 30 Aug 2007 16:51:23 +0200
Message-Id: <1188485483.3978.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UVM+Dz1UksRt0vOtKqQo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-30 at 15:42 +0100, Andy Green wrote:

> Well if for whatever reason you can spawn multiple logical network
> interfaces in the stack, as you can, NM should generically be aware that
> aliases exist it seems to me.

It could be aware of that, but I don't think it helps.

> If a device can handle two associations simultaneously (with two
> radios?), which I take the "multiple STA" to mean, maybe it should
> present as two wiphys and NM can take the hint from that?

No, no can do. You must be on the same channel etc. so it really is just
a single wiphy, but the card can allow multiple associations. It's not
possible with any drivers right now but I'm fairly sure we can add
support for that to b43 (if only with some microcode changes)

I think that NM should probably just ignore non-STA mode interfaces
completely.

johannes

--=-UVM+Dz1UksRt0vOtKqQo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1tlr/ETPhpq3jKURArQNAJ4o5aeN79EdVYRG5HRlih2bFCwgEwCeI21y
G4hdLtYXvxXJYAYSP6IFSaI=
=RiLE
-----END PGP SIGNATURE-----

--=-UVM+Dz1UksRt0vOtKqQo--

