Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38914 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab1DLNR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:17:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:17:31 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/22] ath9k_hw: Introduce a bool for 25mhz clock and populate it
Date: Tue, 12 Apr 2011 18:47:41 +0530
Message-ID: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pll configuration will differ for 25mhz clock.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   11 +++++++++++
 drivers/net/wireless/ath/ath9k/hw.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d98b4c6..8b90b9c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -481,6 +481,9 @@ static void ath9k_hw_attach_ops(struct ath_hw *ah)
 /* Called for all hardware families */
 static int __ath9k_hw_init(struct ath_hw *ah)
 {
+#define AR9340_SOC_SEL_25M_40M 0xB80600B0
+#define AR9340_REF_CLK_40 (1 << 4) /* 0 - 25MHz   1 - 40 MHz */
+
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
@@ -508,6 +511,14 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_attach_ops(ah);
 
+	if (AR_SREV_9340(ah)) {
+		if (*((volatile u32 *) AR9340_SOC_SEL_25M_40M) &
+		    AR9340_REF_CLK_40)
+			ah->is_clk_25mhz = false;
+		else
+			ah->is_clk_25mhz = true;
+	}
+
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		ath_err(common, "Couldn't wakeup chip\n");
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index afdb006..721eb27 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -845,6 +845,8 @@ struct ath_hw {
 
 	/* Enterprise mode cap */
 	u32 ent_mode;
+
+	bool is_clk_25mhz;
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
-- 
1.7.0.4

