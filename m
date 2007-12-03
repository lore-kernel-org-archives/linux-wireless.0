Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLCLoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:44:37 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 08/34] iwlwifi: Move is_legacy() macro family from iwl-4965-hw.h to iwl-4965-rs.h
Date: Mon,  3 Dec 2007 13:43:20 +0200
Message-Id: <11966822301152-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114441_399244_2290C246)
In-Reply-To: <11966822291143-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
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
index fbdc7f9..65c2ae4 100644
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
