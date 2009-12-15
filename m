Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:40015 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbZLOR45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 12:56:57 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH 3/5] ath5k: Fix functions for getting/setting slot time
Date: Tue, 15 Dec 2009 18:56:50 +0100
Message-Id: <1260899813-17585-4-git-send-email-8an@praha12.net>
In-Reply-To: <1260899813-17585-1-git-send-email-8an@praha12.net>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Functions ath5k_hw_get_slot_time and ath5k_hw_set_slot_time were
converting microseconds to clocks only for AR5210, although it's needed
for all supported devices. The conversion was moved outside the
hardware-specific branches.

The original code also limited minimum slot time to 9, while turbo modes
use 6, this was fixed too.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 drivers/net/wireless/ath/ath5k/qcu.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index eeebb9a..ed9021a 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -520,12 +520,16 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
  */
 unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
 {
+	unsigned int slot_time_clock;
+
 	ATH5K_TRACE(ah->ah_sc);
+
 	if (ah->ah_version == AR5K_AR5210)
-		return ath5k_hw_clocktoh(ath5k_hw_reg_read(ah,
-				AR5K_SLOT_TIME) & 0xffff, ah->ah_turbo);
+		slot_time_clock = ath5k_hw_reg_read(ah, AR5K_SLOT_TIME);
 	else
-		return ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
+		slot_time_clock = ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT);
+
+	return ath5k_hw_clocktoh(slot_time_clock & 0xffff, ah->ah_turbo);
 }
 
 /*
@@ -533,15 +537,17 @@ unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
  */
 int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 {
+	u32 slot_time_clock = ath5k_hw_htoclock(slot_time, ah->ah_turbo);
+
 	ATH5K_TRACE(ah->ah_sc);
-	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
+
+	if (slot_time < 6 || slot_time_clock > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
 
 	if (ah->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(ah, ath5k_hw_htoclock(slot_time,
-				ah->ah_turbo), AR5K_SLOT_TIME);
+		ath5k_hw_reg_write(ah, slot_time_clock, AR5K_SLOT_TIME);
 	else
-		ath5k_hw_reg_write(ah, slot_time, AR5K_DCU_GBL_IFS_SLOT);
+		ath5k_hw_reg_write(ah, slot_time_clock, AR5K_DCU_GBL_IFS_SLOT);
 
 	return 0;
 }
-- 
1.6.4.4

