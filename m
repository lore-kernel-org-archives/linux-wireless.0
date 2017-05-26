Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35488 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948595AbdEZSl5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 14:41:57 -0400
Received: by mail-oi0-f65.google.com with SMTP id v80so2985731oie.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 11:41:56 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>, lkp@intel.com
Subject: [PATCH v2 1/7] rtlwifi: btcoex: update new btcoex version
Date: Fri, 26 May 2017 13:41:41 -0500
Message-Id: <20170526184147.31239-2-Larry.Finger@lwfinger.net> (sfid-20170526_204332_352127_CF27014A)
In-Reply-To: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
References: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

This patch updates the btcoexist to a newer version with some callbacks.

Specific issues fixed are
pre_load_firmware()
	fix the unstable issues before FW is ready
power_on_seting()
	fix the unstable issues before HW is ready
Some notify finctions, check hardware type and call corresponding
functions to specific chip

As noted by the kbuild test robot <lkp@intel.com>, there was a missing
global. This problem has been fixed.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
Cc: lkp@intel.com
---
v2 - Fix missing global as reported by the kbuild test robot.
---
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  22 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  32 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  52 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  41 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  38 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  26 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 838 ++++++++++++++++-----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  42 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  35 +-
 11 files changed, 814 insertions(+), 317 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 39b9a3309cfd..2ac989a4b2bb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -37,6 +37,28 @@
 
 #include "halbtcoutsrc.h"
 
+/* Interface type */
+#define RT_PCI_INTERFACE	1
+#define RT_USB_INTERFACE	2
+#define RT_SDIO_INTERFACE	3
+#define DEV_BUS_TYPE		RT_PCI_INTERFACE
+
+/* IC type */
+#define RTL_HW_TYPE(adapter)	(rtl_hal((struct rtl_priv *)adapter)->hw_type)
+
+#define IS_NEW_GENERATION_IC(adapter)		\
+			(RTL_HW_TYPE(adapter) >= HARDWARE_TYPE_RTL8192EE)
+#define IS_HARDWARE_TYPE_8812(adapter)		\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8812AE)
+#define IS_HARDWARE_TYPE_8821(adapter)		\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8821AE)
+#define IS_HARDWARE_TYPE_8723A(adapter)	\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8723AE)
+#define IS_HARDWARE_TYPE_8723B(adapter)	\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8723BE)
+#define IS_HARDWARE_TYPE_8192E(adapter)	\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8192EE)
+
 #include "halbtc8192e2ant.h"
 #include "halbtc8723b1ant.h"
 #include "halbtc8723b2ant.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 9015512ed647..44c25724529e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -3194,7 +3194,7 @@ void ex_btc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	btc8192e2ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
+void ex_btc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
index a57d6947eaf7..65502acee52c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
@@ -164,20 +164,20 @@ struct coex_sta_8192e_2ant {
 /****************************************************************
  *    The following is interface which will notify coex module.
  ****************************************************************/
-void ex_halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist);
-void ex_halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist);
-void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
+void ex_btc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist);
+void ex_btc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist);
+void ex_btc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type);
+void ex_btc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type);
+void ex_btc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmpbuf, u8 length);
+void ex_btc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
 					    u8 type);
-void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type);
-void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length);
-void ex_halbtc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
-					       u8 type);
-void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist);
-void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist);
-void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8192e2ant_halt_notify(struct btc_coexist *btcoexist);
+void ex_btc8192e2ant_periodical(struct btc_coexist *btcoexist);
+void ex_btc8192e2ant_display_coex_info(struct btc_coexist *btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index a0f3a18add25..03998d2e9eb8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2390,9 +2390,9 @@ static void halbtc8723b1ant_init_hw_config(struct btc_coexist *btcoexist,
 }
 
 /**************************************************************
- * extern function start with ex_halbtc8723b1ant_
+ * extern function start with ex_btc8723b1ant_
  **************************************************************/
-void ex_halbtc8723b1ant_power_on_setting(struct btc_coexist *btcoexist)
+void ex_btc8723b1ant_power_on_setting(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_board_info *board_info = &btcoexist->board_info;
@@ -2462,14 +2462,14 @@ void ex_halbtc8723b1ant_power_on_setting(struct btc_coexist *btcoexist)
 }
 
 
-void ex_halbtc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist,
-				      bool wifi_only)
+void ex_btc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist,
+				   bool wifi_only)
 {
 	halbtc8723b1ant_init_hw_config(btcoexist, true, wifi_only);
 	btcoexist->stop_coex_dm = false;
 }
 
-void ex_halbtc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist)
+void ex_btc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2483,7 +2483,7 @@ void ex_halbtc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist)
 	halbtc8723b1ant_query_bt_info(btcoexist);
 }
 
-void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
+void ex_btc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -2758,7 +2758,7 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
-void ex_halbtc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2787,7 +2787,7 @@ void ex_halbtc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2805,7 +2805,7 @@ void ex_halbtc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
@@ -2891,7 +2891,7 @@ void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
@@ -2961,8 +2961,8 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
-					    u8 type)
+void ex_btc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
@@ -3042,8 +3042,8 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type)
+void ex_btc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool bt_hs_on = false;
@@ -3119,8 +3119,8 @@ void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	}
 }
 
-void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmp_buf, u8 length)
+void ex_btc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 bt_info = 0;
@@ -3211,11 +3211,11 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected)
-				ex_halbtc8723b1ant_media_status_notify(btcoexist,
-							     BTC_MEDIA_CONNECT);
+				ex_btc8723b1ant_media_status_notify(btcoexist,
+						BTC_MEDIA_CONNECT);
 			else
-				ex_halbtc8723b1ant_media_status_notify(btcoexist,
-							  BTC_MEDIA_DISCONNECT);
+				ex_btc8723b1ant_media_status_notify(btcoexist,
+						BTC_MEDIA_DISCONNECT);
 		}
 
 		if (coex_sta->bt_info_ext & BIT3) {
@@ -3364,7 +3364,7 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	halbtc8723b1ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u32 u32tmp;
@@ -3401,7 +3401,7 @@ void ex_halbtc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
+void ex_btc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -3418,12 +3418,12 @@ void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
 					 0x0, 0x0);
 	halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
 
-	ex_halbtc8723b1ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
+	ex_btc8723b1ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 
 	btcoexist->stop_coex_dm = true;
 }
 
-void ex_halbtc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
+void ex_btc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -3458,7 +3458,7 @@ void ex_halbtc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 	}
 }
 
