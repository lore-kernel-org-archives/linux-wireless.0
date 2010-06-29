Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0F2TpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:45:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, ath9k-devel@atheros.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: remove unused function ath9k_hw_keyisvalid
Date: Tue, 29 Jun 2010 15:38:50 -0400
Message-Id: <1277840330-18228-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   11 -----------
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1ed1440..9d22444 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1737,17 +1737,6 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 }
 EXPORT_SYMBOL(ath9k_hw_set_keycache_entry);
 
-bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
-{
-	if (entry < ah->caps.keycache_size) {
-		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
-		if (val & AR_KEYTABLE_VALID)
-			return true;
-	}
-	return false;
-}
-EXPORT_SYMBOL(ath9k_hw_keyisvalid);
-
 /******************************/
 /* Power Management (Chipset) */
 /******************************/
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e9578a4..f0e0cc9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -863,7 +863,6 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac);
 bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
 				 const u8 *mac);
-bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry);
 
 /* GPIO / RFKILL / Antennae */
 void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio);
-- 
1.7.0.1

