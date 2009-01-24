Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751047AbZAXJqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 04:46:11 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 24 Jan 2009 09:12:23 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090124081223.50440@gmx.net> (sfid-20090124_104635_187150_1D09A1D7)
MIME-Version: 1.0
Subject: [PATCH] ath5k: Set TSF fix
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that some Atheros hardware more like this code for setting the=
 TSF.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/drivers/net/wireless/ath5k/pcu.c wirele=
ss-testing/drivers/net/wireless/ath5k/pcu.c
--- wireless-testing.orig/drivers/net/wireless/ath5k/pcu.c	2009-01-23 2=
2:54:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath5k/pcu.c	2009-01-24 08:47:=
16.000000000 +0100
@@ -657,9 +657,8 @@
 {
 	ATH5K_TRACE(ah->ah_sc);
=20
-	ath5k_hw_reg_write(ah, 0x00000000, AR5K_TSF_L32);
-	ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
 	ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L32);
+	ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
 }
=20
 /**

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
