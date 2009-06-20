Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:49528 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZFTWCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 18:02:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: wake up the chip for TSF reset
Date: Sun, 21 Jun 2009 00:02:14 +0200
Message-Id: <1245535335-10572-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we are in NETWORK SLEEP state, AR_SLP32_TSF_WRITE_STATUS limit
always exceeds in 'ath9k_hw_reset_tsf', because reading of the
AR_SLP3 register always return with the magic 0xdeadbeef value.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 34935a8..8cb5956 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3793,6 +3793,7 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
 	int count;
 
+	ath9k_ps_wakeup(ah->ah_sc);
 	count = 0;
 	while (REG_READ(ah, AR_SLP32_MODE) & AR_SLP32_TSF_WRITE_STATUS) {
 		count++;
@@ -3804,6 +3805,7 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 		udelay(10);
 	}
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
+	ath9k_ps_restore(ah->ah_sc);
 }
 
 bool ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
-- 
1.5.3.2

