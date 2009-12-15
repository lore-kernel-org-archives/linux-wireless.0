Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:40019 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbZLOR45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 12:56:57 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH 4/5] ath5k: Reimplement clock rate to usec conversion
Date: Tue, 15 Dec 2009 18:56:51 +0100
Message-Id: <1260899813-17585-5-git-send-email-8an@praha12.net>
In-Reply-To: <1260899813-17585-1-git-send-email-8an@praha12.net>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code was correct in 802.11a mode only, 802.11b/g uses
different clock rates. The new code uses values taken from FreeBSD HAL
and should be correct for all modes including turbo modes.

The former rate calculation was used by slope coefficient calculation
function ath5k_hw_write_ofdm_timings. However, this function requires
the 802.11a values even in 802.11g mode. Thus the use of
ath5k_hw_htoclock was replaced by hardcoded values. Possibly the slope
coefficient calculation is not related to clock rate at all.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   22 ++---------
 drivers/net/wireless/ath/ath5k/pcu.c   |   64 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath5k/qcu.c   |    4 +-
 drivers/net/wireless/ath/ath5k/reset.c |    3 +-
 4 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6a2a967..ae311d2 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1231,6 +1231,10 @@ extern int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout);
 extern unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah);
 extern int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout);
 extern unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah);
+/* Clock rate related functions */
+unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
+unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
+unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah);
 /* Key table (WEP) functions */
 extern int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
 extern int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry);
@@ -1310,24 +1314,6 @@ extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
  * Functions used internaly
  */
 
-/*
- * Translate usec to hw clock units
- * TODO: Half/quarter rate
- */
-static inline unsigned int ath5k_hw_htoclock(unsigned int usec, bool turbo)
-{
-	return turbo ? (usec * 80) : (usec * 40);
-}
-
-/*
- * Translate hw clock units to usec
- * TODO: Half/quarter rate
- */
-static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
-{
-	return turbo ? (clock / 80) : (clock / 40);
-}
-
 static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
 {
         return &ah->common;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 64fc1eb..8c72845 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -187,8 +187,8 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), ah->ah_turbo);
+	return ath5k_hw_clocktoh(ah, AR5K_REG_MS(ath5k_hw_reg_read(ah,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK));
 }
 
 /**
@@ -200,12 +200,12 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
-			ah->ah_turbo) <= timeout)
+	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK))
+			<= timeout)
 		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
-		ath5k_hw_htoclock(timeout, ah->ah_turbo));
+		ath5k_hw_htoclock(ah, timeout));
 
 	return 0;
 }
@@ -218,8 +218,8 @@ int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), ah->ah_turbo);
+	return ath5k_hw_clocktoh(ah, AR5K_REG_MS(ath5k_hw_reg_read(ah,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS));
 }
 
 /**
@@ -231,17 +231,61 @@ unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
-			ah->ah_turbo) <= timeout)
+	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS))
+			<= timeout)
 		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
-			ath5k_hw_htoclock(timeout, ah->ah_turbo));
+			ath5k_hw_htoclock(ah, timeout));
 
 	return 0;
 }
 
 /**
+ * ath5k_hw_htoclock - Translate usec to hw clock units
+ *
+ * @ah: The &struct ath5k_hw
+ * @usec: value in microseconds
+ */
+unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
+{
+	return usec * ath5k_hw_get_clockrate(ah);
+}
+
+/**
+ * ath5k_hw_clocktoh - Translate hw clock units to usec
+ * @clock: value in hw clock units
+ */
+unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
+{
+	return clock / ath5k_hw_get_clockrate(ah);
+}
+
+/**
+ * ath5k_hw_get_clockrate - Get the clock rate for current mode
+ *
+ * @ah: The &struct ath5k_hw
+ */
+unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah)
+{
+	struct ieee80211_channel *channel = ah->ah_current_channel;
+	int clock;
+
+	if (channel->hw_value & CHANNEL_5GHZ)
+		clock = 40; /* 802.11a */
+	else if (channel->hw_value & CHANNEL_CCK)
+		clock = 22; /* 802.11b */
+	else
+		clock = 44; /* 802.11g */
+
+	/* Clock rate in turbo modes is twice the normal rate */
+	if (channel->hw_value & CHANNEL_TURBO)
+		clock *= 2;
+
+	return clock;
+}
+
+/**
  * ath5k_hw_set_lladdr - Set station id
  *
  * @ah: The &struct ath5k_hw
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index ed9021a..6af0ac8 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -529,7 +529,7 @@ unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
 	else
 		slot_time_clock = ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT);
 	
-	return ath5k_hw_clocktoh(slot_time_clock & 0xffff, ah->ah_turbo);
+	return ath5k_hw_clocktoh(ah, slot_time_clock & 0xffff);
 }
 
 /*
@@ -537,7 +537,7 @@ unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
  */
 int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 {
-	u32 slot_time_clock = ath5k_hw_htoclock(slot_time, ah->ah_turbo);
+	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
 
 	ATH5K_TRACE(ah->ah_sc);
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 62954fc..f1dc4c8 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -64,8 +64,7 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 	 * we scale coef by shifting clock value by 24 for
 	 * better precision since we use integers */
 	/* TODO: Half/quarter rate */
-	clock =  ath5k_hw_htoclock(1, channel->hw_value & CHANNEL_TURBO);
-
+	clock =  (channel->hw_value & CHANNEL_TURBO) ? 80 : 40;
 	coef_scaled = ((5 * (clock << 24)) / 2) / channel->center_freq;
 
 	/* Get exponent
-- 
1.6.4.4

