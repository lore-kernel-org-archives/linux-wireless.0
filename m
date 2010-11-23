Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39604 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0KWTJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:09:47 -0500
Received: by eye27 with SMTP id 27so4880603eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:09:45 -0800 (PST)
Date: Tue, 23 Nov 2010 21:09:11 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 14/30] ath5k: Extend get_default_sifs/slot_time
Message-ID: <20101123190911.GN4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Extend get_default_sifs/slot_time to include timings for turbo
 half and quarter rate modes.

 * AR5210 code for now uses timings already on core clock units
 instead of usecs so rename them (we 'll clean it up later).

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   24 ++++++++++++--
 drivers/net/wireless/ath/ath5k/pcu.c   |   52 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath5k/qcu.c   |   16 +++++----
 3 files changed, 68 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 005cad0..e11fc8f 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -226,16 +226,16 @@
 #define AR5K_INIT_USEC				39
 #define AR5K_INIT_USEC_TURBO			79
 #define AR5K_INIT_USEC_32			31
-#define AR5K_INIT_SLOT_TIME			396
-#define AR5K_INIT_SLOT_TIME_TURBO		480
+#define AR5K_INIT_SLOT_TIME_CLOCK		396
+#define AR5K_INIT_SLOT_TIME_TURBO_CLOCK		480
 #define AR5K_INIT_ACK_CTS_TIMEOUT		1024
 #define AR5K_INIT_ACK_CTS_TIMEOUT_TURBO		0x08000800
 #define AR5K_INIT_PROG_IFS			920
 #define AR5K_INIT_PROG_IFS_TURBO		960
 #define AR5K_INIT_EIFS				3440
 #define AR5K_INIT_EIFS_TURBO			6880
-#define AR5K_INIT_SIFS				560
-#define AR5K_INIT_SIFS_TURBO			480
+#define AR5K_INIT_SIFS_CLOCK			560
+#define AR5K_INIT_SIFS_TURBO_CLOCK		480
 #define AR5K_INIT_SH_RETRY			10
 #define AR5K_INIT_LG_RETRY			AR5K_INIT_SH_RETRY
 #define AR5K_INIT_SSH_RETRY			32
@@ -251,6 +251,22 @@
 	(AR5K_INIT_PROG_IFS_TURBO)					\
 )
 
+/* Slot time */
+#define AR5K_INIT_SLOT_TIME_TURBO		6
+#define AR5K_INIT_SLOT_TIME_DEFAULT		9
+#define	AR5K_INIT_SLOT_TIME_HALF_RATE		13
+#define	AR5K_INIT_SLOT_TIME_QUARTER_RATE	21
+#define	AR5K_INIT_SLOT_TIME_B			20
+#define AR5K_SLOT_TIME_MAX			0xffff
+
+/* SIFS */
+#define	AR5K_INIT_SIFS_TURBO			6
+/* XXX: 8 from initvals 10 from standard */
+#define	AR5K_INIT_SIFS_DEFAULT_BG		8
+#define	AR5K_INIT_SIFS_DEFAULT_A		16
+#define	AR5K_INIT_SIFS_HALF_RATE		32
+#define AR5K_INIT_SIFS_QUARTER_RATE		64
+
 /* Rx latency for 5 and 10MHz operation (max ?) */
 #define AR5K_INIT_RX_LAT_MAX			63
 /* Tx latencies from initvals (5212 only but no problem
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index ae99e37..cb6e277 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -43,14 +43,27 @@
 static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
+	unsigned int slot_time;
 
-	if (channel->hw_value & CHANNEL_TURBO)
-		return 6; /* both turbo modes */
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_40MHZ:
+		slot_time = AR5K_INIT_SLOT_TIME_TURBO;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		slot_time = AR5K_INIT_SLOT_TIME_HALF_RATE;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		slot_time = AR5K_INIT_SLOT_TIME_QUARTER_RATE;
+		break;
+	case AR5K_BWMODE_DEFAULT:
+		slot_time = AR5K_INIT_SLOT_TIME_DEFAULT;
+	default:
+		if (channel->hw_value & CHANNEL_CCK)
+			slot_time = AR5K_INIT_SLOT_TIME_B;
+		break;
+	}
 
-	if (channel->hw_value & CHANNEL_CCK)
-		return 20; /* 802.11b */
-
-	return 9; /* 802.11 a/g */
+	return slot_time;
 }
 
 /**
@@ -58,17 +71,30 @@ static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
  *
  * @ah: The &struct ath5k_hw
  */
-static unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
+unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
+	unsigned int sifs;
 
-	if (channel->hw_value & CHANNEL_TURBO)
-		return 8; /* both turbo modes */
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_40MHZ:
+		sifs = AR5K_INIT_SIFS_TURBO;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		sifs = AR5K_INIT_SIFS_HALF_RATE;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		sifs = AR5K_INIT_SIFS_QUARTER_RATE;
+		break;
+	case AR5K_BWMODE_DEFAULT:
+		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
+	default:
+		if (channel->hw_value & CHANNEL_5GHZ)
+			sifs = AR5K_INIT_SIFS_DEFAULT_A;
+		break;
+	}
 
-	if (channel->hw_value & CHANNEL_5GHZ)
-		return 16; /* 802.11a */
-
-	return 10; /* 802.11 b/g */
+	return sifs;
 }
 
 /**
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index c422d5c..6eb6838 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -297,7 +297,8 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 		/* Set Slot time */
 		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
+			AR5K_INIT_SLOT_TIME_TURBO_CLOCK :
+			AR5K_INIT_SLOT_TIME_CLOCK,
 			AR5K_SLOT_TIME);
 		/* Set ACK_CTS timeout */
 		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
@@ -306,15 +307,16 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 		/* Set IFS0 */
 		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
-			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
-				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO) <<
-				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
+			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO_CLOCK +
+				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO_CLOCK)
+				<< AR5K_IFS0_DIFS_S) |
+				AR5K_INIT_SIFS_TURBO_CLOCK,
 				AR5K_IFS0);
 		} else {
-			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
-				tq->tqi_aifs * AR5K_INIT_SLOT_TIME) <<
+			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_CLOCK +
+				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_CLOCK) <<
 				AR5K_IFS0_DIFS_S) |
-				AR5K_INIT_SIFS, AR5K_IFS0);
+				AR5K_INIT_SIFS_CLOCK, AR5K_IFS0);
 		}
 
 		/* Set IFS1 */
