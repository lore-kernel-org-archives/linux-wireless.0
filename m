Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbXC2LJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:09:43 -0400
Subject: Re: [PATCH] mac80211: optimise ieee80211_get_hdrlen
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070328191116.GJ6036@devicescape.com>
References: <1175011305.9282.10.camel@johannes.berg>
	 <20070328191116.GJ6036@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9+P/Cmk9hM73Tf8TSQ4L"
Date: Thu, 29 Mar 2007 13:07:27 +0200
Message-Id: <1175166447.8807.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9+P/Cmk9hM73Tf8TSQ4L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 12:11 -0700, Jouni Malinen wrote:

> > +		/* QoS Control Field */
> > +		hdrlen +=3D (fc & IEEE80211_STYPE_QOS_DATA)
> > +				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
> >  		break;
>=20
> Could you please add a comment explaining what exactly happens here and
> more importantly, include an easy way of understanding that this adds 2
> bytes.

Yeah, I should do that.

> Is this case even used anywhere? Looks like unnecessary optimization at
> the cost of making the source code more difficult to understand and
> modify.

Not sure. I tested in userspace with a program that simply tried all
possible values.

johannes

--=-9+P/Cmk9hM73Tf8TSQ4L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGC53v/ETPhpq3jKURAks7AKCrnJeY5Be/gqrR4oQ+eMCKHhExFgCfcHgm
NHeeoZzxYrNu2Y54Lg52Jpc=
=3aCL
-----END PGP SIGNATURE-----

--=-9+P/Cmk9hM73Tf8TSQ4L--

