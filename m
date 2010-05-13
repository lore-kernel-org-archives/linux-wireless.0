Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab0EMVuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/17] iwlwifi: code cleanup for _agn devices
Date: Thu, 13 May 2010 14:49:54 -0700
Message-Id: <1273787399-9280-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move configuration structure for _agn devices from iwl-dev.h to
iwl-agn.h. Those data structures are for _agn devices and should be keep
for _agn devices only.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h |   26 --------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 12c198f..2ebbe81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -65,6 +65,32 @@
 
 #include "iwl-dev.h"
 
+/* configuration for the _agn devices */
+extern struct iwl_cfg iwl4965_agn_cfg;
+extern struct iwl_cfg iwl5300_agn_cfg;
+extern struct iwl_cfg iwl5100_agn_cfg;
+extern struct iwl_cfg iwl5350_agn_cfg;
+extern struct iwl_cfg iwl5100_bgn_cfg;
+extern struct iwl_cfg iwl5100_abg_cfg;
+extern struct iwl_cfg iwl5150_agn_cfg;
+extern struct iwl_cfg iwl5150_abg_cfg;
+extern struct iwl_cfg iwl6000g2a_2agn_cfg;
+extern struct iwl_cfg iwl6000g2a_2abg_cfg;
+extern struct iwl_cfg iwl6000g2a_2bg_cfg;
+extern struct iwl_cfg iwl6000g2b_bgn_cfg;
+extern struct iwl_cfg iwl6000g2b_bg_cfg;
+extern struct iwl_cfg iwl6000g2b_2agn_cfg;
+extern struct iwl_cfg iwl6000g2b_2abg_cfg;
+extern struct iwl_cfg iwl6000g2b_2bg_cfg;
+extern struct iwl_cfg iwl6000i_2agn_cfg;
+extern struct iwl_cfg iwl6000i_2abg_cfg;
+extern struct iwl_cfg iwl6000i_2bg_cfg;
+extern struct iwl_cfg iwl6000_3agn_cfg;
+extern struct iwl_cfg iwl6050_2agn_cfg;
+extern struct iwl_cfg iwl6050_2abg_cfg;
+extern struct iwl_cfg iwl1000_bgn_cfg;
+extern struct iwl_cfg iwl1000_bg_cfg;
+
 extern struct iwl_mod_params iwlagn_mod_params;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 04296fd..8b2d06c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -48,32 +48,6 @@
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
 
-/* configuration for the iwl4965 */
-extern struct iwl_cfg iwl4965_agn_cfg;
-extern struct iwl_cfg iwl5300_agn_cfg;
-extern struct iwl_cfg iwl5100_agn_cfg;
-extern struct iwl_cfg iwl5350_agn_cfg;
-extern struct iwl_cfg iwl5100_bgn_cfg;
-extern struct iwl_cfg iwl5100_abg_cfg;
-extern struct iwl_cfg iwl5150_agn_cfg;
-extern struct iwl_cfg iwl5150_abg_cfg;
-extern struct iwl_cfg iwl6000g2a_2agn_cfg;
-extern struct iwl_cfg iwl6000g2a_2abg_cfg;
-extern struct iwl_cfg iwl6000g2a_2bg_cfg;
-extern struct iwl_cfg iwl6000g2b_bgn_cfg;
-extern struct iwl_cfg iwl6000g2b_bg_cfg;
-extern struct iwl_cfg iwl6000g2b_2agn_cfg;
-extern struct iwl_cfg iwl6000g2b_2abg_cfg;
-extern struct iwl_cfg iwl6000g2b_2bg_cfg;
-extern struct iwl_cfg iwl6000i_2agn_cfg;
-extern struct iwl_cfg iwl6000i_2abg_cfg;
-extern struct iwl_cfg iwl6000i_2bg_cfg;
-extern struct iwl_cfg iwl6000_3agn_cfg;
-extern struct iwl_cfg iwl6050_2agn_cfg;
-extern struct iwl_cfg iwl6050_2abg_cfg;
-extern struct iwl_cfg iwl1000_bgn_cfg;
-extern struct iwl_cfg iwl1000_bg_cfg;
-
 struct iwl_tx_queue;
 
 /* CT-KILL constants */
-- 
1.6.3.3

