Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYIZLIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 07:08:50 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1222361863.14444.18.camel@localhost.localdomain>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com>
	 <200809250834.07781.hs4233@mail.mn-solutions.de>
	 (sfid-20080925_083440_223989_866F07A7)  <1222332205.10563.26.camel@johannes.berg>
	 <1222361863.14444.18.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+bN+81YQ1dNBI3w93haO"
Date: Fri, 26 Sep 2008 13:08:43 +0200
Message-Id: <1222427323.10563.109.camel@johannes.berg> (sfid-20080926_130854_961383_6611B713)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+bN+81YQ1dNBI3w93haO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 12:57 -0400, Dan Williams wrote:

> channel <-> frequency conversion

have that in cfg80211

> common regulatory domains and their restrictions

that too

> common BSS structure for scan results
> common scan result translation handlers
>=20
> Two options for scan result handling:

Can you look at the RFC patch I posted?

> -------------------------------------------------------------------------=
-
> 1) common GIWSCAN processing function that takes a callback.  This
> callback would be executed until it returns FALSE to signify no further
> scan results.  Callback prototype:
>=20
> bool scan_res_hook(struct common_bss *bss, void *user_data);
>=20
> 'bss' would simply be a _single_ common bss structure allocated at the
> start of iteration, and zeroed each time before calling the hook.  The
> scan hook then fills that common BSS structure with information from its
> own internal scan list.  The GIWSCAN processor then handles translation
> into the actual WEXT event stream or nl80211 formats.
>=20
> -------------------------------------------------------------------------=
-
> 2) common GIWSCAN processing function that takes a list of common BSS
> structures that the driver stores internally.  The common BSS structure
> would have a "void *driver_data" pointer in which the driver could keep
> driver-specific data items, but the driver would be responsible for
> setting all available information in the common BSS structure when the
> firmware provides scan results.  lib80211 provides common allocation,
> deallocation, bss entry aging, ref/unref, and free-list fetching.

I had something like this option 2 in mind when I wrote my patch, can
you take a look at it? The only thing missing now is
quality/signal/noise handling. Here's the most recent version:

http://johannes.sipsolutions.net/patches/kernel/all/2008-09-26-11%3a08/020-=
cfg80211-scan.patch

johannes

--=-+bN+81YQ1dNBI3w93haO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3MK2AAoJEKVg1VMiehFY9GAP/1BMO0F8oTirXE6p+iumzVRE
ZhUZhHkg/X0MPncTlHiZhPwGvDQng8hIEjPRTXGuNmZG3WvVP49ffVvLmLTjsgJw
Qf3XMukl7B21XJcR4IUSF2GdjREd8D2pbrjdWOR/yoZMyYQzqh66WRr+ymqCViEz
GAI34bjW7SnZ+g7ICZ6puyD/UQfKR/qTRCMPI/KO8z5EVHwJoVtOwlFW6QBYaLWF
eWljYe5exMxwGh7GXkSfRhf8d1TgyA+3eOGl+tKVLh6X4QH/sS8kDC6Mw0LvCe9Q
Smxp8uSoTv0VAERKpNYHhXTM55oBbcBeZU7Dw0n82pg4+AHry/Pwz9c6B5M17UT7
8tCg0s0A+oPuobuOnB4d5AVxjFAvWkEdES3JJKPXPcFMLWn6IuB625iwprr98DEe
8RnGtoPHnDu9DUQcLgU4ZgGaiH7q8YDdEbX604sV2CuJMj/CkR4mIvTOa4GqMfeY
WGd/WnwFH9n72rDIAXIH5njA5YrDnoJd4l2/c9HFvFE1c77I/5fI5ZyV1LlfqgYm
M0E1xUIiejYuypZFuFCx89VxnssbykHQzU+0/K3av2S5vNL9rxx95ns99GUrl8xV
GmdW2GxyXJhz7lPdhkF3WMdTw/xJ9lsUV9Iuk73KMvU7oRcZgKel+pbEcDvB1nhj
pBKxLBvwHvQP5JelwGXK
=h21E
-----END PGP SIGNATURE-----

--=-+bN+81YQ1dNBI3w93haO--

