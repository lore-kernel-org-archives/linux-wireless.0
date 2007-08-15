Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbXHOKsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:48:09 -0400
Subject: Re: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070815024135.GF1415@jm.kir.nu>
References: <20070814093254.021041000@sipsolutions.net>
	 <20070814093410.322846000@sipsolutions.net>
	 <20070815024135.GF1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/VwbmkE/5HO1FJCe0OfP"
Date: Wed, 15 Aug 2007 12:44:42 +0200
Message-Id: <1187174682.3998.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/VwbmkE/5HO1FJCe0OfP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 19:41 -0700, Jouni Malinen wrote:

> Agreed on 802.11a vs. b/g as long as frequency is used for configuration
> (as is the case here; channel numbers would not have been unique).
> Dropping the b vs. g is somewhat unfortunate, though.

Agreed. I can live with leaving it in.

> Furthermore, frequency may not be unique in future with additional PHY
> changes. Having option of setting both a "mode" and frequency is a pair
> is a good way of making sure the design is more future proof in this
> area.

Agreed as well, the plan for nl80211 was to have the tuple set together.
I quite dislike the idea of this internal "next_mode" state but I
suppose it's the best we have now.

However, this is the reason David Woodhouse couldn't get his Broadcom
based card to work in B mode, hostapd tried to select a B mode channel
and b43 doesn't offer any since it offers G mode. Should the burden be
on the driver authors here, or should we somehow select a G channel if B
isn't available?

johannes

--=-/VwbmkE/5HO1FJCe0OfP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtka/ETPhpq3jKURAmnCAJ9STgIcvfBgJKBEsDYFBQEi02NAfwCgqEBH
Ao5GtVwp78ATTq//2IL3XG4=
=GD+p
-----END PGP SIGNATURE-----

--=-/VwbmkE/5HO1FJCe0OfP--

