Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:43282 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYKZVR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 16:17:26 -0500
Received: by qyk4 with SMTP id 4so936638qyk.13
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 13:17:25 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: nbd@openwrt.org, lrodriguez@atheros.com, mickflemm@gmail.com,
	linville@tuxdriver.com, jirislaby@gmail.com
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Date: Wed, 26 Nov 2008 16:17:11 -0500
Message-Id: <20081126211711.16875.71258.sendpatchset@localhost> (sfid-20081126_221730_685892_80C6081C)
Subject: [PATCH 1/3] ath5k: preserve higher order bits when setting mac address
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases we would like to set the mac address without changing
the operating mode.  However, Atheros cards store PCU data in the high
16 bits of the mac address register.  Change ath5k_hw_set_lladdr() to
not clobber the PCU settings.

Changes-licensed-under: ISC
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/pcu.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index d7f0c10..79879f2 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -267,24 +267,23 @@ void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
  * @mac: The card's mac address
  *
  * Set station id on hw using the provided mac address
- *
- * NOTE: This is only called during attach, don't call it
- * on reset because it overwrites all AR5K_STA_ID1 settings.
- * We have set_opmode (above) for reset.
  */
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
 	u32 low_id, high_id;
+	u32 pcu_reg;
 
 	ATH5K_TRACE(ah->ah_sc);
 	/* Set new station ID */
 	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
 
+	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
+
 	low_id = AR5K_LOW_ID(mac);
 	high_id = AR5K_HIGH_ID(mac);
 
 	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, high_id, AR5K_STA_ID1);
+	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
 
 	return 0;
 }
-- 
1.5.4.2.182.gb3092

