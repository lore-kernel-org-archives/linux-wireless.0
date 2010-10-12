Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40831 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab0JLOIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:08:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k_hw: fix PHY counter overflow handling in ANI v1
Date: Tue, 12 Oct 2010 16:08:02 +0200
Message-Id: <1286892483-71182-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286892483-71182-1-git-send-email-nbd@openwrt.org>
References: <1286892483-71182-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PHY counter overflows need to be checked for the old ANI version,
because of its use of interrupt based counter overflow reports when
the counters exceed the configured thresholds.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 9297f57..63ccb39 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -664,7 +664,7 @@ static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 
-	if (use_new_ani(ah) && (phyCnt1 < ofdm_base || phyCnt2 < cck_base)) {
+	if (!use_new_ani(ah) && (phyCnt1 < ofdm_base || phyCnt2 < cck_base)) {
 		if (phyCnt1 < ofdm_base) {
 			ath_print(common, ATH_DBG_ANI,
 				  "phyCnt1 0x%x, resetting "
-- 
1.7.2.2

