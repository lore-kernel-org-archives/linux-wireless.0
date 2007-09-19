Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:53110 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935AbXISVEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 17:04:12 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] adm8211: Adapt to filter configuration API
Date: Wed, 19 Sep 2007 17:03:23 -0400
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <20070918213833.8850.90828.stgit@magic.sourmilk.net> <200709181742.33948.flamingice@sourmilk.net> <200709191946.43300.mb@bu3sch.de>
In-Reply-To: <200709191946.43300.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5489781.Z1XFJ8NoPj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709191703.30877.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5489781.Z1XFJ8NoPj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 19 September 2007 13:46, Michael Buesch wrote:
> This is broken on BigEndian platforms.
> use cpu_to_leX().
Hm, yeah, I remember thinking that at one point and then I forgot about tha=
t=20
issue. This patch doesn't introduce it of course.. the code was always brok=
en=20
in that fashion, but this moves it to a new place.

> You can also replace the handcoded endianness conversion in
> adm8211_set_bssid by cpu_to_leX().
>
Sure, but then I have to do some questionable looking casts to shut up spar=
se.=20
(might be worth it, we'll see)

=2DMichael Wu

--nextPart5489781.Z1XFJ8NoPj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG8Y6iT3Oqt9AH4aERAu9bAKCzU290WJhpK62EoPSRmaLuEnXiagCfee5n
Hrz59Fc6UEK5hGw/82rOouM=
=hAq+
-----END PGP SIGNATURE-----

--nextPart5489781.Z1XFJ8NoPj--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
