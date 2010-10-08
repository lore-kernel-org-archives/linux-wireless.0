Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56224 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681Ab0JHUOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 16:14:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com, br1@einfach.org
Subject: [PATCH 2/4] ath5k: store the clock rate in common data on channel changes
Date: Fri,  8 Oct 2010 22:13:52 +0200
Message-Id: <1286568834-18821-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286568834-18821-1-git-send-email-nbd@openwrt.org>
References: <1286568834-18821-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c   |   13 ++++++++-----
 drivers/net/wireless/ath/ath5k/phy.c   |    1 +
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 0cba2e3..4a367cd 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1201,7 +1201,7 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
 /* Clock rate related functions */
 unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
 unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
-unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah);
+void ath5k_hw_set_clockrate(struct ath5k_hw *ah);
 
 /* Queue Control Unit, DFS Control Unit Functions */
 int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 095d30b..074b4c6 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -207,7 +207,8 @@ static int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
  */
 unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
 {
-	return usec * ath5k_hw_get_clockrate(ah);
+	struct ath_common *common = ath5k_hw_common(ah);
+	return usec * common->clockrate;
 }
 
 /**
@@ -216,17 +217,19 @@ unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
  */
 unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
 {
-	return clock / ath5k_hw_get_clockrate(ah);
+	struct ath_common *common = ath5k_hw_common(ah);
+	return clock / common->clockrate;
 }
 
 /**
- * ath5k_hw_get_clockrate - Get the clock rate for current mode
+ * ath5k_hw_set_clockrate - Set common->clockrate for the current channel
  *
  * @ah: The &struct ath5k_hw
  */
-unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah)
+void ath5k_hw_set_clockrate(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
+	struct ath_common *common = ath5k_hw_common(ah);
 	int clock;
 
 	if (channel->hw_value & CHANNEL_5GHZ)
@@ -240,7 +243,7 @@ unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah)
 	if (channel->hw_value & CHANNEL_TURBO)
 		clock *= 2;
 
-	return clock;
+	common->clockrate = clock;
 }
 
 /**
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 61da913..2193678 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1093,6 +1093,7 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 
 	ah->ah_current_channel = channel;
 	ah->ah_turbo = channel->hw_value == CHANNEL_T ? true : false;
+	ath5k_hw_set_clockrate(ah);
 
 	return 0;
 }
-- 
1.7.2.2

