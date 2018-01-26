Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39009 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbeAZHrI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 02:47:08 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/10] rtlwifi: add definition radio_mask for RF and maximum bandwidth
Date: Fri, 26 Jan 2018 15:46:42 +0800
Message-ID: <20180126074645.27201-8-pkshih@realtek.com> (sfid-20180126_084718_099037_D26BE0A3)
In-Reply-To: <20180126074645.27201-1-pkshih@realtek.com>
References: <20180126074645.27201-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add rf mask definition (BIT 0, BIT 1, BIT 2, ...) that is different from
rf path definition (0, 1, 2, ...), and then combinations of rf path are
possible.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 4de2ab1d5416..2e9a20273a2d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -286,6 +286,13 @@ enum radio_path {
 	RF90_PATH_D = 3,
 };
 
+enum radio_mask {
+	RF_MASK_A = BIT(0),
+	RF_MASK_B = BIT(1),
+	RF_MASK_C = BIT(2),
+	RF_MASK_D = BIT(3),
+};
+
 enum regulation_txpwr_lmt {
 	TXPWR_LMT_FCC = 0,
 	TXPWR_LMT_MKK = 1,
@@ -579,6 +586,7 @@ enum ht_channel_width {
 	HT_CHANNEL_WIDTH_20 = 0,
 	HT_CHANNEL_WIDTH_20_40 = 1,
 	HT_CHANNEL_WIDTH_80 = 2,
+	HT_CHANNEL_WIDTH_MAX,
 };
 
 /* Ref: 802.11i sepc D10.0 7.3.2.25.1
-- 
2.15.1
