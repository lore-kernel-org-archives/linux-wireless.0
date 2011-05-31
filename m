Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53494 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab1EaTrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:51 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 10/32] ath9k: use different BB watchdog timeout value for AR9330
Date: Tue, 31 May 2011 21:37:01 +0200
Message-Id: <1306870643-7935-11-git-send-email-juhosg@openwrt.org> (sfid-20110531_214803_082567_DA710981)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 826ed5d..f53a3bf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -615,7 +615,10 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
 
-	ah->bb_watchdog_timeout_ms = 25;
+	if (AR_SREV_9330(ah))
+		ah->bb_watchdog_timeout_ms = 85;
+	else
+		ah->bb_watchdog_timeout_ms = 25;
 
 	common->state = ATH_HW_INITIALIZED;
 
-- 
1.7.2.1

