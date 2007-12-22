Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53721 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbXLVWKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 17:10:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Only select allowed TX and RX antennas
Date: Sat, 22 Dec 2007 23:08:05 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <200712222154.20424.mb@bu3sch.de> <476D87DA.5030908@lwfinger.net>
In-Reply-To: <476D87DA.5030908@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200712222308.05818.mb@bu3sch.de> (sfid-20071222_221028_464943_47E2E81B)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 December 2007 22:55:38 Larry Finger wrote:
> Michael Buesch wrote:
> > This fixes antenna selection in b43. It adds a sanity check
> > for the antenna numbers we get from mac80211.
> >=20
> > This patch depends on
> > [PATCH] ssb: Fix extraction of values from SPROM
> >=20
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
>=20
> After applying the 4 patches you sent earlier, the compilation fails =
with
>=20
>   CC [M]  drivers/ssb/main.o
> drivers/net/wireless/b43/main.c: In function =E2=80=98b43_ieee80211_a=
ntenna_sanitize=E2=80=99:
> drivers/net/wireless/b43/main.c:2720: error: =E2=80=98struct ssb_spro=
m=E2=80=99 has no member named =E2=80=98ant_available_bg=E2=80=99
> drivers/net/wireless/b43/main.c:2722: error: =E2=80=98struct ssb_spro=
m=E2=80=99 has no member named =E2=80=98ant_available_a=E2=80=99
>=20
> These members of ssb_sprom are defined in the patch you sent to Felix=
 Fietkau on Dec. 10, but not in
> this patch set.

This patch was included in the series I just sent.
[PATCH] ssb: Fix extraction of values from SPROM

> Index: wireless-2.6/include/linux/ssb/ssb.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/include/linux/ssb/ssb.h   2007-12-14
> 13:15:42.000000000 +0100 +++ wireless-2.6/include/linux/ssb/ssb.h    =
  =20
> 2007-12-20 18:58:49.000000000 +0100 @@ -22,7 +22,12 @@ struct ssb_spr=
om {
>         u8 et1mac[6];           /* MAC address for 802.11a */
>         u8 et0phyaddr;          /* MII address for enet0 */
>         u8 et1phyaddr;          /* MII address for enet1 */
> +       u8 et0mdcport;          /* MDIO for enet0 */
> +       u8 et1mdcport;          /* MDIO for enet1 */
> +       u8 board_rev;           /* Board revision number from SPROM. =
*/
>         u8 country_code;        /* Country Code */
> +       u8 ant_available_a;     /* A-PHY antenna available bits (up t=
o 4)
> +       u8 ant_available_bg;    /* B/G-PHY antenna available bits (up=
 to

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
