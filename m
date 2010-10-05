Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:37019 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab0JEJzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:55:13 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Gabor Juhos <juhosg@openwrt.org>,
	Shu Hwa Shen <shensh@zcomm.com.cn>
Subject: [PATCH] ath9k: get correct tx gain type in ath9k_hw_4k_get_eeprom
Date: Tue,  5 Oct 2010 11:32:17 +0200
Message-Id: <1286271137-10861-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The base_eep_header_4k structure contains information that the
device supports high power tx gain table or not. However the
ath9k_hw_4k_get_eeprom function does not return that value when
it is called with EEP_TXGAIN_TYPE. This leads to that the tx gain
initialization will use the init values from the original tx gain
table even if the device inidicates that the high power table
should be used.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Shu Hwa Shen <shensh@zcomm.com.cn>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index d6eed1f..872e75b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -179,6 +179,9 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
+	u16 ver_minor;
+
+	ver_minor = pBase->version & AR5416_EEP_VER_MINOR_MASK;
 
 	switch (param) {
 	case EEP_NFTHRESH_2:
@@ -204,7 +207,7 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	case EEP_DB_2:
 		return pModal->db1_1;
 	case EEP_MINOR_REV:
-		return pBase->version & AR5416_EEP_VER_MINOR_MASK;
+		return ver_minor;
 	case EEP_TX_MASK:
 		return pBase->txMask;
 	case EEP_RX_MASK:
@@ -217,6 +220,11 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 		return pModal->version;
 	case EEP_ANT_DIV_CTL1:
 		return pModal->antdiv_ctl1;
+	case EEP_TXGAIN_TYPE:
+		if (ver_minor >= AR5416_EEP_MINOR_VER_19)
+			return pBase->txGainType;
+		else
+			return AR5416_EEP_TXGAIN_ORIGINAL;
 	default:
 		return 0;
 	}
-- 
1.7.2.1

