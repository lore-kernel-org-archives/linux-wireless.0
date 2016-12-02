Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32947 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754943AbcLBBsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:52 -0500
Received: by mail-oi0-f66.google.com with SMTP id f201so25534816oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:51 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 05/14] rtlwifi: Add TX report and disable key will wait until report acked.
Date: Thu,  1 Dec 2016 19:48:24 -0600
Message-Id: <20161202014833.6856-6-Larry.Finger@lwfinger.net> (sfid-20161202_025212_614254_D0FC4E9C)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

When using EAPOL to do a PTK rekey, there is a possible race condition.
When msg 3/4 is received, the supplicant will send msg 4/4 and install
the new key immediately; however, the driver must make sure that msg 4/4
is sent before installing the new key. We use TX report to ensure it is
sent.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c        | 117 ++++++++++++++++++---
 drivers/net/wireless/realtek/rtlwifi/base.h        |   7 ++
 drivers/net/wireless/realtek/rtlwifi/core.c        |   2 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   2 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |   8 ++
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   8 ++
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |  12 +++
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |   8 ++
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |  13 +++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  10 ++
 14 files changed, 180 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index fa2d26a..edab6ec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1107,6 +1107,9 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 	if (txrate)
 		tcb_desc->hw_rate = txrate->hw_value;
 
+	if (rtl_is_tx_report_skb(hw, skb))
+		tcb_desc->use_spe_rpt = 1;
+
 	if (ieee80211_is_data(fc)) {
 		/*
 		 *we set data rate INX 0
@@ -1315,21 +1318,13 @@ static void setup_arp_tx(struct rtl_priv *rtlpriv, struct rtl_ps_ctl *ppsc)
 	ppsc->last_delaylps_stamp_jiffies = jiffies;
 }
 
-/*should call before software enc*/
-u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
-		       bool is_enc)
+static const u8 *rtl_skb_ether_type_ptr(struct ieee80211_hw *hw,
+					struct sk_buff *skb, bool is_enc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	__le16 fc = rtl_get_fc(skb);
-	u16 ether_type;
 	u8 mac_hdr_len = ieee80211_get_hdrlen_from_skb(skb);
 	u8 encrypt_header_len = 0;
 	u8 offset;
-	const struct iphdr *ip;
-
-	if (!ieee80211_is_data(fc))
-		goto end;
 
 	switch (rtlpriv->sec.pairwise_enc_algorithm) {
 	case WEP40_ENCRYPTION:
@@ -1349,10 +1344,29 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 	offset = mac_hdr_len + SNAP_SIZE;
 	if (is_enc)
 		offset += encrypt_header_len;
-	ether_type = be16_to_cpup((__be16 *)(skb->data + offset));
+
+	return skb->data + offset;
+}
+
+/*should call before software enc*/
+u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
+		       bool is_enc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	__le16 fc = rtl_get_fc(skb);
+	u16 ether_type;
+	const u8 *ether_type_ptr;
+	const struct iphdr *ip;
+
+	if (!ieee80211_is_data(fc))
+		goto end;
+
+	ether_type_ptr = rtl_skb_ether_type_ptr(hw, skb, is_enc);
+	ether_type = be16_to_cpup((__be16 *)ether_type_ptr);
 
 	if (ETH_P_IP == ether_type) {
-		ip = (struct iphdr *)((u8 *)skb->data + offset +
+		ip = (struct iphdr *)((u8 *)ether_type_ptr +
 		     PROTOC_TYPE_SIZE);
 		if (IPPROTO_UDP == ip->protocol) {
 			struct udphdr *udp = (struct udphdr *)((u8 *)ip +
@@ -1402,6 +1416,85 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 }
 EXPORT_SYMBOL_GPL(rtl_is_special_data);
 
+bool rtl_is_tx_report_skb(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	u16 ether_type;
+	const u8 *ether_type_ptr;
+
+	ether_type_ptr = rtl_skb_ether_type_ptr(hw, skb, true);
+	ether_type = be16_to_cpup((__be16 *)ether_type_ptr);
+
+	/* EAPOL */
+	if (ether_type == ETH_P_PAE)
+		return true;
+
+	return false;
+}
+
+u16 rtl_get_tx_report_sn(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
+	u16 sn;
+
+	sn = atomic_inc_return(&tx_report->sn) & 0x0FFF;
+
+	tx_report->last_sent_sn = sn;
+	tx_report->last_sent_time = jiffies;
+
+	RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_DMESG,
+		 "Send TX-Report sn=0x%X\n", sn);
+
+	return sn;
+}
+EXPORT_SYMBOL_GPL(rtl_get_tx_report_sn);
+
+void rtl_tx_report_handler(struct ieee80211_hw *hw, u8 *tmp_buf, u8 c2h_cmd_len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
+	u16 sn;
+
+	sn = ((tmp_buf[7] & 0x0F) << 8) | tmp_buf[6];
+
+	tx_report->last_recv_sn = sn;
+
+	RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_DMESG,
+		 "Recv TX-Report st=0x%02X sn=0x%X retry=0x%X\n",
+		 tmp_buf[0], sn, tmp_buf[2]);
+}
+EXPORT_SYMBOL_GPL(rtl_tx_report_handler);
+
+bool rtl_check_tx_report_acked(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tx_report *tx_report = &rtlpriv->tx_report;
+
+	if (tx_report->last_sent_sn == tx_report->last_recv_sn)
+		return true;
+
+	if (time_before(tx_report->last_sent_time + 3 * HZ, jiffies)) {
+		RT_TRACE(rtlpriv, COMP_TX_REPORT, DBG_WARNING,
+			 "Check TX-Report timeout!!\n");
+		return true;	/* 3 sec. (timeout) seen as acked */
+	}
+
+	return false;
+}
+
+void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int i;
+
+	for (i = 0; i < wait_ms; i++) {
+		if (rtl_check_tx_report_acked(hw))
+			break;
+		usleep_range(1000, 2000);
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			 "Wait 1ms (%d/%d) to disable key.\n", i, wait_ms);
+	}
+}
 /*********************************************************
  *
  * functions called by core.c
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 74233d6..05a69f7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -123,6 +123,13 @@ bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 		       bool is_enc);
 
+bool rtl_is_tx_report_skb(struct ieee80211_hw *hw, struct sk_buff *skb);
+u16 rtl_get_tx_report_sn(struct ieee80211_hw *hw);
+void rtl_tx_report_handler(struct ieee80211_hw *hw, u8 *tmp_buf,
+			   u8 c2h_cmd_len);
+bool rtl_check_tx_report_acked(struct ieee80211_hw *hw);
+void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms);
+
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ieee80211_sta *sta, u16 tid, u16 *ssn);
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 35b620a..81e17fc1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1675,6 +1675,8 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 *so don't use rtl_cam_reset_all_entry
 		 *or clear all entry here.
 		 */
