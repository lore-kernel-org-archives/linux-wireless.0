Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65012 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZA0Sbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 13:31:36 -0500
Date: Tue, 27 Jan 2009 12:31:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtl8187: Fix error in setting OFDM power settings for
 RTL8187L
Message-ID: <497f52fb.ABh5zgEKaz63Z7Lu%Larry.Finger@lwfinger.net> (sfid-20090127_193141_404393_587BE9B8)
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
@@ -285,7 +285,10 @@ static void rtl8225_rf_set_tx_power(stru
 	ofdm_power =3D priv->channels[channel - 1].hw_value >> 4;
=20
 	cck_power =3D min(cck_power, (u8)11);
-	ofdm_power =3D min(ofdm_power, (u8)35);
+	if (ofdm_power > (u8)15)
+		ofdm_power =3D 25;
+	else
+		ofdm_power +=3D 10;
=20
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
 			 rtl8225_tx_gain_cck_ofdm[cck_power / 6] >> 1);
@@ -536,7 +539,10 @@ static void rtl8225z2_rf_set_tx_power(st
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
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
