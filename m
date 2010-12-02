Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59169 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBLMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:12:30 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:12:16 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 13/27] ath9k_hw: Add a helper function to get spur channel pointer from cal data for AR9003 family
Date: Thu, 2 Dec 2010 03:06:57 -0800
Message-ID: <1291288031-3409-14-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helper function would be used for AR9485.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6cbfbfa..c85b97e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4758,6 +4758,16 @@ s32 ar9003_hw_get_rx_gain_idx(struct ath_hw *ah)
 	return (eep->baseEepHeader.txrxgain) & 0xf; /* bits 3:0 */
 }
 
+u8 *ar9003_get_spur_chan_ptr(struct ath_hw *ah, bool is_2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (is_2ghz)
+		return eep->modalHeader2G.spurChans;
+	else
+		return eep->modalHeader5G.spurChans;
+}
+
 const struct eeprom_ops eep_ar9300_ops = {
 	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index d189c87..cf3e145 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -348,4 +348,5 @@ struct ar9300_eeprom {
 s32 ar9003_hw_get_tx_gain_idx(struct ath_hw *ah);
 s32 ar9003_hw_get_rx_gain_idx(struct ath_hw *ah);
 
+u8 *ar9003_get_spur_chan_ptr(struct ath_hw *ah, bool is_2ghz);
 #endif
-- 
1.7.0.4

