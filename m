Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50694 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752212AbZCBW2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 17:28:41 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 02 Mar 2009 23:28:38 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090302222838.76740@gmx.net> (sfid-20090302_232844_320012_29CAAD09)
MIME-Version: 1.0
Subject: [PATCH] ath9k: Set TSF fix
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code doesn't work correctly e.g. on newer chipsets like AR5418+=
AR2122 and AR5416+AR2133.

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
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
