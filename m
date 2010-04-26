Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab0DZTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 06/13] ath9k_hw: update EEPROM data structure for AR9280
Date: Mon, 26 Apr 2010 15:04:34 -0400
Message-Id: <1272308681-32396-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Adds read access for the 5 GHz fast clock flag

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.h     |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index fb9c8c9..21354c1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -300,7 +300,8 @@ struct base_eep_header {
 	u32 binBuildNumber;
 	u8 deviceType;
 	u8 pwdclkind;
-	u8 futureBase_1[2];
+	u8 fastClk5g;
+	u8 divChain;
 	u8 rxGainType;
 	u8 dacHiPwrMode_5G;
 	u8 openLoopPwrCntl;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index cf59799..e591ad6 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -274,6 +274,8 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 		return pBase->txMask;
 	case EEP_RX_MASK:
 		return pBase->rxMask;
+	case EEP_FSTCLK_5G:
+		return pBase->fastClk5g;
 	case EEP_RXGAIN_TYPE:
 		return pBase->rxGainType;
 	case EEP_TXGAIN_TYPE:
-- 
1.6.3.3

