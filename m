Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:42807 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803Ab2EWLej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 07:34:39 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: fix/add bits for spectral scanning
Date: Wed, 23 May 2012 13:34:31 +0200
Message-Id: <1337772871-15672-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120523_133443_880757_81930B35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updates for spectral scanning register modification for AR93x:
 * fix bits for spectral_scan_count
 * add bits for new parameters

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   32 ++++++++++++++++----------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index d834d97..44963b0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -817,18 +817,26 @@
 #define AR_PHY_CHAN_INFO_MEMORY_CAPTURE_MASK         0x0001
 #define AR_PHY_RX_DELAY_DELAY   0x00003FFF
 #define AR_PHY_CCK_TX_CTRL_JAPAN    0x00000010
-#define AR_PHY_SPECTRAL_SCAN_ENABLE         0x00000001
-#define AR_PHY_SPECTRAL_SCAN_ENABLE_S       0
-#define AR_PHY_SPECTRAL_SCAN_ACTIVE         0x00000002
-#define AR_PHY_SPECTRAL_SCAN_ACTIVE_S       1
-#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD     0x000000F0
-#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD_S   4
-#define AR_PHY_SPECTRAL_SCAN_PERIOD         0x0000FF00
-#define AR_PHY_SPECTRAL_SCAN_PERIOD_S       8
-#define AR_PHY_SPECTRAL_SCAN_COUNT          0x00FF0000
-#define AR_PHY_SPECTRAL_SCAN_COUNT_S        16
-#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT   0x01000000
-#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S 24
+
+#define AR_PHY_SPECTRAL_SCAN_ENABLE           0x00000001
+#define AR_PHY_SPECTRAL_SCAN_ENABLE_S         0
+#define AR_PHY_SPECTRAL_SCAN_ACTIVE           0x00000002
+#define AR_PHY_SPECTRAL_SCAN_ACTIVE_S         1
+#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD       0x000000F0
+#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD_S     4
+#define AR_PHY_SPECTRAL_SCAN_PERIOD           0x0000FF00
+#define AR_PHY_SPECTRAL_SCAN_PERIOD_S         8
+#define AR_PHY_SPECTRAL_SCAN_COUNT            0x0FFF0000
+#define AR_PHY_SPECTRAL_SCAN_COUNT_S          16
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT     0x10000000
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S   28
+#define AR_PHY_SPECTRAL_SCAN_PRIORITY         0x20000000
+#define AR_PHY_SPECTRAL_SCAN_PRIORITY_S       29
+#define AR_PHY_SPECTRAL_SCAN_USE_ERR5         0x40000000
+#define AR_PHY_SPECTRAL_SCAN_USE_ERR5_S       30
+#define AR_PHY_SPECTRAL_SCAN_COMPRESSED_RPT   0x80000000
+#define AR_PHY_SPECTRAL_SCAN_COMPRESSED_RPT_S 31
+
 #define AR_PHY_CHANNEL_STATUS_RX_CLEAR      0x00000004
 #define AR_PHY_RTT_CTRL_ENA_RADIO_RETENTION     0x00000001
 #define AR_PHY_RTT_CTRL_ENA_RADIO_RETENTION_S   0
-- 
1.7.4.1

