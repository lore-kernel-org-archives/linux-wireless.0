Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbXCHPnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 10:43:47 -0500
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703081639.40395.mb@bu3sch.de>
References: <200703061902.00001.mb@bu3sch.de>
	 <1173317164.3546.41.camel@johannes.berg>  <200703081639.40395.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7mZzq/5fTOjQSF4UE10H"
Date: Thu, 08 Mar 2007 16:43:35 +0100
Message-Id: <1173368616.3248.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7mZzq/5fTOjQSF4UE10H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 16:39 +0100, Michael Buesch wrote:

> I don't think so. tasklet_kill does actually waiting, not killing.
> It waits until the (maybe) scheduled tasklet did run and then waits
> for it to finish running.
> It doesn't rip off a scheduled tasklet without letting it run.

Ah ok.

> Uh, didn't get that. The assertion for this is in the same function
> some lines down.

I used to get that but probably using tasklet_kill for that tasklet
fixes this then.

johannes

--=-7mZzq/5fTOjQSF4UE10H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8C8n/ETPhpq3jKURAktEAJ9f8sBErqIN5chH06EmqBTCls0SuwCeOIv2
MTvnYKlRPVYC3IcN0QrY/qI=
=crd4
-----END PGP SIGNATURE-----

--=-7mZzq/5fTOjQSF4UE10H--

