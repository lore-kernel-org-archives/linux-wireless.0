Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38337 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756974AbYGTNyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 09:54:09 -0400
Message-ID: <48833EB6.7000102@openwrt.org> (sfid-20080720_155412_934018_E5327DB2)
Date: Sun, 20 Jul 2008 15:33:42 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath5k-devel@lists.ath5k.org
Subject: [PATCH 4/5] ath9k: fix return code check
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a return code check for ath9k_hw_nvram_read, this function returns
AH_TRUE when the call succeeded

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -803,7 +803,7 @@
  		u_int16_t magic, magic2;
  		int addr;

-		if (ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
+		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
  					&magic)) {
  			HDPRINTF(ah, HAL_DBG_EEPROM,
  				 "%s: Reading Magic # failed\n", __func__);
