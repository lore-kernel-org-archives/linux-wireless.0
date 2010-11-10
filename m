Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26516 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab0KJNEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:04:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:04:13 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 11/11] ath9k_hw: Fix low throughput issue with AR93xx
Date: Wed, 10 Nov 2010 05:03:16 -0800
Message-ID: <1289394196-3465-11-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

TX underruns were noticed when RTS/CTS preceded aggregates.
This issue was noticed in ar93xx family of chipsets only.
The workaround involves padding the RTS or CTS length up
to the min packet length of 256 bytes required by the
hardware by adding delimiters to the fist descriptor of
the aggregate.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   28 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c         |    3 ++
 drivers/net/wireless/ath/ath9k/hw.h         |    3 ++
 drivers/net/wireless/ath/ath9k/reg.h        |    1 +
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 10c812e..f5896aa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -410,12 +410,36 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
 static void ar9003_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
 					u32 aggrLen)
 {
+#define FIRST_DESC_NDELIMS 60
 	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
 	ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
 
-	ads->ctl17 &= ~AR_AggrLen;
-	ads->ctl17 |= SM(aggrLen, AR_AggrLen);
+	if (ah->ent_mode & AR_ENT_OTP_MPSD) {
+		u32 ctl17, ndelim;
+		/*
+		 * Add delimiter when using RTS/CTS with aggregation
+		 * and non enterprise AR9003 card
+		 */
+		ctl17 = ads->ctl17;
+		ndelim = MS(ctl17, AR_PadDelim);
+
+		if (ndelim < FIRST_DESC_NDELIMS) {
+			aggrLen += (FIRST_DESC_NDELIMS - ndelim) * 4;
+			ndelim = FIRST_DESC_NDELIMS;
+		}
+
+		ctl17 &= ~AR_AggrLen;
+		ctl17 |= SM(aggrLen, AR_AggrLen);
+
+		ctl17 &= ~AR_PadDelim;
+		ctl17 |= SM(ndelim, AR_PadDelim);
+
+		ads->ctl17 = ctl17;
+	} else {
+		ads->ctl17 &= ~AR_AggrLen;
+		ads->ctl17 |= SM(aggrLen, AR_AggrLen);
+	}
 }
 
 static void ar9003_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5fb1bf3..986c779 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1963,6 +1963,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_RAC_SUPPORTED;
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ah->ent_mode = REG_READ(ah, AR_ENT_OTP);
+
 	if (AR_SREV_9287_11_OR_LATER(ah) || AR_SREV_9271(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_SGI_20;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8bebc3e..19c12cf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -797,6 +797,9 @@ struct ath_hw {
 	 * this register when in sleep states.
 	 */
 	u32 WARegVal;
+
+	/* Enterprise mode cap */
+	u32 ent_mode;
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index e676a80..c70d9d0 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1068,6 +1068,7 @@ enum {
 #define AR_INTR_PRIO_ASYNC_ENABLE 0x40d4
 #define AR_ENT_OTP		  0x40d8
 #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
+#define AR_ENT_OTP_MPSD		0x00800000
 
 #define AR_RTC_9300_PLL_DIV          0x000003ff
 #define AR_RTC_9300_PLL_DIV_S        0
-- 
1.7.0.4

