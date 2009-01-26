Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48270 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZAZBhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 20:37:14 -0500
Message-ID: <497D13B8.5090308@lwfinger.net> (sfid-20090126_023723_719139_85EFD328)
Date: Sun, 25 Jan 2009 19:36:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: [RFT] rtl8187: Fix OFDM power settings for RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de> <20090123153144.GA13658@tuxdriver.com> <497B05AF.5050701@hauke-m.de>
In-Reply-To: <497B05AF.5050701@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke,

Please apply this patch on top of current wireless-testing, or
compat-wireless.

Larry
====================


After reports of poor performance, a review of the latest vendor
driver (rtl8187_linux_26.1025.0328.2007) for RTL8187L devices was
undertaken.

A difference was found in the code used to index the OFDM power
tables. When the Linux driver was changed, my unit works at a much
greater range than before.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---



Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -536,7 +536,10 @@ static void rtl8225z2_rf_set_tx_power(st
 	cck_power += priv->txpwr_base & 0xF;
 	cck_power = min(cck_power, (u8)35);

-	ofdm_power = min(ofdm_power, (u8)15);
+	if (ofdm_power > (u8)15)
+		ofdm_power = 25;
+	else
+		ofdm_power += 10;
 	ofdm_power += priv->txpwr_base >> 4;
 	ofdm_power = min(ofdm_power, (u8)35);



