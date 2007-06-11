Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXFKLpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 07:45:24 -0400
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and   channel
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <1181561185.29767.18.camel@johannes.berg>
References: <20070611103828.961999956@warmcat.com>
	 <20070611103914.577674038@warmcat.com>
	 <1181561185.29767.18.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1tnJLahduT+ys36rKX57"
Date: Mon, 11 Jun 2007 13:45:55 +0200
Message-Id: <1181562355.29767.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1tnJLahduT+ys36rKX57
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Damn. This is a firmware thing, the firmware later changed because they
> needed more than 2 bits for the PHY type so things were shifted up by
> one. That means the actual channel ID mask will be 0x7f8 now and this is
> in the current specs. Can you please post which firmware you're using?
> We'll want to force people to use newer firmware with this behaviour
> -or- figure out at what point they made the transition...

See bottom of http://bcm-v4.sipsolutions.net/802.11/RX

Actually, I guess we can test this. Beacons contain the channel, we can
determine the frequency from that and see what's going on. I'll leave it
to Michael to decide what to do.

johannes

--=-1tnJLahduT+ys36rKX57
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbTXz/ETPhpq3jKURAqRWAKCeihD/d9fGPVuy5aKJUwoBpoQsXgCgsBKi
VSZzvCK8aL+a9Th4RxAFnmo=
=f/wa
-----END PGP SIGNATURE-----

--=-1tnJLahduT+ys36rKX57--

