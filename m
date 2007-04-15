Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:18713 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833AbXDOEx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 00:53:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Make wireless statistics yield reasonable values
Date: Sun, 15 Apr 2007 00:50:43 -0400
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <4621a896.akSEX43I3VgRXr70%Larry.Finger@lwfinger.net>
In-Reply-To: <4621a896.akSEX43I3VgRXr70%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1206522.aBPQvGtOq6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704150050.48891.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1206522.aBPQvGtOq6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 15 April 2007 00:22, Larry Finger wrote:
> -	hw->max_rssi =3D -110;
> -	hw->max_signal =3D BCM43xx_RX_MAX_SSI;
> +	hw->max_signal =3D 100; /* This looks wrong, but is what mac80211 wants=
 */
> +	hw->max_rssi =3D BCM43xx_RX_MAX_SSI;
The number being passed into ssi is dBm, so why is the max being set to 60?=
 It=20
should be set to the minimum dBm that the device can report, like -110 as i=
t=20
was set before. Since SSI is actually being passed into signal, MAX_SSI=20
should go to max_signal.

=2DMichael Wu

--nextPart1206522.aBPQvGtOq6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIa8oT3Oqt9AH4aERAg8UAKC/JKKruQZ5W5t3fccvVfP/zqDszQCgr2vS
S9+YSCy01tnV2GotgaSBbsw=
=Qqj3
-----END PGP SIGNATURE-----

--nextPart1206522.aBPQvGtOq6--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
