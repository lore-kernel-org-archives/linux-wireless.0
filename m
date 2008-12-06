Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:6428 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbYLFQIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 11:08:37 -0500
Received: by ug-out-1314.google.com with SMTP id 39so256868ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 08:08:35 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 6 Dec 2008 17:08:27 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812061646.36044.hrogge@googlemail.com> <1228579172.16752.21.camel@johannes.berg>
In-Reply-To: <1228579172.16752.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1843119.EvLoY9NGTz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812061708.32369.hrogge@googlemail.com> (sfid-20081206_170843_429278_204B5185)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1843119.EvLoY9NGTz
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 December 2008 16:59:32 Johannes Berg wrote:
> For one, I'm a bit concerned that the calculation is fairly complex, and
> may not always be necessary; especially divisions can be expensive on
> some CPUs.
What if I push the calculation into nl80211.c, so it will be only called wh=
en=20
the a userspace process requests the station info ? This would mean the=20
calculation is not done at all until someone needs the rate info.

> Also, there are duplicate numbers possible, so just the pure bitrate
> will _not_ actually be "the typical information" because it's not
> specific enough, when debugging, for example, you will probably need to
> know whether it's short-gi or not.
Don't you think the normal nl80211 use will just be a display of "how fast =
are=20
we doing at the moment" ? Most applications don't even need to set a rate,=
=20
they just want to show the user some feedback.

Henning


--nextPart1843119.EvLoY9NGTz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk6o4AACgkQcenvcwAcHWc7cwCfQwh1XjgCpVAAIyghb5hAkXAk
cjEAoImQZb+MMVUycDfZYh1U5UR8P64q
=WKO/
-----END PGP SIGNATURE-----

--nextPart1843119.EvLoY9NGTz--
