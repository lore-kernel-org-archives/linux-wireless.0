Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965404AbXC1JVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:21:16 -0400
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andy Green <andy@warmcat.com>, Jiri Benc <jbenc@suse.cz>,
	Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
In-Reply-To: <200703262239.07013.mb@bu3sch.de>
References: <20070325231817.9C5887B409F@zog.reactivated.net>
	 <200703261328.28156.mb@bu3sch.de> <1174908666.1536.15.camel@johannes.berg>
	 <200703262239.07013.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4tGPrlnbbkIj5pqXEtlW"
Date: Wed, 28 Mar 2007 11:19:55 +0200
Message-Id: <1175073595.5151.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4tGPrlnbbkIj5pqXEtlW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 22:39 +0200, Michael Buesch wrote:

> Well, yeah. It does of course. If you have a STA and a MON interface,
> the STA also receives the packs with bad CRCs. But that's how
> mac80211 designed the virt-interface stuff.
> Same goes for promisc. If you have a STA and a MON you can't have
> the STA in non-promisc mode, so you also receive promisc packets on
> the STA. That's how it's supposed to be. (I think mac80211 filters
> them in the STA code somewhere).

Yeah, it filters those later by BSSID, that's intended, but it wasn't
ever programmed to check the CRC. We'll need to introduce a new rx
status flag "was crc checked".

> The modparams actually are just a temporary hack and were never meant
> to stay there. I wanted to have the knob in cfg80211, sooner or later.
> So when the knob is there, mac80211 should take care that the STA
> doesn't receive the bad packets.

Right.

johannes

--=-4tGPrlnbbkIj5pqXEtlW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCjM7/ETPhpq3jKURAsWyAKC5VMKc2uKSNsVAIY/yDxuLRYJUIwCfV+xu
j14kFvQr5aSAx+HsbW3BFgo=
=aZrK
-----END PGP SIGNATURE-----

--=-4tGPrlnbbkIj5pqXEtlW--

