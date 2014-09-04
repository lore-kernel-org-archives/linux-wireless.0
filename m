Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33035 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbaIDVES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 17:04:18 -0400
Received: by mail-ob0-f179.google.com with SMTP id uz6so7983667obc.24
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 14:04:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	troy_tan@realsil.com.cn
Subject: [PATCH 7/7 V3.18] rtlwifi: btcoexist: Update remaining old parts of the driver
Date: Thu,  4 Sep 2014 16:03:46 -0500
Message-Id: <1409864626-16373-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140904_230424_239011_DD06005B)
In-Reply-To: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes halbtcoutsrc.{c,h} work with the new pieces of the driver.
Also included are some modifications to various header files.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: troy_tan@realsil.com.cn
---
 .../net/wireless/rtlwifi/btcoexist/halbt_precomp.h |   6 ++
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c  |  16 ++--
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h  | 106 +++++++--------------
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c   |   6 +-
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h   |   4 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c   |   4 +-
 drivers/net/wireless/rtlwifi/wifi.h                |  12 ++-
 7 files changed, 65 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
index d76684e..39b9a33 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
@@ -37,7 +37,13 @@
 
 #include "halbtcoutsrc.h"
 
+#include "halbtc8192e2ant.h"
+#include "halbtc8723b1ant.h"
 #include "halbtc8723b2ant.h"
+#include "halbtc8821a2ant.h"
+#include "halbtc8821a1ant.h"
+
+#define GetDefaultAdapter(padapter)	padapter
 
 #define BIT0	0x00000001
 #define BIT1	0x00000002
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
index 9b9d09a..3119e8b 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -389,7 +389,7 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		btcoexist->bt_info.reject_agg_pkt = *bool_tmp;
 		break;
 	case BTC_SET_BL_BT_CTRL_AGG_SIZE:
-		btcoexist->bt_info.b_bt_ctrl_buf_size = *bool_tmp;
+		btcoexist->bt_info.bt_ctrl_buf_size = *bool_tmp;
 		break;
 	case BTC_SET_BL_INC_SCAN_DEV_NUM:
 		btcoexist->bt_info.increase_scan_dev_num = *bool_tmp;
@@ -417,10 +417,10 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	/*	rtlpriv->mlmepriv.scan_compensation = *u8_tmp;  */
 		break;
 	case BTC_SET_U1_1ANT_LPS:
-		btcoexist->bt_info.lps_1ant = *u8_tmp;
+		btcoexist->bt_info.lps_val = *u8_tmp;
 		break;
 	case BTC_SET_U1_1ANT_RPWM:
-		btcoexist->bt_info.rpwm_1ant = *u8_tmp;
+		btcoexist->bt_info.rpwm_val = *u8_tmp;
 		break;
 	/* the following are some action which will be triggered  */
 	case BTC_SET_ACT_LEAVE_LPS:
@@ -506,7 +506,7 @@ static void halbtc_write_1byte(void *bt_context, u32 reg_addr, u8 data)
 }
 
 static void halbtc_bitmask_write_1byte(void *bt_context, u32 reg_addr,
-				       u32 bit_mask, u8 data)
+				       u8 bit_mask, u8 data)
 {
 	struct btc_coexist *btcoexist = (struct btc_coexist *)bt_context;
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -654,7 +654,7 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 
 	btcoexist->cli_buf = &btc_dbg_buf[0];
 
-	btcoexist->bt_info.b_bt_ctrl_buf_size = false;
+	btcoexist->bt_info.bt_ctrl_buf_size = false;
 	btcoexist->bt_info.agg_buf_size = 5;
 
 	btcoexist->bt_info.increase_scan_dev_num = false;
@@ -786,10 +786,8 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 }
 
 void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
-				 enum _RT_MEDIA_STATUS media_status)
+				 enum rt_media_status media_status)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 status;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -846,8 +844,6 @@ void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 stack_op_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
index e90af4b..eae1937 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -66,10 +66,6 @@
 #define		BTC_ANT_WIFI_AT_CPL_MAIN		0
 #define		BTC_ANT_WIFI_AT_CPL_AUX			1
 