-void ex_halbtc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist)
+void ex_btc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -3469,7 +3469,7 @@ void ex_halbtc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist)
 	halbtc8723b1ant_init_coex_dm(btcoexist);
 }
 
-void ex_halbtc8723b1ant_periodical(struct btc_coexist *btcoexist)
+void ex_btc8723b1ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 506961a1ca56..8d4fde235e11 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -200,24 +200,25 @@ struct coex_sta_8723b_1ant {
 /*************************************************************************
  * The following is interface which will notify coex module.
  *************************************************************************/
-void ex_halbtc8723b1ant_power_on_setting(struct btc_coexist *btcoexist);
-void ex_halbtc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist,
-				      bool wifi_only);
-void ex_halbtc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist);
-void ex_halbtc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
-					    u8 type);
-void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type);
-void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length);
-void ex_halbtc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist,
+void ex_btc8723b1ant_power_on_setting(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist,
+				   bool wifi_only);
+void ex_btc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type);
-void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist);
-void ex_halbtc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnpstate);
-void ex_halbtc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist);
-void ex_halbtc8723b1ant_periodical(struct btc_coexist *btcoexist);
-void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type);
+void ex_btc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmpbuf, u8 length);
+void ex_btc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist,
+				      u8 type);
+void ex_btc8723b1ant_halt_notify(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnpstate);
+void ex_btc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_periodical(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 50726beaeead..bc1e3042e271 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -196,5 +196,8 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist);
 void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
