Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:56156 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbZLFRYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:24:52 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: linville@tuxdriver.com
Subject: [PATCH 3/4] ath5k: Fix functions for getting/setting slot time
Date: Sun, 6 Dec 2009 18:24:58 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net>
In-Reply-To: <200912061820.26320.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912061824.58557.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Functions ath5k_hw_get_slot_time and ath5k_hw_set_slot_time were
converting microseconds to clocks only for AR5210, although it's needed
for all supported devices. The conversion was moved outside the
hardware-specific branches.

These functions are not called from anywhere yet, but they are needed
for an implementation of mac80211 callback set_coverage.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 drivers/net/wireless/ath/ath5k/qcu.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c 
b/drivers/net/wireless/ath/ath5k/qcu.c
index eeebb9a..248878a 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -520,12 +520,16 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, 
unsigned int queue)
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
@@ -533,15 +537,18 @@ unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
  */
 int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 {
+	u32 slot_time_clock = ath5k_hw_htoclock(slot_time, ah->ah_turbo);
+	
 	ATH5K_TRACE(ah->ah_sc);
-	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
+	
+	if (slot_time_clock < AR5K_SLOT_TIME_9 ||
+	    slot_time_clock > AR5K_SLOT_TIME_MAX)
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