-#define		BTC_ANT_PATH_WIFI			0
-#define		BTC_ANT_PATH_BT				1
-#define		BTC_ANT_PATH_PTA			2
-
 enum btc_chip_interface {
 	BTC_INTF_UNKNOWN	= 0,
 	BTC_INTF_PCI		= 1,
@@ -79,7 +75,7 @@ enum btc_chip_interface {
 	BTC_INTF_MAX
 };
 
-enum BTC_CHIP_TYPE {
+enum btc_chip_type {
 	BTC_CHIP_UNDEF		= 0,
 	BTC_CHIP_CSR_BC4	= 1,
 	BTC_CHIP_CSR_BC8	= 2,
@@ -89,11 +85,12 @@ enum BTC_CHIP_TYPE {
 	BTC_CHIP_MAX
 };
 
-enum BTC_MSG_TYPE {
+enum btc_msg_type {
 	BTC_MSG_INTERFACE	= 0x0,
 	BTC_MSG_ALGORITHM	= 0x1,
 	BTC_MSG_MAX
 };
+
 extern u32 btc_dbg_type[];
 
 /* following is for BTC_MSG_INTERFACE */
@@ -112,20 +109,15 @@ extern u32 btc_dbg_type[];
 #define		ALGO_TRACE_SW_DETAIL			BIT8
 #define		ALGO_TRACE_SW_EXEC			BIT9
 
-#define		BT_COEX_ANT_TYPE_PG			0
-#define		BT_COEX_ANT_TYPE_ANTDIV			1
-#define		BT_COEX_ANT_TYPE_DETECTED		2
-#define		BTC_MIMO_PS_STATIC			0
-#define		BTC_MIMO_PS_DYNAMIC			1
-#define		BTC_RATE_DISABLE			0
-#define		BTC_RATE_ENABLE				1
-#define		BTC_ANT_PATH_WIFI			0
-#define		BTC_ANT_PATH_BT				1
-#define		BTC_ANT_PATH_PTA			2
-
+/* following is for wifi link status */
+#define		WIFI_STA_CONNECTED			BIT0
+#define		WIFI_AP_CONNECTED			BIT1
+#define		WIFI_HS_CONNECTED			BIT2
+#define		WIFI_P2P_GO_CONNECTED			BIT3
+#define		WIFI_P2P_GC_CONNECTED			BIT4
 
 #define	CL_SPRINTF	snprintf
-#define	CL_PRINTF(buf)	printk("%s", buf)
+#define	CL_PRINTF	printk
 
 #define	BTC_PRINT(dbgtype, dbgflag, printstr, ...)		\
 	do {							\
@@ -134,47 +126,6 @@ extern u32 btc_dbg_type[];
 		}						\
 	} while (0)
 
-#define	BTC_PRINT_F(dbgtype, dbgflag, printstr, ...)		\
-	do {							\
-		if (unlikely(btc_dbg_type[dbgtype] & dbgflag)) {\
-			pr_info("%s: ", __func__);	\
-			printk(printstr, ##__VA_ARGS__);	\
-		}						\
-	} while (0)
-
-#define	BTC_PRINT_ADDR(dbgtype, dbgflag, printstr, _ptr)	\
-	do {							\
-		if (unlikely(btc_dbg_type[dbgtype] & dbgflag)) {	\
-			int __i;				\
-			u8 *__ptr = (u8 *)_ptr;			\
-			printk printstr;			\
-			for (__i = 0; __i < 6; __i++)		\
-				printk("%02X%s", __ptr[__i], (__i == 5) ? \
-				       "" : "-");		\
-			pr_info("\n");				\
-		}						\
-	} while (0)
-
-#define BTC_PRINT_DATA(dbgtype, dbgflag, _titlestring, _hexdata, _hexdatalen) \
-	do {								\
-		if (unlikely(btc_dbg_type[dbgtype] & dbgflag))	{	\
-			int __i;					\
-			u8 *__ptr = (u8 *)_hexdata;			\
-			printk(_titlestring);				\
-			for (__i = 0; __i < (int)_hexdatalen; __i++) {	\
-				printk("%02X%s", __ptr[__i], (((__i + 1) % 4) \
-							== 0) ? "  " : " ");\
-				if (((__i + 1) % 16) == 0)		\
-					printk("\n");			\
-			}						\
-			pr_debug("\n");					\
-		}							\
-	} while (0)
-
-#define BTC_ANT_PATH_WIFI	0
-#define BTC_ANT_PATH_BT		1
-#define BTC_ANT_PATH_PTA	2
-
 #define	BTC_RSSI_HIGH(_rssi_)	\
 	((_rssi_ == BTC_RSSI_STATE_HIGH ||	\
 	  _rssi_ == BTC_RSSI_STATE_STAY_HIGH) ? true : false)
@@ -245,7 +196,6 @@ enum btc_wifi_pnp {
 	BTC_WIFI_PNP_MAX
 };
 
-
 enum btc_get_type {
 	/* type bool */
 	BTC_GET_BL_HS_OPERATION,
@@ -274,6 +224,7 @@ enum btc_get_type {
 	BTC_GET_U4_WIFI_BW,
 	BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
 	BTC_GET_U4_WIFI_FW_VER,
+	BTC_GET_U4_WIFI_LINK_STATUS,
 	BTC_GET_U4_BT_PATCH_VER,
 
 	/* type u1Byte */
@@ -292,7 +243,6 @@ enum btc_get_type {
 	BTC_GET_MAX
 };
 
-
 enum btc_set_type {
 	/* type bool */
 	BTC_SET_BL_BT_DISABLE,
@@ -305,7 +255,6 @@ enum btc_set_type {
 
 	/* type u1Byte */
 	BTC_SET_U1_RSSI_ADJ_VAL_FOR_AGC_TABLE_ON,
-	BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE,
 	BTC_SET_UI_SCAN_SIG_COMPENSATION,
 	BTC_SET_U1_AGG_BUF_SIZE,
 
@@ -317,6 +266,9 @@ enum btc_set_type {
 	/* type bool */
 	BTC_SET_BL_BT_SCO_BUSY,
 	/* type u1Byte */
+	BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE,
+	BTC_SET_U1_LPS_VAL,
+	BTC_SET_U1_RPWM_VAL,
 	BTC_SET_U1_1ANT_LPS,
 	BTC_SET_U1_1ANT_RPWM,
 	/* type trigger some action */
@@ -380,6 +332,20 @@ enum btc_notify_type_special_packet {
 	BTC_PACKET_MAX
 };
 
+enum hci_ext_bt_operation {
+	HCI_BT_OP_NONE = 0x0,
+	HCI_BT_OP_INQUIRY_START = 0x1,
+	HCI_BT_OP_INQUIRY_FINISH = 0x2,
+	HCI_BT_OP_PAGING_START = 0x3,
+	HCI_BT_OP_PAGING_SUCCESS = 0x4,
+	HCI_BT_OP_PAGING_UNSUCCESS = 0x5,
+	HCI_BT_OP_PAIRING_START = 0x6,
+	HCI_BT_OP_PAIRING_FINISH = 0x7,
+	HCI_BT_OP_BT_DEV_ENABLE = 0x8,
+	HCI_BT_OP_BT_DEV_DISABLE = 0x9,
+	HCI_BT_OP_MAX
+};
+
 enum btc_notify_type_stack_operation {
 	BTC_STACK_OP_NONE = 0x0,
 	BTC_STACK_OP_INQ_PAGE_PAIR_START = 0x1,
@@ -387,7 +353,6 @@ enum btc_notify_type_stack_operation {
 	BTC_STACK_OP_MAX
 };
 
-
 typedef u8 (*bfp_btc_r1)(void *btc_context, u32 reg_addr);
 
 typedef u16 (*bfp_btc_r2)(void *btc_context, u32 reg_addr);
@@ -397,7 +362,7 @@ typedef u32 (*bfp_btc_r4)(void *btc_context, u32 reg_addr);
 typedef void (*bfp_btc_w1)(void *btc_context, u32 reg_addr, u8 data);
 
 typedef void (*bfp_btc_w1_bit_mak)(void *btc_context, u32 reg_addr,
-				   u32 bit_mask, u8 data1b);
+				   u8 bit_mask, u8 data1b);
 
 typedef void (*bfp_btc_w2)(void *btc_context, u32 reg_addr, u16 data);
 
@@ -435,20 +400,22 @@ struct btc_bt_info {
 	u8 agg_buf_size;
 	bool limited_dig;
 	bool reject_agg_pkt;
-	bool b_bt_ctrl_buf_size;
+	bool bt_ctrl_buf_size;
 	bool increase_scan_dev_num;
 	u16 bt_hci_ver;
 	u16 bt_real_fw_ver;
 	u8 bt_fw_ver;
 
+	bool bt_disable_low_pwr;
+
 	/* the following is for 1Ant solution */
 	bool bt_ctrl_lps;
 	bool bt_pwr_save_mode;
 	bool bt_lps_on;
 	bool force_to_roam;
 	u8 force_exec_pwr_cmd_cnt;
-	u8 lps_1ant;
-	u8 rpwm_1ant;
+	u8 lps_val;
+	u8 rpwm_val;
 	u32 ra_mask;
 };
 
@@ -479,6 +446,7 @@ struct btc_statistics {
 	u32 cnt_special_packet_notify;
 	u32 cnt_bt_info_notify;
 	u32 cnt_periodical;
+	u32 cnt_coex_dm_switch;
 	u32 cnt_stack_operation_notify;
 	u32 cnt_dbg_ctrl;
 };
@@ -531,7 +499,6 @@ struct btc_coexist {
 	bfp_btc_set_bb_reg btc_set_bb_reg;
 	bfp_btc_get_bb_reg btc_get_bb_reg;
 
-
 	bfp_btc_set_rf_reg btc_set_rf_reg;
 	bfp_btc_get_rf_reg btc_get_rf_reg;
 
@@ -555,13 +522,14 @@ void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action);
 void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
-				 enum _RT_MEDIA_STATUS media_status);
+				 enum rt_media_status media_status);
 void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type);
 void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist, u8 *tmp_buf,
 			     u8 length);
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_halt_notify(struct btc_coexist *btcoexist);
 void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
+void exhalbtc_coex_dm_switch(struct btc_coexist *btcoexist);
 void exhalbtc_periodical(struct btc_coexist *btcoexist);
 void exhalbtc_dbg_control(struct btc_coexist *btcoexist, u8 code, u8 len,
 			  u8 *data);
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
index 826b1a6..b9b0cb7 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
@@ -102,7 +102,7 @@ void rtl_btc_connect_notify(struct rtl_priv *rtlpriv, u8 action)
 }
 
 void rtl_btc_mediastatus_notify(struct rtl_priv *rtlpriv,
-				enum _RT_MEDIA_STATUS mstatus)
+				enum rt_media_status mstatus)
 {
 	exhalbtc_mediastatus_notify(&gl_bt_coexist, mstatus);
 }
@@ -187,11 +187,11 @@ u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
 	return num;
 }
 
-enum _RT_MEDIA_STATUS mgnt_link_status_query(struct ieee80211_hw *hw)
+enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	enum _RT_MEDIA_STATUS    m_status = RT_MEDIA_DISCONNECT;
+	enum rt_media_status    m_status = RT_MEDIA_DISCONNECT;
 
 	u8 bibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ? 1 : 0;
 
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
index d5218ce..ccd5a0f 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
@@ -35,7 +35,7 @@ void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type);
 void rtl_btc_scan_notify(struct rtl_priv *rtlpriv, u8 scantype);
 void rtl_btc_connect_notify(struct rtl_priv *rtlpriv, u8 action);
 void rtl_btc_mediastatus_notify(struct rtl_priv *rtlpriv,
-				enum _RT_MEDIA_STATUS mstatus);
+				enum rt_media_status mstatus);
 void rtl_btc_periodical(struct rtl_priv *rtlpriv);
 void rtl_btc_halt_notify(void);
 void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmpbuf, u8 length);
