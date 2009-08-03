Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42098 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZHCUvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:51:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 13:51:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH] ath9k: fix compile warning on ath9k_hw_AR9287_check_eeprom()
Date: Mon, 3 Aug 2009 13:51:49 -0700
Message-ID: <1249332709-27374-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CC [M]  drivers/net/wireless/ath/ath9k/eeprom.o
drivers/net/wireless/ath/ath9k/eeprom.c: In function ‘ath9k_hw_AR9287_check_eeprom’:
drivers/net/wireless/ath/ath9k/eeprom.c:2866: warning: comparison of distinct pointer types lacks a cast

Cc: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index e8ccec0..4e4a300 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -2816,7 +2816,6 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 }
 static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 {
-#define SIZE_EEPROM_87 (sizeof(struct ar9287_eeprom_t) / sizeof(u16))
 	u32 sum = 0, el, integer;
 	u16 temp, word, magic, magic2, *eepdata;
 	int i, addr;
@@ -2842,7 +2841,9 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 				need_swap = true;
 				eepdata = (u16 *)(&ah->eeprom);
 
-				for (addr = 0; addr < SIZE_EEPROM_87; addr++) {
+				for (addr = 0;
+				     addr < sizeof(struct ar9287_eeprom_t) / sizeof(u16);
+				     addr++) {
 					temp = swab16(*eepdata);
 					*eepdata = temp;
 					eepdata++;
@@ -2862,8 +2863,13 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	else
 		el = ah->eeprom.map9287.baseEepHeader.length;
 
+	if (el > sizeof(struct ar9287_eeprom_t))
+		el = sizeof(struct ar9287_eeprom_t) / sizeof(u16);
+	else
+		el = el / sizeof(u16);
+
 	eepdata = (u16 *)(&ah->eeprom);
-	for (i = 0; i < min(el, SIZE_EEPROM_87); i++)
+	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
 
 	if (need_swap) {
@@ -2914,7 +2920,6 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	}
 
 	return 0;
-#undef SIZE_EEPROM_87
 }
 
 static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
-- 
1.6.3.3

