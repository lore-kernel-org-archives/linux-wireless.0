Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:45928 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755160AbXGCRlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 13:41:24 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Tue, 3 Jul 2007 10:41:22 -0700
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707022235.38791.mb@bu3sch.de> <200707031015.23890.flamingice@sourmilk.net> <200707031936.24084.mb@bu3sch.de>
In-Reply-To: <200707031936.24084.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2499992.bYHeh6bxrL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707031041.27895.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2499992.bYHeh6bxrL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 03 July 2007 10:36, Michael Buesch wrote:
> the _only_ place where it's sane to call stop_queues (to stop all queues)
> is outside of the TX handler. Why would you stop all queues inside of
> the TX path?
isl38xx cards (p54) need the host to manage the memory that frames are copi=
ed=20
to before the card transmits. If the card's memory gets filled up, all queu=
es=20
need to be stopped.

=2DMichael Wu

--nextPart2499992.bYHeh6bxrL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGiopHT3Oqt9AH4aERApj/AKCZW84lj3c+i+hgXy6VV5DXns0coACfVtta
h0nBc5OPJN41Sv7hcMZQk3Q=
=7/U4
-----END PGP SIGNATURE-----

--nextPart2499992.bYHeh6bxrL--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
