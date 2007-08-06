Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbXHGJpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:45:49 -0400
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor interfaces for  injection
From: Johannes Berg <johannes@sipsolutions.net>
To: warmcat <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070802223857.19090.70108.stgit@localhost>
References: <20070802223857.19090.70108.stgit@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i+54E878/JltVsCFC3d1"
Date: Mon, 06 Aug 2007 21:33:09 +0200
Message-Id: <1186428789.4067.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i+54E878/JltVsCFC3d1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 23:38 +0100, warmcat wrote:

> This patch adds a new attribute to ieee80211_tx_control's flags field,
> IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO, which is set for injected
> packets.  The code to add a new radiotap header and echo the packet
> down monitor mode interfaces is now conditional on this attribute not
> being set.

Regardless of whether my approach (just posted) will be accepted, this
patch cannot go in: it stops injected packets from showing up on all
monitor interfaces but the one they were injected into. If my
IFF_NO_MIRROR approach is rejected then we'll have to make this a bit
more elaborate by storing the injection device ifindex in the info
instead of just a flag.

johannes

--=-i+54E878/JltVsCFC3d1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGt3d1/ETPhpq3jKURAiLQAKCYTQ7iCuUtOzMhFzkCfGpGbGSH9wCgofsd
18VMb1skUlYWbVMyRSGXxPs=
=BlXf
-----END PGP SIGNATURE-----

--=-i+54E878/JltVsCFC3d1--

