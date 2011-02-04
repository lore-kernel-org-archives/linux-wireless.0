Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:57830 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046Ab1BDLvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 06:51:40 -0500
Date: Fri, 4 Feb 2011 13:51:28 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath: Fix clearing of secondary key cache entry for TKIP
Message-ID: <20110204115128.GA4695@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All register writes to the key cache have to be done in pairs. However,
the clearing of a separate MIC entry with hardware revisions that use
combined MIC key layout did not do that with one of the registers. Add
the matching register write to the following register to make the KEY4
register write actually complete.

This is mostly a fix for a theoretical issue since the incorrect entry
that could potentially be left behind in the key cache would not match
with received frames. Anyway, better make this code clean the entry
correctly using paired register writes.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/key.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath/key.c	2011-02-04 13:35:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/key.c	2011-02-04 13:35:35.000000000 +0200
@@ -58,8 +58,11 @@ bool ath_hw_keyreset(struct ath_common *
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
-		if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)
+		if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) {
 			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
+			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
+				  AR_KEYTABLE_TYPE_CLR);
+		}
 
 	}
 

-- 
Jouni Malinen                                            PGP id EFC895FA
