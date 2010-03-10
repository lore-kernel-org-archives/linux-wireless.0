Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32470 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0CJFWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwl3945: fix memory corruption
Date: Tue,  9 Mar 2010 21:22:18 -0800
Message-Id: <1268198539-6656-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198539-6656-1-git-send-email-reinette.chatre@intel.com>
References: <1268198539-6656-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Recent patch "iwlwifi: move 3945 clip groups to 3945 data" exposed a memory
corruption problem. When initializing the clip groups the code was
mistakenly using the iwlagn rate count, not the 3945 rate count. This
resulted in more memory being written than was allocated.

"iwlwifi: move 3945 clip groups to 3945 data" moved the location where the
clip groups are stored and the impact is now severe in that the number of
configured TX queues is modified. Previously the
"temperature" field was overwritten, which did not seem to affect the
operation.

Fix this one instance where wrong rate count was used. I also noticed one
more location where the iwlagn rate count was used to index an iwl3945
array, fix this. I also modified one location that modified the iwlagn rate
count to obtain the iwl3945 rate count ... just use the iwl3945 rate count
directly.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2165 and
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2168

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 303cc81..e0678d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -184,7 +184,7 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
 {
 	int idx;
 
-	for (idx = 0; idx < IWL_RATE_COUNT; idx++)
+	for (idx = 0; idx < IWL_RATE_COUNT_3945; idx++)
 		if (iwl3945_rates[idx].plcp == plcp)
 			return idx;
 	return -1;
@@ -805,7 +805,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				  int sta_id, int tx_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(priv->hw, info)->hw_value;
-	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT - 1);
+	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT_3945);
 	u16 rate_mask;
 	int rate;
 	u8 rts_retry_limit;
@@ -2146,7 +2146,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 
 		/* fill in channel group's nominal powers for each rate */
 		for (rate_index = 0;
-		     rate_index < IWL_RATE_COUNT; rate_index++, clip_pwrs++) {
+		     rate_index < IWL_RATE_COUNT_3945; rate_index++, clip_pwrs++) {
 			switch (rate_index) {
 			case IWL_RATE_36M_INDEX_TABLE:
 				if (i == 0)	/* B/G */
-- 
1.6.3.3

