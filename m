Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXHPNNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:13:22 -0400
Subject: Re: [PATCH 17/20] mac80211: avoid copying packets to interfaces  that are down
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708152148.58436.flamingice@sourmilk.net>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145048.965414000@sipsolutions.net>
	 <200708152148.58436.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oKYjpBgMCLidJXYtzfhX"
Date: Thu, 16 Aug 2007 15:14:15 +0200
Message-Id: <1187270055.5141.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oKYjpBgMCLidJXYtzfhX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 21:48 -0700, Michael Wu wrote:
> On Wednesday 15 August 2007 07:49, Johannes Berg wrote:
> > Is there a possibility of a race condition here? If the interface is
> > brought down right after this check the SKB could be copied to that
> > interface after the skb queue has been flushed.
> >
> Yeah. This can be avoided by holding a write lock on the subif lock while=
=20
> flushing the skb queue. Not sure how much I like doing that, but it shoul=
d=20
> work.

Hmm. Not entirely sure what you mean.

johannes

--=-oKYjpBgMCLidJXYtzfhX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxE2n/ETPhpq3jKURArejAKClbGxCmirPj4ai0Sjlq3EkDQkmegCdHpwE
97dkY0KF2auQfRPNkNhel28=
=E6Nd
-----END PGP SIGNATURE-----

--=-oKYjpBgMCLidJXYtzfhX--

