Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:52252
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754937AbbIMVIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 17:08:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple devices
Date: Sun, 13 Sep 2015 22:35:40 +0200
Message-Id: <1442176540-34973-1-git-send-email-nbd@openwrt.org> (sfid-20150913_230839_395443_1947BDF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some platforms really don't like DMA bursts of 256 bytes, and this
causes the firmware to crash when sending beacons.
Also, changing this based on the firmware version does not seem to make
much sense, so use 128 bytes for all versions.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath10k/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 23afcda..678d72a 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -337,7 +337,7 @@ enum ath10k_hw_rate_cck {
 #define TARGET_10X_MAX_FRAG_ENTRIES		0
 
 /* 10.2 parameters */
-#define TARGET_10_2_DMA_BURST_SIZE		1
+#define TARGET_10_2_DMA_BURST_SIZE		0
 
 /* Target specific defines for WMI-TLV firmware */
 #define TARGET_TLV_NUM_VDEVS			4
@@ -391,7 +391,7 @@ enum ath10k_hw_rate_cck {
 
 #define TARGET_10_4_TX_DBG_LOG_SIZE		1024
 #define TARGET_10_4_NUM_WDS_ENTRIES		32
-#define TARGET_10_4_DMA_BURST_SIZE		1
+#define TARGET_10_4_DMA_BURST_SIZE		0
 #define TARGET_10_4_MAC_AGGR_DELIM		0
 #define TARGET_10_4_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
 #define TARGET_10_4_VOW_CONFIG			0
-- 
2.2.2

