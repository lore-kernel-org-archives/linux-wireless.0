Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:24447 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966249AbXEGTR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 15:17:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Allow sleeping in set_key op
Date: Mon, 7 May 2007 15:17:14 -0400
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200705062037.35037.mb@bu3sch.de>
In-Reply-To: <200705062037.35037.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8075669.RYGqeSa4sU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705071517.21331.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8075669.RYGqeSa4sU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 06 May 2007 14:37, Michael Buesch wrote:
> Allow drivers to sleep in the setkey function, as it's rather
> complicated to defer set_key to a workqueue in the driver
> (error code is lost, keyconf->hw_key_idx is possibly hard
> to get right.)
>
I'd rather not defer to a workqueue. That just patches over the awkward=20
locking that the sta_info code has, which is really the reason why you can'=
t=20
sleep in set_key.

=2DMichael Wu

--nextPart8075669.RYGqeSa4sU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGP3tBT3Oqt9AH4aERArbJAJ0QI65Fq8YrVcNMO3Hq3kxrSZV/UQCcDkbZ
01qNGUB5G/RM05eKpUnPaGM=
=Wbng
-----END PGP SIGNATURE-----

--nextPart8075669.RYGqeSa4sU--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
