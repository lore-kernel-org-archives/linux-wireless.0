Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946123AbXBPUW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 15:22:26 -0500
Subject: Re: [PATCH 09/10] cfg80211: pending config
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1171653056.4153.38.camel@localhost.localdomain>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144300.419560000@sipsolutions.net>
	 <1171653056.4153.38.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QJXUfhFM5BvaQsxOkUf5"
Date: Fri, 16 Feb 2007 21:22:24 +0100
Message-Id: <1171657344.3575.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QJXUfhFM5BvaQsxOkUf5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 14:10 -0500, Dan Williams wrote:

> This has _got_ to be defined somewhere else in the stack?  Can we use
> that define, or is it being moved to here?  Seems a shame to have it
> more than one place.

It probably is...

> On a side note, many many drivers need something like this, and many
> many drivers redefine it internally.  Is there some header that all
> drivers (even fullmac like airo, orinoco, atmel, and libertas) can get
> this from?

Yeah, we should have some sort of stack/driver agnosting IEEE 802.11
defines header w/o functions in it. Then I'd use that here too.


> > - * NB3: It's really bad that we can't report an error from the timer-
> > + * NB2: It's really bad that we can't report an error from the timer-
> >   * based commit... Hopefully get_config_valid() can catch everything?
>=20
> Well, we'd have two choices; first, a netlink notification that the
> config was unsuccessful, or second a WEXT SIOCSIWAP event of
> 00:00:00:xxx for WE compat.  Why wouldn't one of those work?

Yes, we can give a notification that it was unsuccessful. For wext, we
don't actually need all this I think because we do it with commit
anyway.

johannes

--=-QJXUfhFM5BvaQsxOkUf5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1hKA/ETPhpq3jKURAmV5AJ4y8koaNy8hV0Kk+c8TRrf1le6VYwCeN0Li
+bUPqD3glhxqEUHJAUCYAm8=
=bmUr
-----END PGP SIGNATURE-----

--=-QJXUfhFM5BvaQsxOkUf5--

