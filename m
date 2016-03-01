Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48791 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbcCAC7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 21:59:25 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 6/8] ath9k: add bits definition of BTCoex MODE2/3 for SOC chips
Date: Tue,  1 Mar 2016 10:58:33 +0800
Message-Id: <1456801115-16636-7-git-send-email-miaoqing@codeaurora.org> (sfid-20160301_035928_484559_E2307AD2)
In-Reply-To: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org>
References: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Add bits definition for AR_BT_COEX_MODE2 and AR_BT_COEX_MODE3, which
needed by SOC chips (AR9340, AR9531, AR9550, AR9561).

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/reg.h | 46 +++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index f82a4ad..f8a96f6 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1890,15 +1890,33 @@ enum {
 
 #define AR9300_BT_WGHT             0xcccc4444
 
-#define AR_BT_COEX_MODE2           0x817c
-#define AR_BT_BCN_MISS_THRESH      0x000000ff
-#define AR_BT_BCN_MISS_THRESH_S    0
-#define AR_BT_BCN_MISS_CNT         0x0000ff00
-#define AR_BT_BCN_MISS_CNT_S       8
-#define AR_BT_HOLD_RX_CLEAR        0x00010000
-#define AR_BT_HOLD_RX_CLEAR_S      16
-#define AR_BT_DISABLE_BT_ANT       0x00100000
-#define AR_BT_DISABLE_BT_ANT_S     20
+#define AR_BT_COEX_MODE2		0x817c
+#define AR_BT_BCN_MISS_THRESH		0x000000ff
+#define AR_BT_BCN_MISS_THRESH_S		0
+#define AR_BT_BCN_MISS_CNT		0x0000ff00
+#define AR_BT_BCN_MISS_CNT_S		8
+#define AR_BT_HOLD_RX_CLEAR		0x00010000
+#define AR_BT_HOLD_RX_CLEAR_S		16
+#define AR_BT_PROTECT_BT_AFTER_WAKEUP	0x00080000
+#define AR_BT_PROTECT_BT_AFTER_WAKEUP_S 19
+#define AR_BT_DISABLE_BT_ANT		0x00100000
+#define AR_BT_DISABLE_BT_ANT_S		20
+#define AR_BT_QUIET_2_WIRE		0x00200000
+#define AR_BT_QUIET_2_WIRE_S		21
+#define AR_BT_WL_ACTIVE_MODE		0x00c00000
+#define AR_BT_WL_ACTIVE_MODE_S		22
+#define AR_BT_WL_TXRX_SEPARATE		0x01000000
+#define AR_BT_WL_TXRX_SEPARATE_S	24
+#define AR_BT_RS_DISCARD_EXTEND		0x02000000
+#define AR_BT_RS_DISCARD_EXTEND_S	25
+#define AR_BT_TSF_BT_ACTIVE_CTRL	0x0c000000
+#define AR_BT_TSF_BT_ACTIVE_CTRL_S	26
+#define AR_BT_TSF_BT_PRIORITY_CTRL	0x30000000
+#define AR_BT_TSF_BT_PRIORITY_CTRL_S	28
+#define AR_BT_INTERRUPT_ENABLE		0x40000000
+#define AR_BT_INTERRUPT_ENABLE_S	30
+#define AR_BT_PHY_ERR_BT_COLL_ENABLE	0x80000000
+#define AR_BT_PHY_ERR_BT_COLL_ENABLE_S	31
 
 #define AR_TXSIFS              0x81d0
 #define AR_TXSIFS_TIME         0x000000FF
@@ -1907,6 +1925,16 @@ enum {
 #define AR_TXSIFS_ACK_SHIFT    0x00007000
 #define AR_TXSIFS_ACK_SHIFT_S  12
 
+#define AR_BT_COEX_MODE3			0x81d4
+#define AR_BT_WL_ACTIVE_TIME			0x000000ff
+#define AR_BT_WL_ACTIVE_TIME_S			0
+#define AR_BT_WL_QC_TIME			0x0000ff00
+#define AR_BT_WL_QC_TIME_S			8
+#define AR_BT_ALLOW_CONCURRENT_ACCESS		0x000f0000
+#define AR_BT_ALLOW_CONCURRENT_ACCESS_S		16
+#define AR_BT_AGC_SATURATION_CNT_ENABLE		0x00100000
+#define AR_BT_AGC_SATURATION_CNT_ENABLE_S	20
+
 #define AR_TXOP_X          0x81ec
 #define AR_TXOP_X_VAL      0x000000FF
 
-- 
1.9.1

