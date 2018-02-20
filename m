Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:1151 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750829AbeBTOmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:42:07 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 2/2] ath9k: Fix ack SIFS time for quarter/half channels
Date: Tue, 20 Feb 2018 15:42:00 +0100
Message-Id: <1519137720-9129-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180220_154210_984633_C51C4B19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ack timing generation has to be adapted for 5/10 MHz channels.
Do it by properly initializing ack shift field in TXSIFS
register. Ack shift assumes channel width of 2.5 Hhz so
value zero means 2.5 MHz, 1 is 5 MHz and so on.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3017078..6b37036 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1038,7 +1038,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	int acktimeout, ctstimeout, ack_offset = 0;
 	int slottime;
 	int sifstime;
-	int rx_lat = 0, tx_lat = 0, eifs = 0;
+	int rx_lat = 0, tx_lat = 0, eifs = 0, ack_shift = 0;
 	u32 reg;
 
 	ath_dbg(ath9k_hw_common(ah), RESET, "ah->misc_mode 0x%x\n",
@@ -1070,6 +1070,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 
 		sifstime = 32;
 		ack_offset = 16;
+		ack_shift = 3;
 		slottime = 13;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
@@ -1080,6 +1081,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 
 		sifstime = 64;
 		ack_offset = 32;
+		ack_shift = 1;
 		slottime = 21;
 	} else {
 		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
@@ -1136,6 +1138,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		SM(tx_lat, AR_USEC_TX_LAT),
 		AR_USEC_TX_LAT | AR_USEC_RX_LAT | AR_USEC_USEC);
 
+	if (IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))
+		REG_RMW(ah, AR_TXSIFS,
+			sifstime | SM(ack_shift, AR_TXSIFS_ACK_SHIFT),
+			(AR_TXSIFS_TIME | AR_TXSIFS_ACK_SHIFT));
 }
 EXPORT_SYMBOL(ath9k_hw_init_global_settings);
 
-- 
2.7.4
