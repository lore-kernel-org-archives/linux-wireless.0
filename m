Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.128.226]:39611 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0BHRIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 12:08:04 -0500
Date: Mon, 8 Feb 2010 12:07:35 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
  algorithm
Message-ID: <20100208120735.4b41a4a6@mycelium.queued.net>
In-Reply-To: <1265619993.3783.0.camel@johannes.berg>
References: <20100207214837.027dfd3d@mycelium.queued.net>
	<1265619993.3783.0.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/br4/23M.lAne+_vPTS65UOy"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/br4/23M.lAne+_vPTS65UOy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 08 Feb 2010 10:06:33 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Sun, 2010-02-07 at 21:48 -0500, Andres Salomon wrote:
> > I discovered that if EMBEDDED=3Dy, one can accidentally build a
> > mac80211 stack w/ no rate control algorithm.  When RC_MINISTREL and
> > RC_PID are both disabled, the RC_DEFAULT string (which rate.c uses
> > as the fallback algorithm) will be "".  That'll cause the
> > rate_control_alloc to fail, which will in turn cause
> > ieee80211_register_hw to fail.  IOW, no driver will load.
> >=20
> > This will tell kconfig to provide a warning if no rate control
> > algorithms have been selected.  That'll at least warn the user that
> > they're about to build a broken wireless stack.
>=20
>=20
> > +comment "mac80211 will not work properly w/out rate control
> > algorithm"
> > +	depends on MAC80211_HAS_RC=3Dn
>=20
> Except that isn't true for hardware that doesn't require an algorithm,
> or drivers that provide it themselves, like iwlagn or ath9k. I would
> prefer it to be worded accordingly.
>=20

Noted.  I was wondering if there were any.

How about having drivers that need them depend upon MAC80211_HAS_RC or
some such, and having the text say something like "most drivers require
rate control"?

--Sig_/br4/23M.lAne+_vPTS65UOy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwRNcACgkQOmXwGc/ULyatygCcC1X3mRDlcdnWWZt152cs2XSX
5OgAnijjsUvF8xtpuLq3lO0Vmpc2G+ie
=llR1
-----END PGP SIGNATURE-----

--Sig_/br4/23M.lAne+_vPTS65UOy--
