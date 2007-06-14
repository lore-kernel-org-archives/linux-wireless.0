Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35923 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbXFNHfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 03:35:03 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Kasper F. Brandt" <poizan42@gmail.com>
Subject: Re: [PATCH] fix for endian bug in rtl8187
Date: Thu, 14 Jun 2007 00:33:48 -0700
Cc: linux-wireless@vger.kernel.org,
	"Andrea Merello" <andrea.merello@gmail.com>,
	John Linville <linville@tuxdriver.com>
References: <c02c330c0706131559i28ce1126mdd01f84eb91f779b@mail.gmail.com>
In-Reply-To: <c02c330c0706131559i28ce1126mdd01f84eb91f779b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8153572.fMyFsgQm2B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706140033.55627.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8153572.fMyFsgQm2B
Content-Type: multipart/mixed;
  boundary="Boundary-01=_c9OcGPRFrl/AQTD"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_c9OcGPRFrl/AQTD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 13 June 2007 15:59, Kasper F. Brandt wrote:
> Hello
>
> The following patch fixes a bug in the mac80211 rtl8187 driver that
> would prevent it from initializing the hardware correctly on
> big-endian machines.
>
Thanks for finding this!

I used a slightly different approach to fixing this in the attached patch, =
but=20
it's the same idea.

This applies to wireless-dev, but should be applied to the driver in=20
wireless-2.6 also.

=2DMichael Wu

--Boundary-01=_c9OcGPRFrl/AQTD
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="05-fix-rtl8187-endianness.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="05-fix-rtl8187-endianness.diff"

rtl8187: fix endianness issue in rtl8225 register writing

=46rom: Michael Wu <flamingice@sourmilk.net>

I failed to notice that a u16 was being passed to the hardware.
This fixes it.

Thanks to Kasper F. Brandt for finding this!

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 .../wireless/mac80211/rtl818x/rtl8187_rtl8225.c    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c b/driv=
ers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
index c3f5bf5..97fdff7 100644
=2D-- a/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
@@ -66,7 +66,7 @@ static void rtl8225_write_bitbang(struct ieee80211_hw *de=
v, u8 addr, u16 data)
 	msleep(2);
 }
=20
=2Dstatic void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, u16 da=
ta)
+static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 d=
ata)
 {
 	struct rtl8187_priv *priv =3D dev->priv;
 	u16 reg80, reg82, reg84;
@@ -105,7 +105,7 @@ void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u=
16 data)
 	struct rtl8187_priv *priv =3D dev->priv;
=20
 	if (priv->asic_rev)
=2D		rtl8225_write_8051(dev, addr, data);
+		rtl8225_write_8051(dev, addr, cpu_to_le16(data));
 	else
 		rtl8225_write_bitbang(dev, addr, data);
 }

--Boundary-01=_c9OcGPRFrl/AQTD--

--nextPart8153572.fMyFsgQm2B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcO9jT3Oqt9AH4aERAu66AJsF0d7h8b4ux+ziCAtXuBvZLVShawCgujhv
kuKakpuzDAqeR7I8JeIYF80=
=iE+G
-----END PGP SIGNATURE-----

--nextPart8153572.fMyFsgQm2B--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
