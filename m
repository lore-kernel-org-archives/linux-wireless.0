Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:38254 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbeBTOlv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:41:51 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 1/2] ath9k: Fix airtime calculation for quarter/half channels
Date: Tue, 20 Feb 2018 15:41:43 +0100
Message-Id: <1519137703-9000-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180220_154154_030937_0A9FC0CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bitrate value for airtime calculation is specified for
full rates. We need to divide it for 5 and 10MHz channels to
get correct result.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cd0f023..3017078 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -184,7 +184,8 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 		break;
 	case WLAN_RC_PHY_OFDM:
 		if (ah->curchan && IS_CHAN_QUARTER_RATE(ah->curchan)) {
-			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_QUARTER) / 1000;
+			bitsPerSymbol =
+				((kbps >> 2) * OFDM_SYMBOL_TIME_QUARTER) / 1000;
 			numBits = OFDM_PLCP_BITS + (frameLen << 3);
 			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
 			txTime = OFDM_SIFS_TIME_QUARTER
@@ -192,7 +193,8 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 				+ (numSymbols * OFDM_SYMBOL_TIME_QUARTER);
 		} else if (ah->curchan &&
 			   IS_CHAN_HALF_RATE(ah->curchan)) {
-			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_HALF) / 1000;
+			bitsPerSymbol =
+				((kbps >> 1) * OFDM_SYMBOL_TIME_HALF) / 1000;
 			numBits = OFDM_PLCP_BITS + (frameLen << 3);
 			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
 			txTime = OFDM_SIFS_TIME_HALF +
-- 
2.7.4
