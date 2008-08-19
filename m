Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYHSNzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 09:55:35 -0400
Subject: Re: [PATCH] mac80211/cfg80211: Add vif configuration options
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080818191036.GC4809@jm.kir.nu>
References: <20080818191036.GC4809@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D+BgLANQ9Iimr7eBpsJe"
Date: Tue, 19 Aug 2008 15:54:45 +0200
Message-Id: <1219154085.3476.4.camel@johannes.berg> (sfid-20080819_155554_170017_7D6327F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D+BgLANQ9Iimr7eBpsJe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-18 at 22:10 +0300, Jouni Malinen wrote:

> + * @drop_unencrypted: Whether to drop unencrypted frames
> + *	(0 =3D no, 1 =3D yes, -1 =3D do not change)

Should that be part of some encryption settings instead? Not really
sure.

> + * @userspace_mlme: Whether to use userspace MLME
> + *	(0 =3D no, 1 =3D yes, -1 =3D do not change)

I don't really like this much, it feels like a specific hack to get
wpa_supplicant and mac80211 play together, rather than an API to do this
generically.

What I've been thinking and talking about for quite a long time is to
make cfg80211 more agnostic as to where the MLME lives, and let nl80211
still be able to configure the interface when a userspace MLME is
active. That way, all tools could continue to work regardless of where
the MLME is.

That would, of course, require to finally put wext into cfg80211, make
the wext code capable of sending nl80211 messages to the userspace MLME
and also have nl80211 divert messages to the MLME back to the userspace
MLME unless they are coming from the userspace MLME.

Ultimately, that would allow the userspace MLME to have much more
control while users are still able to use the regular tools for many
things.

Unless, of course, those guys really put d-bus into the kernel and we
can just have the MLME service for a specific interface bound
anywhere...

johannes

--=-D+BgLANQ9Iimr7eBpsJe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIqtChAAoJEKVg1VMiehFYu00P/0C48wt03febmkk/Ih7PswCl
FoTEvrEc6Fae2UpDonuea1CQ3OmdCgcMlD5oSUzqk8ZyO2nX9jM3Y+6ektd+aynY
pmxzZ9JEWk+AoJ8UaYJn+KajUYJu7dXp6ht9r6L2lPDd0B6XhNBMcd4/oPzCFHMX
Xy0++U7WWjyA1C3BJegWkGaKUgCx0gqp66Gdhxp8jr67aNwFkpXSCe5yFgm56A8M
5qKlzAisQyjvfWv+tgdcvjBk1TNXtD7fxOvPlPYvMLZoYifqeMz0Rfapesrvz6+6
ZsxNf+Mk6yprtb4mI2euU9/YwzzmcO3asFuF8Z6oM6GJgPo3ojTlJY+rBnxJCHCK
Z+NdwNx9c5QKB13RreyU1tp3Fzh4xVsuknHNOh8Fa5vvaYBIO3+6Uc/56Rn5/8eV
7ZYczlXxC5V7iyx3veawesXmiAVWnX5Hsz5fRPuj1lEuCpJUQD6VEk32k/u4x9AZ
rmfXbbNzBSkkDWBZQzRd9ldDks8KoQtxHqgJaaG+V/Tyx09bWISgNtZeg06/wPs7
8erqLC/Zd34AixTpP5dStBtXPeWbZoFtsRNvHRk/pQ4aAo/MiOmkKUObHZrdGelg
WzNd1+RC4csLMbhsx+WT2rR92R9ksK9w+HxxFXssswdj+3MRfQHTZ3fzLpzhoLX0
9L4LiuS6jPKbCLwwA804
=kOdR
-----END PGP SIGNATURE-----

--=-D+BgLANQ9Iimr7eBpsJe--

