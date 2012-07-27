Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:58277 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab2G0QA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 12:00:28 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org
Subject: [PATCH 1/2] mac80211: Add support of transmit power control (TPC) per data packet
Date: Fri, 27 Jul 2012 18:00:08 +0200
Message-Id: <1343404809-70329-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120727_180037_367100_88493A5C)
In-Reply-To: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates a transmit power control (TPC) API for data packets.
It enables a per multi-rate-retry stage annotaion of power-levelvalue
in dBm for each data packet via ieee80211_tx_info->control.Necessary
flags are defined to specify and map hardware specific TPC capabilities
to mac80211. Someone can specify transmit power control capabilities to
the stack via:

@IEEE80211_HW_SUPPORTS_TPC_DATA_PACKET:
	One power level per data packet can be processed. Each data
	packet with all its potential retries is send out at this
	individual power level.

@IEEE80211_HW_SUPPORTS_TPC_DATA_MRR
	One power levels per multi-rate-retry stage can be processed.
	Each retry stage of a data packet is send out at its individual
	power level.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 41 +++++++++++++++++++++++++++--------------
 net/mac80211/rate.c    |  1 +
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8114f59..27ef037 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -491,32 +491,35 @@ enum mac80211_rate_control_flags {
  * @idx: rate index to attempt to send with
  * @flags: rate control flags (&enum mac80211_rate_control_flags)
  * @count: number of tries in this rate before going to the next rate
+ * @tpc: transmit power level in dBm per packet multi-rate-retry (mrr) stage
  *
  * A value of -1 for @idx indicates an invalid rate and, if used
  * in an array of retry rates, that no more rates should be tried.
  *
  * When used for transmit status reporting, the driver should
- * always report the rate along with the flags it used.
+ * always report the rate  and power along with the flags it used.
  *
  * &struct ieee80211_tx_info contains an array of these structs
- * in the control information, and it will be filled by the rate
- * control algorithm according to what should be sent. For example,
- * if this array contains, in the format { <idx>, <count> } the
+ * in the control information, and it will be filled by the joint rate-
+ * power control algorithm according to what should be sent. For example,
+ * if this array contains, in the format { <idx>, <count>, <tpc> } the
  * information
- *    { 3, 2 }, { 2, 2 }, { 1, 4 }, { -1, 0 }, { -1, 0 }
+ *    { 3, 2, 16 }, { 2, 2, 10 }, { 1, 4, 5 }, { -1, 0, 0 }
  * then this means that the frame should be transmitted
- * up to twice at rate 3, up to twice at rate 2, and up to four
- * times at rate 1 if it doesn't get acknowledged. Say it gets
- * acknowledged by the peer after the fifth attempt, the status
+ * up to twice at rate 3 with 16 dBm, up to twice at rate 2 with 10 dBm,
+ * and up to four times at rate 1 with 5 dBm if it doesn't get acknowledged.
+ * Say it gets acknowledged by the peer after the fifth attempt, the status
  * information should then contain
- *   { 3, 2 }, { 2, 2 }, { 1, 1 }, { -1, 0 } ...
- * since it was transmitted twice at rate 3, twice at rate 2
- * and once at rate 1 after which we received an acknowledgement.
+ *   { 3, 2, 16 }, { 2, 2, 10 }, { 1, 1, 5 }, { -1, 0, 0 }
+ * since it was transmitted twice at rate 3 with 16 dBm, twice at rate 2 with
+ * 10 dBm and once at rate 1 with 5 dBm after which we received an
+ * acknowledgement.
  */
 struct ieee80211_tx_rate {
 	s8 idx;
 	u8 count;
 	u8 flags;
+	u8 tpc;
 } __packed;
 
 /**
@@ -552,7 +555,7 @@ struct ieee80211_tx_info {
 	union {
 		struct {
 			union {
-				/* rate control */
+				/* rate control and transmit power control */
 				struct {
 					struct ieee80211_tx_rate rates[
 						IEEE80211_TX_MAX_RATES];
@@ -573,7 +576,7 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			u8 ampdu_len;
 			u8 antenna;
-			/* 21 bytes free */
+			/* 17 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
@@ -640,7 +643,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
 		info->status.rates[i].count = 0;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
+	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 24);
 	memset(&info->status.ampdu_ack_len, 0,
 	       sizeof(struct ieee80211_tx_info) -
 	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
@@ -1216,6 +1219,14 @@ struct ieee80211_tx_control {
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
  *	control for more details.
+ *
+ * @IEEE80211_HW_SUPPORTS_TPC_DATA_PACKET: One power level per data packet
+ *	can be processed. Each data packet with all its potential retries
+ *	is send out at this individual power level.
+ *
+ * @IEEE80211_HW_SUPPORTS_TPC_DATA_MRR: One power levels per multi-rate-retry
+ *	stage can be processed. Each retry stage of a data packet is send out
+ *	using its specified power level.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1243,6 +1254,8 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
+	IEEE80211_HW_SUPPORTS_TPC_DATA_PACKET		= 1<<25,
+	IEEE80211_HW_SUPPORTS_TPC_DATA_MRR		= 1<<26,
 };
 
 /**
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3313c11..98bde93 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -448,6 +448,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		info->control.rates[i].idx = -1;
 		info->control.rates[i].flags = 0;
 		info->control.rates[i].count = 0;
+		info->control.rates[i].tpc = sdata->local->hw.conf.power_level;
 	}
 
 	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
-- 
1.7.11.1

