Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXFTNzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 09:55:06 -0400
Subject: Re: ieee80211_radar_status?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070620135000.GZ5361@jm.kir.nu>
References: <1182296182.3714.19.camel@johannes.berg>
	 <20070620135000.GZ5361@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3aVR9hFSjC9TC6IP8k7a"
Date: Wed, 20 Jun 2007 15:56:07 +0200
Message-Id: <1182347767.3714.69.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3aVR9hFSjC9TC6IP8k7a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-20 at 06:50 -0700, Jouni Malinen wrote:
> On Wed, Jun 20, 2007 at 01:36:21AM +0200, Johannes Berg wrote:
>=20
> > Is there any documentation for the arguments to ieee80211_radar_status?
>=20
> Apparently not. It looks like it was only used for reporting a detected
> radar and none of the arguments were really used, i.e., it is just a
> callback from low-level driver to notify if a radar was detected on the
> current channel.

Huh, ok, but why were the arguments added then. Oh well, doesn't matter
much.

> > When moving to nl80211, this shall be handled there, but since we don't
> > have anybody using it right now we might as well kill it off completely
> > until we need it (again).
>=20
> This function is called by low-level driver and it would not have
> anything to do with nl80211.. The ieee80211_msg_radar type message to
> user space would be the one that would need to be replaced.

Yeah, true, but unless I see something using it I don't think I can
properly define the semantics for the nl80211 message, and thus I can't
define the semantics for cfg80211, and then not for the function that
the low-level driver calls...

johannes

--=-3aVR9hFSjC9TC6IP8k7a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGeTH2/ETPhpq3jKURAsSYAKCs/K5qSJ7VLoCfzt4KFpGENH7ypwCeJdeR
Kl0AAMEObhmBcH+mJTVd8vQ=
=NH75
-----END PGP SIGNATURE-----

--=-3aVR9hFSjC9TC6IP8k7a--

