Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZIYVY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwlwifi: default to using all chains
Date: Fri, 25 Sep 2009 14:24:25 -0700
Message-Id: <1253913868-8400-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When instructing the microcode to use just a single
chain when we have power saving enabled, we should
also tell the AP that we are doing SM powersave.
However, using a single chain doesn't actually have
any power saving advantage while idle -- measurements
show that the power consumption is no different when
using one vs. two or three chains.

Therefore, always instruct the microcode to use all
chains.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5ff0f66..e97b104 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -948,8 +948,13 @@ EXPORT_SYMBOL(iwl_set_rxon_ht);
 #define IWL_NUM_IDLE_CHAINS_DUAL	2
 #define IWL_NUM_IDLE_CHAINS_SINGLE	1
 
-/* Determine how many receiver/antenna chains to use.
- * More provides better reception via diversity.  Fewer saves power.
+/*
+ * Determine how many receiver/antenna chains to use.
+ *
+ * More provides better reception via diversity.  Fewer saves power
+ * at the expense of throughput, but only when not in powersave to
+ * start with.
+ *
  * MIMO (dual stream) requires at least 2, but works better with 3.
  * This does not determine *which* chains to use, just how many.
  */
@@ -962,19 +967,18 @@ static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 		return IWL_NUM_RX_CHAINS_MULTIPLE;
 }
 
+/*
+ * When we are in power saving, there's no difference between
+ * using multiple chains or just a single chain, but due to the
+ * lack of SM PS we lose a lot of throughput if we use just a
+ * single chain.
+ *
+ * Therefore, use the active count here (which will use multiple
+ * chains unless connected to a legacy AP).
+ */
 static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 {
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
-
-	/* # Rx chains when idling and maybe trying to save power */
-
-	/*
-	 * XXX: this is incorrect!!
-	 *	we always indicate to the AP that
-	 *	our SM PS mode is "disabled"
-	 */
-
-	return is_cam ? active_cnt : IWL_NUM_IDLE_CHAINS_SINGLE;
+	return active_cnt;
 }
 
 /* up to 4 chains */
-- 
1.5.6.3

