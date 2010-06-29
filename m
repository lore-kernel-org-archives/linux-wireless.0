Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41181 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0F2TpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:45:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, ath9k-devel@atheros.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: make ath9k_hw_keysetmac static
Date: Tue, 29 Jun 2010 15:39:03 -0400
Message-Id: <1277840343-18266-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +--
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9d22444..6e87af4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1498,7 +1498,7 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 }
 EXPORT_SYMBOL(ath9k_hw_keyreset);
 
-bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
+static bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
 	u32 unicast_flag = AR_KEYTABLE_VALID;
@@ -1536,7 +1536,6 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 
 	return true;
 }
-EXPORT_SYMBOL(ath9k_hw_keysetmac);
 
 bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f0e0cc9..bb99e2e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -859,7 +859,6 @@ u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan);
 
 /* Key Cache Management */
 bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry);
-bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac);
 bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
 				 const u8 *mac);
-- 
1.7.0.1

