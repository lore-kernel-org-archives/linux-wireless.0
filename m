Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbXFPWRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 18:17:13 -0400
Subject: Re: [RFC PATCH] bcm43xx QoS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Joseph Jezak <josejx@gentoo.org>
In-Reply-To: <1ba2fa240706161438lfd629e4j7317bb62340c82a3@mail.gmail.com>
References: <200706161328.53726.mb@bu3sch.de>
	 <1ba2fa240706161438lfd629e4j7317bb62340c82a3@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4NMnY6wNwc7gk47HES9B"
Date: Sun, 17 Jun 2007 00:17:37 +0200
Message-Id: <1182032257.23681.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4NMnY6wNwc7gk47HES9B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-17 at 00:38 +0300, Tomas Winkler wrote:
> iwlwifi supports QoS. It has queues 4 hw for WMM access categories 2
> hw queus for HCCA.

But it too can't ever create QoS-data frames or negotiate TXOPs afaict,
unless it does more than we want in hardware.

> There is also a discussion about supporting hardware queues in qdisc
> in netdev.

Which isn't really a concern to the driver since only mac80211 will need
to be changed for that.

I suppose the question is: what are we missing in mac80211 now? It seems
that we have no way of sending out QoS-data frames and that seems weird.
Nor do we parse TXOP information etc. Possibly this is because we
support WME and that's based on an early 802.11e draft?

johannes

--=-4NMnY6wNwc7gk47HES9B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdGGB/ETPhpq3jKURAtL6AKCpTSM7s2oUjzop7kt2wOvX3LB25wCfbc6W
VKLEBVyIkIGV3mBxkxOVohs=
=hLm7
-----END PGP SIGNATURE-----

--=-4NMnY6wNwc7gk47HES9B--