+		rtl_wait_tx_report_acked(hw, 500); /* wait 500ms for TX ack */
+
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
 		break;
 	default:
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 3e75ebc..d930f8c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -39,7 +39,7 @@ void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 	    COMP_RF | COMP_TURBO | COMP_RATR | COMP_CMD |
 	    COMP_EFUSE | COMP_QOS | COMP_MAC80211 | COMP_REGD | COMP_CHAN |
 	    COMP_EASY_CONCURRENT | COMP_EFUSE | COMP_QOS | COMP_MAC80211 |
-	    COMP_REGD | COMP_CHAN | COMP_BT_COEXIST;
+	    COMP_REGD | COMP_CHAN | COMP_BT_COEXIST | COMP_TX_REPORT;
 
 
 	for (i = 0; i < DBGP_TYPE_MAX; i++)
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 773864e..0886b85 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -105,6 +105,7 @@
 #define COMP_EASY_CONCURRENT	COMP_USB /* reuse of this bit is OK */
 #define COMP_BT_COEXIST			BIT(30)
 #define COMP_IQK			BIT(31)
+#define COMP_TX_REPORT			BIT_ULL(32)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index a4aa239..60f5859 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -859,6 +859,7 @@ static void _rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
 	case C2H_8192E_TX_REPORT:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE ,
 			 "[C2H], C2H_8723BE_TX_REPORT!\n");
+		rtl_tx_report_handler(hw, tmp_buf, c2h_cmd_len);
 		break;
 	case C2H_8192E_BT_INFO:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 2d48ccd..0f9d9f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -731,6 +731,14 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 		}
 
+		/* tx report */
+		if (ptcb_desc->use_spe_rpt) {
+			u16 sn = rtl_get_tx_report_sn(hw);
+
+			SET_TX_DESC_SPE_RPT(pdesc, 1);
+			SET_TX_DESC_SW_DEFINE(pdesc, sn);
+		}
+
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 
 		if (ieee80211_is_mgmt(fc)) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index 8c5c27c..577bb92 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -600,6 +600,7 @@ static void _rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw,
 	case C2H_8723B_TX_REPORT:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "[C2H], C2H_8723BE_TX_REPORT!\n");
+		rtl_tx_report_handler(hw, tmp_buf, c2h_cmd_len);
 		break;
 	case C2H_8723B_BT_INFO:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 2175aec..6fc5c10 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -488,6 +488,14 @@ void rtl8723be_tx_fill_desc(struct ieee80211_hw *hw,
 			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 		}
 
