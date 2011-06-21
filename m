Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41819 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 29/32] ath9k: configure diversity based on eeprom contents for AR9330
Date: Tue, 21 Jun 2011 11:23:49 +0200
Message-Id: <1308648232-9906-30-git-send-email-juhosg@openwrt.org> (sfid-20110621_112531_034793_C1CD0BA1)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 7ea5105..666a174 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3525,7 +3525,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		}
 	}
 
-	if (AR_SREV_9485(ah)) {
+	if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
 		value = ath9k_hw_ar9300_get_eeprom(ah, EEP_ANT_DIV_CTL1);
 		/*
 		 * main_lnaconf, alt_lnaconf, main_tb, alt_tb
-- 
1.7.2.1

