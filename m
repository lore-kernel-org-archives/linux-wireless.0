Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbXHOKq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:46:56 -0400
Subject: Re: [RFC] the recently discussed flags patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <200708141848.57809.mb@bu3sch.de>
References: <1187108515.4037.3.camel@johannes.berg>
	 <200708141848.57809.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oVbETefM5RKaD3ylZkwV"
Date: Wed, 15 Aug 2007 12:38:02 +0200
Message-Id: <1187174282.3998.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oVbETefM5RKaD3ylZkwV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 18:48 +0200, Michael Buesch wrote:

> Please some more comments on what they actually mean
> and what's usually to do when the flag is set.

Will do.

> > +	/* Change filter flags, see above for FIF_* constants.
> > +	 *
> > +	 * Must be atomic due to running under the tx lock.
> > +	 * This callback is required.
> > +	 */
> > +	void (*change_filter_flags)(struct ieee80211_hw *hw,
> > +				    int changed_flags, int total_flags);
>=20
> Better use unsigned int.

Yeah, did that.

> What does changed_flags and total_flags mean?
> I thought we'd like to have a pointer here, to the driver
> can clear what's not supported.

I changed that in the second version, and changed_flags indicates which
ones have changed since the last call so the driver need not set all of
them if that might be expensive.

johannes

--=-oVbETefM5RKaD3ylZkwV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwteK/ETPhpq3jKURAnxdAKC15F2a2DNwYLMSdZAzVjNVFZXCpQCcCTaS
EZF92zdQcyWOSweDA6iaIfI=
=9tRN
-----END PGP SIGNATURE-----

--=-oVbETefM5RKaD3ylZkwV--

