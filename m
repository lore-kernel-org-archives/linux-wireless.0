Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093AbXCVKj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:39:26 -0400
Subject: Re: [PATCH] mac80211: Prevent unregistering of unregistered hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703091730.06796.IvDoorn@gmail.com>
References: <200703091614.04526.IvDoorn@gmail.com>
	 <200703091646.05292.mb@bu3sch.de>  <200703091730.06796.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oRTxFh7yp5Mjs/CHhr73"
Date: Thu, 22 Mar 2007 11:37:54 +0100
Message-Id: <1174559874.3944.83.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oRTxFh7yp5Mjs/CHhr73
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-09 at 17:30 +0100, Ivo van Doorn wrote:

> Well it occurred in rt2x00 during errors during initialization,
> instead of using goto's to step by step free all allocated memory and unr=
egistration
> the main free_dev() was called.

Change that then, we like to see a proper error handling strategy that
one can understand w/o checking all possible flags.

>  And there isn't a way for the driver to check
> if the hw has been registered or not without creating new flags for it.
> But since mac80211 already is using such a flag internally, it would soun=
d like
> more sense to make the check in there.

No, the driver should know from its code flow whether it has registered
it or not, it should be obvious by looking at it.

> > I smell design problems in the driver ;)
>=20
> True, there are different approaches to take care of this inside the driv=
er,
> but I think this check is sane enough as well. ;)

I disagree. In fact, I'd prefer putting
 BUG_ON(local->reg_state !=3D IEEE80211_DEV_REGISTERED)
into ieee80211_unregister_hw.

johannes

--=-oRTxFh7yp5Mjs/CHhr73
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAlyB/ETPhpq3jKURAh3gAJ4qOmCK6ojRZwFlwxbjiXj6OYeUEQCfZpQp
8AqBe6366/HayLgFP5r2CeU=
=OTZw
-----END PGP SIGNATURE-----

--=-oRTxFh7yp5Mjs/CHhr73--

