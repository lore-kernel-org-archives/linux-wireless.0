Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2195 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0HORNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:19 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/6] ath5k: remove own (wrong) IEEE80211_MAX_LEN
Date: Sun, 15 Aug 2010 13:03:11 -0400
Message-Id: <1281891795-14718-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
References: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nick Kossifidis <mickflemm@gmail.com>

Use the version already supplied in include/linux/ieee80211.h.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    5 +----
 drivers/net/wireless/ath/ath5k/base.c  |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 9129e51..f399c4d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -175,7 +175,7 @@
 #define AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF	0
 #define AR5K_TUNE_RADAR_ALERT			false
 #define AR5K_TUNE_MIN_TX_FIFO_THRES		1
-#define AR5K_TUNE_MAX_TX_FIFO_THRES		((IEEE80211_MAX_LEN / 64) + 1)
+#define AR5K_TUNE_MAX_TX_FIFO_THRES	((IEEE80211_MAX_FRAME_LEN / 64) + 1)
 #define AR5K_TUNE_REGISTER_TIMEOUT		20000
 /* Register for RSSI threshold has a mask of 0xff, so 255 seems to
  * be the max value. */
@@ -343,9 +343,6 @@ struct ath5k_srev_name {
 #define AR5K_SREV_PHY_5413	0x61
 #define AR5K_SREV_PHY_2425	0x70
 
-/* IEEE defs */
-#define IEEE80211_MAX_LEN       2500
-
 /* TODO add support to mac80211 for vendor-specific rates and modes */
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index cc080d0..efd9350 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1709,7 +1709,7 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	struct ath5k_buf *bf;
 	int ret;
 
-	common->rx_bufsize = roundup(IEEE80211_MAX_LEN, common->cachelsz);
+	common->rx_bufsize = roundup(IEEE80211_MAX_FRAME_LEN, common->cachelsz);
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
 		  common->cachelsz, common->rx_bufsize);
-- 
1.7.1.1


