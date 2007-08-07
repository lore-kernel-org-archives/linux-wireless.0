Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbXHGKJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 06:09:25 -0400
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with  assoc work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708071157.21105.mb@bu3sch.de>
References: <200708011253.06569.mb@bu3sch.de>
	 <200708031250.51161.mb@bu3sch.de> <1186410230.28655.75.camel@johannes.berg>
	 <200708071157.21105.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kBkU0IMhgoirmlV2kVim"
Date: Tue, 07 Aug 2007 12:10:38 +0200
Message-Id: <1186481438.4067.40.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kBkU0IMhgoirmlV2kVim
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-07 at 11:57 +0200, Michael Buesch wrote:

> Yep, but this patch turns the bug from a
> "It will 100% deadlock all the time"
> into a
> "It might possibly deadlock, although unlikely"
> So it's a win for that crap softmac code.

Agreed, let's go with the patch you just sent. It's rather unlikely that
it will deadlock against the link watch event, and hopefully we can
delete softmac in 2.6.24 with Larry's bcm4301 and zd1211-mac80211
shaping up.

johannes

--=-kBkU0IMhgoirmlV2kVim
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuEUe/ETPhpq3jKURArybAKCiwEtMJ1AYBlvpGsmW/wrdsfSuHQCeKt/x
OmSrg2h5VgQ2/hdjz3qksww=
=FofV
-----END PGP SIGNATURE-----

--=-kBkU0IMhgoirmlV2kVim--

