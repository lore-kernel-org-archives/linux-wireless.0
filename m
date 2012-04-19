Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2DSVdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:08 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so12437635iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:33:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/6 V2] rtlwifi: Move dig_t and ps_t structs
Date: Thu, 19 Apr 2012 16:32:39 -0500
Message-Id: <1334871164-9795-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233329_936670_CE6298DF)
In-Reply-To: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move struct definitions for dig_t and ps_t to the common header file.

This move is needed to convert these structures from a "per-driver" to a
"per-interface" basis.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h |   34 ------------
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h       |   34 ------------
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h       |   49 -----------------
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h       |   42 ---------------
 drivers/net/wireless/rtlwifi/wifi.h               |   59 +++++++++++++++++++++
 5 files changed, 59 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
index 2178e37..b3180ea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -91,40 +91,6 @@
 #define TX_POWER_NEAR_FIELD_THRESH_LVL2		74
 #define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
 
-struct ps_t {
-	u8 pre_ccastate;
-	u8 cur_ccasate;
-	u8 pre_rfstate;
-	u8 cur_rfstate;
-	long rssi_val_min;
-};
-
-struct dig_t {
-	u8 dig_enable_flag;
-	u8 dig_ext_port_stage;
-	u32 rssi_lowthresh;
-	u32 rssi_highthresh;
-	u32 fa_lowthresh;
-	u32 fa_highthresh;
-	u8 cursta_connectctate;
-	u8 presta_connectstate;
-	u8 curmultista_connectstate;
-	u8 pre_igvalue;
-	u8 cur_igvalue;
-	char backoff_val;
-	char backoff_val_range_max;
-	char backoff_val_range_min;
-	u8 rx_gain_range_max;
-	u8 rx_gain_range_min;
-	u8 rssi_val_min;
-	u8 pre_cck_pd_state;
-	u8 cur_cck_pd_state;
-	u8 pre_cck_fa_state;
-	u8 cur_cck_fa_state;
-	u8 pre_ccastate;
-	u8 cur_ccasate;
-};
-
 struct swat_t {
 	u8 failure_cnt;
 	u8 try_flag;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
index 26747fa..56611d7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
@@ -86,40 +86,6 @@
 #define TX_POWER_NEAR_FIELD_THRESH_LVL2		74
 #define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
 
-struct ps_t {
-	u8 pre_ccastate;
-	u8 cur_ccasate;
-	u8 pre_rfstate;
-	u8 cur_rfstate;
-	long rssi_val_min;
-};
-
-struct dig_t {
-	u8 dig_enable_flag;
-	u8 dig_ext_port_stage;
-	u32 rssi_lowthresh;
-	u32 rssi_highthresh;
-	u32 fa_lowthresh;
-	u32 fa_highthresh;
-	u8 cursta_connectctate;
-	u8 presta_connectstate;
-	u8 curmultista_connectstate;
-	u8 pre_igvalue;
-	u8 cur_igvalue;
-	char backoff_val;
-	char backoff_val_range_max;
-	char backoff_val_range_min;
-	u8 rx_gain_range_max;
-	u8 rx_gain_range_min;
-	u8 rssi_val_min;
-	u8 pre_cck_pd_state;
-	u8 cur_cck_pd_state;
-	u8 pre_cck_fa_state;
-	u8 cur_cck_fa_state;
-	u8 pre_ccastate;
-	u8 cur_ccasate;
-};
-
 struct swat_t {
 	u8 failure_cnt;
 	u8 try_flag;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.h b/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
index 91030ec..7ede6a7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
@@ -87,55 +87,6 @@
 #define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
 #define INDEX_MAPPING_NUM			13
 
-struct ps_t {
-	u8 pre_ccastate;
-	u8 cur_ccasate;
-
-	u8 pre_rfstate;
-	u8 cur_rfstate;
-
-	long rssi_val_min;
-};
-
-struct dig_t {
-	u8 dig_enable_flag;
-	u8 dig_ext_port_stage;
-
-	u32 rssi_lowthresh;
-	u32 rssi_highthresh;
-
-	u32 fa_lowthresh;
-	u32 fa_highthresh;
-
-	u8 cursta_connectctate;
-	u8 presta_connectstate;
-	u8 curmultista_connectstate;
-
-	u8 pre_igvalue;
-	u8 cur_igvalue;
-
-	char backoff_val;
-	char backoff_val_range_max;
-	char backoff_val_range_min;
-	u8 rx_gain_range_max;
-	u8 rx_gain_range_min;
-	u8 min_undecorated_pwdb_for_dm;
-	long last_min_undecorated_pwdb_for_dm;
-
-	u8 pre_cck_pd_state;
-	u8 cur_cck_pd_state;
-
-	u8 pre_cck_fa_state;
-	u8 cur_cck_fa_state;
-
-	u8 pre_ccastate;
-	u8 cur_ccasate;
-
-	u8 large_fa_hit;
-	u8 forbidden_igi;
-	u32 recover_cnt;
-};
-
 struct swat {
 	u8 failure_cnt;
 	u8 try_flag;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h b/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
index e1b19a6..f8ace73 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
@@ -29,48 +29,6 @@
 #ifndef	__RTL_92S_DM_H__
 #define __RTL_92S_DM_H__
 
-struct dig_t {
-	u8 dig_enable_flag;
-	u8 dig_algorithm;
-	u8 dig_twoport_algorithm;
-	u8 dig_ext_port_stage;
-	u8 dig_dbgmode;
-	u8 dig_slgorithm_switch;
-
-	long rssi_lowthresh;
-	long rssi_highthresh;
-
-	u32 fa_lowthresh;
-	u32 fa_highthresh;
-
-	long rssi_highpower_lowthresh;
-	long rssi_highpower_highthresh;
-
-	u8 dig_state;
-	u8 dig_highpwrstate;
-	u8 cur_sta_connectstate;
-	u8 pre_sta_connectstate;
-	u8 cur_ap_connectstate;
-	u8 pre_ap_connectstate;
-
-	u8 cur_pd_thstate;
-	u8 pre_pd_thstate;
-	u8 cur_cs_ratiostate;
-	u8 pre_cs_ratiostate;
-
-	u32 pre_igvalue;
-	u32	cur_igvalue;
-
-	u8 backoff_enable_flag;
-	char backoff_val;
-	char backoffval_range_max;
-	char backoffval_range_min;
-	u8 rx_gain_range_max;
-	u8 rx_gain_range_min;
-
-	long rssi_val;
-};
-
 enum dm_dig_alg {
 	DIG_ALGO_BY_FALSE_ALARM = 0,
 	DIG_ALGO_BY_RSSI	= 1,
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 5213988..32df6bd 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1592,6 +1592,65 @@ struct rtl_debug {
 	char proc_name[20];
 };
 
+struct ps_t {
+	u8 pre_ccastate;
+	u8 cur_ccasate;
+	u8 pre_rfstate;
+	u8 cur_rfstate;
+	long rssi_val_min;
+};
+
+struct dig_t {
+	u32 rssi_lowthresh;
+	u32 rssi_highthresh;
+	u32 fa_lowthresh;
+	u32 fa_highthresh;
+	long last_min_undecorated_pwdb_for_dm;
+	long rssi_highpower_lowthresh;
+	long rssi_highpower_highthresh;
+	u32 recover_cnt;
+	u32 pre_igvalue;
+	u32 cur_igvalue;
+	long rssi_val;
+	u8 dig_enable_flag;
+	u8 dig_ext_port_stage;
+	u8 dig_algorithm;
+	u8 dig_twoport_algorithm;
+	u8 dig_dbgmode;
+	u8 dig_slgorithm_switch;
+	u8 cursta_connectctate;
+	u8 presta_connectstate;
+	u8 curmultista_connectstate;
+	char backoff_val;
+	char backoff_val_range_max;
+	char backoff_val_range_min;
+	u8 rx_gain_range_max;
+	u8 rx_gain_range_min;
+	u8 min_undecorated_pwdb_for_dm;
+	u8 rssi_val_min;
+	u8 pre_cck_pd_state;
+	u8 cur_cck_pd_state;
+	u8 pre_cck_fa_state;
+	u8 cur_cck_fa_state;
+	u8 pre_ccastate;
+	u8 cur_ccasate;
+	u8 large_fa_hit;
+	u8 forbidden_igi;
+	u8 dig_state;
+	u8 dig_highpwrstate;
+	u8 cur_sta_connectstate;
+	u8 pre_sta_connectstate;
+	u8 cur_ap_connectstate;
+	u8 pre_ap_connectstate;
+	u8 cur_pd_thstate;
+	u8 pre_pd_thstate;
+	u8 cur_cs_ratiostate;
+	u8 pre_cs_ratiostate;
+	u8 backoff_enable_flag;
+	char backoffval_range_max;
+	char backoffval_range_min;
+};
+
 struct rtl_priv {
 	struct completion firmware_loading_complete;
 	struct rtl_locks locks;
-- 
1.7.10.130.g36e6c

