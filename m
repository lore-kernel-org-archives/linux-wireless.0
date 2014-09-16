Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50050 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbaIPANU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:20 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so4720797wgh.10
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:19 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 01/10] ath9k: export methods related to ACK timeout estimation
Date: Tue, 16 Sep 2014 02:13:07 +0200
Message-Id: <1410826396-15544-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021326_428195_E1DBB492)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove static keyword and export ath9k_hw_setslottime(),
ath9k_hw_set_ack_timeout() and ath9k_hw_set_cts_timeout() in hw.h.
These methods will be used in ACK timeout estimation algorithm (dynack)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
 drivers/net/wireless/ath/ath9k/hw.h | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ef5f5a6..ce395e2 100644
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

