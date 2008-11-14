Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40666 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbYKOHvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 02:51:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 23:51:12 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	<Don.breslin@atheros.com>
Subject: [PATCH] ath9k: Configure AR_PHY_SWITCH_COM with apropriate antenna control
Date: Sat, 15 Nov 2008 00:49:49 +0530
Message-ID: <1226690389-26636-1-git-send-email-vasanth@atheros.com> (sfid-20081115_085116_396010_6BF3D836)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the poor wireless connection which happens even
if we are very well in the range.

Signed-off-by: Don.breslin@atheros.com
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index f5fd03c..a5d02b7 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1244,7 +1244,7 @@ bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 
 	txRxAttenLocal = IS_CHAN_2GHZ(chan) ? 23 : 44;
 
-	ath9k_hw_get_eeprom_antenna_cfg(ah, chan, 1, &ant_config);
+	ath9k_hw_get_eeprom_antenna_cfg(ah, chan, 0, &ant_config);
 	REG_WRITE(ah, AR_PHY_SWITCH_COM, ant_config);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-- 
1.5.5.1

