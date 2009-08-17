Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2819 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbZHQPSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:18:45 -0400
Date: Mon, 17 Aug 2009 11:18:14 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1251: correct definitions for 0th bit defines
Message-ID: <20090817151814.GB13125@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACX_SLV_SOFT_RESET_BIT and ACX_REG_EEPROM_START_BIT are both defined
as "1" in the vendor driver code, but they were defined to be BIT(1)
("2") here.  

The SOFT_RESET typo ensures that wl1251_boot_soft_reset() doesn't;
as a result the device hangs when trying to reprogram the PLL
registers while running.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/wl1251_reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_reg.h b/drivers/net/wireless/wl12xx/wl1251_reg.h
index 2de47cc..86a8666 100644
--- a/drivers/net/wireless/wl12xx/wl1251_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1251_reg.h
@@ -309,8 +309,8 @@ enum wl12xx_acx_int_reg {
 	ACX_REG_TABLE_LEN
 };
 
-#define ACX_SLV_SOFT_RESET_BIT   BIT(1)
-#define ACX_REG_EEPROM_START_BIT BIT(1)
+#define ACX_SLV_SOFT_RESET_BIT   BIT(0)
+#define ACX_REG_EEPROM_START_BIT BIT(0)
 
 /* Command/Information Mailbox Pointers */
 
-- 
1.6.2.5

-- 
Bob Copeland %% www.bobcopeland.com

