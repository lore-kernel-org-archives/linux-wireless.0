Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39421 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaGMKS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:18:28 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so294808wiw.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 03:18:27 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [RFCv2 01/10] ath9k: export methods related to ack timeout estimation
Date: Sun, 13 Jul 2014 12:18:15 +0200
Message-Id: <1405246704-7489-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140713_121835_482769_90488936)
In-Reply-To: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove static keyword and export ath9k_hw_setslottime(),
ath9k_hw_set_ack_timeout() and ath9k_hw_set_cts_timeout() in hw.h. These
methods will be used in dynamic ack timeout estimation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
 drivers/net/wireless/ath/ath9k/hw.h | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fd0158f..e88896c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -935,21 +935,21 @@ static void ath9k_hw_set_sifs_time(struct ath_hw *ah, u32 us)
 	REG_WRITE(ah, AR_D_GBL_IFS_SIFS, val);
 }
 
-static void ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
+void ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
 	u32 val = ath9k_hw_mac_to_clks(ah, us);
 	val = min(val, (u32) 0xFFFF);
 	REG_WRITE(ah, AR_D_GBL_IFS_SLOT, val);
 }
 
-static void ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
+void ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 {
 	u32 val = ath9k_hw_mac_to_clks(ah, us);
 	val = min(val, (u32) MS(0xFFFFFFFF, AR_TIME_OUT_ACK));
 	REG_RMW_FIELD(ah, AR_TIME_OUT, AR_TIME_OUT_ACK, val);
 }
 
-static void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
+void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 {
 	u32 val = ath9k_hw_mac_to_clks(ah, us);
 	val = min(val, (u32) MS(0xFFFFFFFF, AR_TIME_OUT_CTS));
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 51b4ebe..f36d971 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1080,6 +1080,10 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
+void ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us);
+void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us);
+void ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
+
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 {
-- 
1.9.1

