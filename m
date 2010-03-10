Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37366 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0CJQPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 11:15:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, mickflemm@gmail.com, proski@gnu.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] ath5k: remove some dead functions
Date: Wed, 10 Mar 2010 11:08:48 -0500
Message-Id: <1268237330-30013-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ath5k: remove stale function declarations, make some functions static"
commented-out some unused functions.  This removes them.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |   82 ----------------------------------
 drivers/net/wireless/ath/ath5k/phy.c |   12 -----
 drivers/net/wireless/ath/ath5k/qcu.c |   19 --------
 3 files changed, 0 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index be69ebb..8eaa5d6 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -178,21 +178,6 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
 * ACK/CTS Timeouts *
 \******************/
 
-#if 0
-/**
- * ath5k_hw_het_ack_timeout - Get ACK timeout from PCU in usec
- *
- * @ah: The &struct ath5k_hw
- */
-unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	return ath5k_hw_clocktoh(ah, AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK));
-}
-#endif
-
 /**
  * ath5k_hw_set_ack_timeout - Set ACK timeout on PCU
  *
@@ -212,20 +197,6 @@ static int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 	return 0;
 }
 
-#if 0
-/**
- * ath5k_hw_get_cts_timeout - Get CTS timeout from PCU in usec
- *
- * @ah: The &struct ath5k_hw
- */
-unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_clocktoh(ah, AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS));
-}
-#endif
-
 /**
  * ath5k_hw_set_cts_timeout - Set CTS timeout on PCU
  *
@@ -455,44 +426,6 @@ void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
 }
 
-#if 0
-/*
- * Set multicast filter by index
- */
-int ath5k_hw_set_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
-{
-
-	ATH5K_TRACE(ah->ah_sc);
-	if (index >= 64)
-		return -EINVAL;
-	else if (index >= 32)
-		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER1,
-				(1 << (index - 32)));
-	else
-		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
-
-	return 0;
-}
-
-/*
- * Clear Multicast filter by index
- */
-int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
-{
-
-	ATH5K_TRACE(ah->ah_sc);
-	if (index >= 64)
-		return -EINVAL;
-	else if (index >= 32)
-		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER1,
-				(1 << (index - 32)));
-	else
-		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
-
-	return 0;
-}
-#endif
-
 /**
  * ath5k_hw_get_rx_filter - Get current rx filter
  *
@@ -964,21 +897,6 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 	return 0;
 }
 
-#if 0
-/*
- * Check if a table entry is valid
- */
-int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
-
-	/* Check the validation flag at the end of the entry */
-	return ath5k_hw_reg_read(ah, AR5K_KEYTABLE_MAC1(entry)) &
-		AR5K_KEYTABLE_VALID;
-}
-#endif
-
 static
 int ath5k_keycache_type(const struct ieee80211_key_conf *key)
 {
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 10ad877..97a705a 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1774,18 +1774,6 @@ ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant)
 		ath5k_hw_reg_write(ah, ant & 0x7, AR5K_DEFAULT_ANTENNA);
 }
 
-#if 0
-unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (ah->ah_version != AR5K_AR5210)
-		return ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA) & 0x7;
-
-	return false; /*XXX: What do we return for 5210 ?*/
-}
-#endif
-
 /*
  * Enable/disable fast rx antenna diversity
  */
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index d9cab7c..f5831da 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -516,25 +516,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	return 0;
 }
 
-#if 0
-/*
- * Get slot time from DCU
- */
-unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
-{
-	unsigned int slot_time_clock;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (ah->ah_version == AR5K_AR5210)
-		slot_time_clock = ath5k_hw_reg_read(ah, AR5K_SLOT_TIME);
-	else
-		slot_time_clock = ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT);
-
-	return ath5k_hw_clocktoh(ah, slot_time_clock & 0xffff);
-}
-#endif
-
 /*
  * Set slot time on DCU
  */
-- 
1.6.2.5

