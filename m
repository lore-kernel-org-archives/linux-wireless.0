Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:59182 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752169AbXDIAe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 20:34:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Sun, 8 Apr 2007 20:31:52 -0400
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081941.18921.flamingice@sourmilk.net> <461982A7.30901@lwfinger.net>
In-Reply-To: <461982A7.30901@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16337775.sWFHrRrAgs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704082031.59934.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart16337775.sWFHrRrAgs
Content-Type: multipart/mixed;
  boundary="Boundary-01=_4lYGGc7wIQcHrkL"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_4lYGGc7wIQcHrkL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 08 April 2007 20:02, Larry Finger wrote:
> Link Quality=3D219/60  Signal level=3D-200 dBm  Noise level=3D-69 dBm
>
Try the attached patch without your "bcm43xx-mac80211: Fix error in=20
initiallizing max RSSI and max signal" patch.

=2DMichael Wu

--Boundary-01=_4lYGGc7wIQcHrkL
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-bcm43xx-statistics.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="fix-bcm43xx-statistics.diff"

bcm43xx-mac80211: Swap ssi and signal reporting

=46rom: Michael Wu <flamingice@sourmilk.net>

The ssi and signal reporting in bcm43xx-mac80211 should be swapped.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c b/drivers=
/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
index cfc84cd..4f163a5 100644
=2D-- a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
+++ b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
@@ -529,12 +529,12 @@ void bcm43xx_rx(struct bcm43xx_wldev *dev,
 		}
 	}
=20
=2D	status.signal =3D bcm43xx_rssi_postprocess(dev, jssi,
+	status.ssi =3D bcm43xx_rssi_postprocess(dev, jssi,
 					      (phystat0 & BCM43xx_RX_PHYST0_OFDM),
 					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
 					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
 	status.noise =3D dev->stats.link_noise;
=2D	status.ssi =3D jssi;
+	status.signal =3D jssi;
 	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
 		status.rate =3D bcm43xx_plcp_get_bitrate_ofdm(plcp);
 	else

--Boundary-01=_4lYGGc7wIQcHrkL--

--nextPart16337775.sWFHrRrAgs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGYl/T3Oqt9AH4aERAkZGAKDCisDay3L17xAg6IwU2HOPnRpqfQCguhkw
gvfxXlgVV6IUgewVeBtaick=
=KYgT
-----END PGP SIGNATURE-----

--nextPart16337775.sWFHrRrAgs--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