+void ex_btc8723b2ant_pre_load_firmware(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_power_on_setting(struct btc_coexist *btcoexist);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index cb32e7a64ae6..b0a6626fbb66 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -170,21 +170,23 @@ struct coex_sta_8821a_1ant {
  * The following is interface which will notify coex module.
  *===========================================
  */
-void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
-					    u8 type);
-void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type);
-void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length);
-void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnpstate);
-void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_dbg_control(struct btc_coexist *btcoexist, u8 op_code,
-				    u8 op_len, u8 *data);
+void ex_btc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist,
+				   bool wifi_only);
+void ex_btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist);
+void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type);
+void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type);
+void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmpbuf, u8 length);
+void ex_btc8821a1ant_halt_notify(struct btc_coexist *btcoexist);
+void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnpstate);
+void ex_btc8821a1ant_periodical(struct btc_coexist *btcoexist);
+void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8821a1ant_dbg_control(struct btc_coexist *btcoexist, u8 op_code,
+				 u8 op_len, u8 *data);
+void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index a1603e2d44e3..a839d5574422 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -173,58 +173,60 @@ struct coex_sta_8821a_2ant {
  *===========================================
  */
 void
-ex_halbtc8821a2ant_init_hwconfig(
+ex_btc8821a2ant_init_hwconfig(
 	struct btc_coexist *btcoexist
 	);
 void
-ex_halbtc8821a2ant_init_coex_dm(
+ex_btc8821a2ant_init_coex_dm(
 	struct btc_coexist *btcoexist
 	);
 void
-ex_halbtc8821a2ant_ips_notify(
+ex_btc8821a2ant_ips_notify(
 	struct btc_coexist *btcoexist,
 	u8 type
 	);
 void
-ex_halbtc8821a2ant_lps_notify(
+ex_btc8821a2ant_lps_notify(
 	struct btc_coexist *btcoexist,
 	u8 type
 	);
 void
-ex_halbtc8821a2ant_scan_notify(
+ex_btc8821a2ant_scan_notify(
 	struct btc_coexist *btcoexist,
 	u8 type
 	);
 void
-ex_halbtc8821a2ant_connect_notify(
+ex_btc8821a2ant_connect_notify(
 	struct btc_coexist *btcoexist,
 	u8 type
 	);
 void
-ex_halbtc8821a2ant_media_status_notify(
+ex_btc8821a2ant_media_status_notify(
 	struct btc_coexist *btcoexist,
 	u8 type
 	);
 void
-ex_halbtc8821a2ant_special_packet_notify(
+ex_btc8821a2ant_special_packet_notify(
 	struct btc_coexist *btcoexist,
 	u8 type
 	);
 void
-ex_halbtc8821a2ant_bt_info_notify(
+ex_btc8821a2ant_bt_info_notify(
 	struct btc_coexist *btcoexist,
 	u8 *tmp_buf,
 	u8 length
 	);
 void
-ex_halbtc8821a2ant_halt_notify(
+ex_btc8821a2ant_halt_notify(
 	struct btc_coexist *btcoexist
 	);
 void
-ex_halbtc8821a2ant_periodical(
+ex_btc8821a2ant_periodical(
 	struct btc_coexist *btcoexist
 	);
 void
-ex_halbtc8821a2ant_display_coex_info(
+ex_btc8821a2ant_display_coex_info(
 	struct btc_coexist *btcoexist
 	);
+void ex_btc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
+void ex_btc8821a2ant_pre_load_firmware(struct btc_coexist *btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index f13000612913..f00d6e6ab69b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -36,6 +36,20 @@ u32 btc_dbg_type[BTC_MSG_MAX];
 /***************************************************
  *		Debug related function
  ***************************************************/
+
+const char *const gl_btc_wifi_bw_string[] = {
+	"11bg",
+	"HT20",
+	"HT40",
+	"HT80",
+	"HT160"
+};
+
+const char *const gl_btc_wifi_freq_string[] = {
+	"2.4G",
+	"5G"
+};
+
 static bool halbtc_is_bt_coexist_available(struct btc_coexist *btcoexist)
 {
 	if (!btcoexist->binded || NULL == btcoexist->adapter)
@@ -54,28 +68,39 @@ static bool halbtc_is_wifi_busy(struct rtl_priv *rtlpriv)
 
 static void halbtc_dbg_init(void)
 {
-	u8 i;
-
-	for (i = 0; i < BTC_MSG_MAX; i++)
-		btc_dbg_type[i] = 0;
-
-	btc_dbg_type[BTC_MSG_INTERFACE] =
-/*			INTF_INIT				| */
-/*			INTF_NOTIFY				| */
-			0;
+}
 
-	btc_dbg_type[BTC_MSG_ALGORITHM] =
-/*			ALGO_BT_RSSI_STATE			| */
-/*			ALGO_WIFI_RSSI_STATE			| */
-/*			ALGO_BT_MONITOR				| */
-/*			ALGO_TRACE				| */
-/*			ALGO_TRACE_FW				| */
-/*			ALGO_TRACE_FW_DETAIL			| */
-/*			ALGO_TRACE_FW_EXEC			| */
-/*			ALGO_TRACE_SW				| */
-/*			ALGO_TRACE_SW_DETAIL			| */
-/*			ALGO_TRACE_SW_EXEC			| */
-			0;
+/***************************************************
+ *		helper function
+ ***************************************************/
+static bool is_any_client_connect_to_ap(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rtl_mac *mac = rtl_mac(rtlpriv);
+	struct rtl_sta_info *drv_priv;
+	u8 cnt = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_ADHOC ||
+	    mac->opmode == NL80211_IFTYPE_MESH_POINT ||
+	    mac->opmode == NL80211_IFTYPE_AP) {
+		if (in_interrupt() > 0) {
+			list_for_each_entry(drv_priv, &rtlpriv->entry_list,
+					    list) {
+				cnt++;
+			}
+		} else {
+			spin_lock_bh(&rtlpriv->locks.entry_list_lock);
+			list_for_each_entry(drv_priv, &rtlpriv->entry_list,
+					    list) {
+				cnt++;
+			}
+			spin_unlock_bh(&rtlpriv->locks.entry_list_lock);
+		}
+	}
+	if (cnt > 0)
+		return true;
+	else
+		return false;
 }
 
 static bool halbtc_is_bt40(struct rtl_priv *adapter)
@@ -188,12 +213,14 @@ static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 			   &ap_enable);
 
 	if (ap_enable) {
-		pr_info("halbtc_leave_lps()<--dont leave lps under AP mode\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
+			 "%s()<--dont leave lps under AP mode\n", __func__);
 		return;
 	}
 
 	btcoexist->bt_info.bt_ctrl_lps = true;
 	btcoexist->bt_info.bt_lps_on = false;
+	rtl_lps_leave(rtlpriv->mac80211.hw);
 }
 
 static void halbtc_enter_lps(struct btc_coexist *btcoexist)
@@ -209,12 +236,14 @@ static void halbtc_enter_lps(struct btc_coexist *btcoexist)
 			   &ap_enable);
 
 	if (ap_enable) {
-		pr_info("halbtc_enter_lps()<--dont enter lps under AP mode\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
+			 "%s()<--dont enter lps under AP mode\n", __func__);
 		return;
 	}
 
 	btcoexist->bt_info.bt_ctrl_lps = true;
 	btcoexist->bt_info.bt_lps_on = false;
+	rtl_lps_enter(rtlpriv->mac80211.hw);
 }
 
 static void halbtc_normal_lps(struct btc_coexist *btcoexist)
@@ -225,20 +254,58 @@ static void halbtc_normal_lps(struct btc_coexist *btcoexist)
 	}
 }
 
-static void halbtc_leave_low_power(void)
+static void halbtc_leave_low_power(struct btc_coexist *btcoexist)
 {
 }
 
-static void halbtc_nomal_low_power(void)
+static void halbtc_normal_low_power(struct btc_coexist *btcoexist)
 {
 }
 
-static void halbtc_disable_low_power(void)
+static void halbtc_disable_low_power(struct btc_coexist *btcoexist,
+				     bool low_pwr_disable)
 {
+	/* TODO: original/leave 32k low power */
+	btcoexist->bt_info.bt_disable_low_pwr = low_pwr_disable;
 }
 
-static void halbtc_aggregation_check(void)
+static void halbtc_aggregation_check(struct btc_coexist *btcoexist)
 {
+	bool need_to_act = false;
+
+	/* To void continuous deleteBA=>addBA=>deleteBA=>addBA
+	 * This function is not allowed to continuous called
+	 * It can only be called after 8 seconds
+	 */
+
+	if (btcoexist->bt_info.reject_agg_pkt) {
+		;/* TODO: reject */
+		btcoexist->bt_info.pre_reject_agg_pkt =
+			btcoexist->bt_info.reject_agg_pkt;
+	} else {
+		if (btcoexist->bt_info.pre_reject_agg_pkt) {
+			need_to_act = true;
+			btcoexist->bt_info.pre_reject_agg_pkt =
+				btcoexist->bt_info.reject_agg_pkt;
+		}
+
+		if (btcoexist->bt_info.pre_bt_ctrl_agg_buf_size !=
+		    btcoexist->bt_info.bt_ctrl_agg_buf_size) {
+			need_to_act = true;
+			btcoexist->bt_info.pre_bt_ctrl_agg_buf_size =
+				btcoexist->bt_info.bt_ctrl_agg_buf_size;
+		}
+
+		if (btcoexist->bt_info.bt_ctrl_agg_buf_size) {
+			if (btcoexist->bt_info.pre_agg_buf_size !=
+			    btcoexist->bt_info.agg_buf_size) {
+				need_to_act = true;
+			}
+			btcoexist->bt_info.pre_agg_buf_size =
+				btcoexist->bt_info.agg_buf_size;
+		}
+	}
+
 }
 
 static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
@@ -246,10 +313,37 @@ static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
 	return 0;
 }
 
-static s32 halbtc_get_wifi_rssi(struct rtl_priv *adapter)
+u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = adapter;
-	s32	undec_sm_pwdb = 0;
+	/* return value:
+	 * [31:16] => connected port number
+	 * [15:0]  => port connected bit define
+	 */
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rtl_mac *mac = rtl_mac(rtlpriv);
+	u32 ret_val = 0;
+	u32 port_connected_status = 0, num_of_connected_port = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_STATION &&
+	    mac->link_state >= MAC80211_LINKED) {
+		port_connected_status |= WIFI_STA_CONNECTED;
+		num_of_connected_port++;
+	}
+	/* AP & ADHOC & MESH */
+	if (is_any_client_connect_to_ap(btcoexist)) {
+		port_connected_status |= WIFI_AP_CONNECTED;
+		num_of_connected_port++;
+	}
+	/* TODO: P2P Connected Status */
+
+	ret_val = (num_of_connected_port << 16) | port_connected_status;
+
+	return ret_val;
+}
+
+static s32 halbtc_get_wifi_rssi(struct rtl_priv *rtlpriv)
+{
+	int undec_sm_pwdb = 0;
 
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
 		undec_sm_pwdb = rtlpriv->dm.undec_sm_pwdb;
@@ -282,7 +376,10 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_CONNECTED:
-		if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
+		if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_STATION &&
+		    rtlpriv->mac80211.link_state >= MAC80211_LINKED)
+			tmp = true;
+		if (is_any_client_connect_to_ap(btcoexist))
 			tmp = true;
 		*bool_tmp = tmp;
 		break;
@@ -304,28 +401,18 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		else
 			*bool_tmp = false;
 		break;
-	case BTC_GET_BL_WIFI_ROAM:	/*TODO*/
+	case BTC_GET_BL_WIFI_ROAM:
 		if (mac->link_state == MAC80211_LINKING)
 			*bool_tmp = true;
 		else
 			*bool_tmp = false;
 		break;
-	case BTC_GET_BL_WIFI_4_WAY_PROGRESS:	/*TODO*/
-			*bool_tmp = false;
-
-		break;
-	case BTC_GET_BL_WIFI_UNDER_5G:
-		*bool_tmp = false; /*TODO*/
-
-	case BTC_GET_BL_WIFI_DHCP:	/*TODO*/
-		break;
-	case BTC_GET_BL_WIFI_SOFTAP_IDLE:
-		*bool_tmp = true;
-		break;
-	case BTC_GET_BL_WIFI_SOFTAP_LINKING:
+	case BTC_GET_BL_WIFI_4_WAY_PROGRESS:
+		/* TODO */
 		*bool_tmp = false;
 		break;
-	case BTC_GET_BL_WIFI_IN_EARLY_SUSPEND:
+	case BTC_GET_BL_WIFI_UNDER_5G:
+		/* TODO */
 		*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_AP_MODE_ENABLE:
@@ -338,15 +425,25 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 			*bool_tmp = true;
 		break;
 	case BTC_GET_BL_WIFI_UNDER_B_MODE:
-		*bool_tmp = false; /*TODO*/
+		if (rtlpriv->mac80211.mode == WIRELESS_MODE_B)
+			*bool_tmp = true;
+		else
+			*bool_tmp = false;
 		break;
 	case BTC_GET_BL_EXT_SWITCH:
 		*bool_tmp = false;
 		break;
+	case BTC_GET_BL_WIFI_IS_IN_MP_MODE:
+		*bool_tmp = false;
+		break;
+	case BTC_GET_BL_IS_ASUS_8723B:
+		*bool_tmp = false;
+		break;
 	case BTC_GET_S4_WIFI_RSSI:
 		*s32_tmp = halbtc_get_wifi_rssi(rtlpriv);
 		break;
-	case BTC_GET_S4_HS_RSSI:	/*TODO*/
+	case BTC_GET_S4_HS_RSSI:
+		/* TODO */
 		*s32_tmp = halbtc_get_wifi_rssi(rtlpriv);
 		break;
 	case BTC_GET_U4_WIFI_BW:
@@ -359,7 +456,10 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 			*u32_tmp = BTC_WIFI_TRAFFIC_RX;
 		break;
 	case BTC_GET_U4_WIFI_FW_VER:
-		*u32_tmp = rtlhal->fw_version;
+		*u32_tmp = (rtlhal->fw_version << 16) | rtlhal->fw_subversion;
+		break;
+	case BTC_GET_U4_WIFI_LINK_STATUS:
+		*u32_tmp = halbtc_get_wifi_link_status(btcoexist);
 		break;
 	case BTC_GET_U4_BT_PATCH_VER:
 		*u32_tmp = halbtc_get_bt_patch_version(btcoexist);
@@ -374,10 +474,19 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		*u8_tmp = halbtc_get_wifi_central_chnl(btcoexist);
 		break;
 	case BTC_GET_U1_WIFI_HS_CHNL:
-		*u8_tmp = 1;/*BT_OperateChnl(rtlpriv);*/
+		*u8_tmp = 1;
 		break;
-	case BTC_GET_U1_MAC_PHY_MODE:
-		*u8_tmp = BTC_MP_UNKNOWN;
+	case BTC_GET_U1_AP_NUM:
+		/* driver do not know AP num,
+		 * so the return value here is not right
+		 */
+		*u8_tmp = 1;
+		break;
+	case BTC_GET_U1_ANT_TYPE:
+		*u8_tmp = (u8)BTC_ANT_TYPE_0;
+		break;
+	case BTC_GET_U1_IOT_PEER:
+		*u8_tmp = 0;
 		break;
 
 		/************* 1Ant **************/
@@ -420,11 +529,17 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		btcoexist->bt_info.reject_agg_pkt = *bool_tmp;
 		break;
 	case BTC_SET_BL_BT_CTRL_AGG_SIZE:
-		btcoexist->bt_info.bt_ctrl_buf_size = *bool_tmp;
+		btcoexist->bt_info.bt_ctrl_agg_buf_size = *bool_tmp;
 		break;
 	case BTC_SET_BL_INC_SCAN_DEV_NUM:
 		btcoexist->bt_info.increase_scan_dev_num = *bool_tmp;
 		break;
+	case BTC_SET_BL_BT_TX_RX_MASK:
+		btcoexist->bt_info.bt_tx_rx_mask = *bool_tmp;
+		break;
+	case BTC_SET_BL_MIRACAST_PLUS_BT:
+		btcoexist->bt_info.miracast_plus_bt = *bool_tmp;
+		break;
 		/* set some u1Byte type variables. */
 	case BTC_SET_U1_RSSI_ADJ_VAL_FOR_AGC_TABLE_ON:
 		btcoexist->bt_info.rssi_adjust_for_agc_table_on = *u8_tmp;
@@ -432,25 +547,24 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	case BTC_SET_U1_AGG_BUF_SIZE:
 		btcoexist->bt_info.agg_buf_size = *u8_tmp;
 		break;
-		/* the following are some action which will be triggered */
+
+	/* the following are some action which will be triggered */
 	case BTC_SET_ACT_GET_BT_RSSI:
-		/*BTHCI_SendGetBtRssiEvent(rtlpriv);*/
 		break;
 	case BTC_SET_ACT_AGGREGATE_CTRL:
-		halbtc_aggregation_check();
+		halbtc_aggregation_check(btcoexist);
 		break;
 
-		/* 1Ant */
+	/* 1Ant */
 	case BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE:
 		btcoexist->bt_info.rssi_adjust_for_1ant_coex_type = *u8_tmp;
 		break;
 	case BTC_SET_UI_SCAN_SIG_COMPENSATION:
-	/*	rtlpriv->mlmepriv.scan_compensation = *u8_tmp;  */
 		break;
-	case BTC_SET_U1_1ANT_LPS:
+	case BTC_SET_U1_LPS_VAL:
 		btcoexist->bt_info.lps_val = *u8_tmp;
 		break;
-	case BTC_SET_U1_1ANT_RPWM:
+	case BTC_SET_U1_RPWM_VAL:
 		btcoexist->bt_info.rpwm_val = *u8_tmp;
 		break;
 	/* the following are some action which will be triggered  */
@@ -464,20 +578,19 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		halbtc_normal_lps(btcoexist);
 		break;
 	case BTC_SET_ACT_DISABLE_LOW_POWER:
-		halbtc_disable_low_power();
+		halbtc_disable_low_power(btcoexist, *bool_tmp);
 		break;
 	case BTC_SET_ACT_UPDATE_RAMASK:
 		btcoexist->bt_info.ra_mask = *u32_tmp;
 		break;
 	case BTC_SET_ACT_SEND_MIMO_PS:
 		break;
-	case BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT:
-		btcoexist->bt_info.force_exec_pwr_cmd_cnt++;
-		break;
 	case BTC_SET_ACT_CTRL_BT_INFO: /*wait for 8812/8821*/
 		break;
 	case BTC_SET_ACT_CTRL_BT_COEX:
 		break;
+	case BTC_SET_ACT_CTRL_8723B_ANT:
+		break;
 	default:
 		break;
 	}
@@ -485,22 +598,6 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	return true;
 }
 
-static void halbtc_display_coex_statistics(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_bt_link_info(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_bt_fw_info(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_fw_pwr_mode_cmd(struct btc_coexist *btcoexist)
-{
-}
-
 /************************************************************
  *		IO related function
  ************************************************************/
@@ -574,6 +671,35 @@ static void halbtc_write_4byte(void *bt_context, u32 reg_addr, u32 data)
 	rtl_write_dword(rtlpriv, reg_addr, data);
 }
 
+void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr, u8 data)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	if (btcoexist->chip_interface == BTC_INTF_SDIO)
+		;
+	else if (btcoexist->chip_interface == BTC_INTF_PCI)
+		rtl_write_byte(rtlpriv, reg_addr, data);
+	else if (btcoexist->chip_interface == BTC_INTF_USB)
+		rtl_write_byte(rtlpriv, reg_addr, data);
+}
+
+void halbtc_set_macreg(void *btc_context, u32 reg_addr, u32 bit_mask, u32 data)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	rtl_set_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask, data);
+}
+
+u32 halbtc_get_macreg(void *btc_context, u32 reg_addr, u32 bit_mask)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	return rtl_get_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask);
+}
+
 static void halbtc_set_bbreg(void *bt_context, u32 reg_addr, u32 bit_mask,
 			     u32 data)
 {
@@ -619,50 +745,66 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
 					cmd_len, cmd_buf);
 }
 
