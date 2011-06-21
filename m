Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41758 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1FUJY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:58 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 18/32] ath9k: use correct EEPROM base for AR9330
Date: Tue, 21 Jun 2011 11:23:38 +0200
Message-Id: <1308648232-9906-19-git-send-email-juhosg@openwrt.org> (sfid-20110621_112555_780696_6053D6FA)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 83c33a5..5457bd6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3324,6 +3324,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	read = ar9300_read_eeprom;
 	if (AR_SREV_9485(ah))
 		cptr = AR9300_BASE_ADDR_4K;
+	else if (AR_SREV_9330(ah))
+		cptr = AR9300_BASE_ADDR_512;
 	else
 		cptr = AR9300_BASE_ADDR;
 	ath_dbg(common, ATH_DBG_EEPROM,
-- 
1.7.2.1

