Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64257 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0LOPbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:30:59 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] ath9k_hw: Add a helper to get paprd scale factor
Date: Wed, 15 Dec 2010 07:30:51 -0800
Message-ID: <1292427053-5880-5-git-send-email-vasanth@atheros.com>
In-Reply-To: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    3 +++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4149ffb..9fa5793 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4843,6 +4843,27 @@ u8 *ar9003_get_spur_chan_ptr(struct ath_hw *ah, bool is_2ghz)
 		return eep->modalHeader5G.spurChans;
 }
 
+unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
+					   struct ath9k_channel *chan)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (IS_CHAN_2GHZ(chan))
+		return MS(le32_to_cpu(eep->modalHeader2G.papdRateMaskHt20),
+			  AR9300_PAPRD_SCALE_1);
+	else {
+		if (chan->channel >= 5700)
+		return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20),
+			  AR9300_PAPRD_SCALE_1);
+		else if (chan->channel >= 5400)
+			return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt40),
+				   AR9300_PAPRD_SCALE_2);
+		else
+			return MS(le32_to_cpu(eep->modalHeader5G.papdRateMaskHt40),
+				  AR9300_PAPRD_SCALE_1);
+	}
+}
+
 const struct eeprom_ops eep_ar9300_ops = {
 	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index efb6a02..afb0b5e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -315,4 +315,7 @@ s32 ar9003_hw_get_tx_gain_idx(struct ath_hw *ah);
 s32 ar9003_hw_get_rx_gain_idx(struct ath_hw *ah);
 
 u8 *ar9003_get_spur_chan_ptr(struct ath_hw *ah, bool is_2ghz);
+
+unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
+					   struct ath9k_channel *chan);
 #endif
-- 
1.7.0.4

