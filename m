Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36312 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbZBLEk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:26 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42843.318423.175849@gargle.gargle.HOWL> (sfid-20090212_054032_087693_ADD5D289)
Date: Thu, 12 Feb 2009 10:06:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/8] ath9k: Fix rd_ext EEPROM capability for AR9285
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9285 chipsets have a different EEPROM layout,
handle this appropriately when populating the rd_ext
capability.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.h |   12 ++++++++++++
 drivers/net/wireless/ath9k/hw.c     |    3 ++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index b7c656c..5c0d6c3 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -78,6 +78,18 @@
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
+/*
+ * For AR9285 and later chipsets, the following bits are not being programmed
+ * in EEPROM and so need to be enabled always.
+ *
+ * Bit 0: en_fcc_mid
+ * Bit 1: en_jap_mid
+ * Bit 2: en_fcc_dfs_ht40
+ * Bit 3: en_jap_ht40
+ * Bit 4: en_jap_dfs_ht40
+ */
+#define AR9285_RDEXT_DEFAULT    0x1F
+
 #define AR_EEPROM_MAC(i)	(0x1d+(i))
 #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
 #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index cad8e39..55d5a74 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3128,10 +3128,11 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	u16 capField = 0, eeval;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
-
 	ah->regulatory.current_rd = eeval;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		eeval |= AR9285_RDEXT_DEFAULT;
 	ah->regulatory.current_rd_ext = eeval;
 
 	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
-- 
1.6.1

