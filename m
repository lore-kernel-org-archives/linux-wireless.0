Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36311 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbZBLEkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:25 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42836.910347.146000@gargle.gargle.HOWL> (sfid-20090212_054031_266339_7284A764)
Date: Thu, 12 Feb 2009 10:06:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/8] ath9k: Store the correct max TX power level
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug where the max power level
was being calculated incorrectly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |   15 +++++++++++++++
 drivers/net/wireless/ath9k/eeprom.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index c0359ad..afbd753 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -2615,6 +2615,21 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	else
 		ah->regulatory.max_power_level = ratesArray[i];
 
+	switch(ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		ah->regulatory.max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
+		break;
+	case 3:
+		ah->regulatory.max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
+		break;
+	default:
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"Invalid chainmask configuration\n");
+		break;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 99863b5..b7c656c 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -75,6 +75,9 @@
 #define SUB_NUM_CTL_MODES_AT_5G_40 2
 #define SUB_NUM_CTL_MODES_AT_2G_40 3
 
+#define INCREASE_MAXPOW_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
+#define INCREASE_MAXPOW_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
+
 #define AR_EEPROM_MAC(i)	(0x1d+(i))
 #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
 #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
-- 
1.6.1

