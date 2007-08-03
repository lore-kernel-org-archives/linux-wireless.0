Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652AbXHCKWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:22:25 -0400
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor interfaces  for injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46B30035.4080004@warmcat.com>
References: <20070802223857.19090.70108.stgit@localhost>
	 <1186135029.4647.27.camel@johannes.berg>  <46B30035.4080004@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kTVbRYzXsf8H4kZzbhxx"
Date: Fri, 03 Aug 2007 12:23:58 +0200
Message-Id: <1186136638.4647.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kTVbRYzXsf8H4kZzbhxx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 11:15 +0100, Andy Green wrote:

> With the patch, injected packets have the same Monitor mode footprint
> with hard or soft monitoring (you see the injected radiotap stuff)
> because the synthesized "tx report" packet doesn't exist in the real
> world shown by hard monitoring.

I don't see why there's a distinction between hard and soft monitor
mode. To me, hard monitor mode is basically "show me everything you can"
while soft is "best effort". Soft monitor mode also makes no sense while
no other interface is operating.

The synthesized 'tx report packet' isn't that; the only synthesized
thing is the radiotap header, the rest of the packet is what we actually
sent and were thus unable to capture ourselves.

> Acutually I think where it might all be heading is Michael Buesch's
> method of selecting between hard and soft Monitor mode based on
> IFF_PROMISC.

Ah. I see. You're thinking of hard/soft monitor as something totally
different than it is. Soft monitor really is only a hack for
pseudo-softmac hardware that doesn't allow you to capture control
packets while another interface is operating.

johannes

--=-kTVbRYzXsf8H4kZzbhxx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGswI+/ETPhpq3jKURAoVRAKCyGkU4X+4E+s10vyS6vwAFIbMudgCeJPoE
wMdnFy0KQXm98kHbWKm4POg=
=d1cC
-----END PGP SIGNATURE-----

--=-kTVbRYzXsf8H4kZzbhxx--

