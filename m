Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXL2Jya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 04:54:30 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: chris2553@googlemail.com
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200712290942.37396.chris2553@googlemail.com> (sfid-20071229_094310_096852_2D0A533D)
References: <200712290942.37396.chris2553@googlemail.com>
	 (sfid-20071229_094310_096852_2D0A533D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dnUugocE6vYYHK6CwkSZ"
Date: Sat, 29 Dec 2007 10:54:15 +0100
Message-Id: <1198922056.4172.25.camel@johannes.berg> (sfid-20071229_095433_023070_500F7D75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dnUugocE6vYYHK6CwkSZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I didn't think that many drivers had this problem... The warning is
harmless on machines that are ok with unaligned memory accesses.

> WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
> Pid: 0, comm: swapper Not tainted 2.6.24-rc6-git5 #11

comes from
        /*
         * Drivers are required to align the payload data to a four-byte
         * boundary, so the last two bits of the address where it starts
         * may not be set. The header is required to be directly before
         * the payload data, padding like atheros hardware adds which is
         * inbetween the 802.11 header and the payload is not supported,
         * the driver is required to move the 802.11 header further back
         * in that case.
         */
        hdrlen =3D ieee80211_get_hdrlen(rx.fc);
        WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);


Although I'm starting to doubt my own sanity here with this sanity check
if so many drivers can trigger it.

johannes

--=-dnUugocE6vYYHK6CwkSZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3YZRqVg1VMiehFYAQIKYhAAlBolpHw1S8Lub/Yciouc3goWXFqUHwIP
tcdX0/lcGuY5NAVSOO8+oAnf2drlhvpNBUZ04M1UIULsLUNiZ2b5sKS4w33rB9HR
yPuBeQdM38Lhb3ycqJZ97Dh2NJjYs2nDC5OTAl+UYBOqWi7ZA1dj8r4KJd47IIoB
PKjwuz2S3VDdumfT8+ea8Tb9Q1cX0sy28UATGh+79QWhhs7qSdreXpFQGNH9VLPJ
z1GpGeFZqyrMgKWp6EF4KjLNgsDTdoAX6ehxVz33zAy8cKibsxukIbeaH201IXoS
6O8Jouq9UmtBkYjeLr7PFBUflWeLrcnFA7aWLggGEc+yc0Vf5anexoNAXZJAWERi
p1J6VxkaHCFBIP5u/XRLjgQjSzCddCf/4MbKkmDV9qJgscqVC9XiNQ7kMHHLRdJJ
QAUoWmNYGc0om7P6g62fDx90BMRBqA4jpnu2GfCHBJAyt/SbYziMjNogOC/yke/H
8g+2nvPBdv6EO6wCvA26I/7Jd9v4/ghEXSbaSXYIfKJB/Ybhi27wT+VSJRcVpz3s
jSuRIIwFj0+KIeVYvX+X2Lhi/2dUKFFZ9IZEqNPzTxkoHxFix85w580+rx+CkqSZ
WvIXZBj0rZb1OMloeL9lStHrbKS2Ap6rtFg0esYtoXKB07hcsOl/IV1/BzlbcC8t
yJf/UBHOhns=
=vic+
-----END PGP SIGNATURE-----

--=-dnUugocE6vYYHK6CwkSZ--

