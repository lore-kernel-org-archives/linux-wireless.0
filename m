Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1KYSlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:41:16 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so988570eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:41:16 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 11/12] ath5k: Renumber hw queue ids
Date: Fri, 25 Nov 2011 20:40:30 +0200
Message-Id: <1322246431-10825-12-git-send-email-mickflemm@gmail.com> (sfid-20111125_194124_424634_6BEF2DDA)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to documentation higher DCUs have higher priority and should
be used for beacons and CAB traffic. More specifically DCU 9 should be
used for beacons and DCU 8 for CAB traffic, I assumed DCU 7 should be
OK for UAPSD traffic.

Note that DCU 8 and 9 are special because they can only be mapped to a single
QCU each but since we use a 1:1 mapping between QCUs and DCUs anyway we don't
have to change much.

P.S. I also did a few related cleanups on qcu.c and ath5k.h

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   10 ++++------
 drivers/net/wireless/ath/ath5k/qcu.c   |   14 +++++++-------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index c3815f7..e564e58 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -571,20 +571,18 @@ enum ath5k_tx_queue_subtype {
  * @AR5K_TX_QUEUE_ID_CAB: Content after beacon queue
  * @AR5K_TX_QUEUE_ID_BEACON: Beacon queue
  * @AR5K_TX_QUEUE_ID_UAPSD: Urgent Automatic Power Save Delivery,
- * @AR5K_TX_QUEUE_ID_XR_DATA: XR Data queue
  *
  * Each number represents a hw queue. If hw does not support hw queues
- * (eg 5210) all data goes in one queue. These match
- * mac80211 definitions.
+ * (eg 5210) all data goes in one queue.
  */
 enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_NOQCU_DATA	= 0,
 	AR5K_TX_QUEUE_ID_NOQCU_BEACON	= 1,
 	AR5K_TX_QUEUE_ID_DATA_MIN	= 0,
 	AR5K_TX_QUEUE_ID_DATA_MAX	= 3,
-	AR5K_TX_QUEUE_ID_CAB		= 6,
-	AR5K_TX_QUEUE_ID_BEACON		= 7,
-	AR5K_TX_QUEUE_ID_UAPSD		= 8,
+	AR5K_TX_QUEUE_ID_UAPSD		= 7,
+	AR5K_TX_QUEUE_ID_CAB		= 8,
+	AR5K_TX_QUEUE_ID_BEACON		= 9,
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 31924c3..e50e64d 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -54,7 +54,7 @@ Queue Control Unit, DCF Control Unit Functions
 /**
  * ath5k_hw_num_tx_pending() - Get number of pending frames for a  given queue
  * @ah: The &struct ath5k_hw
- * @queue: The hw queue number
+ * @queue: One of enum ath5k_tx_queue_id
  */
 u32
 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
@@ -85,7 +85,7 @@ ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
 /**
  * ath5k_hw_release_tx_queue() - Set a transmit queue inactive
  * @ah: The &struct ath5k_hw
- * @queue: The hw queue number
+ * @queue: One of enum ath5k_tx_queue_id
  */
 void
 ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
@@ -120,7 +120,7 @@ ath5k_cw_validate(u16 cw_req)
 /**
  * ath5k_hw_get_tx_queueprops() - Get properties for a transmit queue
  * @ah: The &struct ath5k_hw
- * @queue: The hw queue number
+ * @queue: One of enum ath5k_tx_queue_id
  * @queue_info: The &struct ath5k_txq_info to fill
  */
 int
@@ -134,7 +134,7 @@ ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 /**
  * ath5k_hw_set_tx_queueprops() - Set properties for a transmit queue
  * @ah: The &struct ath5k_hw
- * @queue: The hw queue number
+ * @queue: One of enum ath5k_tx_queue_id
  * @qinfo: The &struct ath5k_txq_info to use
  *
  * Returns 0 on success or -EIO if queue is inactive
@@ -267,7 +267,7 @@ ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 /**
  * ath5k_hw_set_tx_retry_limits() - Set tx retry limits on DCU
  * @ah: The &struct ath5k_hw
- * @queue: The hw queue number
+ * @queue: One of enum ath5k_tx_queue_id
  *
  * This function is used when initializing a queue, to set
  * retry limits based on ah->ah_retry_* and the chipset used.
@@ -310,9 +310,9 @@ ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
 /**
  * ath5k_hw_reset_tx_queue() - Initialize a single hw queue
  * @ah: The &struct ath5k_hw
- * @queue: The hw queue number
+ * @queue: One of enum ath5k_tx_queue_id
  *
- * Set DFS properties for the given transmit queue on DCU
+ * Set DCF properties for the given transmit queue on DCU
  * and configures all queue-specific parameters.
  */
 int
-- 
1.7.8.rc3

