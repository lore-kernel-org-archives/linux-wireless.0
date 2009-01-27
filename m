Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZA0DIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 22:08:45 -0500
Date: Mon, 26 Jan 2009 21:08:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: barreyromartin@gmail.com,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix error in setting OFDM power settings for
 RTL8187L
Message-ID: <497e7ab0.kLnSOwAkXc2Qgtkb%Larry.Finger@lwfinger.net> (sfid-20090127_040852_201192_75279664)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After reports of poor performance, a review of the latest vendor driver
(rtl8187_linux_26.1025.0328.2007) for RTL8187L devices was undertaken.

A difference was found in the code used to index the OFDM power tables.=
 When
the Linux driver was changed, my unit works at a much greater range tha=
n
before. I think this fixes Bugzilla #12380 and has been tested by at le=
ast
two other users.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Mart=C3=ADn Ernesto Barreyro <barreyromartin@gmail.com>
Cc: Stable <stable@kernel.org>
---

John,

This material should be included in 2.6.29. Although I have Cc'd stable=
, the
patch will need to be respun due to the file renaming.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rtl8225.=
c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -285,6 +285,10 @@ static void rtl8225_rf_set_tx_power(stru
 	ofdm_power =3D priv->channels[channel - 1].hw_value >> 4;
=20
 	cck_power =3D min(cck_power, (u8)11);
+	if (ofdm_power > (u8)15)
+		ofdm_power =3D 25;
+	else
+		ofdm_power +=3D 10;
 	ofdm_power =3D min(ofdm_power, (u8)35);
=20
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
@@ -536,7 +540,10 @@ static void rtl8225z2_rf_set_tx_power(st
 	cck_power +=3D priv->txpwr_base & 0xF;
 	cck_power =3D min(cck_power, (u8)35);
=20
-	ofdm_power =3D min(ofdm_power, (u8)15);
+	if (ofdm_power > (u8)15)
+		ofdm_power =3D 25;
+	else
+		ofdm_power +=3D 10;
 	ofdm_power +=3D priv->txpwr_base >> 4;
 	ofdm_power =3D min(ofdm_power, (u8)35);
=20
---

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
