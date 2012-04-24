Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758296Ab2DXXv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/11] iwlwifi: remove unused macros
Date: Tue, 24 Apr 2012 16:45:54 -0700
Message-Id: <1335311164-10252-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015154_657822_84191929)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   69 ----------------------------
 1 files changed, 0 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e1c2bb8..0642186 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -186,75 +186,6 @@ done:
 /*
  * BT coex
  */
-/*
- * Macros to access the lookup table.
- *
- * The lookup table has 7 inputs: bt3_prio, bt3_txrx, bt_rf_act, wifi_req,
-* wifi_prio, wifi_txrx and wifi_sh_ant_req.
- *
- * It has three outputs: WLAN_ACTIVE, WLAN_KILL and ANT_SWITCH
- *
- * The format is that "registers" 8 through 11 contain the WLAN_ACTIVE bits
- * one after another in 32-bit registers, and "registers" 0 through 7 contain
- * the WLAN_KILL and ANT_SWITCH bits interleaved (in that order).
- *
- * These macros encode that format.
- */
-#define LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, wifi_req, wifi_prio, \
-		  wifi_txrx, wifi_sh_ant_req) \
-	(bt3_prio | (bt3_txrx << 1) | (bt_rf_act << 2) | (wifi_req << 3) | \
-	(wifi_prio << 4) | (wifi_txrx << 5) | (wifi_sh_ant_req << 6))
-
-#define LUT_PTA_WLAN_ACTIVE_OP(lut, op, val) \
-	lut[8 + ((val) >> 5)] op (cpu_to_le32(BIT((val) & 0x1f)))
-#define LUT_TEST_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-				 wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	(!!(LUT_PTA_WLAN_ACTIVE_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, \
-				   bt_rf_act, wifi_req, wifi_prio, wifi_txrx, \
-				   wifi_sh_ant_req))))
-#define LUT_SET_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-				wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_PTA_WLAN_ACTIVE_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, \
-			       bt_rf_act, wifi_req, wifi_prio, wifi_txrx, \
-			       wifi_sh_ant_req))
-#define LUT_CLEAR_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
-				  wifi_req, wifi_prio, wifi_txrx, \
-				  wifi_sh_ant_req) \
-	LUT_PTA_WLAN_ACTIVE_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, \
-			       bt_rf_act, wifi_req, wifi_prio, wifi_txrx, \
-			       wifi_sh_ant_req))
-
-#define LUT_WLAN_KILL_OP(lut, op, val) \
-	lut[(val) >> 4] op (cpu_to_le32(BIT(((val) << 1) & 0x1e)))
-#define LUT_TEST_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-			   wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	(!!(LUT_WLAN_KILL_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-			     wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
-#define LUT_SET_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-			  wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_WLAN_KILL_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-			 wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-#define LUT_CLEAR_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-			    wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_WLAN_KILL_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-			 wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-
-#define LUT_ANT_SWITCH_OP(lut, op, val) \
-	lut[(val) >> 4] op (cpu_to_le32(BIT((((val) << 1) & 0x1e) + 1)))
-#define LUT_TEST_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-			    wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	(!!(LUT_ANT_SWITCH_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-			      wifi_req, wifi_prio, wifi_txrx, \
-			      wifi_sh_ant_req))))
-#define LUT_SET_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-			   wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_ANT_SWITCH_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-			  wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-#define LUT_CLEAR_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-			     wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_ANT_SWITCH_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-			  wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-
 static const __le32 iwlagn_def_3w_lookup[12] = {
 	cpu_to_le32(0xaaaaaaaa),
 	cpu_to_le32(0xaaaaaaaa),
-- 
1.7.0.4

