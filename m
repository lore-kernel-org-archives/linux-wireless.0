Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:24359 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932993AbXBET41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 14:56:27 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Date: Mon, 5 Feb 2007 14:55:55 -0500
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20070131013717.GA28076@tuxdriver.com> <200702051423.13998.flamingice@sourmilk.net> <1170703485.3572.43.camel@johannes.berg>
In-Reply-To: <1170703485.3572.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2453089.ssXtxff1Uj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702051455.59331.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2453089.ssXtxff1Uj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 05 February 2007 14:24, Johannes Berg wrote:
> On Mon, 2007-02-05 at 14:23 -0500, Michael Wu wrote:
> > Anyway, netlink does not seem appropriate for
> > sending or receiving frames.
>
> Care to explain why you think so?
>
1. Userspace usually expects to send things on network interfaces. The kern=
el=20
usually receives frames from userspace on network interfaces. I don't see t=
he=20
point of making an exception for 802.11 frames. (or rather, the potential f=
or=20
simpler frame injection code is not enough to justify inventing a new=20
interface for doing it)
2. nl80211/cfg80211 is for configuring interfaces. Everything there is rela=
ted=20
to configuration of wireless interfaces except for the frame injection hook=
=2E=20
It doesn't look right.

=2DMichael Wu

--nextPart2453089.ssXtxff1Uj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFx4vPT3Oqt9AH4aERAjcvAJ9S9C66Q+D/1E28sFy+fxYCK+zbSACgj+pm
4THXhObZ/GXI32+p+3S07vM=
=5oO2
-----END PGP SIGNATURE-----

--nextPart2453089.ssXtxff1Uj--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
