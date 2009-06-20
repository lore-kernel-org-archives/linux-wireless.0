Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:49537 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZFTWCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 18:02:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: make use ath9k_hw_wait int ath9k_hw_reset_tsf
Date: Sun, 21 Jun 2009 00:02:15 +0200
Message-Id: <1245535335-10572-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245535335-10572-1-git-send-email-juhosg@openwrt.org>
References: <1245535335-10572-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a dedicated function for this kind of checks, use that
instead of duplicating the code.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   17 +++++------------
 drivers/net/wireless/ath/ath9k/hw.h |    1 +
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8cb5956..fecdfc6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3791,19 +3791,12 @@ void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64)
 
 void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
-	int count;
-
 	ath9k_ps_wakeup(ah->ah_sc);
-	count = 0;
-	while (REG_READ(ah, AR_SLP32_MODE) & AR_SLP32_TSF_WRITE_STATUS) {
-		count++;
-		if (count > 10) {
-			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-				"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
-			break;
-		}
-		udelay(10);
-	}
+	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
+			   AH_TSF_WRITE_TIMEOUT))
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+			"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
+
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
 	ath9k_ps_restore(ah->ah_sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9d0b31a..a8570b5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -95,6 +95,7 @@
 
 #define MAX_RATE_POWER              63
 #define AH_WAIT_TIMEOUT             100000 /* (us) */
+#define AH_TSF_WRITE_TIMEOUT        100    /* (us) */
 #define AH_TIME_QUANTUM             10
 #define AR_KEYTABLE_SIZE            128
 #define POWER_UP_TIME               200000
-- 
1.5.3.2

