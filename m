Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16328 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYHKIpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:45:44 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:45:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63877.567100.267045@localhost.localdomain> (sfid-20080811_104546_165487_3C6C1048)
Date: Mon, 11 Aug 2008 14:04:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 05/10] ath9k: Remove ar5416hal and assign default values directly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   28 +++-------------------------
 1 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index bde162f..b294485 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -85,29 +85,6 @@ static const struct hal_percal_data adc_init_dc_cal = {
 	ath9k_hw_adc_dccal_calibrate
 };
 
-static const struct ath_hal ar5416hal = {
-	AR5416_MAGIC,
-	0,
-	0,
-	NULL,
-	NULL,
-	CTRY_DEFAULT,
-	0,
-	0,
-	0,
-	0,
-	0,
-	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	},
-};
-
 static struct ath9k_rate_table ar5416_11a_table = {
 	8,
 	{0},
@@ -1196,11 +1173,12 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 
 	ah = &ahp->ah;
 
-	memcpy(&ahp->ah, &ar5416hal, sizeof(struct ath_hal));
-
 	ah->ah_sc = sc;
 	ah->ah_sh = mem;
 
+	ah->ah_magic = AR5416_MAGIC;
+	ah->ah_countryCode = CTRY_DEFAULT;
+
 	ah->ah_devid = devid;
 	ah->ah_subvendorid = 0;
 
-- 
1.5.6.5

