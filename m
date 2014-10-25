Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:35579
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbaJYTgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:36:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 09/10] ath9k: allow disabling bands via platform data
Date: Sat, 25 Oct 2014 17:19:34 +0200
Message-Id: <1414250375-74121-9-git-send-email-nbd@openwrt.org> (sfid-20141025_213634_470434_A3E1370B)
In-Reply-To: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
References: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices have multiple bands enables in the EEPROM data, even though
they are only calibrated for one. Allow platform data to disable
unsupported bands.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 24 ++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/hw.h   |  2 ++
 drivers/net/wireless/ath/ath9k/init.c |  2 ++
 include/linux/ath9k_platform.h        |  2 ++
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 85a7817..47f410e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2344,17 +2344,25 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
-	if ((eeval & (AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A)) == 0) {
-		ath_err(common,
-			"no band has been marked as supported in EEPROM\n");
-		return -EINVAL;
+
+	if (eeval & AR5416_OPFLAGS_11A) {
+		if (ah->disable_5ghz)
+			ath_warn(common, "disabling 5GHz band\n");
+		else
+			pCap->hw_caps |= ATH9K_HW_CAP_5GHZ;
 	}
 
-	if (eeval & AR5416_OPFLAGS_11A)
-		pCap->hw_caps |= ATH9K_HW_CAP_5GHZ;
+	if (eeval & AR5416_OPFLAGS_11G) {
+		if (ah->disable_2ghz)
+			ath_warn(common, "disabling 2GHz band\n");
+		else
+			pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
+	}
 
-	if (eeval & AR5416_OPFLAGS_11G)
-		pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
+	if ((pCap->hw_caps & (ATH9K_HW_CAP_2GHZ | ATH9K_HW_CAP_5GHZ)) == 0) {
+		ath_err(common, "both bands are disabled\n");
+		return -EINVAL;
+	}
 
 	if (AR_SREV_9485(ah) ||
 	    AR_SREV_9285(ah) ||
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c6dba9b..e49721e8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -930,6 +930,8 @@ struct ath_hw {
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
+	bool disable_2ghz;
+	bool disable_5ghz;
 
 	const struct firmware *eeprom_blob;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3a1da83..a4d69a0 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -531,6 +531,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		ah->is_clk_25mhz = pdata->is_clk_25mhz;
 		ah->get_mac_revision = pdata->get_mac_revision;
 		ah->external_reset = pdata->external_reset;
+		ah->disable_2ghz = pdata->disable_2ghz;
+		ah->disable_5ghz = pdata->disable_5ghz;
 		if (!pdata->endian_check)
 			ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 4350165..33eb274 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -34,6 +34,8 @@ struct ath9k_platform_data {
 	bool endian_check;
 	bool is_clk_25mhz;
 	bool tx_gain_buffalo;
+	bool disable_2ghz;
+	bool disable_5ghz;
 
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
-- 
2.1.2

