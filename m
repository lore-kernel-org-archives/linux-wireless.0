Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33899 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3KRRLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:11:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 03/12 NEXT] rtlwifi: Redo register save locations
Date: Mon, 18 Nov 2013 11:11:27 -0600
Message-Id: <1384794696-20314-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_181248_367289_D881F569)
In-Reply-To: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initial USB driver did not use some register save locations in the
private data storage. To save some memory, a union was used to overlay these
variables with USB I/O components. In an update of the gain-control code,
these register save locations are now needed for USB drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/wifi.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 0aa89fd..8c64739 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1033,6 +1033,7 @@ struct rtl_ht_agg {
 
 struct rssi_sta {
 	long undec_sm_pwdb;
+	long undec_sm_cck;
 };
 
 struct rtl_tid_data {
@@ -1323,8 +1324,10 @@ struct fast_ant_training {
 struct rtl_dm {
 	/*PHY status for Dynamic Management */
 	long entry_min_undec_sm_pwdb;
+	long undec_sm_cck;
 	long undec_sm_pwdb;	/*out dm */
 	long entry_max_undec_sm_pwdb;
+	s32 ofdm_pkt_cnt;
 	bool dm_initialgain_enable;
 	bool dynamic_txpower_enable;
 	bool current_turbo_edca;
@@ -1339,6 +1342,7 @@ struct rtl_dm {
 	bool inform_fw_driverctrldm;
 	bool current_mrc_switch;
 	u8 txpowercount;
+	u8 powerindex_backup[6];
 
 	u8 thermalvalue_rxgain;
 	u8 thermalvalue_iqk;
@@ -1350,7 +1354,9 @@ struct rtl_dm {
 	bool done_txpower;
 	u8 dynamic_txhighpower_lvl;	/*Tx high power level */
 	u8 dm_flag;		/*Indicate each dynamic mechanism's status. */
+	u8 dm_flag_tmp;
 	u8 dm_type;
+	u8 dm_rssi_sel;
 	u8 txpower_track_control;
 	bool interrupt_migration;
 	bool disable_tx_int;
@@ -1949,6 +1955,7 @@ struct dig_t {
 	u8 pre_ccastate;
 	u8 cur_ccasate;
 	u8 large_fa_hit;
+	u8 dig_dynamic_min;
 	u8 forbidden_igi;
 	u8 dig_state;
 	u8 dig_highpwrstate;
@@ -2029,22 +2036,15 @@ struct rtl_priv {
 	struct dig_t dm_digtable;
 	struct ps_t dm_pstable;
 
-	/* section shared by individual drivers */
-	union {
-		struct {	/* data buffer pointer for USB reads */
-			__le32 *usb_data;
-			int usb_data_index;
-			bool initialized;
-		};
-		struct {	/* section for 8723ae */
-			bool reg_init;	/* true if regs saved */
-			u32 reg_874;
-			u32 reg_c70;
-			u32 reg_85c;
-			u32 reg_a74;
-			bool bt_operation_on;
-		};
-	};
+	u32 reg_874;
+	u32 reg_c70;
+	u32 reg_85c;
+	u32 reg_a74;
+	bool reg_init;	/* true if regs saved */
+	bool bt_operation_on;
+	__le32 *usb_data;
+	int usb_data_index;
+	bool initialized;
 	bool enter_ps;	/* true when entering PS */
 	u8 rate_mask[5];
 
-- 
1.8.4