@@ -49,6 +49,6 @@ struct rtl_btc_ops *rtl_btc_get_ops_pointer(void);
 u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_exist(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv);
-enum _RT_MEDIA_STATUS mgnt_link_status_query(struct ieee80211_hw *hw);
+enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
index 5d534df..f76c50f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
@@ -56,11 +56,11 @@ void rtl8723ae_bt_coex_off_before_lps(struct ieee80211_hw *hw)
 	}
 }
 
-static enum _RT_MEDIA_STATUS mgnt_link_status_query(struct ieee80211_hw *hw)
+static enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	enum _RT_MEDIA_STATUS m_status = RT_MEDIA_DISCONNECT;
+	enum rt_media_status m_status = RT_MEDIA_DISCONNECT;
 
 	u8 bibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ? 1 : 0;
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index e44e2df..541b077 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -170,6 +170,11 @@ enum rf_tx_num {
 	RF_TX_NUM_NONIMPLEMENT,
 };
 
+#define PACKET_NORMAL			0
+#define PACKET_DHCP			1
+#define PACKET_ARP			2
+#define PACKET_EAPOL			3
+
 struct txpower_info_2g {
 	u8 index_cck_base[MAX_RF_PATH][MAX_CHNL_GROUP_24G];
 	u8 index_bw40_base[MAX_RF_PATH][MAX_CHNL_GROUP_24G];
@@ -234,8 +239,9 @@ enum hardware_type {
 	HARDWARE_TYPE_RTL8192DU,
 	HARDWARE_TYPE_RTL8723AE,
 	HARDWARE_TYPE_RTL8723U,
-	HARDWARE_TYPE_RTL8723BE,
 	HARDWARE_TYPE_RTL8188EE,
+	HARDWARE_TYPE_RTL8723BE,
+	HARDWARE_TYPE_RTL8192EE,
 	HARDWARE_TYPE_RTL8821AE,
 	HARDWARE_TYPE_RTL8812AE,
 
@@ -428,7 +434,7 @@ enum hw_variables {
 	HW_VAR_DATA_FILTER,
 };
 
-enum _RT_MEDIA_STATUS {
+enum rt_media_status {
 	RT_MEDIA_DISCONNECT = 0,
 	RT_MEDIA_CONNECT = 1
 };
@@ -2316,7 +2322,7 @@ struct rtl_btc_ops {
 	void (*btc_scan_notify) (struct rtl_priv *rtlpriv, u8 scantype);
 	void (*btc_connect_notify) (struct rtl_priv *rtlpriv, u8 action);
 	void (*btc_mediastatus_notify) (struct rtl_priv *rtlpriv,
-					enum _RT_MEDIA_STATUS mstatus);
+					enum rt_media_status mstatus);
 	void (*btc_periodical) (struct rtl_priv *rtlpriv);
 	void (*btc_halt_notify) (void);
 	void (*btc_btinfo_notify) (struct rtl_priv *rtlpriv,
-- 
1.8.4.5

