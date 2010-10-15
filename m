Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38718 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0JOSDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 14:03:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 6/6] ath9k_hw: make ath9k_hw_gettsf32 static
Date: Fri, 15 Oct 2010 20:03:33 +0200
Message-Id: <1287165813-94331-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287165813-94331-5-git-send-email-nbd@openwrt.org>
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
 <1287165813-94331-2-git-send-email-nbd@openwrt.org>
 <1287165813-94331-3-git-send-email-nbd@openwrt.org>
 <1287165813-94331-4-git-send-email-nbd@openwrt.org>
 <1287165813-94331-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is now only used in hw.c

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +--
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cc13ee1..d37a8ad 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2312,11 +2312,10 @@ static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
 	return timer_table->gen_timer_index[b];
 }
 
-u32 ath9k_hw_gettsf32(struct ath_hw *ah)
+static u32 ath9k_hw_gettsf32(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_TSF_L32);
 }
-EXPORT_SYMBOL(ath9k_hw_gettsf32);
 
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d032939..e68204a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -892,7 +892,6 @@ void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
 
 void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
-u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
 void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
 
-- 
1.7.2.2

