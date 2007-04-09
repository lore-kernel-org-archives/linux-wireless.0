Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:57238 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752097AbXDIRS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 13:18:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Mon, 9 Apr 2007 13:16:19 -0400
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <1176120428.2693.12.camel@localhost.localdomain> <461A6092.20701@lwfinger.net>
In-Reply-To: <461A6092.20701@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2658290.msSaxLGmkY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704091316.23661.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2658290.msSaxLGmkY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 09 April 2007 11:49, Larry Finger wrote:
> > In WE, qual is arbitrary within a few limits:
> >
> > a) qual _must_ change on a linear scale
> > b) a valid max_qual.qual must be set
> > c) qual must fall within the bounds of [0, max_qual.qual] inclusive
>
> Note that the quantity supplied by the bcm43xx firmware (called jssi in t=
he
> code) varies linearly with the strength of the signal, whereas the quanti=
ty
> derived from it in bcm43xx_rssi_postprocess is quasi logarithmic. The
> statement in a) above would argue against reversal of my conventions. What
> happens in the other drivers that use mac80211?
>
rt2x00 does not use qual. All other drivers in tree that use qual=20
(zd1211rw-mac80211, rtl8187) use the current convention.

I don't see anything in those 4 points that would argue against the current=
=20
conventions in mac80211. In fact, it sounds like you are arguing for it sin=
ce=20
jssi, which you said is linear, goes to qual (after my patch is applied)=20
which wants a linear number.

=2DMichael Wu

--nextPart2658290.msSaxLGmkY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGnTnT3Oqt9AH4aERAixTAKCfBnkA3dWh96YHTzO+6l6ppS9lqwCfRliD
+3m84rvfhSgpkYpRC4DSn7w=
=vU8y
-----END PGP SIGNATURE-----

--nextPart2658290.msSaxLGmkY--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
