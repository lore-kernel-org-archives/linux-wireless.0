Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ukl.yahoo.com ([217.146.182.248]:47728 "HELO
	nm7.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752825Ab1HCIQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 04:16:21 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marek Lindner <lindner_marek@yahoo.de>
Subject: [PATCH] ath9k: remove eeprom txgain override for minor version < 19
Date: Wed,  3 Aug 2011 10:16:12 +0200
Message-Id: <1312359372-5586-1-git-send-email-lindner_marek@yahoo.de> (sfid-20110803_101626_367539_9B49D579)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_4k_get_eeprom() overrides the eeprom value for txgain if the
minor version is not 19 or above with a value of 0.
ar9002_hw_init_mode_gain_regs() relies on this information to
determine whether this is a high power wifi card or not. The override
caused the driver to always use the 'normal' power tables even for
high power devices if their minor version was not high enough. Thus
leading to reduced power output.

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 5b1e894..10f3072 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -237,10 +237,7 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	case EEP_ANT_DIV_CTL1:
 		return pModal->antdiv_ctl1;
 	case EEP_TXGAIN_TYPE:
-		if (ver_minor >= AR5416_EEP_MINOR_VER_19)
-			return pBase->txGainType;
-		else
-			return AR5416_EEP_TXGAIN_ORIGINAL;
+		return pBase->txGainType;
 	default:
 		return 0;
 	}
-- 
1.7.5.3

