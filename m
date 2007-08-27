Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:16033 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753494AbXH0Xrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 19:47:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: port of my recent patches to net-2.6.24
Date: Mon, 27 Aug 2007 19:45:51 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1188027470.9529.5.camel@johannes.berg>
In-Reply-To: <1188027470.9529.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart108026812.FtPWj39jt0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708271945.55384.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart108026812.FtPWj39jt0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 25 August 2007 03:37, Johannes Berg wrote:
> http://johannes.sipsolutions.net/patches/net-2.6.24/
>
Patch 22:
+		ap =3D sta_info_get(key->local, key->sdata->u.sta.bssid);
How does this work when we're setting a multicast/broadcast key on an AP=20
interface?

+	list_add(&key->list, &sdata->key_list);
Should we be holding the key mutex here?

This patch does too many things. If you can split some things out into=20
separate patches, like moving code into key.c, it would be easier to review.

Patch 23-29: ACK

Thanks,
=2DMichael Wu

--nextPart108026812.FtPWj39jt0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG02IzT3Oqt9AH4aERAhZXAKDJA4t3WioVqE0+bbajTp7VeDMYAQCg1qzu
tgHEAB++NL/Z+WlvviMZ8LQ=
=PpYj
-----END PGP SIGNATURE-----

--nextPart108026812.FtPWj39jt0--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
