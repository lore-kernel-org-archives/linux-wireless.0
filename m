Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:44388 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbXDIEqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 00:46:05 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Mon, 9 Apr 2007 00:43:29 -0400
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704082031.59934.flamingice@sourmilk.net> <4619B90E.1030403@lwfinger.net>
In-Reply-To: <4619B90E.1030403@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2034599.ngmQpmyn6N";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704090043.34436.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2034599.ngmQpmyn6N
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 08 April 2007 23:54, Larry Finger wrote:
> Why would I want to do this?
Did it fix the output?

> If the community agrees on anything, it is=20
> that the signal is given in dBm (i.e. a negative number) and that the rssi
> is a positive number.
Nope. dBm doesn't have to be negative, though it often is since most wirele=
ss=20
hardware isn't that powerful. RSSI is simply a number that's bigger for=20
stronger signals. It could be dBm, but it doesn't have to be. If you want a=
=20
stronger definition of RSSI, look at RCPI.

> The firmware in the bcm43xx chips return a quantity=20
> that looks like an rssi with a received packet, and
> bcm43xx_rssi_postprocess turns that into a quantity that looks like dBm.
> Your patch reverses those designations and mixes up the two quantities.
> Again I ask "Why"?
>
Because of the naming/use of the statistics in mac80211 and WE. Signal ends=
 up=20
getting assigned to (struct iw_quality).qual, which is actually just an=20
arbitrary link quality indicator, not dBm. Anything you care about can be p=
ut=20
there. (r)ssi gets assigned to (struct iw_quality).level, which is RSSI. WE=
=20
allows that and noise to be specified in either arbitrary units or dBm or=20
RCPI.

Yes, I did reverse your conventions, but it makes more sense this way. (R)S=
SI=20
is always valid to assign to (struct iw_quality).level and signal ((struct=
=20
iw_quality).qual) is quite arbitrary and cannot be specified in specific=20
units.

Signal should be probably be renamed to qual to make it more clear that it =
is=20
arbitrary.

=2DMichael Wu

--nextPart2034599.ngmQpmyn6N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGcR2T3Oqt9AH4aERAnWKAJ4h0xjh03/Z/0sjedXG8qK4pYGuNgCfQE3b
bq3gVUtQCox6Rboumr811Ho=
=OTBz
-----END PGP SIGNATURE-----

--nextPart2034599.ngmQpmyn6N--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
