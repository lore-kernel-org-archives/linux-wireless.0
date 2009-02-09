Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13366 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBIIDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:03:35 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:03:35 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57973.930063.73035@gargle.gargle.HOWL> (sfid-20090209_090337_597950_3E05DBD3)
Date: Mon, 9 Feb 2009 13:29:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 02/10] ath9k: Convert ANI channel to a pointer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch converts the ANI channel reference to a pointer,
this facilitates moving struct ar5416AniState to ani.h

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ani.c |    8 ++++----
 drivers/net/wireless/ath9k/ani.h |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.h  |   27 ---------------------------
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index d75bd6e..9cebf0e 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -23,11 +23,11 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hal *ah,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ahp->ah_ani); i++) {
-		if (ahp->ah_ani[i].c.channel == chan->channel)
+		if (ahp->ah_ani[i].c &&
+		    ahp->ah_ani[i].c->channel == chan->channel)
 			return i;
-		if (ahp->ah_ani[i].c.channel == 0) {
-			ahp->ah_ani[i].c.channel = chan->channel;
-			ahp->ah_ani[i].c.channelFlags = chan->channelFlags;
+		if (ahp->ah_ani[i].c == NULL) {
+			ahp->ah_ani[i].c = chan;
 			return i;
 		}
 	}
diff --git a/drivers/net/wireless/ath9k/ani.h b/drivers/net/wireless/ath9k/ani.h
index cfb7fbc..78880e5 100644
--- a/drivers/net/wireless/ath9k/ani.h
+++ b/drivers/net/wireless/ath9k/ani.h
@@ -72,6 +72,33 @@ struct ath9k_node_stats {
 	u32 ns_avgtxrate;
 };
 
+struct ar5416AniState {
+	struct ath9k_channel *c;
+	u8 noiseImmunityLevel;
+	u8 spurImmunityLevel;
+	u8 firstepLevel;
+	u8 ofdmWeakSigDetectOff;
+	u8 cckWeakSigThreshold;
+	u32 listenTime;
+	u32 ofdmTrigHigh;
+	u32 ofdmTrigLow;
+	int32_t cckTrigHigh;
+	int32_t cckTrigLow;
+	int32_t rssiThrLow;
+	int32_t rssiThrHigh;
+	u32 noiseFloor;
+	u32 txFrameCount;
+	u32 rxFrameCount;
+	u32 cycleCount;
+	u32 ofdmPhyErrCount;
+	u32 cckPhyErrCount;
+	u32 ofdmPhyErrBase;
+	u32 cckPhyErrBase;
+	int16_t pktRssi[2];
+	int16_t ofdmErrRssi[2];
+	int16_t cckErrRssi[2];
+};
+
 struct ar5416Stats {
 	u32 ast_ani_niup;
 	u32 ast_ani_nidown;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 2b72e75..b353b1f 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -406,33 +406,6 @@ enum {
 	ATH9K_RESET_COLD,
 };
 
-struct ar5416AniState {
-	struct ath9k_channel c;
-	u8 noiseImmunityLevel;
-	u8 spurImmunityLevel;
-	u8 firstepLevel;
-	u8 ofdmWeakSigDetectOff;
-	u8 cckWeakSigThreshold;
-	u32 listenTime;
-	u32 ofdmTrigHigh;
-	u32 ofdmTrigLow;
-	int32_t cckTrigHigh;
-	int32_t cckTrigLow;
-	int32_t rssiThrLow;
-	int32_t rssiThrHigh;
-	u32 noiseFloor;
-	u32 txFrameCount;
-	u32 rxFrameCount;
-	u32 cycleCount;
-	u32 ofdmPhyErrCount;
-	u32 cckPhyErrCount;
-	u32 ofdmPhyErrBase;
-	u32 cckPhyErrBase;
-	int16_t pktRssi[2];
-	int16_t ofdmErrRssi[2];
-	int16_t cckErrRssi[2];
-};
-
 struct ath_hal {
 	u32 ah_magic;
 	u16 ah_devid;
-- 
1.6.1