-static void halbtc_display_dbg_msg(void *bt_context, u8 disp_type)
+void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
 {
-	struct btc_coexist *btcoexist =	(struct btc_coexist *)bt_context;
-	switch (disp_type) {
-	case BTC_DBG_DISP_COEX_STATISTICS:
-		halbtc_display_coex_statistics(btcoexist);
-		break;
-	case BTC_DBG_DISP_BT_LINK_INFO:
-		halbtc_display_bt_link_info(btcoexist);
-		break;
-	case BTC_DBG_DISP_BT_FW_VER:
-		halbtc_display_bt_fw_info(btcoexist);
-		break;
-	case BTC_DBG_DISP_FW_PWR_MODE_CMD:
-		halbtc_display_fw_pwr_mode_cmd(btcoexist);
-		break;
-	default:
-		break;
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 cmd_buffer1[4] = {0};
+	u8 cmd_buffer2[4] = {0};
+	u8 *addr_to_set = (u8 *)&offset;
+	u8 *value_to_set = (u8 *)&set_val;
+	u8 oper_ver = 0;
+	u8 req_num = 0;
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		cmd_buffer1[0] |= (oper_ver & 0x0f);	/* Set OperVer */
+		cmd_buffer1[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
+		cmd_buffer1[1] = 0x0d;	/* OpCode: BT_LO_OP_WRITE_REG_VALUE */
+		cmd_buffer1[2] = value_to_set[0];	/* Set WriteRegValue */
+		rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
+						&cmd_buffer1[0]);
+
+		msleep(200);
+		req_num++;
+
+		cmd_buffer2[0] |= (oper_ver & 0x0f);	/* Set OperVer */
+		cmd_buffer2[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
+		cmd_buffer2[1] = 0x0c;	/* OpCode: BT_LO_OP_WRITE_REG_ADDR */
+		cmd_buffer2[3] = addr_to_set[0];	/* Set WriteRegAddr */
+		rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
+						&cmd_buffer2[0]);
 	}
 }
 
