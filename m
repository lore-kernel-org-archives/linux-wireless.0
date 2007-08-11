Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXHKIPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 04:15:19 -0400
Subject: Re: [PATCH 4/4] mac80211: remove radar stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46BD2A89.8050906@lwfinger.net>
References: <20070810220544.321975000@sipsolutions.net>
	 <20070810220634.450509000@sipsolutions.net> <46BD2A89.8050906@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-emKtupNuo7D8tsC5Kk3Z"
Date: Sat, 11 Aug 2007 10:17:47 +0200
Message-Id: <1186820267.5363.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-emKtupNuo7D8tsC5Kk3Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-10 at 22:18 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> > Unused in drivers, userspace and mac80211.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
>=20
> Won't 802.11a drivers need this? If so, does it hurt to leave it in for n=
ow?

Absolutely correct, they probably will. None of the ones we have,
however, actually uses it, and it uses the management interface we're
trying to get rid of for the notification. The same function should
probably be added back to mac80211 or cfg80211 once somebody actually
wants it, but do the notification
 1) with well-defined arguments (explanation for the two args anyone?)
 2) via nl80211

It doesn't really "hurt" but I'm trying to actually remove the master
interface now and I'm almost there, so this code is in my way.

johannes

--=-emKtupNuo7D8tsC5Kk3Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGvXCr/ETPhpq3jKURApGfAKC6GLxnDpLSKjbTvIx/bCIHFfzqTwCeMe+V
pPb34C3e5DQeCNZLKg91E5s=
=kEXC
-----END PGP SIGNATURE-----

--=-emKtupNuo7D8tsC5Kk3Z--

