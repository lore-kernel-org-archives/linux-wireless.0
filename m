Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55853 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934373AbcCNOUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 10:20:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ath9k: fix buffer overrun for ar9287
Date: Mon, 14 Mar 2016 15:18:36 +0100
Message-Id: <1457965120-3155420-4-git-send-email-arnd@arndb.de> (sfid-20160314_152252_697219_DC6C3860)
In-Reply-To: <1457965120-3155420-1-git-send-email-arnd@arndb.de>
References: <1457965120-3155420-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code that was added back in 2.6.38 has an obvious overflow
when accessing a static array, and at the time it was added
only a code comment was put in front of it as a reminder
to have it reviewed properly.

This has not happened, but gcc-6 now points to the specific
overflow:

drivers/net/wireless/ath/ath9k/eeprom.c: In function 'ath9k_hw_get_gain_boundaries_pdadcs':
drivers/net/wireless/ath/ath9k/eeprom.c:483:44: error: array subscript is above array bounds [-Werror=array-bounds]
     maxPwrT4[i] = data_9287[idxL].pwrPdg[i][4];
                   ~~~~~~~~~~~~~~~~~~~~~~~~~^~~

It turns out that the correct array length exists in the local
'intercepts' variable of this function, so we can just use that
instead of hardcoding '4', so this patch changes all three
instances to use that variable. The other two instances were
already correct, but it's more consistent this way.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 940cd2c12ebf ("ath9k_hw: merge the ar9287 version of ath9k_hw_get_gain_boundaries_pdadcs")
---
 drivers/net/wireless/ath/ath9k/eeprom.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 73fb4232f9f2..a794157a147d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -477,10 +477,9 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 
 	if (match) {
 		if (AR_SREV_9287(ah)) {
-			/* FIXME: array overrun? */
 			for (i = 0; i < numXpdGains; i++) {
 				minPwrT4[i] = data_9287[idxL].pwrPdg[i][0];
-				maxPwrT4[i] = data_9287[idxL].pwrPdg[i][4];
+				maxPwrT4[i] = data_9287[idxL].pwrPdg[i][intercepts - 1];
 				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						data_9287[idxL].pwrPdg[i],
 						data_9287[idxL].vpdPdg[i],
@@ -490,7 +489,7 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 		} else if (eeprom_4k) {
 			for (i = 0; i < numXpdGains; i++) {
 				minPwrT4[i] = data_4k[idxL].pwrPdg[i][0];
-				maxPwrT4[i] = data_4k[idxL].pwrPdg[i][4];
+				maxPwrT4[i] = data_4k[idxL].pwrPdg[i][intercepts - 1];
 				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						data_4k[idxL].pwrPdg[i],
 						data_4k[idxL].vpdPdg[i],
@@ -500,7 +499,7 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 		} else {
 			for (i = 0; i < numXpdGains; i++) {
 				minPwrT4[i] = data_def[idxL].pwrPdg[i][0];
-				maxPwrT4[i] = data_def[idxL].pwrPdg[i][4];
+				maxPwrT4[i] = data_def[idxL].pwrPdg[i][intercepts - 1];
 				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						data_def[idxL].pwrPdg[i],
 						data_def[idxL].vpdPdg[i],
-- 
2.7.0