+bool halbtc_under_ips(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
+	enum rf_pwrstate rtstate;
+
+	if (ppsc->inactiveps) {
+		rtstate = ppsc->rfpwr_state;
+
+		if (rtstate != ERFON &&
+		    ppsc->rfoff_reason == RF_CHANGE_BY_IPS) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /*****************************************************************
  *         Extern functions called by other module
  *****************************************************************/
-bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
+bool exhalbtc_initlize_variables(void)
 {
 	struct btc_coexist *btcoexist = &gl_bt_coexist;
 
-	btcoexist->statistics.cnt_bind++;
-
 	halbtc_dbg_init();
 
-	if (btcoexist->binded)
-		return false;
-	else
-		btcoexist->binded = true;
-
 	btcoexist->chip_interface = BTC_INTF_UNKNOWN;
 
-	if (NULL == btcoexist->adapter)
-		btcoexist->adapter = adapter;
-
-	btcoexist->stack_info.profile_notified = false;
-
 	btcoexist->btc_read_1byte = halbtc_read_1byte;
 	btcoexist->btc_write_1byte = halbtc_write_1byte;
 	btcoexist->btc_write_1byte_bitmask = halbtc_bitmask_write_1byte;
@@ -670,6 +812,7 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	btcoexist->btc_write_2byte = halbtc_write_2byte;
 	btcoexist->btc_read_4byte = halbtc_read_4byte;
 	btcoexist->btc_write_4byte = halbtc_write_4byte;
+	btcoexist->btc_write_local_reg_1byte = halbtc_write_local_reg_1byte;
 
 	btcoexist->btc_set_bb_reg = halbtc_set_bbreg;
 	btcoexist->btc_get_bb_reg = halbtc_get_bbreg;
@@ -678,10 +821,11 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	btcoexist->btc_get_rf_reg = halbtc_get_rfreg;
 
 	btcoexist->btc_fill_h2c = halbtc_fill_h2c_cmd;
-	btcoexist->btc_disp_dbg_msg = halbtc_display_dbg_msg;
 
 	btcoexist->btc_get = halbtc_get;
 	btcoexist->btc_set = halbtc_set;
+	btcoexist->btc_set_bt_reg = halbtc_set_bt_reg;
+
 
 	btcoexist->bt_info.bt_ctrl_buf_size = false;
 	btcoexist->bt_info.agg_buf_size = 5;
@@ -690,40 +834,138 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	return true;
 }
 
+bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
+{
+	struct btc_coexist *btcoexist = &gl_bt_coexist;
+	struct rtl_priv *rtlpriv = adapter;
+	u8 ant_num = 2, chip_type, single_ant_path = 0;
+
+	if (btcoexist->binded)
+		return false;
+
+	btcoexist->binded = true;
+	btcoexist->statistics.cnt_bind++;
+
+	btcoexist->adapter = adapter;
+
+	btcoexist->stack_info.profile_notified = false;
+
+	btcoexist->bt_info.bt_ctrl_agg_buf_size = false;
+	btcoexist->bt_info.agg_buf_size = 5;
+
+	btcoexist->bt_info.increase_scan_dev_num = false;
+	btcoexist->bt_info.miracast_plus_bt = false;
+
+	chip_type = rtl_get_hwpg_bt_type(rtlpriv);
+	exhalbtc_set_chip_type(chip_type);
+	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
+	exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
+
+	/* set default antenna position to main  port */
+	btcoexist->board_info.btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
+
+	single_ant_path = rtl_get_hwpg_single_ant_path(rtlpriv);
+	exhalbtc_set_single_ant_path(single_ant_path);
+
+	if (rtl_get_hwpg_package_type(rtlpriv) == 0)
+		btcoexist->board_info.tfbga_package = false;
+	else if (rtl_get_hwpg_package_type(rtlpriv) == 1)
+		btcoexist->board_info.tfbga_package = false;
+	else
+		btcoexist->board_info.tfbga_package = true;
+
+	if (btcoexist->board_info.tfbga_package)
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Package Type = TFBGA\n");
+	else
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Package Type = Non-TFBGA\n");
+
+	return true;
+}
+
+void exhalbtc_power_on_setting(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	btcoexist->statistics.cnt_power_on++;
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_power_on_setting(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_power_on_setting(btcoexist);
+	}
+}
+
+void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	btcoexist->statistics.cnt_pre_load_firmware++;
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_pre_load_firmware(btcoexist);
+	}
+}
+
 void exhalbtc_init_hw_config(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	bool wifi_only = true;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
 	btcoexist->statistics.cnt_init_hw_config++;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_init_hwconfig(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_init_hwconfig(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_init_hwconfig(btcoexist, wifi_only);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_init_hwconfig(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_init_hwconfig(btcoexist, wifi_only);
+	} else if (IS_HARDWARE_TYPE_8723A(btcoexist->adapter)) {
+		/* 8723A has no this function */
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_init_hwconfig(btcoexist);
+	}
 }
 
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
 	btcoexist->statistics.cnt_init_coex_dm++;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_init_coex_dm(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_init_coex_dm(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_init_coex_dm(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_init_coex_dm(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_init_coex_dm(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_init_coex_dm(btcoexist);
+	}
 
 	btcoexist->initilized = true;
 }
 
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 ips_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -737,18 +979,28 @@ void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 	else
 		ips_type = BTC_IPS_LEAVE;
 
-	halbtc_leave_low_power();
-
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_ips_notify(btcoexist, ips_type);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_ips_notify(btcoexist, ips_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_ips_notify(btcoexist, ips_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_ips_notify(btcoexist, ips_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_ips_notify(btcoexist, ips_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_ips_notify(btcoexist, ips_type);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 lps_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -762,14 +1014,24 @@ void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	else
 		lps_type = BTC_LPS_ENABLE;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_lps_notify(btcoexist, lps_type);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_lps_notify(btcoexist, lps_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_lps_notify(btcoexist, lps_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_lps_notify(btcoexist, lps_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_lps_notify(btcoexist, lps_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_lps_notify(btcoexist, lps_type);
+	}
 }
 
 void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 scan_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -783,18 +1045,28 @@ void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	else
 		scan_type = BTC_SCAN_FINISH;
 
-	halbtc_leave_low_power();
-
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_scan_notify(btcoexist, scan_type);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_scan_notify(btcoexist, scan_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_scan_notify(btcoexist, scan_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_scan_notify(btcoexist, scan_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_scan_notify(btcoexist, scan_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_scan_notify(btcoexist, scan_type);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 asso_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -808,10 +1080,24 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 	else
 		asso_type = BTC_ASSOCIATE_FINISH;
 
-	halbtc_leave_low_power();
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_connect_notify(btcoexist, asso_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_connect_notify(btcoexist, asso_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_connect_notify(btcoexist, asso_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_connect_notify(btcoexist, asso_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_connect_notify(btcoexist, asso_type);
+	}
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_connect_notify(btcoexist, asso_type);
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
@@ -830,15 +1116,28 @@ void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
 	else
 		status = BTC_MEDIA_DISCONNECT;
 
-	halbtc_leave_low_power();
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_media_status_notify(btcoexist, status);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_media_status_notify(btcoexist, status);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_media_status_notify(btcoexist, status);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_media_status_notify(btcoexist, status);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_media_status_notify(btcoexist, status);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 packet_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -847,28 +1146,85 @@ void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 	if (btcoexist->manual_control)
 		return;
 
-	packet_type = BTC_PACKET_DHCP;
-
-	halbtc_leave_low_power();
+	if (pkt_type == PACKET_DHCP) {
+		packet_type = BTC_PACKET_DHCP;
+	} else if (pkt_type == PACKET_EAPOL) {
+		packet_type = BTC_PACKET_EAPOL;
+	} else if (pkt_type == PACKET_ARP) {
+		packet_type = BTC_PACKET_ARP;
+	} else {
+		packet_type = BTC_PACKET_UNKNOWN;
+		return;
+	}
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_special_packet_notify(btcoexist,
-						      packet_type);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_special_packet_notify(btcoexist,
+							      packet_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_special_packet_notify(btcoexist,
+							      packet_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_special_packet_notify(btcoexist,
+							      packet_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_special_packet_notify(btcoexist,
+							      packet_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_special_packet_notify(btcoexist,
+							      packet_type);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 			     u8 *tmp_buf, u8 length)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 	btcoexist->statistics.cnt_bt_info_notify++;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_bt_info_notify(btcoexist, tmp_buf, length);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
+	}
+
+	halbtc_normal_low_power(btcoexist);
+}
+
+void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_rf_status_notify(btcoexist, type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	}
 }
 
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
@@ -881,44 +1237,117 @@ void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
 	if (btcoexist->manual_control)
 		return;
 
-	stack_op_type = BTC_STACK_OP_NONE;
-
-	halbtc_leave_low_power();
-
-	halbtc_nomal_low_power();
+	if ((type == HCI_BT_OP_INQUIRY_START) ||
+	    (type == HCI_BT_OP_PAGING_START) ||
+	    (type == HCI_BT_OP_PAIRING_START)) {
+		stack_op_type = BTC_STACK_OP_INQ_PAGE_PAIR_START;
+	} else if ((type == HCI_BT_OP_INQUIRY_FINISH) ||
+		   (type == HCI_BT_OP_PAGING_SUCCESS) ||
+		   (type == HCI_BT_OP_PAGING_UNSUCCESS) ||
+		   (type == HCI_BT_OP_PAIRING_FINISH)) {
+		stack_op_type = BTC_STACK_OP_INQ_PAGE_PAIR_FINISH;
+	} else {
+		stack_op_type = BTC_STACK_OP_NONE;
+	}
 }
 
 void exhalbtc_halt_notify(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_halt_notify(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_halt_notify(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_halt_notify(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_halt_notify(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_halt_notify(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_halt_notify(btcoexist);
+	}
+
+	btcoexist->binded = false;
 }
 
 void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
+
+	/* currently only 1ant we have to do the notification,
+	 * once pnp is notified to sleep state, we have to leave LPS that
+	 * we can sleep normally.
+	 */
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_pnp_notify(btcoexist, pnp_state);
+	} else if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_pnp_notify(btcoexist, pnp_state);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	}
 }
 
-void exhalbtc_periodical(struct btc_coexist *btcoexist)
+void exhalbtc_coex_dm_switch(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
-	btcoexist->statistics.cnt_periodical++;
+	btcoexist->statistics.cnt_coex_dm_switch++;
+
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1) {
+			btcoexist->stop_coex_dm = true;
+			ex_btc8723b1ant_coex_dm_reset(btcoexist);
+			exhalbtc_set_ant_num(rtlpriv,
+					     BT_COEX_ANT_TYPE_DETECTED, 2);
+			ex_btc8723b2ant_init_hwconfig(btcoexist);
+			ex_btc8723b2ant_init_coex_dm(btcoexist);
+			btcoexist->stop_coex_dm = false;
+		}
+	}
 
-	halbtc_leave_low_power();
+	halbtc_normal_low_power(btcoexist);
+}
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_periodical(btcoexist);
+void exhalbtc_periodical(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+	btcoexist->statistics.cnt_periodical++;
 
-	halbtc_nomal_low_power();
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_periodical(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			if (!halbtc_under_ips(btcoexist))
+				ex_btc8821a1ant_periodical(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_periodical(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_periodical(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_periodical(btcoexist);
+	}
+
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_dbg_control(struct btc_coexist *btcoexist,
@@ -927,6 +1356,17 @@ void exhalbtc_dbg_control(struct btc_coexist *btcoexist,
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 	btcoexist->statistics.cnt_dbg_ctrl++;
+
+	halbtc_leave_low_power(btcoexist);
+
+	halbtc_normal_low_power(btcoexist);
+}
+
+void exhalbtc_antenna_detection(struct btc_coexist *btcoexist, u32 cent_freq,
+				u32 offset, u32 span, u32 seconds)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
 }
 
 void exhalbtc_stack_update_profile_info(void)
@@ -964,11 +1404,6 @@ void exhalbtc_set_bt_patch_version(u16 bt_hci_version, u16 bt_patch_version)
 	btcoexist->bt_info.bt_hci_ver = bt_hci_version;
 }
 
-void exhalbtc_set_bt_exist(bool bt_exist)
-{
-	gl_bt_coexist.board_info.bt_exist = bt_exist;
-}
-
 void exhalbtc_set_chip_type(u8 chip_type)
 {
 	switch (chip_type) {
@@ -1002,25 +1437,8 @@ void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
 	if (BT_COEX_ANT_TYPE_PG == type) {
 		gl_bt_coexist.board_info.pg_ant_num = ant_num;
 		gl_bt_coexist.board_info.btdm_ant_num = ant_num;
-		/* The antenna position:
-		 * Main (default) or Aux for pgAntNum=2 && btdmAntNum =1.
-		 * The antenna position should be determined by
-		 * auto-detect mechanism.
-		 * The following is assumed to main,
-		 * and those must be modified
-		 * if y auto-detect mechanism is ready
-		 */
-		if ((gl_bt_coexist.board_info.pg_ant_num == 2) &&
-		    (gl_bt_coexist.board_info.btdm_ant_num == 1))
-			gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
-		else
-			gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
 	} else if (BT_COEX_ANT_TYPE_ANTDIV == type) {
 		gl_bt_coexist.board_info.btdm_ant_num = ant_num;
-		gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
 	} else if (type == BT_COEX_ANT_TYPE_DETECTED) {
 		gl_bt_coexist.board_info.btdm_ant_num = ant_num;
 		if (rtlpriv->cfg->mod_params->ant_sel == 1)
@@ -1032,13 +1450,33 @@ void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
 	}
 }
 
+/* Currently used by 8723b only, S0 or S1 */
+void exhalbtc_set_single_ant_path(u8 single_ant_path)
+{
+	gl_bt_coexist.board_info.single_ant_path = single_ant_path;
+}
+
 void exhalbtc_display_bt_coex_info(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_display_coex_info(btcoexist);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8821a2ant_display_coex_info(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8821a1ant_display_coex_info(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8723b2ant_display_coex_info(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8723b1ant_display_coex_info(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8192e2ant_display_coex_info(btcoexist);
+	}
+
+	halbtc_normal_low_power(btcoexist);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index c5c360e011a9..32cbbd0595ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -153,6 +153,7 @@ struct btc_board_info {
 	u8 btdm_ant_pos;
 	u8 single_ant_path; /* current used for 8723b only, 1=>s0,  0=>s1 */
 	bool bt_exist;
+	bool tfbga_package;
 };
 
 enum btc_dbg_opcode {
@@ -217,6 +218,26 @@ enum btc_iot_peer {
 	BTC_IOT_PEER_MAX,
 };
 
+/* for 8723b-d cut large current issue */
+enum bt_wifi_coex_state {
+	BTC_WIFI_STAT_INIT,
+	BTC_WIFI_STAT_IQK,
+	BTC_WIFI_STAT_NORMAL_OFF,
+	BTC_WIFI_STAT_MP_OFF,
+	BTC_WIFI_STAT_NORMAL,
+	BTC_WIFI_STAT_ANT_DIV,
+	BTC_WIFI_STAT_MAX
+};
+
+enum bt_ant_type {
+	BTC_ANT_TYPE_0,
+	BTC_ANT_TYPE_1,
+	BTC_ANT_TYPE_2,
+	BTC_ANT_TYPE_3,
+	BTC_ANT_TYPE_4,
+	BTC_ANT_TYPE_MAX
+};
+
 enum btc_get_type {
 	/* type bool */
 	BTC_GET_BL_HS_OPERATION,
@@ -237,6 +258,9 @@ enum btc_get_type {
 	BTC_GET_BL_WIFI_UNDER_B_MODE,
 	BTC_GET_BL_EXT_SWITCH,
 	BTC_GET_BL_WIFI_IS_IN_MP_MODE,
+	BTC_GET_BL_IS_ASUS_8723B,
+	BTC_GET_BL_FW_READY,
+	BTC_GET_BL_RF4CE_CONNECTED,
 
 	/* type s4Byte */
 	BTC_GET_S4_WIFI_RSSI,
@@ -249,6 +273,11 @@ enum btc_get_type {
 	BTC_GET_U4_WIFI_LINK_STATUS,
 	BTC_GET_U4_BT_PATCH_VER,
 	BTC_GET_U4_VENDOR,
+	BTC_GET_U4_SUPPORTED_VERSION,
+	BTC_GET_U4_SUPPORTED_FEATURE,
+	BTC_GET_U4_WIFI_IQK_TOTAL,
+	BTC_GET_U4_WIFI_IQK_OK,
+	BTC_GET_U4_WIFI_IQK_FAIL,
 
 	/* type u1Byte */
 	BTC_GET_U1_WIFI_DOT11_CHNL,
@@ -256,6 +285,7 @@ enum btc_get_type {
 	BTC_GET_U1_WIFI_HS_CHNL,
 	BTC_GET_U1_MAC_PHY_MODE,
 	BTC_GET_U1_AP_NUM,
+	BTC_GET_U1_ANT_TYPE,
 	BTC_GET_U1_IOT_PEER,
 
 	/* for 1Ant */
@@ -315,6 +345,7 @@ enum btc_set_type {
 	/* BT Coex related */
 	BTC_SET_ACT_CTRL_BT_INFO,
 	BTC_SET_ACT_CTRL_BT_COEX,
+	BTC_SET_ACT_CTRL_8723B_ANT,
 	/***************************/
 	BTC_SET_MAX
 };
@@ -433,12 +464,18 @@ struct btc_bt_info {
 	bool bt_disabled;
 	u8 rssi_adjust_for_agc_table_on;
 	u8 rssi_adjust_for_1ant_coex_type;
+	bool pre_bt_ctrl_agg_buf_size;
 	bool bt_busy;
+	u8 pre_agg_buf_size;
 	u8 agg_buf_size;
 	bool limited_dig;
+	bool pre_reject_agg_pkt;
 	bool reject_agg_pkt;
 	bool bt_ctrl_buf_size;
 	bool increase_scan_dev_num;
+	bool miracast_plus_bt;
+	bool bt_ctrl_agg_buf_size;
+	bool bt_tx_rx_mask;
 	u16 bt_hci_ver;
 	u16 bt_real_fw_ver;
 	u8 bt_fw_ver;
@@ -486,6 +523,8 @@ struct btc_statistics {
 	u32 cnt_coex_dm_switch;
 	u32 cnt_stack_operation_notify;
 	u32 cnt_dbg_ctrl;
+	u32 cnt_pre_load_firmware;
+	u32 cnt_power_on;
 };
 
 struct btc_bt_link_info {
@@ -560,7 +599,7 @@ bool halbtc_is_wifi_uplink(struct rtl_priv *adapter);
 
 extern struct btc_coexist gl_bt_coexist;
 
-bool exhalbtc_initlize_variables(struct rtl_priv *adapter);
+bool exhalbtc_initlize_variables(void);
 void exhalbtc_init_hw_config(struct btc_coexist *btcoexist);
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist);
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type);
@@ -591,5 +630,6 @@ void exhalbtc_signal_compensation(struct btc_coexist *btcoexist,
 				  u8 *rssi_wifi, u8 *rssi_bt);
 void exhalbtc_lps_leave(struct btc_coexist *btcoexist);
 void exhalbtc_low_wifi_traffic_notify(struct btc_coexist *btcoexist);
+void exhalbtc_set_single_ant_path(u8 single_ant_path);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 46e0fa6be273..3ab0cfe26513 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -49,37 +49,24 @@ static struct rtl_btc_ops rtl_btc_operation = {
 
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
 {
-	exhalbtc_initlize_variables(rtlpriv);
+	exhalbtc_initlize_variables();
 }
 
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv)
 {
-	u8 ant_num;
-	u8 bt_exist;
-	u8 bt_type;
+	/* move ant_num, bt_type and single_ant_path to
+	 * exhalbtc_bind_bt_coex_withadapter()
+	 */
+}
 
-	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "%s, antNum is %d\n", __func__, ant_num);
+void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
+{
+	u8 bt_exist;
 
 	bt_exist = rtl_get_hwpg_bt_exist(rtlpriv);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "%s, bt_exist is %d\n", __func__, bt_exist);
-	exhalbtc_set_bt_exist(bt_exist);
-
-	bt_type = rtl_get_hwpg_bt_type(rtlpriv);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "%s, bt_type is %d\n",
-		 __func__, bt_type);
-	exhalbtc_set_chip_type(bt_type);
+		"%s, bt_exist is %d\n", __func__, bt_exist);
 
-	if (rtlpriv->cfg->mod_params->ant_sel == 1)
-		exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_DETECTED, 1);
-	else
-		exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
-}
-
-void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
-{
 	exhalbtc_init_hw_config(&gl_bt_coexist);
 	exhalbtc_init_coex_dm(&gl_bt_coexist);
 }
@@ -118,7 +105,9 @@ void rtl_btc_periodical(struct rtl_priv *rtlpriv)
 
 void rtl_btc_halt_notify(void)
 {
-	exhalbtc_halt_notify(&gl_bt_coexist);
+	struct btc_coexist *btcoexist = &gl_bt_coexist;
+
+	exhalbtc_halt_notify(btcoexist);
 }
 
 void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
-- 
2.12.0
