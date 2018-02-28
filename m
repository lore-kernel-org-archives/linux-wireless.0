Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52455 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbeB1DHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:40 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/15] rtlwifi: btcoex: Add customer_id to do special deal to oem vendor
Date: Wed, 28 Feb 2018 11:07:07 +0800
Message-ID: <20180228030718.19510-5-pkshih@realtek.com> (sfid-20180228_040807_810742_4D6FE4AE)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add customer_id field in structure, and then this is a clue to implement
the behavior defined by vendor LENOVO_CHINA.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index f5d8159a88eb..3c6a1e8851ec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -154,6 +154,7 @@ struct btc_board_info {
 
 	u8 rfe_type;
 	u8 ant_div_cfg;
+	u8 customer_id;
 };
 
 enum btc_dbg_opcode {
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 438678c2d14a..d27e33960e77 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -556,6 +556,7 @@ enum rt_oem_id {
 	RT_CID_NETGEAR = 36,
 	RT_CID_PLANEX = 37,
 	RT_CID_CC_C = 38,
+	RT_CID_LENOVO_CHINA = 40,
 };
 
 enum hw_descs {
-- 
2.15.1
