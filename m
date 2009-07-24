Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbZGXSNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/14] iwlwifi: Name fix for MPDU density for TX aggregation
Date: Fri, 24 Jul 2009 11:13:09 -0700
Message-Id: <1248459194-10239-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Fix incorrect name for HT MPDU Density.
default set to 4 uSec

Reported-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3ca188a..facbc3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -491,8 +491,16 @@ union iwl_ht_rate_supp {
 };
 
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
-#define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
-#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
+
+/*
+ * Maximal MPDU density for TX aggregation
+ * 4 - 2us density
+ * 5 - 4us density
+ * 6 - 8us density
+ * 7 - 16us density
+ */
+#define CFG_HT_MPDU_DENSITY_4USEC   (0x5)
+#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_4USEC
 
 struct iwl_ht_info {
 	/* self configuration data */
-- 
1.5.6.3

