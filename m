Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbXK2DKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:39 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/36] iwlwifi: Move is_legacy() macro family from iwl-4965-hw.h to iwl-4965-rs.h
Date: Thu, 29 Nov 2007 11:09:48 +0800
Message-Id: <1196305816-23023-9-git-send-email-yi.zhu@intel.com> (sfid-20071129_033536_523154_47B80C4B)
In-Reply-To: <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Move is_legacy() macro family from iwl-4965-hw.h to iwl-4965-rs.h

These macros are for driver's rate scaling implementation, and are not
related to hardware or uCode API values (moved from iwl-4965-hw.h).

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    7 -------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index e106ec1..93e2dff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1036,13 +1036,6 @@ union iwl4965_tx_power_dual_stream {
 #define R_MCS_36M_DUAL_MSK 0x400
 #define R_MCS_48M_DUAL_MSK 0x800
 
-#define is_legacy(tbl) (((tbl) == LQ_G) || ((tbl) == LQ_A))
-#define is_siso(tbl) (((tbl) == LQ_SISO))
-#define is_mimo(tbl) (((tbl) == LQ_MIMO))
-#define is_Ht(tbl) (is_siso(tbl) || is_mimo(tbl))
-#define is_a_band(tbl) (((tbl) == LQ_A))
-#define is_g_and(tbl) (((tbl) == LQ_G))
-
 /* Flow Handler Definitions */
 
 /**********************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 0c9552b..31e21e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -223,6 +223,13 @@ enum iwl4965_table_type {
 	LQ_MAX,
 };
 
+#define is_legacy(tbl) (((tbl) == LQ_G) || ((tbl) == LQ_A))
+#define is_siso(tbl) (((tbl) == LQ_SISO))
+#define is_mimo(tbl) (((tbl) == LQ_MIMO))
+#define is_Ht(tbl) (is_siso(tbl) || is_mimo(tbl))
+#define is_a_band(tbl) (((tbl) == LQ_A))
+#define is_g_and(tbl) (((tbl) == LQ_G))
+
 /* 4965 has 2 antennas/chains for Tx (but 3 for Rx) */
 enum iwl4965_antenna_type {
 	ANT_NONE,
-- 
1.5.3.6
