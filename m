Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25543 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754306AbXFMGr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 02:47:59 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Mark Powell" <Mark.Powell@csr.com>
Subject: Re: [RFC] {cfg,nl}80211 API
Date: Tue, 12 Jun 2007 23:46:54 -0700
Cc: "David Lamparter" <dl@diac24.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"David Lamparter" <lists@diac24.net>,
	"Dan Williams" <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20070611230434.GA13221@charon.n2.diac24.net> <200706120945.41154.flamingice@sourmilk.net> <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
In-Reply-To: <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2751354.vG6mUV1dNI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706122346.59935.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2751354.vG6mUV1dNI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 12 June 2007 10:01, Mark Powell wrote:
> This is to do with the operation of the "Controlled Port" as specified
> by 802.1x, which is handled by the driver. When the key exchanges are
> complete and the link is secure, then data is allowed to flow. With
> wext, the driver has to guess when this state is reached, based on
> knowledge of how wpa_supplicant uses wext.
>
=46rom Documentation/networking/operstates.txt:

However, an interface is not usable just because the admin enabled it
=2D ethernet requires to be plugged into the switch and, depending on
a site's networking policy and configuration, an 802.1X authentication
to be performed before user data can be transferred. Operational state
shows the ability of an interface to transmit this user data.

Thanks to 802.1X, userspace must be granted the possibility to
influence operational state. To accommodate this, operational state is
split into two parts: Two flags that can be set by the driver only, and
a RFC2863 compatible state that is derived from these flags, a policy,
and changeable from userspace under certain rules.
=2D---

Dormant state allow userspace to control the state of an interface well eno=
ugh=20
to do 802.1x properly, regardless of whether it is wired or wireless.=20
wpa_supplicant already uses this AFAIK. Drivers don't need to do anything.

=2DMichael Wu

--nextPart2751354.vG6mUV1dNI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGb5LjT3Oqt9AH4aERAvbeAJ9dp+W0mYG018MgJqbgdbgN0DOlQACbBWgp
jMP/7qGadlJ2LixQeH0Cz+4=
=3hn8
-----END PGP SIGNATURE-----

--nextPart2751354.vG6mUV1dNI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
