Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54206 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbZDMQbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:03 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26558.933755.575033@gargle.gargle.HOWL> (sfid-20090413_183106_533461_C2A8EBD4)
Date: Mon, 13 Apr 2009 21:56:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/11] ath9k: Remove unused channel flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5c4127e..7e37570 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -266,13 +266,6 @@ enum ath9k_int {
 #define CHANNEL_HT40PLUS  0x20000
 #define CHANNEL_HT40MINUS 0x40000
 
-#define CHANNEL_INTERFERENCE    0x01
-#define CHANNEL_DFS             0x02
-#define CHANNEL_4MS_LIMIT       0x04
-#define CHANNEL_DFS_CLEAR       0x08
-#define CHANNEL_DISALLOW_ADHOC  0x10
-#define CHANNEL_PER_11D_ADHOC   0x20
-
 #define CHANNEL_A           (CHANNEL_5GHZ|CHANNEL_OFDM)
 #define CHANNEL_B           (CHANNEL_2GHZ|CHANNEL_CCK)
 #define CHANNEL_G           (CHANNEL_2GHZ|CHANNEL_OFDM)
@@ -303,10 +296,6 @@ struct ath9k_channel {
 	int16_t rawNoiseFloor;
 };
 
-#define IS_CHAN_A(_c) ((((_c)->channelFlags & CHANNEL_A) == CHANNEL_A) || \
-       (((_c)->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20) || \
-       (((_c)->channelFlags & CHANNEL_A_HT40PLUS) == CHANNEL_A_HT40PLUS) || \
-       (((_c)->channelFlags & CHANNEL_A_HT40MINUS) == CHANNEL_A_HT40MINUS))
 #define IS_CHAN_G(_c) ((((_c)->channelFlags & (CHANNEL_G)) == CHANNEL_G) || \
        (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
        (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
@@ -314,7 +303,6 @@ struct ath9k_channel {
 #define IS_CHAN_OFDM(_c) (((_c)->channelFlags & CHANNEL_OFDM) != 0)
 #define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
 #define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
-#define IS_CHAN_PASSIVE(_c) (((_c)->channelFlags & CHANNEL_PASSIVE) != 0)
 #define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
 #define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
 #define IS_CHAN_A_5MHZ_SPACED(_c)			\
-- 
1.6.2.2

