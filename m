Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46077 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750868AbZAXIPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 03:15:45 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 24 Jan 2009 09:15:42 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090124081542.50450@gmx.net> (sfid-20090124_091602_653845_5373D802)
MIME-Version: 1.0
Subject: [PATCH] ath9k: Set TSF fix
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that some Atheros hardware more like this code for setting the=
 TSF.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/drivers/net/wireless/ath9k/hw.c wireles=
s-testing/drivers/net/wireless/ath9k/hw.c
--- wireless-testing.orig/drivers/net/wireless/ath9k/hw.c	2009-01-23 22=
:54:08.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath9k/hw.c	2009-01-24 08:47:4=
5.000000000 +0100
@@ -3736,9 +3736,8 @@
=20
 void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64)
 {
-	REG_WRITE(ah, AR_TSF_L32, 0x00000000);
-	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
 	REG_WRITE(ah, AR_TSF_L32, tsf64 & 0xffffffff);
+	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
 }
=20
 void ath9k_hw_reset_tsf(struct ath_hal *ah)

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
