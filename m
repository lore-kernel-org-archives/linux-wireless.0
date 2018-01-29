Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:57304 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeA2D1B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:27:01 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 03/10] rtlwifi: Use 6 bits as sequence number of TX report
Date: Mon, 29 Jan 2018 11:26:34 +0800
Message-ID: <20180129032641.17841-4-pkshih@realtek.com> (sfid-20180129_042721_921990_7692E0AC)
In-Reply-To: <20180129032641.17841-1-pkshih@realtek.com>
References: <20180129032641.17841-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In new design, SW_DEFINE[1:0] of tx desc are used by firmware, and the TX
report only contains SW_DEFINE[7:0]. To satisfy with all cases, driver uses
SW_DEFINE[7:2] as sequence number.
Besides, the format of tx report have been changed, so a new flag
RTL_SPEC_EXT_C2H is used to access report.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 22 ++++++++++++++++++----
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  8 ++++++++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index a2da057d3cdd..92f99a303920 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1597,7 +1597,11 @@ static u16 rtl_get_tx_report_sn(struct ieee80211_hw *hw)
 	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
 	u16 sn;
 
-	sn = atomic_inc_return(&tx_report->sn) & 0x0FFF;
+	/* SW_DEFINE[11:8] are reserved (driver fills zeros)
+	 * SW_DEFINE[7:2] are used by driver
+	 * SW_DEFINE[1:0] are reserved for firmware (driver fills zeros)
+	 */
+	sn = (atomic_inc_return(&tx_report->sn) & 0x003F) << 2;
 
 	tx_report->last_sent_sn = sn;
 	tx_report->last_sent_time = jiffies;
@@ -1625,14 +1629,23 @@ void rtl_tx_report_handler(struct ieee80211_hw *hw, u8 *tmp_buf, u8 c2h_cmd_len)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
 	u16 sn;
+	u8 st, retry;
 
-	sn = ((tmp_buf[7] & 0x0F) << 8) | tmp_buf[6];
+	if (rtlpriv->cfg->spec_ver & RTL_SPEC_EXT_C2H) {
+		sn = GET_TX_REPORT_SN_V2(tmp_buf);
+		st = GET_TX_REPORT_ST_V2(tmp_buf);
+		retry = GET_TX_REPORT_RETRY_V2(tmp_buf);
+	} else {
+		sn = GET_TX_REPORT_SN_V1(tmp_buf);
+		st = GET_TX_REPORT_ST_V1(tmp_buf);
+		retry = GET_TX_REPORT_RETRY_V1(tmp_buf);
+	}
 
 	tx_report->last_recv_sn = sn;
 
 	RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_DMESG,
 		 "Recv TX-Report st=0x%02X sn=0x%X retry=0x%X\n",
-		 tmp_buf[0], sn, tmp_buf[2]);
+		 st, sn, retry);
 }
 EXPORT_SYMBOL_GPL(rtl_tx_report_handler);
 
@@ -1646,7 +1659,8 @@ bool rtl_check_tx_report_acked(struct ieee80211_hw *hw)
 
 	if (time_before(tx_report->last_sent_time + 3 * HZ, jiffies)) {
 		RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_WARNING,
-			 "Check TX-Report timeout!!\n");
+			 "Check TX-Report timeout!! s_sn=0x%X r_sn=0x%X\n",
+			 tx_report->last_sent_sn, tx_report->last_recv_sn);
 		return true;	/* 3 sec. (timeout) seen as acked */
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 2df0bc316532..be45420f34d3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -153,6 +153,13 @@ enum rtl8192c_h2c_cmd {
 	MAX_H2CCMD
 };
 
+#define GET_TX_REPORT_SN_V1(c2h)	(c2h[6])
+#define GET_TX_REPORT_ST_V1(c2h)	(c2h[0] & 0xC0)
+#define GET_TX_REPORT_RETRY_V1(c2h)	(c2h[2] & 0x3F)
+#define GET_TX_REPORT_SN_V2(c2h)	(c2h[6])
+#define GET_TX_REPORT_ST_V2(c2h)	(c2h[7] & 0xC0)
+#define GET_TX_REPORT_RETRY_V2(c2h)	(c2h[8] & 0x3F)
+
 #define MAX_TX_COUNT			4
 #define MAX_REGULATION_NUM		4
 #define MAX_RF_PATH_NUM			4
@@ -952,6 +959,7 @@ enum package_type {
 enum rtl_spec_ver {
 	RTL_SPEC_NEW_RATEID = BIT(0),	/* use ratr_table_mode_new */
 	RTL_SPEC_SUPPORT_VHT = BIT(1),	/* support VHT */
+	RTL_SPEC_EXT_C2H = BIT(2),	/* extend FW C2H (e.g. TX REPORT) */
 };
 
 struct octet_string {
-- 
2.15.1