+		/* tx report */
+		if (ptcb_desc->use_spe_rpt) {
+			u16 sn = rtl_get_tx_report_sn(hw);
+
+			SET_TX_DESC_SPE_RPT(pdesc, 1);
+			SET_TX_DESC_SW_DEFINE(pdesc, sn);
+		}
+
 		/* ptcb_desc->use_driver_rate = true; */
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 		if (ptcb_desc->hw_rate > DESC92C_RATEMCS0)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.h
index 8a9fe41..78aba34 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.h
@@ -187,6 +187,18 @@
 #define SET_TX_DESC_RTS_SC(__pdesc, __val)		\
 	SET_BITS_TO_LE_4BYTE(__pdesc+20, 13, 4, __val)
 
+#define SET_TX_DESC_SW_DEFINE(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 0, 12, __val)
+#define SET_TX_DESC_MBSSID(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 12, 4, __val)
+#define SET_TX_DESC_ANTSEL_A(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 16, 3, __val)
+#define SET_TX_DESC_ANTSEL_B(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 19, 3, __val)
+#define SET_TX_DESC_ANTSEL_C(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 22, 3, __val)
+#define SET_TX_DESC_ANTSEL_D(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 25, 3, __val)
 
 #define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
 	SET_BITS_TO_LE_4BYTE(__pdesc+28, 0, 16, __val)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 2f598dd..3135243 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1819,6 +1819,9 @@ static void _rtl8821ae_c2h_content_parsing(struct ieee80211_hw *hw,
 	case C2H_8812_DBG:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "[C2H], C2H_8812_DBG!!\n");
 		break;
+	case C2H_8812_TX_REPORT:
+		rtl_tx_report_handler(hw, tmp_buf, c2h_cmd_len);
+		break;
 	case C2H_8812_RA_RPT:
 		rtl8821ae_c2h_ra_report_handler(hw, tmp_buf, c2h_cmd_len);
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 2772718..b0d6bef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -740,6 +740,14 @@ void rtl8821ae_tx_fill_desc(struct ieee80211_hw *hw,
 			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 		}
 
+		/* tx report */
+		if (ptcb_desc->use_spe_rpt) {
+			u16 sn = rtl_get_tx_report_sn(hw);
+
+			SET_TX_DESC_SPE_RPT(pdesc, 1);
+			SET_TX_DESC_SW_DEFINE(pdesc, sn);
+		}
+
 		/* ptcb_desc->use_driver_rate = true; */
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 		if (ptcb_desc->hw_rate > DESC_RATEMCS0)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
index b6f3c56..58bd76e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
@@ -185,6 +185,19 @@
 #define SET_TX_DESC_RTS_SC(__pdesc, __val)	\
 	SET_BITS_TO_LE_4BYTE(__pdesc+20, 13, 4, __val)
 
+#define SET_TX_DESC_SW_DEFINE(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 0, 12, __val)
+#define SET_TX_DESC_ANTSEL_A(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 16, 3, __val)
+#define SET_TX_DESC_ANTSEL_B(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 19, 3, __val)
+#define SET_TX_DESC_ANTSEL_C(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 22, 3, __val)
+#define SET_TX_DESC_ANTSEL_D(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 25, 3, __val)
+#define SET_TX_DESC_MBSSID(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 12, 4, __val)
+
 #define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
 	SET_BITS_TO_LE_4BYTE(__pdesc+28, 0, 16, __val)
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index dafe486..80e6f5e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1873,6 +1873,13 @@ struct rtl_efuse {
 	u8 channel_plan;
 };
 
+struct rtl_tx_report {
+	atomic_t sn;
+	u16 last_sent_sn;
+	unsigned long last_sent_time;
+	u16 last_recv_sn;
+};
+
 struct rtl_ps_ctl {
 	bool pwrdomain_protect;
 	bool in_powersavemode;
@@ -2062,6 +2069,8 @@ struct rtl_tcb_desc {
 	u8 use_driver_rate:1;
 	u8 disable_ratefallback:1;
 
+	u8 use_spe_rpt:1;
+
 	u8 ratr_index;
 	u8 mac_id;
 	u8 hw_rate;
@@ -2570,6 +2579,7 @@ struct rtl_priv {
 	struct rtl_dm dm;
 	struct rtl_security sec;
 	struct rtl_efuse efuse;
+	struct rtl_tx_report tx_report;
 
 	struct rtl_ps_ctl psc;
 	struct rate_adaptive ra;
-- 
2.10.2
